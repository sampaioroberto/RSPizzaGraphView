Pod::Spec.new do |s|

  s.name         = "RSPizzaGraphView"
  s.version      = "1.0.2"
  s.summary      = "A nice pizza graph."
  
  s.description  = <<-DESC
  This pizza graph was made for developers who wants to have a nice UI in their apps.
                   DESC

  s.license   = "MIT"
  s.author    = "Roberto Sampaio"
  s.homepage  = "https://github.com/sampaioroberto/RSPizzaGraphView"

  s.platform     = :ios, "11.4"
  
  s.swift_version       = '5.0'

  s.source = { :git => 'https://github.com/sampaioroberto/RSPizzaGraphView.git', :tag => "1.0.2" }

  s.source_files  = "RSPizzaGraphView", "RSPizzaGraphView/**/*.{h,m,swift}"

end