//
//  MNModifier.m
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

#import "MNModifier.h"
#import "MNNote.h"
#import "MNLog.h"
#import "MNEnum.h"
#import "MNModifierContext.h"
#import "MNMetrics.h"
#import "MNGlyphList.h"
#import "MNGlyph.h"
#import "MNStaff.h"
//#import "MNNote.h"
#import "MNTickContext.h"
#import "MNRenderOptions.h"
#import <objc/runtime.h>
#import "NSString+Ruby.h"
#import "MNRational.h"
#import "MNBoundingBox.h"
#import "MNTuplet.h"
#import "MNTable.h"
#import "MNTickable.h"
#import "MNPoint.h"

@interface MNModifier (private)
//@property (assign, nonatomic) float width;
@end

@implementation MNModifier

@synthesize x = _x;
@synthesize ticks = _ticks;
//@synthesize x_shift = _x_shift;
@synthesize shouldIgnoreTicks = _shouldIgnoreTicks;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setupModifier];
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"x_shift" : @"xShift",
        @"y_shift" : @"yShift",
    }];
    return propertiesEntriesMapping;
}

- (void)setupModifier
{
    self.width = 0;
    //    self.graphicsContext = NULL;

    // Modifiers are attached to a note and an index. An index is a
    // specific head in a chord.
    //    _note = nil;
    self.index = 0;

    // The `text_line` is reserved space above or below a stave.
    _text_line = 0;
    _positionType = MNPositionLeft;
    _modifierContext = nil;
    _xShift = 0;
    _yShift = 0;
    // NOTE: uncomment the folloing for more debug info
    //     [MNLog logInfo:[NSString stringWithFormat:@"Created new modifier. Class: %@ Category: %@",
    //                                              [object_getClass((id)self) class], [object_getClass((id)self)
    //                                              CATEGORY]]];
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY;
{
    return @"none";
}

// Every modifier has a category. The `ModifierContext` uses this to determine
// the type and order of the modifiers.
- (NSString*)category;
{
    return [MNModifier CATEGORY];
}

+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context;
{
    return YES;
}

//- (BOOL)preFormat; { return YES; }
//- (BOOL)postFormat; { return YES; }
- (BOOL)postFormatWith:(NSArray*)notes;
{
    return YES;
}

#pragma mark - Properties

// Shift modifier `x` pixels in the direction of the modifier. Negative values
// shift reverse.
- (id)setXShift:(float)xShift;
{
    _xShift = 0;
    if(self.position == MNPositionLeft)
    {
        _xShift -= xShift;
    }
    else
    {
        _xShift += xShift;
    }
    return self;
}

- (float)xShift
{
    return _xShift;
}

- (id)setPosition:(MNPositionType)position;
{
    _positionType = position;
    return self;
}

- (MNPositionType)position;
{
    return _positionType;
}

- (void)setIndex:(NSUInteger)index;
{
    _index = index;
}

- (NSUInteger)index;
{
    return _index;
}

// Render the modifier onto the canvas.
- (void)draw:(CGContextRef)ctx withStaff:(MNStaff*)staff withShiftX:(float)shiftX;
{
    // abstract ?
}

- (void)setupTickable;
{
    _intrinsicTicks = 0;
    _tickMultiplier = [MNRational rationalWithNumerator:1 andDenominator:1];
    _ticks = [MNRational rationalWithNumerator:0 andDenominator:1];
    self.width = 0;
    _xShift = 0;   // Shift from tick context
    _voice = nil;
    _tickContext = nil;
    _modifierContext = nil;
    _modifiers = [@[] mutableCopy];
    _tuplet = nil;

    self.centerAlign = NO;
    _center_x_shift = 0;   // Shift from tick context if center aligned

    // self flag tells the formatter to ignore self tickable during
    // formatting and justification. It is set by tickables such as BarNote.
    _ignore_ticks = NO;
    //    self.graphicsContext = nil;
}

- (MNTickableMetrics*)metrics
{
    // FIXME: this doesn't work for all modifiers
    MNTickableMetrics* ret = [[MNTickableMetrics alloc] initWithDictionary:nil];
    ret.extraLeftPx = self.extraLeftPx;
    ret.extraRightPx = self.extraRightPx;
    ret.noteWidth = self.note.width;
    ret.left_shift = 0;
    ret.modLeftPx = self.point.x;
    ret.modRightPx = self.point.y;
    ret.notePoints = 0;
    ret.width = self.width;
    ret.point = self.point;
    return ret;
}

- (MNBoundingBox*)boundingBox;
{
    MNTickableMetrics* metrics = self.metrics;
    return [MNBoundingBox boundingBoxAtX:metrics.modLeftPx atY:metrics.modRightPx withWidth:self.width andHeight:0];
}

- (float)getCenterXShift;
{
    if(self.centerAlign)
    {
        return self.center_x_shift;
    }
    return 0;
}

//- (void)setCenterAlignment:(BOOL)align_center;
//{
//    self.align_center = align_center;
//}

// Every tickable must be associated with a voice. self allows formatters
// and preFormatter to associate them with the right modifierContexts
- (MNVoice*)voice
{
    if(!_voice)
    {
        MNLogError(@"NoVoice, Tickable has no voice.");
    }
    return _voice;
}

- (MNTuplet*)tuplet
{
    return _tuplet;
}

/*!
 *  Attach self to a tuplet object
 *  @param tuplet the tuplet to attach to
 *  @return this object
 */
- (id)setTuplet:(MNTuplet*)tuplet;
{
    // Detach from previous tuplet
    NSUInteger noteCount, beatsOccupied;

    if(self.tuplet)
    {
        noteCount = self.tuplet.noteCount;
        beatsOccupied = self.tuplet.beatsOccupied;

        // Revert old multiplier
        [self applyTickMultiplier:noteCount denominator:beatsOccupied];
    }

    // Attach to [tuplet
    if(tuplet)
    {
        noteCount = tuplet.noteCount;
        beatsOccupied = tuplet.beatsOccupied;

        [self applyTickMultiplier:beatsOccupied denominator:noteCount];
    }

    _tuplet = tuplet;
    return self;
}

// optional, if tickable has modifiers
- (void)addToModifierContext:(MNModifierContext*)mc;
{
    self.modifierContext = mc;
    // Add modifiers to modifier context (if any)
    self.preFormatted = NO;
}

// optional, if tickable has modifiers
//- (void)addModifiersObject:(MNModifier*)mod;
//{
//    [self.modifiers addObject:mod];
//    self.preFormatted = NO;
//}

- (id)addModifier:(MNModifier*)modifier;
{
    [self.modifiers addObject:modifier];
    self.preFormatted = NO;
    return self;
}

- (void)setTickContext:(MNTickContext*)tickContext;
{
    _tickContext = tickContext;
    self.preFormatted = NO;
}

- (BOOL)preFormat;
{
    if(self.preFormatted)
    {
        return YES;
    }
    self.width = 0;
    if(self.modifierContext)
    {
        [self.modifierContext preFormat];
    }
    return YES;
}

- (BOOL)postFormat;
{
    if(self.postFormatted)
    {
        return YES;
    }
    self.postFormatted = YES;
    return YES;
}

- (MNRational*)tickMultiplier;
{
    if(!_tickMultiplier)
    {
        _tickMultiplier = RationalOne();
    }
    return _tickMultiplier;
}

- (MNRational*)ticks;
{
    if(!_ticks)
    {
        _ticks = RationalZero();
    }
    return _ticks;
}

- (void)setIntrinsicTicks:(NSUInteger)intrinsicTicks;
{
    _intrinsicTicks = intrinsicTicks;
    _ticks = [[self.tickMultiplier clone] mult:intrinsicTicks];
}

- (void)applyTickMultiplier:(NSUInteger)numerator denominator:(NSUInteger)denominator;
{
    [self.tickMultiplier multiply:[MNRational rationalWithNumerator:numerator andDenominator:denominator]];
    _ticks = [[self.tickMultiplier clone] mult:self.intrinsicTicks];
}

//- (void)setDuration:(Rational*)duration;
//{
//    NSUInteger ticks = duration.numerator * (kRESOLUTION / duration.denominator);
//    _ticks = [[self.tickMultiplier clone] mult:ticks];
//    _intrinsicTicks = [self.ticks floatValue];
//}

- (void)setTickDuration:(MNRational*)duration;
{
    NSUInteger ticks = duration.numerator * (kRESOLUTION / duration.denominator);
    _ticks = [[self.tickMultiplier clone] mult:ticks];
    _intrinsicTicks = [self.ticks floatValue];
}

@end
