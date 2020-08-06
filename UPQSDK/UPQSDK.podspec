#
#  Be sure to run `pod spec lint UPQSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "UPQSDK"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of UPQSDK"
  spec.description  = "A complete description of UPQSDK"

  spec.platform     = :ios, "11.1"

  spec.homepage     = "http://EXAMPLE/MyFramework"
  spec.license      = "MIT"
  spec.author             = { "GaneshDotsquares" => "techdotsquares@gmail.com" }
  spec.source       = { git: => "https://github.com/GaneshDotsquares/UPQSDKBeta.git", :tag => "1.0.0"  }
  spec.source_files  = "UPQSDK/**/*"
  spec.swift_version = "5" 
  spec.dependency 'SVProgressHUD'
  spec.dependency 'Socket.IO-Client-Swift', '~> 14.0'
  spec.dependency 'googleapis', :path => '.'
end

