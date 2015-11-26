//
//  MNClefTests.m
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

#import "MNClefTests.h"

// TODO: add test for moveable c

@implementation MNClefTests

- (void)start
{
    [super start];
    //       [MNGlyph setDebugMode:YES];
    [self runTest:@"Clef Test" func:@selector(draw:withTitle:) frame:CGRectMake(10, 10, 800, 250)];
    [self runTest:@"Clef End Test" func:@selector(drawEnd:withTitle:) frame:CGRectMake(10, 10, 800, 250)];
    [self runTest:@"Small Clef Test" func:@selector(drawSmall:withTitle:) frame:CGRectMake(10, 10, 800, 250)];
    [self runTest:@"Small Clef End Test" func:@selector(drawSmallEnd:withTitle:) frame:CGRectMake(10, 10, 800, 250)];
    [self runTest:@"Clef Change Test" func:@selector(drawClefChange:withTitle:) frame:CGRectMake(10, 10, 800, 250)];
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

- (MNTestTuple*)draw:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 700, 0)];

      [staff addClefWithName:@"treble"];
      [staff addClefWithName:@"treble" size:@"default" annotation:@"8va"];
      [staff addClefWithName:@"treble" size:@"default" annotation:@"8vb"];
      [staff addClefWithName:@"alto"];
      [staff addClefWithName:@"tenor"];
      [staff addClefWithName:@"soprano"];
      [staff addClefWithName:@"bass"];
      [staff addClefWithName:@"bass" size:@"default" annotation:@"8vb"];
      [staff addClefWithName:@"mezzo-soprano"];
      [staff addClefWithName:@"baritone-c"];
      [staff addClefWithName:@"baritone-f"];
      [staff addClefWithName:@"subbass"];
      [staff addClefWithName:@"percussion"];
      [staff addClefWithName:@"french"];

      [staff addEndClefWithName:@"treble"];

      [staff draw:ctx];
      // ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawEnd:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 700, 0)];

      [staff addClefWithName:@"bass"];

      [staff addEndClefWithName:@"treble"];
      [staff addEndClefWithName:@"treble" size:@"default" annotation:@"8va"];
      [staff addEndClefWithName:@"treble" size:@"default" annotation:@"8vb"];
      [staff addEndClefWithName:@"alto"];
      [staff addEndClefWithName:@"tenor"];
      [staff addEndClefWithName:@"soprano"];
      [staff addEndClefWithName:@"bass"];
      [staff addEndClefWithName:@"bass" size:@"default" annotation:@"8vb"];
      [staff addEndClefWithName:@"mezzo-soprano"];
      [staff addEndClefWithName:@"baritone-c"];
      [staff addEndClefWithName:@"baritone-f"];
      [staff addEndClefWithName:@"subbass"];
      [staff addEndClefWithName:@"percussion"];
      [staff addEndClefWithName:@"french"];

      [staff draw:ctx];
      // ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawSmall:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 700, 0)];

      [staff addClefWithName:@"treble" size:@"small"];
      [staff addClefWithName:@"treble" size:@"small" annotation:@"8va"];
      [staff addClefWithName:@"treble" size:@"small" annotation:@"8vb"];
      [staff addClefWithName:@"alto" size:@"small"];
      [staff addClefWithName:@"tenor" size:@"small"];
      [staff addClefWithName:@"soprano" size:@"small"];
      [staff addClefWithName:@"bass" size:@"small"];
      [staff addClefWithName:@"bass" size:@"small" annotation:@"8vb"];
      [staff addClefWithName:@"mezzo-soprano" size:@"small"];
      [staff addClefWithName:@"baritone-c" size:@"small"];
      [staff addClefWithName:@"baritone-f" size:@"small"];
      [staff addClefWithName:@"subbass" size:@"small"];
      [staff addClefWithName:@"percussion" size:@"small"];
      [staff addClefWithName:@"french" size:@"small"];

      [staff addEndClefWithName:@"treble" size:@"small"];

      [staff draw:ctx];
      // ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawSmallEnd:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 700, 0)];

      [staff addClefWithName:@"bass" size:@"small"];

      [staff addEndClefWithName:@"treble" size:@"small"];
      [staff addEndClefWithName:@"treble" size:@"small" annotation:@"8va"];
      [staff addEndClefWithName:@"treble" size:@"small" annotation:@"8vb"];
      [staff addEndClefWithName:@"alto" size:@"small"];
      [staff addEndClefWithName:@"tenor" size:@"small"];
      [staff addEndClefWithName:@"soprano" size:@"small"];
      [staff addEndClefWithName:@"bass" size:@"small"];
      [staff addEndClefWithName:@"bass" size:@"small" annotation:@"8vb"];
      [staff addEndClefWithName:@"mezzo-soprano" size:@"small"];
      [staff addEndClefWithName:@"baritone-c" size:@"small"];
      [staff addEndClefWithName:@"baritone-f" size:@"small"];
      [staff addEndClefWithName:@"subbass" size:@"small"];
      [staff addEndClefWithName:@"percussion" size:@"small"];
      [staff addEndClefWithName:@"french" size:@"small"];

      [staff draw:ctx];
      // ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawClefChange:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 700, 0)];
      [staff addClefWithName:@"treble"];

      [staff draw:ctx];

      NSArray* notes = @[
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"treble"],
          [MNClefNote clefNoteWithClef:@"alto" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"alto"],
          [MNClefNote clefNoteWithClef:@"tenor" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"tenor"],
          [MNClefNote clefNoteWithClef:@"soprano" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"soprano"],
          [MNClefNote clefNoteWithClef:@"bass" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"bass"],
          [MNClefNote clefNoteWithClef:@"mezzo-soprano" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"mezzo-soprano"],
          [MNClefNote clefNoteWithClef:@"baritone-c" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"baritone-c"],
          [MNClefNote clefNoteWithClef:@"baritone-f" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"baritone-f"],
          [MNClefNote clefNoteWithClef:@"subbass" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"subbass"],
          [MNClefNote clefNoteWithClef:@"french" size:@"small"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"french"],
          [MNClefNote clefNoteWithClef:@"treble" size:@"small" annotation:@"8vb"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"treble" octaveShift:-1],
          [MNClefNote clefNoteWithClef:@"treble" size:@"small" annotation:@"8va"],
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q" andClef:@"treble" octaveShift:1],
      ];

      MNVoice* voice = [MNVoice voiceWithNumBeats:12 beatValue:4 resolution:kRESOLUTION];
      [voice addTickables:notes];
      MNFormatter* formatter = [[MNFormatter alloc] init];
      [formatter joinVoices:@[ voice ]];
      //        [formatter formatWith:@[voice] withJustifyWidth:500 andOptions:nil];
      [formatter formatWith:@[ voice ] withJustifyWidth:650];
      [voice draw:ctx dirtyRect:parent.frame toStaff:staff];

      // ok(YES, @"all pass");
    };
    return ret;
}

@end
