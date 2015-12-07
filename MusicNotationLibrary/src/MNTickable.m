//
//  MNTickable.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Mohit Cheppudira <mohit@muthanna.com>
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

#import "MNUtils.h"
#import "MNTickable.h"
#import "MNRational.h"
#import "MNModifierContext.h"
#import "MNBoundingBox.h"
#import "MNTuplet.h"
#import "MNConstants.h"

@implementation MNTickable

@synthesize x = _x;
@synthesize center_x_shift = _center_x_shift;
@synthesize centerAlign = _centerAlign;
//@synthesize extraLeftPx = _extraLeftPx;
//@synthesize extraRightPx = _extraRightPx;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupTickable];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (void)setupTickable
{
    _intrinsicTicks = 0;
    _tickMultiplier = [MNRational rationalWithNumerator:1 andDenominator:1];
    _ticks = [MNRational rationalWithNumerator:0 andDenominator:1];
    self.width = 0;
    _x_shift = 0;   // Shift from tick context
    _voice = nil;
    _tickContext = nil;
    _modifierContext = nil;
    _modifiers = [@[] mutableCopy];
    self.preFormatted = NO;
    self.postFormatted = NO;
    _tuplet = nil;

    self.align_center = NO;
    _center_x_shift = 0;   // Shift from tick context if center aligned

    // self flag tells the formatter to ignore self tickable during
    // formatting and justification. It is set by tickables such as BarNote.
    _ignore_ticks = NO;
    self.graphicsContext = NULL;
    _metrics = [[MNTickableMetrics alloc] initWithDictionary:nil];
}

- (id)metrics
{
    if(!_metrics)
    {
        _metrics = [MNMetrics metricsZero];
    }
    return _metrics;
}

- (MNBoundingBox*)boundingBox
{
    MNTickableMetrics* metrics = _metrics;
    return [MNBoundingBox boundingBoxAtX:metrics.modLeftPx atY:metrics.modRightPx withWidth:self.width andHeight:0];
}

- (float)getCenterXShift
{
    if([self isCenterAligned])
    {
        return self.center_x_shift;
    }
    return 0;
}

- (BOOL)isCenterAligned
{
    return self.align_center;
}

- (void)setCenterAlignment:(BOOL)align_center
{
    self.align_center = align_center;
}

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

- (void)setTuplet:(MNTuplet*)tuplet
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

    self.tuplet = tuplet;
}

// optional, if tickable has modifiers
- (void)addToModifierContext:(MNModifierContext*)mc
{
    self.modifierContext = mc;
    // Add modifiers to modifier context (if any)
    self.preFormatted = NO;
}

// optional, if tickable has modifiers
- (void)addModifiersObject:(MNModifier*)mod
{
    [self.modifiers addObject:mod];
    self.preFormatted = NO;
}

- (void)setTickContext:(MNTickContext*)tickContext
{
    _tickContext = tickContext;
    self.preFormatted = NO;
}

- (BOOL)preFormat
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

- (BOOL)postFormat
{
    if(self.postFormatted)
    {
        return YES;
    }
    self.postFormatted = YES;
    return YES;
}

- (void)setIntrinsicTicks:(NSUInteger)intrinsicTicks
{
    _intrinsicTicks = intrinsicTicks;
    self.ticks = [[self.tickMultiplier clone] mult:intrinsicTicks];
}

- (void)applyTickMultiplier:(NSUInteger)numerator denominator:(NSUInteger)denominator
{
    [self.tickMultiplier multiply:[MNRational rationalWithNumerator:numerator andDenominator:denominator]];
    self.ticks = [[self.tickMultiplier clone] mult:self.intrinsicTicks];
}

- (void)setTickDuration:(MNRational*)duration
{
    NSUInteger ticks = duration.numerator * (kRESOLUTION / duration.denominator);
    self.ticks = [[self.tickMultiplier clone] mult:ticks];
    _intrinsicTicks = [_ticks floatValue];
}

- (MNRational*)getTicks
{
    return _ticks;
}

- (id)setTicks:(MNRational*)ticks
{
    _ticks = ticks;
    return self;
}

- (BOOL)getIgnoreTicks
{
    return _ignore_ticks;
}

- (id)setIgnoreTicks:(BOOL)ignoreTicks
{
    _ignore_ticks = ignoreTicks;
    return self;
}

- (void)addModifier:(MNModifier*)modifier
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (float)extraLeftPx
{
    return _extraLeftPx;
}

- (float)extraRightPx
{
    return _extraRightPx;
}

- (id)setExtraLeftPx:(float)extraLeftPx
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
    return self;
}

- (id)setExtraRightPx:(float)extraRightPx
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
    return self;
}

- (MNRational*)ticks
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
    return nil;
}

- (id)setXShift:(float)xShift
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
    return self;
}

- (float)xShift
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
    return 0;
}

@end
