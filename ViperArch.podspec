Pod::Spec.new do |s|
  s.name         = "ViperArch"
  s.version      = "1.0.0"
  s.summary      = "Foundation library for Viper Architecture by ideil. Ported to Swift from ViperMcFlurry by Rambler"

  s.homepage     = "https://www.ideil.com/"

  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.authors      = {
                      "Eduard Pelesh" => "e.pelesh@ideil.com",
                      "Natali Polovnikova" => "n.polovnikova@ideil.com"
                   }

  s.platform = :ios, :tvos
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/ideil/ios-viper-arch.git", :tag => "#{s.version}" }
  s.source_files = [
                      "Source/*.swift",
                      "ViperArch/*.{h,m}",
                      "ViperArchTV/*.{h,m}"
                   ]
  s.module_name  = "ViperArch"

  s.ios.exclude_files  = 'ViperArchTV/**/*.{h,m,swift}'
  s.tvos.exclude_files = 'ViperArch/**/*.{h,m,swift}'

end
