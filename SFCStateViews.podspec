Pod::Spec.new do |s|
  s.name            = "SFCStateViews"
  s.version         = "0.1.0"
  s.summary         = "State views"
  s.homepage        = "https://github.com/bubnov/SFCStateViews"
  s.license         = 'MIT'
  s.author          = { "Bubnov Slavik" => "bubnovslavik@gmail.com" }
  s.source          = { :git => "https://github.com/bubnov/SFCStateViews.git", :tag => s.version.to_s }
  s.platform        = :ios, '7.0'
  s.requires_arc    = true
  s.source_files    = 'SFCStateViews'
  s.public_header_files = 'SFCStateViews/**/*.{h}'
  s.source_files = 'SFCStateViews/**/*.{h,m}'
end
