//
//  YMAConnectionOperation.m
//
//  Created by Александр Мертвецов on 31.10.13.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAConnectionOperation.h"

@interface YMAConnectionOperation () {
    BOOL _executing;
    BOOL _finished;
    NSURLConnection *_connection;
}

@property(nonatomic, strong) NSURLRequest *request;
@property(nonatomic, copy) YMAConnectionHandler handler;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) NSURLResponse *response;
@property(nonatomic, assign) BOOL isNeedFollowRedirects;

@end

@implementation YMAConnectionOperation

- (id)initWithRequest:(NSURLRequest *)request needFollowRedirects:(BOOL)needFollowRedirects andCompletionHandler:(YMAConnectionHandler)handler {
    self = [super init];

    if (self) {
        _request = request;
        _handler = [handler copy];
        _isNeedFollowRedirects = needFollowRedirects;
        _executing = NO;
        _finished = NO;
    }

    return self;
}

+ (instancetype)connectionOperationWithRequest:(NSURLRequest *)request needFollowRedirects:(BOOL)needFollowRedirects andCompletionHandler:(YMAConnectionHandler)handler {
    return [[YMAConnectionOperation alloc] initWithRequest:request needFollowRedirects:needFollowRedirects andCompletionHandler:handler];
}

#pragma mark -
#pragma mark *** NSOperation ***
#pragma mark -

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (void)done {
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }

    // Alert anyone that we are finished
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)canceled {
    [self done];
}

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start)
                               withObject:nil waitUntilDone:NO];
        return;
    }

    if (_finished || [self isCancelled]) {
        [self done];
        return;
    }

    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];

    _connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
}

#pragma mark -
#pragma mark *** NSURLConnectionDelegate implementation ***
#pragma mark -

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([self isCancelled]) {
        [self canceled];
        return;
    } else
        self.handler(self.request, self.response, self.data, error);
}

#pragma mark -
#pragma mark *** NSURLConnectionDataDelegate implementation ***
#pragma mark -

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    if ([self isCancelled]) {
        [self canceled];
        return nil;
    }

    if (!response)
        return request;

    if (response && self.isNeedFollowRedirects)
        return request;

    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([self isCancelled]) {
        [self canceled];
        return;
    }

    self.response = response;

    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if ([self isCancelled]) {
        [self canceled];
        return;
    }

    [self.data appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self isCancelled]) {
        [self canceled];
        return;
    }

    self.handler(self.request, self.response, self.data, nil);

    [self done];
}

@end
