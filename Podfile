# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Assignment' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Assignment

  pod 'Alamofire', '~> 4.9.0'
  pod 'SwiftyJSON'
  pod 'IQKeyboardManagerSwift'
  
  use_modular_headers!
  pod 'RealmSwift'
  
  target 'AssignmentTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AssignmentUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
