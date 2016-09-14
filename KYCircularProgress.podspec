Pod::Spec.new do |s|
  s.name         = "KYCircularProgress"
  s.version      = "0.6.0"
  s.summary      = "Flexible progress bar written in Swift."
  s.homepage     = "https://github.com/kentya6/KYCircularProgress"
  s.license      = "MIT"
  s.author       = { "Kengo Yokoyama" => "appknop@gmail.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/kentya6/KYCircularProgress.git", :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files  = "Source/*.swift"
  s.requires_arc = true
end
