Pod::Spec.new do |s|
  s.name             = "HaidoraStepProgressView"
  s.version          = "0.1.0"
  s.summary          = "HaidoraStepProgressView."
  s.description      = <<-DESC
                        通过UIBezierPath自定义形状的分段进度条。
                       DESC
  s.homepage         = "https://github.com/Haidora/HaidoraStepProgressView"
  s.license          = 'MIT'
  s.author           = { "mrdaios" => "mrdaios@gmail.com" }
  s.source           = { :git => "https://github.com/Haidora/HaidoraStepProgressView.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  #s.resource_bundles = {
  #  'HaidoraStepProgressView' => ['Pod/Assets/*.png']
  #}
end
