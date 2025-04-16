# Be sure to run `pod lib lint DoraemonKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DoraemonKit'
  s.version          = '3.1.6'
  s.summary          = 'iOS tools'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iOS tools
                       DESC

  s.homepage         = 'https://www.dokit.cn'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'OrangeLab' => 'orange-lab@didiglobal.com' }
  s.source           = { :git => 'https://github.com/iangeli/DoKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.default_subspec = 'Core'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }

  s.subspec 'Core' do |ss| 
    ss.source_files = 'iOS/DoraemonKit/Src/Core/**/*.{h,m,c,mm}'
    ss.resource_bundle = {
      'DoraemonKit' => 'iOS/DoraemonKit/Resource/**/*'
    }
  end

  s.subspec 'WithLoad' do |ss| 
    ss.source_files = 'iOS/DoraemonKit/Src/MethodUseTime/**/*{.h,.m,.mm}'
    ss.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) DoraemonWithLoad'
    }
    ss.dependency 'DoraemonKit/Core'
  end

  # below has swizzle

  s.subspec 'WithGPS' do |ss|
    ss.source_files = 'iOS/DoraemonKit/Src/GPS/**/*{.h,.m}'
    ss.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) DoraemonWithGPS'
    }
    ss.dependency 'DoraemonKit/Core'
  end

  s.subspec 'WithUIProfile' do |ss|
    ss.source_files = 'iOS/DoraemonKit/Src/UIProfile/**/*{.h,.m}'
    ss.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) DoraemonWithUIProfile'
    }
    ss.dependency 'DoraemonKit/Core'
  end

  s.subspec 'WithViewMetrics' do |ss|
    ss.source_files = 'iOS/DoraemonKit/Src/ViewMetrics/**/*{.h,.m}'
    ss.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) DoraemonWithViewMetrics'
    }
    ss.dependency 'DoraemonKit/Core'
  end

end
