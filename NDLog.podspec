Pod::Spec.new do |s|
  s.name         = "NDLog"
  s.version      = "0.0.4"
  s.summary      = "A log system."
  s.description  = <<-DESC
  NDLog is a small and lightweight framework that help log.
                   DESC
  s.homepage     = "https://github.com/hiep-nd/nd-log.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Nguyen Duc Hiep" => "hiep.nd@gmail.com" }
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.swift_versions = ['4.0', '5.1', '5.2']
  #s.source        = { :http => 'file:' + URI.escape(__dir__) + '/' }
  s.source       = { :git => "https://github.com/hiep-nd/nd-log.git", :tag => "Pod-#{s.version}" }
  
  s.source_files  = "NDLog/**/*.{h,m,mm}"
  s.public_header_files = 'NDLog/**/*.h'
end
