# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

target 'Tenso' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tenso

end

target 'Tenso MessagesExtension' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tenso MessagesExtension
  pod 'PeakOperation', '~> 3.1.0'

end

post_install do |installer|

    project_name = Dir.glob("*.xcodeproj").first
    project = Xcodeproj::Project.open(project_name)
    project.targets.each do |target|
      puts(target)
      target.build_configurations.each do |config|
        config.build_settings['VALID_ARCHS'] = 'arm64 arm64e'
        config.build_settings['ENABLE_BITCODE'] = 'NO'
        config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
      end
    end
    project.save

  installer.pods_project.targets.each do |target|

    puts(target)

    target.build_configurations.each do |config|

      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'

    end
  end
end
