//
//  MNVoice.h
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


#import "MNEnum.h"
#import "MNDelegates.h"
#import "IAModelBase.h"
#import "MNVoiceTime.h"

@class MNStaff, MNRational, MNStaffNote, MNVoiceGroup, MNBoundingBox;

/*! The `MNVoice` class represents a voicing. In music composition and arranging, a voicing is the
        instrumentation and vertical spacing and ordering of the pitches in a chord (which notes are on
        the top or in the middle, which ones are doubled, which octave each is in, and which instruments
        or voices perform each). Which note is on the bottom determines the inversion.

    Voicing is "the manner in which one distributes, or spaces, notes and chords among the various
        instruments" and spacing or "simultaneous vertical placement of notes in relation to each
        other."

     http://en.wikipedia.org/wiki/Voicing_%28music%29

 */
@interface MNVoice : IAModelBase
{
}

#pragma mark - Properties

@property (strong, nonatomic) NSMutableArray* tickables;

@property (strong, nonatomic, readonly) MNRational* totalTicks;   // Get the total ticks in the voice

@property (strong, nonatomic, readonly)
    MNRational* ticksUsed;   // Get the total ticks used in the voice by all the tickables

@property (strong, nonatomic) MNRational* smallestTickCount;   // Get the tick count for the shortest tickable

@property (assign, nonatomic, readonly) NSUInteger largestTickWidth;   // Get the largest width of all the tickables

@property (weak, nonatomic) MNStaff* staff;   // Set the voice's stave

@property (strong, nonatomic) MNVoiceGroup* voiceGroup;

@property (retain, nonatomic) MNBoundingBox* boundingBox;

/*! strict/soft/full
 */
@property (assign, nonatomic, setter=setStrict:)
    MNModeType mode;   // Get/set the voice mode, use a value from `Voice.Mode`

@property (strong, nonatomic, readonly) MNVoiceTime* time;

@property (assign, nonatomic) NSUInteger resolutionMultiplier;   // Get the resolution multiplier for the voice
@property (assign, nonatomic, readonly, getter=getActualResolution) NSUInteger actualResolution;

@property (assign, nonatomic, readonly, getter=isComplete) BOOL isComplete;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithTimeDict:(NSDictionary*)optionsDict;
+ (MNVoice*)voiceWithTime:(MNVoiceTime*)timeStruct;

+ (MNVoice*)voiceWithNumBeats:(NSUInteger)beats beatValue:(NSUInteger)beatValue resolution:(NSUInteger)resolution;
+ (MNVoice*)voiceWithTimeSignature:(MNTimeType)time;
//- (id)addTickable:(MNStaffNote*)tickable;
- (id)addTickable:(id<MNTickableDelegate>)tickable;
- (id)addTickables:(NSArray*)tickables;

- (BOOL)preFormat;
//- (void)draw:(CGContextRef)ctx toStaff:(MNStaff*)staff;
- (void)draw:(CGContextRef)ctx dirtyRect:(CGRect)dirtyRect toStaff:(MNStaff*)staff;

@end
