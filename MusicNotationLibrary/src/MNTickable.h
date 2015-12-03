//
//  MNTickable.h
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

#import "MNDelegates.h"
#import "MNSymbol.h"
#import "IAModelBase.h"
#import "MNTickableMetrics.h"

@class MNPoint;
@class MNModifierContext, MNTickContext, MNVoice, MNTuplet, MNBoundingBox, MNRational, MNModifier;

/*!
 *  The `MNTickable`. Tickables are things that sit on a score and
 *  have a duration, i.e., they occupy space in the musical rendering dimension.
 */
@interface MNTickable : MNSymbol <MNTickableDelegate>
{
   @private
    __weak MNStaff* _staff;

    NSUInteger _intrinsicTicks;
    MNRational* _tickMultiplier;
    MNRational* _ticks;

    //    float _width;
    float _x;
    float _x_shift;

    __weak MNVoice* _voice;
    MNTickContext* _tickContext;
    MNModifierContext* _modifierContext;
    NSMutableArray* _modifiers;

    MNTuplet* _tuplet;

    BOOL _align_center;
    float _center_x_shift;   // Shift from tick context if center aligned
    BOOL _ignore_ticks;

    float _getCenterXShift;
    float _extraLeftPx;
    float _extraRightPx;
    BOOL _shouldIgnoreTicks;
}

#pragma mark - Properties
@property (weak, nonatomic) MNStaff* staff;
@property (assign, nonatomic) NSUInteger intrinsicTicks;
@property (strong, nonatomic) MNRational* tickMultiplier;
//@property (strong, nonatomic) Rational *ticks;
//@property (assign, nonatomic) float width;
//@property (assign, nonatomic) float x;
@property (assign, nonatomic) float x_shift;
@property (weak, nonatomic) MNVoice* voice;
@property (strong, nonatomic) MNTickContext* tickContext;
@property (strong, nonatomic) MNModifierContext* modifierContext;
@property (strong, nonatomic) NSMutableArray* modifiers;
@property (strong, nonatomic) MNTuplet* tuplet;
//@property (strong, nonatomic) TickableMetrics *metrics;

@property (assign, nonatomic, getter=isCenterAligned, setter=setCenterAlignment:) BOOL align_center;
@property (assign, nonatomic) float centerXShift;   // Shift from tick context if center aligned

// This flag tells the formatter to ignore this tickable during
// formatting and justification. It is set by tickables such as BarNote.
//@property (assign, nonatomic) BOOL ignore_ticks;
@property (assign, nonatomic) CGContextRef graphicsContext;
@property (strong, nonatomic, readonly) MNBoundingBox* boundingBox;

@property (readonly, nonatomic, getter=getCenterXShift) float getCenterXShift;

//@property (assign, nonatomic) float extraLeftPx;
//@property (assign, nonatomic) float extraRightPx;
@property (assign, nonatomic, getter=shouldIgnoreTicks) BOOL shouldIgnoreTicks;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (id)metrics;

- (void)addToModifierContext:(MNModifierContext*)modifierContext;
- (void)addModifier:(MNModifier*)modifier;

- (BOOL)preFormat;
- (BOOL)postFormat;

- (void)setIntrinsicTicks:(NSUInteger)intrinsicTicks;
- (void)applyTickMultiplier:(NSUInteger)numerator denominator:(NSUInteger)denominator;
- (void)setTickDuration:(MNRational*)duration;

- (float)getExtraLeftPx;
- (float)getExtraRightPx;
- (id)setExtraLeftPx:(float)extraLeftPx;
- (id)setExtraRightPx:(float)extraRightPx;

- (MNRational*)getTicks;
- (id)setTicks:(MNRational*)ticks;

- (BOOL)getIgnoreTicks;
- (id)setIgnoreTicks:(BOOL)ignoreTicks;

@end
