//
//  MNDelegates.h
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

#if TARGET_OS_IPHONE

//#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC

#endif

@class MNModifierContext, MNTickContext, MNVoice, MNTuplet, MNBoundingBox, MNModifier, MNStaff, MNRational;
@class MNMetrics, MNTuplet;
@protocol TickableMetrics;

/*!
 *  The `MNTickableDelegate` protocol...
 */
@protocol MNTickableDelegate <NSObject>
@required
@property (weak, nonatomic) MNStaff* staff;
@property (assign, nonatomic) NSUInteger intrinsicTicks;
@property (strong, nonatomic) MNRational* tickMultiplier;
//@property (strong, nonatomic) Rational* ticks;
- (MNRational*)ticks;
- (id)setTicks:(MNRational*)ticks;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float x;
//@property (assign, nonatomic) float x_shift;
- (id)setXShift:(float)xShift;
- (float)xShift;
//@property (weak, nonatomic)  MNVoice* voice;
- (id)setVoice:(MNVoice*)voice;
- (MNVoice*)voice;
- (id)setTuplet:(MNTuplet*)tuplet;
- (MNTuplet*)tuplet;
//@property (strong, nonatomic)  MNTickContext* tickContext;
- (id)setTickContext:(MNTickContext*)tickContext;
- (MNTickContext*)tickContext;
//@property (strong, nonatomic)  MNModifierContext* modifierContext;
- (id)setModifierContext:(MNModifierContext*)modifierContext;
- (MNModifierContext*)modifierContext;
@property (strong, nonatomic) NSMutableArray* modifiers;
@property (assign, nonatomic) BOOL preFormatted;
@property (assign, nonatomic) BOOL postFormatted;
//@property (strong, nonatomic)  MNTuplet* tuplet;

@property (assign, nonatomic) BOOL centerAlign;
@property (assign, nonatomic) float center_x_shift;   // Shift from tick context if center aligned
//@property (assign, nonatomic) BOOL ignore_ticks;
@property (strong, nonatomic, readonly) MNBoundingBox* boundingBox;
//@property (readonly, nonatomic, getter=getCenterXShift) float getCenterXShift;
@property (assign, nonatomic) float extraLeftPx;
@property (assign, nonatomic) float extraRightPx;
@property (assign, nonatomic) BOOL shouldIgnoreTicks;

@required
//- (id)metrics;

@required
- (void)addToModifierContext:(MNModifierContext*)mc;
//- (void)addModifiersObject:(MNModifier*)mod;
- (id)addModifier:(MNModifier*)modifier;

- (BOOL)preFormat;
- (BOOL)postFormat;

- (id<TickableMetrics>)metrics;

//- (BOOL)getIgnoreTicks;
//- (id)setIgnoreTicks:(BOOL)ignoreTicks;

- (void)setIntrinsicTicks:(NSUInteger)intrinsicTicks;
- (void)applyTickMultiplier:(NSUInteger)numerator denominator:(NSUInteger)denominator;
- (void)setTickDuration:(MNRational*)duration;

@optional
- (void)draw:(CGContextRef)ctx;
@end

@protocol TickableMetrics <NSObject>
@required
@property (assign, nonatomic) float width;          // The total width of the note (including modifiers.)
@property (assign, nonatomic) float noteWidth;      // The width of the note head only.
@property (assign, nonatomic) float left_shift;     // The horizontal displacement of the note.
@property (assign, nonatomic) float modLeftPx;      // Start `X` for left modifiers.
@property (assign, nonatomic) float modRightPx;     // Start `X` for right modifiers.
@property (assign, nonatomic) float extraLeftPx;    // Extra left pixels for modifers & displace notes
@property (assign, nonatomic) float extraRightPx;   // Extra right pixels for modifers & displace notes
@property (assign, nonatomic) float notePoints;
@end
