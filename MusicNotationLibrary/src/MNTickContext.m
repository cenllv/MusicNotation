//
//  MNTickContext.m
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

#import "MNTickContext.h"
#import "MNUtils.h"
#import "MNTickable.h"
#import "MNModifier.h"
#import "MNRational.h"
#import "MNPadding.h"

@interface MNTickContext (private)
@property (assign, nonatomic) BOOL preFormatted;
@property (assign, nonatomic) BOOL postFormatted;
@end

@implementation MNTickContext

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
        [self setupTickContext];
    }
    return self;
}

- (void)setupTickContext
{
    _currentTick = RationalZero();
    _maxTicks = RationalZero();
    _minTicks = nil;
    _width = 0;
    _padding = [MNPadding paddingWith:3];   // padding on each side (width += padding * 2)
    _pointsUsed = 0;
    _x = 0;
    _tickables = [NSMutableArray array];   // Notes, tabs, chords, lyrics.
    _notePx = 0;                           // width of widest note in self context
    _extraLeftPx = 0;                      // Extra left pixels for modifers & displace notes
    _extraRightPx = 0;                     // Extra right pixels for modifers & displace notes
    _align_center = NO;

    _tContexts = [NSMutableArray array];   // Parent array of tick contexts

    // Ignore self tick context for formatting and justification
    _shouldIgnoreTicks = YES;
    _preFormatted = NO;
    _postFormatted = NO;
    _graphicsContext = NULL;   // Rendering context
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (NSString*)description
{
    //    //prolog
    //    NSString *ret = [NSString stringWithFormat:@"<%p> : { \n", self];
    //
    //    //guts
    //    ret = [ret concat:[NSString stringWithFormat:@"List: %@\n", [self.list prettyPrint]]];
    //    ret = [ret concat:[NSString stringWithFormat:@"Map: %@\n", [self.map prettyPrint]]];
    //    ret = [ret concat:[NSString stringWithFormat:@"Resolution multiplier: %li\n",
    //    (long)self.resolutionMultiplier]];
    //    //    ret = [ret concat:[NSString stringWithFormat:@"Ticks: %@\n", [self.ticks description]]];
    //    NSString *shouldIgnoreTicksDescription = self.shouldIgnoreTicks ? @"YES" : @"NO";
    //    ret = [ret concat:[NSString stringWithFormat:@"ShouldIgnoreTicks: %@\n", shouldIgnoreTicksDescription]];
    //    NSString *parentDescription = self.parent != Nil ? [self.parent description] : @"";
    //    ret = [ret concat:parentDescription];
    //
    //    //epilog
    //    ret = [ret concat:@"}"];
    //    return  [MNLog FormatObject:ret];
    return nil;
}

#pragma mark - Properties

- (BOOL)shouldIgnoreTicks
{
    return _shouldIgnoreTicks;
}

//- (float)getWidth
//{
//    return _width + (self.padding.width * 2);
//}

- (float)width
{
//        return self.metrics.width;
    return _width + (self.padding.width * 2);
}

- (void)setWidth:(float)width
{
    //    self.metrics.width = width;
    _width = width;
}

- (float)x
{
    return _x;
}

- (void)setX:(float)x
{
    _x = x;
}

- (float)getPointsUsed
{
    return _pointsUsed;
}

- (void)setPointsUsed:(float)pixelsUsed
{
    _pointsUsed = pixelsUsed;
}

- (void)setPadding:(MNPadding*)padding
{
    _padding = [padding copy];
}

- (MNRational*)getMaxTicks
{
    return _maxTicks;
}

- (MNRational*)getMinTicks
{
    return _minTicks;
}

- (NSArray*)getTickables
{
    return [_tickables asArray];
}

- (NSArray*)getCenterAlignedTickables
{
    return [self.tickables filter:^BOOL(MNTickable* tickable) {
      return tickable.centerAlign;
    }];
}

// Get widths context, note and left/right modifiers for formatting
- (id<TickableMetrics>)metrics
{
    id<TickableMetrics> metrics = [[MNTickableMetrics alloc] initWithDictionary:nil];
    metrics.width = self.width;
    metrics.notePoints = self.notePoints;
    metrics.extraLeftPx = self.extraLeftPx;
    metrics.extraRightPx = self.extraRightPx;
    return metrics;
}

- (MNRational*)getCurrentTick
{
    return _currentTick;
}

- (void)setCurrentTick:(MNRational*)currentTick
{
    _currentTick = currentTick;
    self.preFormatted = NO;
}

// Get left & right pixels used for modifiers
- (MNExtraPoints*)getExtraPx
{
    float left_shift = 0;
    float right_shift = 0;
    float extraLeftPx = 0;
    float extraRightPx = 0;

    for(NSUInteger i = 0; i < self.tickables.count; ++i)
    {
        //         MNTickable* tickable = (MNTickable*)self.tickables[i];
        id<MNTickableDelegate> tickable = (id<MNTickableDelegate>)self.tickables[i];
        extraLeftPx = MAX(tickable.extraLeftPx, extraLeftPx);
        extraRightPx = MAX(tickable.extraRightPx, extraRightPx);
        MNModifierContext* mContext = tickable.modifierContext;
        if(mContext != nil)
        {
            left_shift = MAX(left_shift, mContext.state.left_shift);
            right_shift = MAX(right_shift, mContext.state.right_shift);
        }
    }

    return [[MNExtraPoints alloc] initWithLeft:left_shift right:right_shift extraLeft:extraLeftPx extraRight:extraRightPx];
}

#pragma mark - Methods
//- (void)addTickable:(MNTickable*)tickable
- (id)addTickable:(id<MNTickableDelegate>)tickable
{
    if(!tickable)
    {
        MNLogError(@"BadArgument, Invalid tickable added.");
    }

    if(!tickable.shouldIgnoreTicks)
    {
        _shouldIgnoreTicks = NO;

        MNRational* ticks = tickable.ticks;

        if(!ticks)
        {
            MNLogError(@"NoTicksException");
            //            abort();
        }

        if([ticks gt:self.maxTicks])
        {
            self.maxTicks = [ticks clone];
        }

        if(self.minTicks == nil)
        {
            self.minTicks = [ticks clone];
        }
        else if([ticks lt:self.minTicks])
        {
            self.minTicks = [ticks clone];
        }
    }

    [tickable setTickContext:self];
    [self.tickables push:tickable];
    _preFormatted = NO;
    return self;
}

- (BOOL)preFormat
{
    if(self.preFormatted)
    {
        return YES;
    }

    for(NSUInteger i = 0; i < self.tickables.count; ++i)
    {
        id<MNTickableDelegate> tickable = self.tickables[i];
        [tickable preFormat];
        id<TickableMetrics> metrics = tickable.metrics;

        // Maintain max extra pixels from all tickables in the context
        self.extraLeftPx = MAX(self.extraLeftPx, metrics.extraLeftPx + metrics.modLeftPx);
        self.extraRightPx = MAX(self.extraRightPx, metrics.extraRightPx + metrics.modRightPx);

        // Maintain the widest note for all tickables in the context
        self.notePx = MAX(self.notePx, metrics.noteWidth);

        // Recalculate the tick context total width
        self.width = self.notePx + self.extraLeftPx + self.extraRightPx;
    }

    return YES;
}

- (BOOL)postFormat
{
    if(self.postFormatted)
    {
        return YES;
    }
    _postFormatted = YES;
    return YES;
}

+ (MNTickContext*)getNextContext:(MNTickContext*)tContext
{
    NSArray* contexts = tContext.tContexts;
    NSUInteger index = [contexts indexOfObject:tContext];
    if(contexts.count > index + 1)
    {
        return contexts[index + 1];
    }
    else
    {
        return nil;
    }
}

@end
