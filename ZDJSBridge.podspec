Pod::Spec.new do |s|
  s.name             = 'ZDJSBridge'
  s.version          = '1.1.1'
  s.summary          = 'iOS/macOS 与 JS 交互桥'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/izaodao/ZDJSBridge'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '吕浩轩' => 'lyuhaoxuan@aliyun.com' }
  s.source           = { :git => 'https://github.com/izaodao/ZDJSBridge.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.12'

  s.source_files = 'ZDJSBridge/Classes/**/*'
end
