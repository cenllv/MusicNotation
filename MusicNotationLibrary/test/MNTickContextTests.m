//
//  MNTickContextTests.m
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

#import "MNTickContextTests.h"
#import "MNMockTickable.h"
#import "MNConstants.h"

@implementation MNTickContextTests

- (void)start
{
    [super start];
    [self runTest:@"Current Tick Test" func:@selector(currentTick)];
    [self runTest:@"Tracking Test" func:@selector(tracking)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(MNTestCollectionItemView*)parent
{
    /*
     Vex.Flow.Test.ThreeVoices.setupContext = function(options, x, y) {
     Vex.Flow.Test.resizeCanvas(options.canvas_sel, x || 350, y || 150);
     var ctx = Vex.getCanvasContext(options.canvas_sel);
     ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
     ctx.font = " 10pt Arial";
      MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 30, x || 350, 0) addTrebleGlyph].
     setContext(ctx).draw();

     return {context: ctx, staff: staff};
     }
     */
    NSUInteger w = size.width;
    NSUInteger h = size.height;

    w = w != 0 ? w : 350;
    h = h != 0 ? h : 150;

    // [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (void)currentTick
{
    MNTickContext* tc = [[MNTickContext alloc] init];
    assertThatFloat(tc.currentTick.floatValue, describedAs(@"New tick context has no ticks", equalToFloat(0), nil));
}

- (void)tracking
{
    /*
    Vex.Flow.Test.TickContext.tracking = function() {
        function createTickable() {
            return new Vex.Flow.Test.MockTickable(Vex.Flow.Test.TIME4_4);
        }

        NSUInteger R = kRESOLUTION;
        NSUInteger BEAT = 1 * R / 4;

        var tickables = @[
                         createTickable().setTicks(BEAT).setWidth(10),
                         createTickable().setTicks(BEAT * 2).setWidth(20),
                         createTickable().setTicks(BEAT).setWidth(30)
                         ];

         MNTickContext *tc = [[MNTickContext alloc]init];
        tc.padding = 0;

        [tc addTickable:tickables[0]];
        assertThatUnsignedInteger(tc.maxTicks.floatValue, equalToUnsignedInteger(BEAT));

        [tc addTickable:tickables[1]];
        assertThatUnsignedInteger(tc.maxTicks.floatValue, equalToUnsignedInteger(BEAT * 2));

        [tc addTickable:tickables[2]];
        assertThatUnsignedInteger(tc.maxTicks.floatValue, equalToUnsignedInteger(BEAT * 2));

        assertThatUnsignedInteger(tc.width, equalToUnsignedInteger(0));
        [tc preFormat];
        assertThatUnsignedInteger(tc.width, equalToUnsignedInteger(30));
    }
    */

    MockTickable* (^createTickable)() = ^MockTickable*()
    {
        return [[MockTickable alloc] initWithTimeType:MNTime4_4];
    };

    NSUInteger R = kRESOLUTION;
    NSUInteger BEAT = 1 * R / 4;

    NSArray* tickables = @[
        createTickable(),
        createTickable(),
        createTickable(),
    ];

    [((id<MNTickableDelegate>)tickables[0])setTicks:Rational(BEAT, 1)];
    ((id<MNTickableDelegate>)tickables[0]).width = 10;

    //.setTicks(BEAT * 2).setWidth(20),
    [((id<MNTickableDelegate>)tickables[1])setTicks:Rational(BEAT * 2, 1)];
    ((id<MNTickableDelegate>)tickables[1]).width = 20;

    // .setTicks(BEAT).setWidth(30)
    [((id<MNTickableDelegate>)tickables[2])setTicks:Rational(BEAT, 1)];
    ((id<MNTickableDelegate>)tickables[2]).width = 30;

    MNTickContext* tc = [[MNTickContext alloc] init];
    tc.padding = 0;

    [tc addTickable:tickables[0]];
    assertThatUnsignedInteger(tc.maxTicks.floatValue, equalToUnsignedInteger(BEAT));

    [tc addTickable:tickables[1]];
    assertThatUnsignedInteger(tc.maxTicks.floatValue, equalToUnsignedInteger(BEAT * 2));

    [tc addTickable:tickables[2]];
    assertThatUnsignedInteger(tc.maxTicks.floatValue, equalToUnsignedInteger(BEAT * 2));

    assertThatUnsignedInteger(tc.width, equalToUnsignedInteger(0));
    [tc preFormat];
    assertThatUnsignedInteger(tc.width, equalToUnsignedInteger(30));
}

@end
