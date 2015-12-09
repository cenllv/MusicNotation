Pod::Spec.new do |spec|
    spec.name         = 'MusicNotation'
    spec.version      = '0.1'
    spec.summary      = 'An Objective-C music notation rendering framework'
    spec.homepage     = 'https://github.com/slcott/MusicNotation'
    spec.license      = 'License.txt'
    spec.author       = 'Scott Riccardelli'
    spec.source       = { :git => 'git@github.com:slcott/MusicNotation.git', :tag => 'v0.1' }
    spec.ios.deployment_target = '9.0'
    spec.osx.deployment_target = '10.11'
    spec.source_files = 'MusicNotation/src/*'
#    spec.source_files = 'MusicNotation/src/**/*.{h,m}'
#    spec.exclude_files = 'Modules/TPCircularBuffer'
#    spec.osx.exclude_files = 'Modules/Filters/AEReverbFilter.*'
    spec.requires_arc = true
#    spec.compiler_flags = '-DTPCircularBuffer=AECB',
#                        '-D_TPCircularBufferInit=_AECBInit',
    spec.dependency 'TheAmazingAudioEngine', '~> 1.5.2'
    spec.dependency 'pop', '~> 1.0'
#    spec.dependency 'RegExCategories'
    spec.dependency 'ReflectableEnum'
#    spec.frameworks = 'AudioToolbox', 'Accelerate'
end