Pod::Spec.new do |s|
  s.name             = 'NetworkModule'
  s.version          = '1.0.0'
  s.summary          = 'A module for recording videos.'
  s.description      = 'This module provides functionality for recording videos within an iOS app.'

  s.homepage         = 'https://example.com/recording-module'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'your@email.com' }

  s.platform     = :ios, '10.0'
  s.source       = { :git => 'https://github.com/yourusername/RecordingModule.git', :tag => s.version.to_s }
#  s.dependency 'UtilityModule'
#  s.source_files = 'Implementation/**/*.{swift}'

  # Define sub-specs for protocols and implementations
  s.subspec 'Protocols' do |subspec|
    subspec.source_files = 'Protocols/**/*.swift'
  end

  s.subspec 'Implementation' do |subspec|
    subspec.source_files = 'Implementation/**/*.swift'
  end

end
