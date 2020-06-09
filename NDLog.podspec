Pod::Spec.new do |s|
  s.name         = "NDLog"
  s.version      = "0.0.2"
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
  
  s.default_subspecs = 'Core'
  s.subspec 'Core' do |ss|
    ss.source_files  = "NDLog/Core/**/*.{h,m,mm}"
    ss.public_header_files = 'NDLog/Core/**/*.h'
  end

  s.subspec 'Swift' do |ss|
    ss.dependency 'NDLog/Core'
    ss.source_files = 'NDLog/Swift/**/*.{swift}'
  end
end
