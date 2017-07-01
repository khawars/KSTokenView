Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "KSTokenView"
  s.version      = "3.1.4"
  s.summary      = "An iOS control for displaying multiple selections as tokens."
  s.description  = <<-DESC
                   KSTokenView is a control that displays a collection of tokens in an editable UITextField and sends messages to delegate object. It can also be used to input text from user and perform search operation asynchronously. UI can be fully custimized to look like part of your application.
                   DESC

  s.homepage = "https://github.com/khawars/KSTokenView"
  s.screenshots  = "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/iphone1.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/iphone2.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/iphone3.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/iphone4.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/ipad1.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/ipad2.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/ipad3.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/ipad4.png"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Khawar Shahzad" => "khawar.shzd@gmail.com" }


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.ios.deployment_target = '9.0'


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/khawars/KSTokenView.git", :tag => s.version }

  s.source_files  = "KSTokenView/*.swift"
end
