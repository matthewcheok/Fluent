Pod::Spec.new do |s|
  s.name     = 'Fluent'
  s.version  = '0.1.1'
  s.ios.deployment_target   = '8.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'Swift Animations made Easy'
  s.homepage = 'https://github.com/matthewcheok/Fluent'
  s.author   = { 'Matthew Cheok' => 'hello@matthewcheok.com' }
  s.requires_arc = true
  s.source   = {
    :git => 'https://github.com/matthewcheok/Fluent.git',
    :branch => 'master',
    :tag => s.version.to_s
  }
  s.source_files = 'Fluent/*.swift'
  s.requires_arc = true
end
