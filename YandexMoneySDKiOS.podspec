#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "YandexMoneySDKiOS"
  s.version          = "1.0.0"
  s.summary          = "Default UI for iOS Yandex.Money SDK"
  s.homepage         = "https://github.com/yandex-money/yandex-money-sdk-ios"
  s.license          = 'MIT'
  s.author           = { "Alex Mertvetsov" => "mertvetsov@yamoney.ru" }
  s.source           = { :git => "https://github.com/yandex-money/yandex-money-sdk-ios.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/yamoneynews'
  s.documentation_url = 'http://api.yandex.ru/money/'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
  s.resources = 'Assets/uiymcpssdkios.bundle'

  s.frameworks = 'UIKit'
  s.dependency 'YandexMoneySDKObjc'
end
