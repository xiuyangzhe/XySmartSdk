Pod::Spec.new do |s|
    s.name             = 'xysmartsdk'
    s.version          = '1.0.3'
    s.summary          = 'xy smart device sdk'
    s.description      = <<-DESC
                         xy smart device sdk.
                         DESC
  
    s.homepage         = 'https://github.com/xiuyangzhe/XySmartSdk'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Rocky' => '769865744@qq.com' }
    s.source           = { :git => 'https://github.com/xiuyangzhe/XySmartSdk.git', :commit => "6392ce314c52368ea759a7333051bd0800163f41" } # :tag => "v1.0.0" 
  
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
  