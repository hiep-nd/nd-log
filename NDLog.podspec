Pod::Spec.new do |s|
  s.name         = "NDLog"
  s.version      = "1.0"
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
  
  s.subspec 'Core_ObjC' do |ss|
    ss.source_files = "Sources/Core_ObjC/*.{h,m,mm,swift}"

    ss.framework = 'Foundation'
  end

  s.subspec 'Core_Swift' do |ss|
    ss.source_files = "Sources/Core_Swift/*.{h,m,mm,swift}"

    ss.dependency 'NDLog/Core_ObjC'
  end

  s.subspec 'Core' do |ss|
    ss.dependency 'NDLog/Core_Swift'
  end

  s.subspec 'ObjC' do |ss|
    ss.dependency 'NDLog/Core_ObjC'
  end

  s.subspec 'Swift' do |ss|
    ss.dependency 'NDLog/Core_Swift'
  end

  s.default_subspec = 'Swift'
end
