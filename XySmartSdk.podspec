Pod::Spec.new do |s|
    s.name             = 'XySmartSdk'
    s.version          = '1.0.2'
    s.summary          = 'xy smart device sdk'
    s.description      = <<-DESC
                         xy smart device sdk.
                         DESC
  
    s.homepage         = 'https://github.com/xiuyangzhe/XySmartSdk'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Rocky' => '769865744@qq.com' }
    s.source           = { :git => 'https://github.com/xiuyangzhe/XySmartSdk.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '17.2'
  
    s.source_files = 'XySmartSdk/XySmartSdk/**/*'
    s.public_header_files = 'XySmartSdk/XySmartSdk/*.h'
  
    # 如果是动态库
    # s.vendored_frameworks = 'XySmartSdk.framework'
  
    # 或者如果是静态库
    s.vendored_libraries = 'XySmartSdk.a'
    
    # 添加其他依赖和配置
    s.dependency 'CocoaMQTT'
    
    # 设置swift版本（如果适用）
    s.swift_version = '5.9'
  end
  