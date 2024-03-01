# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'Book A Ride' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'ACFloatingTextfield-Swift'
  pod 'IQKeyboardManagerSwift'
  pod 'CHIPageControl'
  pod 'GoogleMaps'
  pod 'GooglePlaces', '~> 7.2.0'
  pod 'Alamofire'
  pod 'Socket.IO-Client-Swift'
  pod 'NVActivityIndicatorView'
  pod 'SDWebImage', '~> 4.0'
  pod 'M13Checkbox'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  pod 'SideMenuController'
  pod 'CreditCardForm'
  pod 'FormTextField'
  pod 'IQDropDownTextField'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'MarqueeLabel/Swift' #, '3.1.4'
  pod 'CountryPickerView'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'DropDown' #, '2.3.1'
  pod 'FSPagerView'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
    end
  end
end
