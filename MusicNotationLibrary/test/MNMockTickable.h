//
//  MNMocks.h
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

#import "MNTestViewController.h"
#import "MNDelegates.h"
#import "MNTickable.h"
#import "MNEnum.h"

/*!
 *  The `MNMockTickable` class sets up a mock tickable delegate object for testing formatting without a complicated
 * notation
 */
@interface MockTickable : NSObject <MNTickableDelegate>
{
    __weak MNStaff* _staff;
    NSUInteger _intrinsicTicks;
    MNRational* _tickMultiplier;
    MNRational* _ticks;
    float _width;
    float _x;
    float _xShift;
    __weak MNVoice* _voice;
    MNTickContext* _tickContext;
    MNModifierContext* _modifierContext;
    NSMutableArray* _modifiers;
    BOOL _preFormatted;
    BOOL _postFormatted;
    MNTuplet* _tuplet;
    MNTickableMetrics* _metrics;
    BOOL _align_center;
    float _center_x_shift;
    BOOL _ignore_ticks;
    CGContextRef _graphicsContext;
    MNBoundingBox* _boundingBox;
    float _getCenterXShift;
    float _extraLeftPx;
    float _extraRightPx;
    BOOL _shouldIgnoreTicks;
}
@property (weak, nonatomic) MNStaff* staff;

@property (assign, nonatomic) NSUInteger intrinsicTicks;
@property (strong, nonatomic) MNRational* tickMultiplier;

//@property (strong, nonatomic) Rational* ticks;

//@property (assign, nonatomic) float width;
//@property (assign, nonatomic) float x_shift;
@property (weak, nonatomic) MNVoice* voice;

@property (strong, nonatomic) MNTickContext* tickContext;

@property (strong, nonatomic) MNModifierContext* modifierContext;
@property (strong, nonatomic) NSMutableArray* modifiers;
@property (assign, nonatomic) BOOL preFormatted;
@property (assign, nonatomic) BOOL postFormatted;
@property (strong, nonatomic) MNTuplet* tuplet;
@property (strong, nonatomic) MNTickableMetrics* metrics;
@property (assign, nonatomic, getter=isCenterAligned, setter=setCenterAlignment:) BOOL align_center;
@property (assign, nonatomic) float center_x_shift;   // Shift from tick context if center aligned

//@property (assign, nonatomic) BOOL ignore_ticks;

@property (assign, nonatomic) CGContextRef graphicsContext;
@property (strong, nonatomic, readonly) MNBoundingBox* boundingBox;
@property (readonly, nonatomic, getter=getCenterXShift) float getCenterXShift;
@property (assign, nonatomic) float extraLeftPx;
@property (assign, nonatomic) float extraRightPx;

@property (assign, nonatomic) BOOL shouldIgnoreTicks;

- (instancetype)initWithTimeType:(MNTimeType)timeType;
+ (MockTickable*)mockTickableWithTimeType:(MNTimeType)timeType;

//- (void)addToModifierContext:(MNModifierContext *)mc;
//- (void)addModifiersObject:(MNModifier *)mod;
- (BOOL)preFormat;
//- (BOOL)postFormat;
//- (void)setIntrinsicTicks:(Rational *)intrinsicTicks;
//- (void)applyTickMultiplier:(NSUInteger)numerator denominator:(NSUInteger)denominator;
//- (void)setDuration:(Rational *)duration;

- (float)getX;
- (MNRational*)getIntrinsicTicks;
//- (Rational*)getTicks;
- (MockTickable*)setCustomTicks:(MNRational*)t;
- (NSDictionary*)getMetrics;
- (void)getWidth;
- (MockTickable*)setCustomWidth:(float)w;
- (id)setWidth:(float)w;
- (void)setVoice:(MNVoice*)v;
- (void)setstaff:(MNStaff*)staff;
//- (void)setTickContext:(MNTickContext *)tc;
//- (void)setIgnoreTicks:(BOOL)ignore_ticks;
//- (BOOL)shouldIgnoreTicks;

- (MNRational*)getTicks;
- (id)setTicks:(MNRational*)ticks;

- (BOOL)getIgnoreTicks;
- (id)setIgnoreTicks:(BOOL)ignoreTicks;

@end
