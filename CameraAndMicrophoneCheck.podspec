
Pod::Spec.new do |s|
  s.name             = 'CameraAndMicrophoneCheck'
  s.version          = '0.0.1'
  s.summary          = 'A short description of CameraAndMicrophoneCheck.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/melenom/CameraAndMicrophoneChek'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pz' => 'melenom@163.com' }
  s.source           = { :git => 'https://github.com/melenom/CameraAndMicrophoneChek.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.source_files = 'CameraAndMicrophoneCheck/Classes/**/*.{swift}'
end
