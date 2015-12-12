//
//  MNLayerNoteTests.m
//  MusicNotation
//
//  Created by Scott on 8/12/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MNLayerNoteTests.h"
#import <objc/runtime.h>

#if TARGET_OS_IPHONE

#import "MNMAppDelegate.h"

#elif TARGET_OS_MAC

#import "AppDelegate.h"

#endif

@interface MNShapeLayer (AnimationSwizzle)

@end

@implementation MNShapeLayer (AnimationSwizzle)

+ (void)load
{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
      SEL animateSelector = @selector(animate);
      SEL customAnimateSelector = @selector(customAnimate);
      Method originalMethod = class_getInstanceMethod(self, animateSelector);
      Method extendedMethod = class_getInstanceMethod(self, customAnimateSelector);
      method_exchangeImplementations(originalMethod, extendedMethod);
    });
}

- (void)customAnimate
{
    // NOTE: uncomment the following line and comment the next one to use original animation
    // [self customAnimate];
    [self animateSuperFancy];
}

- (void)animateSuperFancy
{
    //    POPDecayAnimation* scaleAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    //    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(1.5f, 1.5f)];
    //    scaleAnimation.autoreverses = YES;
    //    [self pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];

    POPBasicAnimation* scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    //    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25f:1.5f:0.5f:1.f];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5f, 1.5f)];
    [self pop_addAnimation:scaleAnimation forKey:@"arstarstarst"];

    POPBasicAnimation* shadowRadiusAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowRadius];
    shadowRadiusAnimation.timingFunction = scaleAnimation.timingFunction;
    shadowRadiusAnimation.fromValue = @(0);
    shadowRadiusAnimation.toValue = @(15);

    //    POPBasicAnimation* shadowOpacityAnimation = [POPBasicAnimation
    //    animationWithPropertyNamed:kPOPLayerShadowOpacity];
    //    POPBasicAnimation* shadowOffsetAnimation = [POPBasicAnimation
    //    animationWithPropertyNamed:kPOPLayerShadowOffset];
    //    POPBasicAnimation* shadowColorAnimation = [POPBasicAnimation
    //    animationWithPropertyNamed:kPOPLayerShadowColor];

    typedef struct _previousShadow
    {
        CGColorRef shadowColor;
        CGSize offSet;
        float opacity;
        float radius;
        CGColorRef fillColor;
    } PreviousShadow;

    PreviousShadow prev = {
        self.shadowColor, self.shadowOffset, self.shadowOpacity, self.shadowRadius, self.fillColor,
    };

    self.shadowColor = MNColor.blueColor.CGColor;
    self.shadowOffset = CGSizeMake(1, 1);
    self.shadowOpacity = 1;
    self.fillColor = MNColor.yellowColor.CGColor;
    //    self.shadowRadius = 10;

    [self pop_addAnimation:shadowRadiusAnimation forKey:@"arsfpwfp"];

    shadowRadiusAnimation.completionBlock = ^(POPAnimation* anim, BOOL finished) {
      //      self.shadowColor = nil;
      //      self.shadowOffset = CGSizeMake(0, 0);
      //      self.shadowOpacity = 0;
      //      self.shadowRadius = 0;
      //      self.fillColor = MNColor.blackColor.CGColor;
      self.shadowColor = prev.shadowColor;
      self.shadowOffset = prev.offSet;
      self.shadowOpacity = prev.opacity;
      self.shadowRadius = prev.radius;
      self.fillColor = prev.fillColor;
      //        self.strokeColor = MNColor.blackColor.CGColor;
      //        self.lineWidth = 1.;
    };

    scaleAnimation.autoreverses = YES;

    [((MNLayerNoteTests*)self.controller)oneshotPlay];
}

@end

@interface MNLayerNoteTests ()
{
    AEAudioController* _audioController;
    AEChannelGroupRef _group;
}
@property (strong, nonatomic) NSMutableArray<MNShapeLayer*>* layers;

@property (strong, nonatomic) AEAudioController* audioController;
@property (nonatomic, strong) AEAudioUnitChannel* audioUnitPlayer;
@property (nonatomic, strong) AEAudioFilePlayer* oneshot;
@property (assign, nonatomic) AudioUnit mySamplerUnit;
@property (nonatomic, strong) AEAudioFilePlayer* loop1;
@property (nonatomic, strong) AEAudioFilePlayer* loop2;
@property (nonatomic, strong) AEBlockChannel* oscillator;
@property (nonatomic, strong) CALayer* inputLevelLayer;
@property (nonatomic, strong) CALayer* outputLevelLayer;
@property (nonatomic, weak) NSTimer* levelsTimer;
@property (nonatomic, strong) AEAudioFilePlayer* player;

@end

@implementation MNLayerNoteTests

- (void)start
{
    [super start];
    [self runTest:@"Layer Note Test"
             func:@selector(layerTest:params:)
            frame:CGRectMake(0, 0, 600, 250)
           params:@{
               @"shadow" : @(NO)
           }];
    [self runTest:@"Layer Note Test - shadow"
             func:@selector(layerTest:params:)
            frame:CGRectMake(0, 0, 600, 250)
           params:@{
               @"shadow" : @(YES)
           }];
    [self audioSetup];
}

- (void)tearDown
{
    [super tearDown];
    [_audioController stop];
    dispatch_async(dispatch_get_main_queue(), ^{
      for(MNShapeLayer* layer in self.layers)
      {
          [layer removeAllAnimations];
          [layer removeFromSuperlayer];
      }
    });
}

- (NSMutableArray<MNShapeLayer*>*)layers
{
    if(!_layers)
    {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

- (void)audioSetup
{
    [super audioSetup];
    static BOOL once = YES;
    if(once)
    {
        once = NO;
#if TARGET_OS_IPHONE
        MNMAppDelegate* appDelegate = (MNMAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.audioController = appDelegate.audioController;

        self.loop1 = [AEAudioFilePlayer
            audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Southern Rock Drums" withExtension:@"m4a"]
                             error:NULL];
        _loop1.volume = 1.0;
        _loop1.channelIsMuted = YES;
        _loop1.loop = YES;

        // Create the second loop player
        self.loop2 = [AEAudioFilePlayer
            audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Southern Rock Organ" withExtension:@"m4a"]
                             error:NULL];
        _loop2.volume = 1.0;
        _loop2.channelIsMuted = YES;
        _loop2.loop = YES;

        // Create a block-based channel, with an implementation of an oscillator
        __block float oscillatorPosition = 0;
        __block float oscillatorRate = 622.0 / 44100.0;
        self.oscillator =
            [AEBlockChannel channelWithBlock:^(const AudioTimeStamp* time, UInt32 frames, AudioBufferList* audio) {
              for(int i = 0; i < frames; i++)
              {
                  // Quick sin-esque oscillator
                  float x = oscillatorPosition;
                  x *= x;
                  x -= 1.0;
                  x *= x;   // x now in the range 0...1
                  x *= INT16_MAX;
                  x -= INT16_MAX / 2;
                  oscillatorPosition += oscillatorRate;
                  if(oscillatorPosition > 1.0)
                      oscillatorPosition -= 2.0;

                  ((SInt16*)audio->mBuffers[0].mData)[i] = x;
                  ((SInt16*)audio->mBuffers[1].mData)[i] = x;
              }
            }];
        _oscillator.audioDescription = AEAudioStreamBasicDescriptionNonInterleaved16BitStereo;
        _oscillator.channelIsMuted = YES;

        // Create an audio unit channel (a file player)
        self.audioUnitPlayer = [[AEAudioUnitChannel alloc]
            initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple,
                                                                         kAudioUnitType_Generator,
                                                                         kAudioUnitSubType_AudioFilePlayer)];

        // Create a group for loop1, loop2 and oscillator
        _group = [_audioController createChannelGroup];
        [_audioController addChannels:@[ _loop1, _loop2, _oscillator ] toChannelGroup:_group];

        // Finally, add the audio unit player
        [_audioController addChannels:@[ _audioUnitPlayer ]];

#elif TARGET_OS_MAC

        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        self.audioController = appDelegate.audioController;

        // Create the first loop player
        self.loop1 = [AEAudioFilePlayer
            audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Southern Rock Drums" withExtension:@"m4a"]
                             error:NULL];
        _loop1.volume = 1.0;
        _loop1.channelIsMuted = YES;
        _loop1.loop = YES;

        // Create the second loop player
        self.loop2 = [AEAudioFilePlayer
            audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Southern Rock Organ" withExtension:@"m4a"]
                             error:NULL];
        _loop2.volume = 1.0;
        _loop2.channelIsMuted = YES;
        _loop2.loop = YES;

        // Create a block-based channel, with an implementation of an oscillator
        __block float oscillatorPosition = 0;
        __block float oscillatorRate = 622.0 / 44100.0;
        self.oscillator =
            [AEBlockChannel channelWithBlock:^(const AudioTimeStamp* time, UInt32 frames, AudioBufferList* audio) {
              for(int i = 0; i < frames; i++)
              {
                  // Quick sin-esque oscillator
                  float x = oscillatorPosition;
                  x *= x;
                  x -= 1.0;
                  x *= x;   // x now in the range 0...1
                  x -= 0.5;
                  oscillatorPosition += oscillatorRate;
                  if(oscillatorPosition > 1.0)
                      oscillatorPosition -= 2.0;
                  ((float*)audio->mBuffers[0].mData)[i] = x;
                  ((float*)audio->mBuffers[1].mData)[i] = x;
              }
            }];
        _oscillator.audioDescription = self.audioController.audioDescription;
        _oscillator.channelIsMuted = YES;

        // Create an audio unit channel (a file player)
        self.audioUnitPlayer = [[AEAudioUnitChannel alloc]
            initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple,
                                                                         kAudioUnitType_Generator,
                                                                         kAudioUnitSubType_AudioFilePlayer)];

        // Create a group for loop1, loop2 and oscillator
        _group = [_audioController createChannelGroup];
        [_audioController addChannels:@[ _loop1, _loop2, _oscillator ] toChannelGroup:_group];

        // Finally, add the audio unit player
        [_audioController addChannels:@[ _audioUnitPlayer ]];
#endif
    }
}

- (void)oneshotPlay
{
    if(_oneshot)
    {
        [_audioController removeChannels:@[ _oneshot ]];
        self.oneshot = nil;
    }
    else
    {
        self.oneshot = [AEAudioFilePlayer
            audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Organ Run" withExtension:@"m4a"]
                             error:NULL];
        _oneshot.removeUponFinish = YES;
        __weak typeof(self) weakSelf = self;
        _oneshot.completionBlock = ^{
          typeof(self) strongSelf = weakSelf;
          strongSelf.oneshot = nil;
        };
        [_audioController addChannels:@[ _oneshot ]];
    }
}

- (MNTestBlockStruct*)layerTest:(id<MNTestParentDelegate>)parent params:(NSDictionary*)options
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    //    ret.drawBlock = nil;
    //    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
    //    };

    MNLogInfo(@"");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(50, 50, 100, 0)];
    NSDictionary* note_struct = @{ @"keys" : @[ @"g/4", @"bb/4", @"d/5" ], @"duration" : @"q" };
    MNStaffNote* note = [[MNStaffNote alloc] initWithDictionary:note_struct];
    [note addAccidental:[MNAccidental accidentalWithType:@"b"] atIndex:1];
    //  [ret.staves addObject:staff];

    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:note] preFormat];
    tickContext.x = 25;
    tickContext.pointsUsed = 20;
    note.staff = staff;

    MNShapeLayer* staffNoteLayer = (MNShapeLayer*)[note shapeLayer];
    //#if TARGET_OS_IPHONE
    //#elif TARGET_OS_MAC
    staffNoteLayer.controller = self;

#if TARGET_OS_IOS
    if(![parent isKindOfClass:[UIView class]])
    {
        MNLogError(@"Attempting to store non-view superview for layer note");
    }
    staffNoteLayer.superView = (UIView*)parent;
#endif
    staffNoteLayer.backgroundColor = MNColor.orangeColor.CGColor;
    staffNoteLayer.frame = [self rectInSuperView:staffNoteLayer];

    if([options[@"shadow"] boolValue])
    {
        staffNoteLayer.backgroundColor = nil;
        staffNoteLayer.fillColor = MNColor.blueColor.CGColor;
        staffNoteLayer.shadowColor = MNColor.blueColor.CGColor;
        staffNoteLayer.shadowOffset = CGSizeMake(1, 1);
        staffNoteLayer.shadowOpacity = 1;
        staffNoteLayer.shadowRadius = 10;
    }

    //        CALayer* tmp = [CALayer layer];
    //        tmp.frame = CGRectMake(50, 50, 50, 50);
    //        tmp.backgroundColor = MNColor.blueColor.CGColor;
    //        [weakParent.layer addSublayer:tmp];

    [self.layers addObject:staffNoteLayer];

    //    dispatch_async(dispatch_get_main_queue(), ^{
    //      [parent.layer addSublayer:staffNoteLayer];
    //    });

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [parent.layer addSublayer:staffNoteLayer];
    };

    return ret;
}

/*
static CGFloat xMax;
static CGFloat xMin;
static CGFloat yMax;
static CGFloat yMin;

void ApplierFunction(void* info, const CGPathElement* element)
{
    CGPoint point = element->points[0];
    if(point.x > xMax)
    {
        xMax = point.x;
    }
    // ...
    // ...
    // ...
}
 */

- (CGRect)rectInSuperView:(MNShapeLayer*)layer
{
    // // one method to iterate over a path
    //    CGPathApply(layer.path, NULL, &ApplierFunction);

    CGRect ret = CGPathGetBoundingBox(layer.path);
    ret.origin = [layer convertPoint:ret.origin toLayer:layer.superlayer.superlayer];
    return ret;
}

//// this method assumes the class has a member called mySamplerUnit
//// which is an instance of an AUSampler
//- (OSStatus)loadFromDLSOrSoundFont:(NSURL*)bankURL withPatch:(int)presetNumber
//{
//    OSStatus result = noErr;
//
//    // fill out a instrument data structure
//    AUSamplerInstrumentData instdata;
//    instdata.fileURL = (__bridge CFURLRef)bankURL;
//    instdata.instrumentType = kInstrumentType_DLSPreset;
//    instdata.bankMSB = kAUSampler_DefaultMelodicBankMSB;
//    instdata.bankLSB = kAUSampler_DefaultBankLSB;
//    instdata.presetID = (UInt8)presetNumber;
//
//    // set the kAUSamplerProperty_LoadPresetFromBank property
//    result = AudioUnitSetProperty(self.mySamplerUnit, kAUSamplerProperty_LoadInstrument, kAudioUnitScope_Global, 0,
//                                  &instdata, sizeof(instdata));
//
//    // check for errors
//    NSCAssert(result == noErr, @"Unable to set the preset property on the Sampler. Error code:%d '%.4s'", (int)result,
//              (const char*)&result);
//
//    return result;
//}

@end