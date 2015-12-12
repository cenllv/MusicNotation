//
//  MNVoice.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
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

#import "MNVoice.h"
#import <objc/runtime.h>
#import "MNUtils.h"
#import "MNTickable.h"
#import "MNRational.h"
#import "MNStaff.h"
#import "MNVoiceGroup.h"
#import "MNBoundingBox.h"
#import "MNTable.h"
#import "MNStaffNote.h"
#import "MNConstants.h"

@interface MNVoice ()
{
    __weak MNStaff* _staff;
    BOOL _preFormatted;
    NSUInteger _largestTickWidth;
    MNRational* _ticksUsed;
    MNRational* _totalTicks;
    MNVoiceTime* _time;
}
@end

@implementation MNVoice

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithTimeDict:(NSDictionary*)optionsDict
{
    self = [self initWithDictionary:optionsDict];
    if(self)
    {
        // TODO: test that passing a time Dict can initialize propertly
        // i.e.
        // init: function(time) {
        //    self.time = Vex.Merge({
        //    num_beats: 4,
        //    beat_value: 4,
        //    resolution: Vex.Flow.RESOLUTION
        //    }, time);

        //        [self setupVoice];
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)initWithTime:(MNVoiceTime*)timeStruct
{
    self = [self initWithTimeDict:nil];
    if(self)
    {
        _time = timeStruct;
        [self setupVoice];
    }
    return self;
}

+ (MNVoice*)voiceWithTime:(MNVoiceTime*)timeStruct
{
    return [[MNVoice alloc] initWithTime:timeStruct];
}

+ (MNVoice*)voiceWithBeats:(NSUInteger)numberOfBeats beatValue:(NSUInteger)beatValue resolution:(NSUInteger)resolution
{
    return [[MNVoice alloc]
        initWithTime:[MNVoiceTime timeWithBeats:numberOfBeats beatValue:beatValue resolution:resolution]];
}

+ (MNVoice*)voiceWithTimeSignature:(MNTimeType)timeType
{
    if(timeType > 23)
    {
        MNLogError(@"InvalidMNTimeType, argument for  MNVoice initializer must be less than 10");
        return nil;
    }
    switch(timeType)
    {
        case MNTime4_4:
            return [MNVoice voiceWithBeats:4 beatValue:4 resolution:kRESOLUTION];
            break;
        case MNTime3_4:
            return [MNVoice voiceWithBeats:3 beatValue:4 resolution:kRESOLUTION];
            break;
        case MNTime2_4:
            return [MNVoice voiceWithBeats:2 beatValue:4 resolution:kRESOLUTION];
            break;
        case MNTime4_2:
            return [MNVoice voiceWithBeats:4 beatValue:2 resolution:kRESOLUTION];
            break;
        case MNTime2_2:
            return [MNVoice voiceWithBeats:2 beatValue:2 resolution:kRESOLUTION];
            break;
        case MNTime3_8:
            return [MNVoice voiceWithBeats:3 beatValue:8 resolution:kRESOLUTION];
            break;
        case MNTime6_8:
            return [MNVoice voiceWithBeats:6 beatValue:8 resolution:kRESOLUTION];
            break;
        case MNTime9_8:
            return [MNVoice voiceWithBeats:9 beatValue:8 resolution:kRESOLUTION];
            break;
        case MNTime12_8:
            return [MNVoice voiceWithBeats:12 beatValue:8 resolution:kRESOLUTION];
            break;
        case MNTime5_8:
            return [MNVoice voiceWithBeats:5 beatValue:8 resolution:kRESOLUTION];
            break;
        default:
            return nil;
            break;
    }
}

- (void)setupVoice
{
    // Recalculate total ticks.

    _totalTicks = [MNRational rationalWithNumerator:(self.time.numBeats * self.time.resolution / self.time.beatValue)
                                     andDenominator:1];
    _resolutionMultiplier = 1;

    // Set defaults
    //    _tickables = [NSMutableArray array];
    _ticksUsed = RationalZero();
    self.smallestTickCount = [self.totalTicks clone];
    _largestTickWidth = 0;
    _staff = nil;   //[MNStaff currentStaff];
    _boundingBox = nil;

    // Do we care about strictly timed notes
    _mode = MNModeStrict;

    // This must belong to a VoiceGroup
    _voiceGroup = nil;
}

+ (MNVoice*)voiceWithNumBeats:(NSUInteger)beats beatValue:(NSUInteger)beatValue resolution:(NSUInteger)resolution
{
    return [MNVoice voiceWithBeats:beats beatValue:beatValue resolution:resolution];
}

+ (MNVoice*)standardVoice
{
    return [MNVoice voiceWithBeats:4 beatValue:4 resolution:kRESOLUTION];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"num_beats" : @"time.numBeats",
        @"beat_value" : @"time.beatValue",
        @"resolution" : @"time.resolution",
    }];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

- (MNVoiceTime*)time
{
    if(!_time)
    {
        MNLogError(@"InitializationError, no time set for voice, using standard time.");
        _time = [MNVoiceTime timeWithBeats:4 beatValue:4 resolution:kRESOLUTION];
    }
    return _time;
}

// Get the actual tick resolution for the voice
- (NSUInteger)getActualResolution
{
    return _resolutionMultiplier * self.time.resolution;
}

- (NSMutableArray*)tickables
{
    if(!_tickables)
    {
        _tickables = [[NSMutableArray alloc] init];
    }
    return _tickables;
}

- (MNRational*)totalTicks
{
    if(!_totalTicks)
    {
        _totalTicks = RationalZero();
    }
    return _totalTicks;
}

- (MNRational*)ticksUsed
{
    if(!_ticksUsed)
    {
        _ticksUsed = RationalZero();
    }
    return _ticksUsed;
}

- (MNRational*)smallestTickCount
{
    if(!_smallestTickCount)
    {
        _smallestTickCount = RationalZero();
    }
    return _smallestTickCount;
}

- (MNStaff*)staff
{
    if(!_staff)
    {
        MNLogInfo(@"StaffInstantiationInfo %@", @"no weak staff parent.");
    }
    return _staff;
}

// set the voice's staff
- (void)setStaff:(MNStaff*)staff
{
    MNLogInfo(@"VoiceStaffSettingInfo, setting up the voice on staff");
    _boundingBox = nil;
    _staff = staff;
}

// Get the bounding box for the voice
- (MNBoundingBox*)boundingBox
{
    _boundingBox = [MNBoundingBox boundingBoxZero];
    if(!self.staff)
    {
        MNLogError(@"NoStaff, Can't get bounding box without Staff.");
        abort();
    }

    BOOL first = YES;
    for(MNStaffNote* tickable in self.tickables)
    {
        if([tickable isMemberOfClass:[MNStaffNote class]])
        {
            tickable.staff = self.staff;
            MNBoundingBox* bb = tickable.boundingBox;
            if(first)
            {
                first = !first;
                _boundingBox.xPosition = bb.xPosition;
                _boundingBox.yPosition = bb.yPosition;
            }
            [_boundingBox mergeWithBox:bb];
        }
        else
        {
            MNLogError(@"Unknown object in tickables array.");
        }
    }
    return _boundingBox;
}

// Every tickable must be associated with a voiceGroup. This allows formatters
// and preformatters to associate them with the right modifierContexts.
- (MNVoiceGroup*)getVoiceGroup
{
    if(!_voiceGroup)
    {
        MNLogError(@"NoVoiceGroup, No voice group for voice.");
        return nil;
    }
    return _voiceGroup;
}

// Set the voice mode to strict or soft
// TODO: change this to BOOL?
- (void)setStrict:(MNModeType)mode
{
    if(mode != 0)
    {
        _mode = mode;
    }
    //    _mode = mode  ?  MNModeStrict :  MNModeSoft;
}

// Determine if the voice is complete according to the voice mode
- (BOOL)isComplete
{
    if(self.mode == MNModeStrict)
    {
        return [self.ticksUsed equals:self.totalTicks];
    }
    else
    {
        return YES;
    }
}

#pragma mark - Methods

/*!
 *  Add a tickable to the voice
 *  @param tickable a tickable object
 *  @return this voice
 */
- (id)addTickable:(id<MNTickableDelegate>)tickable
{
    if(![tickable shouldIgnoreTicks])
    {
        MNRational* ticks = tickable.ticks;

        // update the total ticks for this line
        [self.ticksUsed add:tickable.ticks];

        if((self.mode == MNModeStrict || self.mode == MNModeFull) && [self.ticksUsed greaterThan:self.totalTicks])
        {
            [self.totalTicks subtract:ticks];
            MNLogError(@"BadArgument, Too many ticks.");
        }

        // track the smallest tickable for formatting
        if([ticks lessThan:self.smallestTickCount])
        {
            self.smallestTickCount = [ticks clone];
        }
        self.resolutionMultiplier = self.ticksUsed.denominator;

        // expand total ticks using denominator from ticks used
        //[self.totalTicks add:ticks];
        [self.totalTicks add:[MNRational rationalWithNumerator:0 andDenominator:self.ticksUsed.denominator]];
    }

    // add the tickable to the line
    [self.tickables addObject:tickable];
    if([tickable isKindOfClass:[MNNote class]])
    {
        tickable.voice = self;
    }
    else
    {
        MNLogError(@"NoteAddTickableException, cannot set voice on note.");
    }
    return self;
}

/*!
 *  Add an array of tickables to the voice.
 *  @param tickables the array of tickables
 *  @return this voice
 */
- (id)addTickables:(NSArray*)tickables
{
    for(id<MNTickableDelegate> tickable in tickables)
    {
        [self addTickable:tickable];
    }
    return self;
}

/*!
 *  Preformats the voice by applying the voice's stave to each note.
 *  @return if preformatted successfully
 */
- (BOOL)preFormat
{
    if(!_preFormatted)
    {
        [self.tickables oct_foreach:^(id<MNTickableDelegate> tickable, NSUInteger index, BOOL* stop) {
          tickable.staff = self.staff;
        }];
    }
    _preFormatted = YES;
    return YES;
}

// Render the voice onto the canvas `context` and an optional `stave`.
// If `stave` is omitted, it is expected that the notes have staves
// already set.
- (void)draw:(CGContextRef)ctx dirtyRect:(CGRect)dirtyRect toStaff:(MNStaff*)staff
{
    //    MNBoundingBox *boundingBox = ((MNStaffNote *)self.tickables[0]).boundingBox;
    //    for (MNStaffNote *tickable in self.tickables) {
    for(id<MNTickableDelegate> tickable in self.tickables)
    {
        if(staff)
        {
            [tickable setStaff:staff];
        }
        if(!tickable.staff)
        {
            MNLogError(@"MissingStave, The voice cannot draw tickables without staves.");
        }
        //        if (tickable.boundingBox) {
        //            [boundingBox mergeWithBox:tickable.boundingBox];
        //        }

        // TODO: the following call may be unncessesary
        [tickable preFormat];
        [tickable draw:ctx];
    }
    //    self.boundingBox = boundingBox;
}

@end
