platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

target 'TomoWallet' do
  use_frameworks!

  pod 'BigInt', '~> 3.0'
  pod 'PromiseKit', '~> 6.0'
  pod 'MBProgressHUD'
  pod 'StatefulViewController'
  pod 'QRCodeReaderViewController', :git=>'https://github.com/yannickl/QRCodeReaderViewController.git', :branch=>'master'
  pod 'KeychainSwift'
  pod 'SwiftLint'
  pod 'SeedStackViewController'
  pod 'RealmSwift'
  pod 'Moya', '~> 10.0.1'
  pod 'CryptoSwift', '~> 0.10.0'
  pod 'Fabric'
  pod 'Crashlytics', '~> 3.10'
  pod 'Kingfisher', '~> 4.0'
  pod 'TrustCore', :git=>'https://github.com/TrustWallet/trust-core', :branch=>'master'
  pod 'TrustKeystore', :git=>'https://github.com/TrustWallet/trust-keystore', :branch=>'master'
  pod 'Branch'
  pod 'SAMKeychain'
  pod 'TrustWeb3Provider', :git=>'https://github.com/TrustWallet/trust-web3-provider', :commit=>'f4e0ebb1b8fa4812637babe85ef975d116543dfd'
  pod 'URLNavigator'
  pod 'TrustWalletSDK', :git=>'https://github.com/TrustWallet/TrustSDK-iOS', :branch=>'master'


  pod 'MXParallaxHeader'
  pod 'lottie-ios'
  pod 'JSQWebViewController'
  pod 'GradientLoadingBar', '~> 1.0'
  pod 'Eureka'

  target 'TomoWalletTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TomoWalletUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['JSONRPCKit'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
    if ['TrustKeystore'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
    # if target.name != 'Realm'
    #     target.build_configurations.each do |config|
    #         config.build_settings['MACH_O_TYPE'] = 'staticlib'
    #     end
    # end
  end
end
