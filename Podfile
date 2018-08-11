use_frameworks!

workspace 'Workspace/iOSium.xcworkspace'
project 'Workspace/iOSium/iOSium.xcodeproj'

platform :osx, '10.11'


target "iOSium" do

pod 'RxSwift'
pod 'RxCocoa'
pod 'Alamofire'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.11'
        end
    end
end
