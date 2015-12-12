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
    //    [MNGlyph setDebugMode:YES];
    float w = 750, h = 150;
    [self runTest:@"Clef Test" func:@selector(draw:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Clef End Test" func:@selector(drawEnd:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Small Clef Test" func:@selector(drawSmall:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Small Clef End Test" func:@selector(drawSmallEnd:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Clef Change Test" func:@selector(drawClefChange:) frame:CGRectMake(10, 10, w, h + 50)];
}

- (void)tearDown
{
    [super tearDown];
}

#define STAFF_Y 10

- (MNTestBlockStruct*)draw:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, STAFF_Y, 700, 0)];

      void (^space)(float) = ^(float w) {
        [staff addGlyph:[staff makeSpacer:w]];
      };

      float w = 10;
      [staff addClefWithName:@"treble"];
      space(w);
      [staff addClefWithName:@"treble" size:@"default" annotation:@"8va"];
      space(w);
      [staff addClefWithName:@"treble" size:@"default" annotation:@"8vb"];
      space(w);
      [staff addClefWithName:@"alto"];
      space(w);
      [staff addClefWithName:@"tenor"];
      space(w);
      [staff addClefWithName:@"soprano"];
      space(w);
      [staff addClefWithName:@"bass"];
      space(w);
      [staff addClefWithName:@"bass" size:@"default" annotation:@"8vb"];
      space(w);
      [staff addClefWithName:@"mezzo-soprano"];
      space(w);
      [staff addClefWithName:@"baritone-c"];
      space(w);
      [staff addClefWithName:@"baritone-f"];
      space(w);
      [staff addClefWithName:@"subbass"];
      space(w);
      [staff addClefWithName:@"percussion"];
      space(w);
      [staff addClefWithName:@"french"];
      space(w);

      [staff addEndClefWithName:@"treble"];
      space(w);

      [staff draw:ctx];
      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawEnd:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, STAFF_Y, 700, 0)];

      void (^space)(float) = ^(float w) {
        [staff addEndGlyph:[staff makeSpacer:w]];
      };

      float w = 15;
      [staff addClefWithName:@"bass"];
      //      space(w);
      [staff addEndClefWithName:@"treble"];
      space(w);
      [staff addEndClefWithName:@"treble" size:@"default" annotation:@"8va"];
      space(w);
      [staff addEndClefWithName:@"treble" size:@"default" annotation:@"8vb"];
      space(w);
      [staff addEndClefWithName:@"alto"];
      space(w);
      [staff addEndClefWithName:@"tenor"];
      space(w);
      [staff addEndClefWithName:@"soprano"];
      space(w);
      [staff addEndClefWithName:@"bass"];
      space(w);
      [staff addEndClefWithName:@"bass" size:@"default" annotation:@"8vb"];
      space(w);
      [staff addEndClefWithName:@"mezzo-soprano"];
      space(w);
      [staff addEndClefWithName:@"baritone-c"];
      space(w);
      [staff addEndClefWithName:@"baritone-f"];
      space(w);
      [staff addEndClefWithName:@"subbass"];
      space(w);
      [staff addEndClefWithName:@"percussion"];
      space(w);
      [staff addEndClefWithName:@"french"];

      [staff draw:ctx];
      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawSmall:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, STAFF_Y, 700, 0)];

      void (^space)(float) = ^(float w) {
        [staff addGlyph:[staff makeSpacer:w]];
      };
      float w = 15;

      [staff addClefWithName:@"treble" size:@"small"];
      space(w);
      [staff addClefWithName:@"treble" size:@"small" annotation:@"8va"];
      space(w);
      [staff addClefWithName:@"treble" size:@"small" annotation:@"8vb"];
      space(w);
      [staff addClefWithName:@"alto" size:@"small"];
      space(w);
      [staff addClefWithName:@"tenor" size:@"small"];
      space(w);
      [staff addClefWithName:@"soprano" size:@"small"];
      space(w);
      [staff addClefWithName:@"bass" size:@"small"];
      space(w);
      [staff addClefWithName:@"bass" size:@"small" annotation:@"8vb"];
      space(w);
      [staff addClefWithName:@"mezzo-soprano" size:@"small"];
      space(w);
      [staff addClefWithName:@"baritone-c" size:@"small"];
      space(w);
      [staff addClefWithName:@"baritone-f" size:@"small"];
      space(w);
      [staff addClefWithName:@"subbass" size:@"small"];
      space(w);
      [staff addClefWithName:@"percussion" size:@"small"];
      space(w);
      [staff addClefWithName:@"french" size:@"small"];
      space(w);

      [staff addEndClefWithName:@"treble" size:@"small"];

      [staff draw:ctx];
      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawSmallEnd:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, STAFF_Y, 700, 0)];

      void (^space)(float) = ^(float w) {
        [staff addGlyph:[staff makeSpacer:w]];
      };
      float w = 15;

      [staff addClefWithName:@"bass" size:@"small"];
      space(w);

      [staff addEndClefWithName:@"treble" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"treble" size:@"small" annotation:@"8va"];
      space(w);
      [staff addEndClefWithName:@"treble" size:@"small" annotation:@"8vb"];
      space(w);
      [staff addEndClefWithName:@"alto" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"tenor" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"soprano" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"bass" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"bass" size:@"small" annotation:@"8vb"];
      space(w);
      [staff addEndClefWithName:@"mezzo-soprano" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"baritone-c" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"baritone-f" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"subbass" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"percussion" size:@"small"];
      space(w);
      [staff addEndClefWithName:@"french" size:@"small"];
      space(w);

      [staff draw:ctx];
      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawClefChange:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, STAFF_Y + 20, 700, 0)];
    [staff addClefWithName:@"treble"];

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
    [formatter formatWith:@[ voice ] withJustifyWidth:500];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"all pass");
    };
    return ret;
}

@end
