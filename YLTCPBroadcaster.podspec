Pod::Spec.new do |s|
  s.name         = 'YLTCPBroadcaster'
  s.version      = '1.0.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = 'Network scanner to find all TCP hosts with a given open port'
  s.description  = <<-DESC
                    YLTCPBroadcaster is a small library to help to scan/broadcast over the TCP protocol and written in Objective-C.
                   DESC
  s.authors      = { 'Yannick Loriot' => 'http://yannickloriot.com' }
  s.source       = { :git => 'https://github.com/YannickL/YLTCPBroadcaster.git',
                     :tag => s.version.to_s }
  s.requires_arc = true

  s.source_files        = ['YLTCPBroadcaster/*.{h,m}']

  s.framework = 'Foundation'

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.8'
end
