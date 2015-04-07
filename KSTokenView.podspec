Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "KSTokenView"
  s.version      = “1.2.5”
  s.summary      = "An iOS control for displaying multiple selections as tokens."
  s.description  = <<-DESC
                   A KSTokenView is a control that displays a collection of tokens in a an editable UITextField and sends messages to delegate object. It can be used to gather small amounts of text from user and perform search operation. User can choose multiple search results, which are displayed as token in UITextField.
                   DESC

  s.homepage = "https://github.com/khawars/KSTokenView"
  s.screenshots  = "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/iphone1.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/iphone2.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/iphone3.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/iphone4.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/ipad1.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/ipad2.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/ipad3.png", "https://raw.githubusercontent.com/khawars/KSTokenView/screenshots/screenshots/ipad4.png"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Khawar Shahzad" => "khawar.shzd@gmail.com" }


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "8.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/khawars/KSTokenView.git", :tag => “1.2.5” }

  s.source_files  = "KSTokenView/*.swift"
  s.requires_arc = true
end
