Pod::Spec.new do |s|
    s.name             = 'xysmartsdk'
    s.version          = '1.0.11'
    s.summary          = 'xy smart device sdk'
    s.description      = <<-DESC
                         xy smart device sdk.
                         DESC
  
    s.homepage         = 'https://github.com/xiuyangzhe/XySmartSdk'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Rocky' => '769865744@qq.com' }
    s.source           = { :git => 'https://github.com/xiuyangzhe/XySmartSdk.git', :commit => "ce90a65f011028782c66b280610948199600c9a0" } # :tag => "v1.0.0" 
  
    s.ios.deployment_target = '12.0'
  
    s.source_files = 'XySmartSdk/**/*.swift'
    s.public_header_files = 'XySmartSdk/**/*.h'
  
    # 如果是动态库
    # s.vendored_frameworks = 'XySmartSdk.framework'
  
    # 或者如果是静态库
    s.vendored_libraries = 'XySmartSdk.a'
    
    # 添加其他依赖和配置
    s.dependency 'CocoaMQTT'
    
    # 设置swift版本（如果适用）
    # s.swift_version = '5.9'
  end

  # pod trunk push xysmartsdk.podspec --verbose --allow-warnings
  