require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
  s.name         = 'ConsentWidgets'
  s.module_name  = 'ConsentWidgets'
  s.authors      = 'Koninklijke Philips N.V.'
  s.version      = VersionCSWPlatform
  s.license      = 'proprietary'
  s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/csw-iOS'
  s.summary      = 'ConsentWidgets contains MicroApp that will allow the user to manage the consents.'
  s.platform     = :ios, "10.0"
  s.author       = 'Philips Connected Digital Propositions'
  s.license      = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2015. All rights reserved.
                    LICENSE
                    }
  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/Library_#commithash#.zip' }

  s.dependency 'PhilipsUIKitDLS'
  s.dependency 'UAPPFramework'

  s.requires_arc = true
  s.default_subspec = 'Source'
  s.xcconfig = { 'SWIFT_VERSION' => '5.0' }
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  s.xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  s.ios.deployment_target  = '10.0'

  s.subspec 'Source' do |source|
    source.source_files = [ 'Source/Library/ConsentWidgets/**/*.{h,swift}',
                            'Source/Library/ConsentWidgets/*.{h,swift}' ,
                        	'Source/Library/JustInTimeConsent/*.swift',
                          	'Source/Library/Helpers/*.swift',
                      		'Source/Library/Lingo/*.swift']
    source.resources =    [ 'Source/Library/ConsentWidgets/ConsentWidgets.storyboard',
                            'Source/Library/ConsentWidgets/**/*.{xcassets,lproj,png,ttf}' ]
  end

end
