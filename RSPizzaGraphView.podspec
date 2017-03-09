Pod::Spec.new do |s|

  s.name         = "RSPizzaGraphView"
  s.version      = "1.0.0"
  s.summary      = "A nice pizza graph."
  
  s.description  = <<-DESC
  This pizza graph was made for developers who wants to have a nice UI in their apps.
                   DESC

  s.license   = "MIT"
  s.author    = "Roberto Sampaio"
  s.homepage  = "https://github.com/sampaioroberto"

  s.platform     = :ios, "10.0"

  s.source = { :git => 'https://github.com/sampaioroberto/RSPizzaGraphView.git', :tag => "1.0.0" }

  s.source_files  = "RSPizzaGraphView", "RSPizzaGraphView/**/*.{h,m,swift}"

end