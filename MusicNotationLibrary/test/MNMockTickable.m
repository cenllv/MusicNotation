//
//  MNMocks.m
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

#import "MNMockTickable.h"

@implementation MockTickable

@synthesize width = _width;
@synthesize x = _x;
@synthesize centerAlign = _centerAlign;

/*!
 * VexFlow - TickContext Tests
 *

Vex.Flow.Test.TIME4_4 = {
num_beats: 4,
beat_value: 4,
resolution: kRESOLUTION
};

// Mock Tickable

 Vex.Flow.Test.MockTickable = function() { this.ignore_ticks = NO; }
*/

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _ignore_ticks = NO;
    }
    return self;
}

- (instancetype)initWithTimeType:(MNTimeType)timeType
{
    self = [super init];
    if(self)
    {
        //         [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
        //        abort();
    }
    return self;
}

+ (MockTickable*)mockTickableWithTimeType:(MNTimeType)timeType;
{
    return [[MockTickable alloc] initWithTimeType:timeType];
}

/*
Vex.Flow.Test.MockTickable.prototype.getX = function() {
    return this.tickContext.getX();}
Vex.Flow.Test.MockTickable.prototype.getIntrinsicTicks = function() {return this.ticks;}
Vex.Flow.Test.MockTickable.prototype.getTicks = function() {return this.ticks;}
Vex.Flow.Test.MockTickable.prototype.setTicks = function(t) {
    this.ticks = new Vex.Flow.Fraction(t, 1); return this; };
Vex.Flow.Test.MockTickable.prototype.getMetrics = function() {
    return { noteWidth: this.width,
    left_shift: 0,
    modLeftPx: 0, modRightPx: 0,
        extraLeftPx: 0, extraRightPx: 0 };
}
Vex.Flow.Test.MockTickable.prototype.getWidth = function() {return this.width;}
Vex.Flow.Test.MockTickable.prototype.setWidth = function(w) {
    this.width = w; return this; }
Vex.Flow.Test.MockTickable.prototype.setVoice = function(v) {
    this.voice = v; return this; }
Vex.Flow.Test.MockTickable.prototype.setstaff = function(staff) {
    this.staff = staff; return this; }
Vex.Flow.Test.MockTickable.prototype.setTickContext = function(tc) {
    this.tickContext = tc; return this; }
Vex.Flow.Test.MockTickable.prototype.setIgnoreTicks = function(ignore_ticks) {
    this.ignore_ticks = ignore_ticks; return this; }
Vex.Flow.Test.MockTickable.prototype.shouldIgnoreTicks = function() {
    return this.ignore_ticks; }
Vex.Flow.Test.MockTickable.prototype.preFormat = function() {}
*/

- (float)getX;
{
    return self.tickContext.x;
}
- (MNRational*)getIntrinsicTicks;
{
    return _ticks;
}

- (MNRational*)getTicks;
{
    return _ticks;
}

- (id)setTicks:(MNRational*)ticks;
{
    _ticks = ticks;
    return self;
}

- (BOOL)getIgnoreTicks;
{
    return _ignore_ticks;
}

- (id)setIgnoreTicks:(BOOL)ignoreTicks;
{
    _ignore_ticks = ignoreTicks;
    return self;
}

- (NSDictionary*)getMetrics;
{
    return @{
        @"noteWidth" : @(self.width),
        @"left_shift" : @0,
        @"modLeftPx" : @0,
        @"modRightPx" : @0,
        @"extraLeftPx" : @0,
        @"extraRightPx" : @0
    };
    //    Metrics *ret = [Metrics metricsZero];
    //    ret.noteWidth = self.width;
    //    ret.modLeftPx = 0;
    //    ret.modRightPx = 0;
    //    ret.extraLeftPx = 0;
    //    ret.extraRightPx = 0;
}
//- (float)getWidth; {
//    return self.width;
//}
- (id)setWidth:(float)w;
{
    _width = w;
    return self;
}
- (void)setVoice:(MNVoice*)v;
{
    _voice = v;
}
- (void)setstaff:(MNStaff*)staff;
{
    _staff = staff;
}
- (void)setTickContext:(MNTickContext*)tc;
{
    _tickContext = tc;
}

- (BOOL)shouldIgnoreTicks;
{
    return _ignore_ticks;
}

- (BOOL)preFormat;
{
    return YES;
}

- (MockTickable*)setCustomTicks:(MNRational*)t;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (void)getWidth;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (id)setXShift:(float)xShift;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (float)xShift;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (MockTickable*)setCustomWidth:(float)w;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (MNRational*)ticks;
{
    return _ticks;
}

- (void)addToModifierContext:(MNModifierContext*)mc;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (id)addModifier:(MNModifier*)modifier;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (BOOL)postFormat;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (void)applyTickMultiplier:(NSUInteger)numerator denominator:(NSUInteger)denominator;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (void)setTickDuration:(MNRational*)duration;
{
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

@end
