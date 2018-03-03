# Uncomment the next line to define a global platform for your project
platform :ios, '11.2'

target 'DateApp' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
use_frameworks!
  # Pods for DateApp
  pod 'SDWebImage'
  pod 'Socket.IO-Client-Swift', '~> 8.3.3'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'MessageKit'
  pod 'TPKeyboardAvoiding'
  target 'DateAppTests' do
    inherit! :search_paths
    # Pods for testing
  end
  target 'DateAppUITests' do
    inherit! :search_paths
    # Pods for testing
  end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Socket.IO-Client-Swift'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'  ## or '3.0'
            end
	end
    end
end
end
