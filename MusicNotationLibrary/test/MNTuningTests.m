//
//  MNTuningTests.m
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

#import "MNTuningTests.h"

@implementation MNTuningTests

- (void)start
{
    [super start];
    [self runTest:@"Standard Tuning" func:@selector(standard)];
    [self runTest:@"Return note for fret" func:@selector(noteForFret)];
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

+ (void)checkStandard:(MNTuning*)tuning
{
    /*
    Vex.Flow.Test.Tuning.checkStandard = function(tuning) {
        try {
            tuning.getValueForString(0);
        } catch (e) {
            equal(e.code, "BadArguments", "String 0");
        }

        try {
            tuning.getValueForString(9);
        } catch (e) {
            equal(e.code, "BadArguments", "String 7");
        }
    }
     */
    assertThatUnsignedInteger([tuning getValueForString:6],
                              describedAs(@"Low E string", equalToUnsignedInteger(40), nil));
    assertThatUnsignedInteger([tuning getValueForString:5], describedAs(@"A string", equalToUnsignedInteger(45), nil));
    assertThatUnsignedInteger([tuning getValueForString:4], describedAs(@"D string", equalToUnsignedInteger(50), nil));
    assertThatUnsignedInteger([tuning getValueForString:3], describedAs(@"G string", equalToUnsignedInteger(55), nil));
    assertThatUnsignedInteger([tuning getValueForString:2], describedAs(@"B string", equalToUnsignedInteger(59), nil));
    assertThatUnsignedInteger([tuning getValueForString:1],
                              describedAs(@"High E string", equalToUnsignedInteger(64), nil));
}

- (void)standard
{
    expect(@"16");
    MNTuning* tuning = [[MNTuning alloc] init];
    [[self class] checkStandard:tuning];

    // Test named tuning
    [tuning setTuning:@"standard"];
    [[self class] checkStandard:tuning];
}

- (void)noteForFret
{
    expect(@"8");

    MNTuning* tuning = [[MNTuning alloc] initWithTuningString:@"E/5,B/4,G/4,D/4,A/3,E/3"];

    /*
        try {
            tuning.getNoteForFret(-1, 1);
        } catch(e) {
            equal(e.code, "BadArguments", "Fret -1");
        }

        try {
            tuning.getNoteForFret(1, -1);
        } catch(e) {
            equal(e.code, "BadArguments", "String -1");
        }
    }
    */

    assertThatBool([[tuning getNoteForFret:0 andStringNum:1] isEqualToString:@"E/5"],
                   describedAs(@"High E string", isTrue(), nil));
    assertThatBool([[tuning getNoteForFret:5 andStringNum:1] isEqualToString:@"A/5"],
                   describedAs(@"High E string, fret 5", isTrue(), nil));
    assertThatBool([[tuning getNoteForFret:0 andStringNum:2] isEqualToString:@"B/4"],
                   describedAs(@"B string", isTrue(), nil));
    assertThatBool([[tuning getNoteForFret:0 andStringNum:3] isEqualToString:@"G/4"],
                   describedAs(@"G string", isTrue(), nil));
    assertThatBool([[tuning getNoteForFret:12 andStringNum:2] isEqualToString:@"B/5"],
                   describedAs(@"B string, fret 12", isTrue(), nil));
    assertThatBool([[tuning getNoteForFret:0 andStringNum:6] isEqualToString:@"E/3"],
                   describedAs(@"Low E string", isTrue(), nil));
}

@end
