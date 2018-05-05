Pod::Spec.new do |s|
  s.name         = "Finch"
  s.version      = "1.0.3"
  s.summary      = "Simple, low-latency OpenAL sound engine for Apple iOS."
  s.homepage     = "https://github.com/zoul/Finch"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Tomáš Znamenáček" => "tomas.znamenacek@gmail.com" }
  s.source       = { :git => "https://github.com/zoul/Finch.git", :tag => "1.0.3" }
  s.platform     = :ios
  s.source_files = 'Finch/**/*.{h,m}'
  s.exclude_files = 'Finch/**/*Test*'
  s.frameworks = 'OpenAL', 'AudioToolbox', 'AVFoundation'
  s.requires_arc = true
end
