#
#  Be sure to run `pod spec lint RWHBaseModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#
#  验证是否正确（后面还有一个git的私有地址)
#  pod lib lint RWHBaseModule.podspec --allow-warnings --use-libraries --sources=https://github.com/CocoaPods/Specs.git,https://github.com/wukexiu/O2RWHSpecs.git
#  提交到库  (O2RWHSpecs就是你们的私有库名 后面还有一个git的私有地址)
#  pod repo push O2RWHSpecs RWHBaseModule.podspec --allow-warnings --use-libraries --sources=https://github.com/CocoaPods/Specs.git,https://github.com/wukexiu/O2RWHSpecs.git
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "RWHBaseModule"             #名称
s.version      = "0.0.1"                     #版本号
s.summary      = "iOS模块化功能的引用"         #简短介绍

s.homepage     = "https://github.com/wukexiu/O2RWH_Module"
s.license      = { :type => "MIT", :file => "FILE_LICENSE" }     #开源协议
s.author             = { "wukexiu" => "290348331@qq.com" }

s.platform     = :ios, "7.0"                 #支持的平台及版本
## 这里不支持ssh的地址，只支持HTTP和HTTPS，最好使用HTTPS
## 正常情况下我们会使用稳定的tag版本来访问，如果是在开发测试的时候，不需要发布release版本，直接指向git地址使用
## 待测试通过完成后我们再发布指定release版本，使用如下方式
s.source       = { :git => "https://github.com/wukexiu/O2RWH_Module.git", :tag => "#{s.version}" }

s.requires_arc = true                        #是否使用ARC

s.subspec 'RWHCore' do |rwhCore|
rwhCore.source_files = 'RWHBaseModule/RWHCore/**/*.{h,m}'
rwhCore.resource_bundles = {
   'RWHCoreRes' => ['RWHBaseModule/RWHCore/**/*.png','RWHBaseModule/RWHCore/**/*.xib']
}
rwhCore.dependency 'XAspect'
rwhCore.dependency 'Aspects'
rwhCore.dependency 'Masonry'
rwhCore.dependency 'ActionSheetPicker'  
end

#s.subspec 'RWHGT' do |RWHGT|
#RWHGT.source_files = 'RWHBaseModule/RWHGT/**/*'
#RWHGT.dependency 'RWHBaseModule/RWHCore'
#RWHGT.dependency 'XAspect'
#RWHGT.dependency 'GTSDK', '~> 1.5.0'
#end

#s.subspec 'RWHAnalytics' do |RWHAnalytics|
#RWHAnalytics.source_files = 'RWHBaseModule/RWHAnalytics/**/*'
#RWHAnalytics.dependency 'RWHBaseModule/RWHCore'
#RWHAnalytics.dependency 'XAspect'
#RWHAnalytics.dependency 'Aspects'
#RWHAnalytics.dependency 'UMengAnalytics-NO-IDFA', '~> 4.1.1'
#end

# https://github.com/CocoaPods/CocoaPods/issues/5738 因QQ不支持I386，目前无法用Pod进行管理（symbol(s) not found for architecture i386）
#s.subspec 'RWHShare' do |RWHShare|
#RWHShare.source_files = 'RWHBaseModule/RWHShare/**/*'
#RWHShare.dependency 'RWHBaseModule/RWHCore'
#RWHShare.dependency 'XAspect'
#RWHShare.dependency 'UMengUShare/UI'
#RWHShare.dependency 'UMengUShare/Social/Sina'
#RWHShare.dependency 'UMengUShare/Social/WeChat'
#RWHShare.dependency 'UMengUShare/Social/QQ'
#RWHShare.dependency 'UMengUShare/Social/TencentWeibo'
#end

#s.subspec 'PayModule' do |PayModule|
#PayModule.source_files = 'RWHModuleDemo/PayModule/**/*'
#PayModule.dependency 'RWHBaseModule/RWHCore'
#PayModule.dependency 'MJExtension', '~>3.0.10'
#PayModule.dependency 'ActionSheetPicker' #'ActionSheetPicker-3.0', '~> 2.2.0'
#end


s.frameworks = 'UIKit'                          #所需的framework,多个用逗号隔开
# s.module_name = 'RWHBaseModule'                       #模块名称
# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
# s.dependency "JSONKit", "~> 1.4"              #依赖关系，该项目所依赖的其他库，如果有多个可以写多个 s.dependency
end
