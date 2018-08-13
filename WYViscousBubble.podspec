#
#  Be sure to run `pod spec lint WYViscousBubble.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name          = "WYViscousBubble"
  s.version       = "1.0.0"
  s.platform      = 8.0
  s.summary       = "A short description of WYViscousBubble."
  s.description   = <<-DESC
                      #
                    DESC

  s.license       = { 
            :type => 'MIT', 
            :text => <<-LICENSE
    
    LICENSE
  } 
  s.homepage      = "https://github.com/shanpengtao"
  s.frameworks    = "Foundation","UIKit"
  s.author        = { "wayne" => "shanpengtao@vip.qq.com" }
  s.source        = { :git => "https://github.com/shanpengtao/WYViscousBubble.git", :tag => "#{s.version}" } 
  # s.source_files  = "WYViscousBubble/WYViscousBubble/*.{h,m,mm,c,cc,cpp}"
  s.subspec 'WYViscousBubble' do |sf|
      sf.source_files        = 'WYViscousBubble/WYViscousBubble/*.{h,m,mm,c,cc,cpp}'
  end

  s.requires_arc  = true

  s.xcconfig = { 
          'OTHER_LDFLAGS'         => '-ObjC -lxml2 $(inherited)',
  }

end
