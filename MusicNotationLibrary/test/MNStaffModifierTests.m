//
//  MNStaffModifierTests.m
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

#import "MNStaffModifierTests.h"

@implementation MNStaffModifierTests

- (void)start
{
    [super start];
    [self runTest:@"Staff Draw Test" func:@selector(draw:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Vertical Bar Test" func:@selector(drawVerticalBar:) frame:CGRectMake(10, 10, 700, 250)];
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

    [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (MNTestTuple*)draw:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Staff.draw = function(options, contextBuilder) {
        var ctx = new contextBuilder(options.canvas_sel, 400, 120);
         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 300);

        [staff draw:ctx];

        equal(staff.getYForNote(0), 100, "getYForNote(0)");
        equal(staff.getYForLine(5), 100, "getYForLine(5)");
        equal(staff.getYForLine(0), 50, "getYForLine(0) - Top Line");
        equal(staff.getYForLine(4), 90, "getYForLine(4) - Bottom Line");

        ok(YES, @"all pass");
    }
     */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 300, 0)];
      [staff draw:ctx];
      assertThatFloat([staff getYForNoteWithLine:0], describedAs(@"getYForNote(0) = 100", equalToFloat(100), nil));
      assertThatFloat([staff getYForLine:5], describedAs(@"getYForNote(5) = 99", equalToFloat(99), nil));
      assertThatFloat([staff getYForLine:0], describedAs(@"getYForNote(0) = 49 - Top Line", equalToFloat(49), nil));
      assertThatFloat([staff getYForLine:4], describedAs(@"getYForNote(4) = 89 - Bottom Line", equalToFloat(89), nil));
      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawVerticalBar:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Staff.drawVerticalBar = function(options, contextBuilder) {
        var ctx = contextBuilder(options.canvas_sel, 400, 120);
         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 300);

        [staff draw:ctx];
        [staff drawVerticalBar:(100);
        [staff drawVerticalBar:(150);
        [staff drawVerticalBar:(300);

        ok(YES, @"all pass");
    }
    */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 300, 0)];

      [staff draw:ctx];
      [staff drawVerticalBar:ctx x:100];
      [staff drawVerticalBar:ctx x:150];
      [staff drawVerticalBar:ctx x:300];
      ok(YES, @"all pass");
    };
    return ret;
}
@end
