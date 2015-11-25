//
//  MNVoiceTests.m
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

#import "MNVoiceTests.h"
#import "MNMockTickable.h"

@implementation MNVoiceTests

- (void)start
{
    [super start];
    [self runTest:@"Strict Test" func:@selector(strict)];
    [self runTest:@"Ignore Test" func:@selector(ignore)];
    [self runTest:@"Full Voice Mode Test" func:@selector(full:withTitle:) frame:CGRectMake(0, 0, 550, 200)];
}

//- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(MNTestView*)parent
//{
//    /*
//     Vex.Flow.Test.ThreeVoices.setupContext = function(options, x, y) {
//     Vex.Flow.Test.resizeCanvas(options.canvas_sel, x || 350, y || 150);
//     var ctx = Vex.getCanvasContext(options.canvas_sel);
//     ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
//     ctx.font = " 10pt Arial";
//      MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 30, x || 350, 0) addTrebleGlyph].
//     setContext(ctx).draw();
//
//     return {context: ctx, staff: staff};
//     }
//     */
//    NSUInteger w = size.width;
//    NSUInteger h = size.height;
//
//    w = w != 0 ? w : 350;
//    h = h != 0 ? h : 150;
//
//     // [MNFont setFont:@" 10pt Arial"];
//
//
//    withParent:parent];
//    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
//    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
//}

- (void)strict
{
    MockTickable* (^createTickable)() = ^MockTickable*()
    {
        return [MockTickable mockTickableWithTimeType:MNTime4_4];
    };

    NSUInteger R = kRESOLUTION;
    MNRational* BEAT = Rational1(1 * R / 4);

    NSArray* tickables =
        @[ [createTickable() setTicks:BEAT], [createTickable() setTicks:BEAT], [createTickable() setTicks:BEAT] ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    assertThatFloat(voice.totalTicks.floatValue,
                    describedAs(@"4/4 Voice has 4 beats", equalToFloat([BEAT mult:4].floatValue), nil));
    assertThatFloat(voice.ticksUsed.floatValue,
                    describedAs(@"No beats in voice", equalToFloat([BEAT mult:0].floatValue), nil));
    [voice addTickables:tickables];
    assertThatFloat(voice.ticksUsed.floatValue,
                    describedAs(@"Three beats in voice", equalToFloat([BEAT mult:3].floatValue), nil));
    [voice addTickable:[createTickable() setTicks:BEAT]];
    assertThatFloat(voice.ticksUsed.floatValue,
                    describedAs(@"Four beats in voice", equalToFloat([BEAT mult:4].floatValue), nil));
    assertThatBool(voice.isComplete, describedAs(@"Voice is complete", isTrue(), nil));

    /*
    try {
        voice addTickable:createTickable() setTicks:BEAT]);
    } catch (e) {
        equal(e.code, "BadArgument", "Too many ticks exception");
    }
     */

    //        assertThatFloat([note getTicks].floatValue, equalToFloat(BEAT * 3.5));
    assertThatFloat(voice.smallestTickCount.floatValue,
                    describedAs(@"Smallest tick count is BEAT", equalToFloat(BEAT.floatValue), nil));
}

- (void)ignore
{
    MockTickable* (^createTickable)() = ^MockTickable*()
    {
        return [MockTickable mockTickableWithTimeType:MNTime4_4];
    };

    NSUInteger R = kRESOLUTION;
    MNRational* BEAT = Rational(1 * R / 4, 1);

    NSArray* tickables = @[
        [createTickable() setTicks:BEAT],
        [createTickable() setTicks:BEAT],
        [[createTickable() setTicks:BEAT] setIgnoreTicks:YES],
        [createTickable() setTicks:BEAT],
        [[createTickable() setTicks:BEAT] setIgnoreTicks:YES],
        [createTickable() setTicks:BEAT]
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:tickables];

    ok(YES, @"all pass");
}

- (MNTestTuple*)full:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 500, 0)];
      [[[staff addClefWithName:@"treble"] addTimeSignatureWithName:@"4/4"] setEndBarType:MNBarLineEnd];
      [staff draw:ctx];

      NSArray* notes = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"q"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"d/4" ],
              @"duration" : @"q"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"qr"
          }]
      ];

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      voice.mode = MNModeFull;
      [voice addTickables:notes];

      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:500];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      voice.staff = staff;
      MNBoundingBox* bb = voice.boundingBox;
      [bb draw:ctx];

      /*
      try {
          voice addTickable:
          [[[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/4"], @"duration" : @"h" })
            );
        } catch (e) {
            equal(e.code, "BadArgument", "Too many ticks exception");
        }
       */
    };
    return ret;
}

@end
