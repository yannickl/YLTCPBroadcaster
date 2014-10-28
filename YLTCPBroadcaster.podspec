Pod::Spec.new do |s|
  s.name         = 'YLTCPBroadcaster'
  s.version      = '1.0.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = 'Fast and easy-to-use network scanner to locate every host with a given open port'
  s.description  = <<-DESC
                    YLTCPBroadcaster is a small library written in Objective-C to find every host with
                    a given TCP port number open on the network. It works like an UDP broadcast but for
                    the TCP protocol.
                   DESC
  s.homepage     = 'https://github.com/YannickL/YLTCPBroadcaster'
  s.authors      = { 'Yannick Loriot' => 'http://yannickloriot.com' }
  s.source       = { :git => 'https://github.com/YannickL/YLTCPBroadcaster.git',
                     :tag => s.version.to_s }
  s.requires_arc = true

  s.source_files = ['YLTCPBroadcaster/*.{h,m}']

  s.framework = 'Foundation'

  s.ios.deployment_target = '6.0'
end
