Pod::Spec.new do |s|
  s.name             = 'ZDJSBridge'
  s.version          = '1.1.0'
  s.summary          = 'iOS/macOS 与 JS 交互桥'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitlab.izaodao.com/lvhaoxuan/ZDJSBridge'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lvhaoxuan' => 'lvhaoxuan@izaodao.com' }
  s.source           = { :git => 'https://gitlab.izaodao.com/lvhaoxuan/ZDJSBridge.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.12'

  s.source_files = 'ZDJSBridge/Classes/**/*'
end
