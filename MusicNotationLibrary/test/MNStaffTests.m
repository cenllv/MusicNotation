//
//  MNStaffTests.m
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

#import "MNStaffTests.h"
#import "MNUtils.h"
#import "MNStaffTempoOptionsStruct.h"

@implementation MNStaffTests

- (void)start
{
    [super start];
    [self runTest:@"Staff Draw Test" func:@selector(draw:) frame:CGRectMake(10, 10, 750, 180)];
    [self runTest:@"Vertical Bar Test" func:@selector(drawVerticalBar:) frame:CGRectMake(10, 10, 750, 150)];
    [self runTest:@"Multiple Staff Barline Test"
             func:@selector(drawMultipleMeasures:)
            frame:CGRectMake(10, 10, 700, 200)];
    [self runTest:@"Multiple Staff Repeats Test" func:@selector(drawRepeats:) frame:CGRectMake(10, 10, 800, 200)];
    [self runTest:@"Multiple Staves Volta Test Test" func:@selector(drawVoltaTest:) frame:CGRectMake(10, 10, 800, 250)];
    [self runTest:@"Tempo Test" func:@selector(drawTempo:) frame:CGRectMake(10, 10, 700, 350)];
    [self runTest:@"Single Line Configuration Test"
             func:@selector(configureSingleLine:)
            frame:CGRectMake(10, 10, 600, 150)];
    [self runTest:@"Batch Line Configuration Test"
             func:@selector(configureAllLines:)
            frame:CGRectMake(10, 10, 600, 150)];
    [self runTest:@"Staff Text Test" func:@selector(drawStaffText:) frame:CGRectMake(10, 10, 600, 250)];
    [self runTest:@"Multiple Line staff Text Test"
             func:@selector(drawStaffTextMultiLine:)
            frame:CGRectMake(10, 10, 600, 250)];
}

- (void)tearDown
{
    [super tearDown];
}

static float w = 700;

//- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(id<MNTestParentDelegate>)parent
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
//    //    NSUInteger h = size.height;
//
//    w = w != 0 ? w : 350;
//    //    h = h != 0 ? h : 150;
//
//    // [MNFont setFont:@" 10pt Arial"];
//
//    // withParent:parent withTitle:title];
//    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
//    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
//}

- (MNTestBlockStruct*)draw:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(40, 40, w - 40, 0)];

    //  [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [staff drawBoundingBox:ctx];

      assertThatFloat([staff getYForNoteWithLine:0], describedAs(@"getYForNote(0) = 100", equalToFloat(100), nil));
      assertThatFloat([staff getYForLine:5], describedAs(@"getYForNote(5) = 99", equalToFloat(99), nil));
      assertThatFloat([staff getYForLine:0], describedAs(@"getYForNote(0) = 49 - Top Line", equalToFloat(49), nil));
      assertThatFloat([staff getYForLine:4], describedAs(@"getYForNote(4) = 89 - Bottom Line", equalToFloat(89), nil));
    };
    return ret;
}

- (MNTestBlockStruct*)drawVerticalBar:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(20, 40, w - 40, 0)];

    //  [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [staff drawVerticalBar:ctx x:50];
      [staff drawVerticalBar:ctx x:150];
      [staff drawVertical:ctx x:250 isDouble:YES];
      [staff drawVertical:ctx x:300];
    };
    return ret;
}

- (MNTestBlockStruct*)drawMultipleMeasures:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    // bar 1
    MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 50, 250, 0)];
    staffBar1.begBarType = MNBarLineRepeatBegin;
    staffBar1.endBarType = MNBarLineDouble;
    [staffBar1 setSectionWithSection:@"A" atY:0];
    //    [staffBar1 addClefWithName:@"treble"];
    [staffBar1 addTrebleGlyph];

    NSArray* notesBar1 = [@[
        [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q"],
        [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"q"],
        [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"qr"],
        [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"q"],
    ] mutableCopy];

    MNVoice* voice = [MNVoice voiceWithNumBeats:4 beatValue:4 resolution:kRESOLUTION];
    [voice addTickables:notesBar1];
    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staffBar1];

    // // FIXME: calls to formatWith:withJustifyWidth screws up the width. width is too bid in this case.
    // formatWith:@[ voice ] withJustifyWidth:staffBar1.width];

    // bar 2 - juxtaposing second bar next to first bar
    MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 300, 0)];
    [staffBar2 setSectionWithSection:@"B" atY:0];
    staffBar2.endBarType = MNBarLineEnd;
    //        [staffBar2 draw:ctx];

    NSMutableArray* notesBar2_part1 = [@[
        [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"8"],
        [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"8"],
        [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"8"],
        [MNStaffNote noteWithKeys:@[ @"e/4" ] andDuration:@"8"],
    ] mutableCopy];

    NSMutableArray* notesBar2_part2 = [@[
        [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"8"],
        [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"8"],
        [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"8"],
        [MNStaffNote noteWithKeys:@[ @"e/4" ] andDuration:@"8"],
    ] mutableCopy];

    // create the beams for 8th notes in 2nd measure
    MNBeam* beam1 = [MNBeam beamWithNotes:notesBar2_part1];
    MNBeam* beam2 = [MNBeam beamWithNotes:notesBar2_part2];

    NSArray* notesBar2 = [notesBar2_part1 arrayByAddingObjectsFromArray:notesBar2_part2];

    // Helper function to justify and draw a 4/4 voice
    //            MNFormatter* formatter2 =
    //            [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];

    MNVoice* voice2 = [MNVoice voiceWithNumBeats:4 beatValue:4 resolution:kRESOLUTION];
    [voice2 addTickables:notesBar2];
    //    MNFormatter* formatter2 = [voice addTickables:notesBar2];
    //    [[[MNFormatter formatter] joinVoices:@[ voice2 ]] formatWith:@[ voice2 ] withJustifyWidth:staffBar2.width];

    //    MNFormatter* formatter2 =
    [[[MNFormatter formatter] joinVoices:@[ voice2 ]] formatToStaff:@[ voice2 ] staff:staffBar2];

    //    [ret.formatters addObjectsFromArray:@[ formatter, formatter2 ]];

    //    [ret.staves addObject:staffBar1];
    //  //  [ret.voices addObject:voice];
    //
    //    [ret.staves addObject:staffBar2];
    //    [ret.voices addObject:voice2];
    //
    //    [ret.beams addObject:@[ beam1 ]];
    //    [ret.beams addObject:@[ beam2 ]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staffBar1 draw:ctx];
      [staffBar2 draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staffBar1];

      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staffBar2];

      [beam1 draw:ctx];
      [beam2 draw:ctx];
    };
    return ret;
}

- (MNTestBlockStruct*)drawRepeats:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 50, 250, 0)];
      [staffBar1 setBegBarType:MNBarLineRepeatBegin];
      [staffBar1 setEndBarType:MNBarLineRepeatEnd];
      [staffBar1 addClefWithName:@"treble"];
      staffBar1.keySignature = [MNKeySignature keySignatureWithKey:@"A"];
      //      [staffBar1 setSectionWithSection:@"A" atY:0];
      [staffBar1 draw:ctx];

      NSArray* notesBar1 = @[
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q"],
          [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"q"],
          [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"qr"],
          [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"q"],
      ];

      //       [MNGlyph setDebugMode:YES];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];

      // bar 2 - juxtaposing second bar next to first bar
      MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 250, 0)];
      [staffBar2 setBegBarType:MNBarLineRepeatBegin];
      [staffBar2 setEndBarType:MNBarLineRepeatEnd];
      [staffBar2 draw:ctx];

      NSArray* notesBar2_part1 = @[
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"8"],
          [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"8"],
          [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"8"],
          [MNStaffNote noteWithKeys:@[ @"e/4" ] andDuration:@"8"],
      ];

      NSArray* notesBar2_part2 = @[
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"8"],
          [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"8"],
          [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"8"],
          [MNStaffNote noteWithKeys:@[ @"e/4" ] andDuration:@"8"],
      ];

      [notesBar2_part2[0] addAccidental:[MNAccidental accidentalWithType:@"#"] atIndex:0];
      [notesBar2_part2[1] addAccidental:[MNAccidental accidentalWithType:@"#"] atIndex:0];
      [notesBar2_part2[3] addAccidental:[MNAccidental accidentalWithType:@"b"] atIndex:0];

      // create the beams for 8th notes in 2nd measure
      MNBeam* beam1 = [MNBeam beamWithNotes:notesBar2_part1];
      MNBeam* beam2 = [MNBeam beamWithNotes:notesBar2_part2];
      NSArray* notesBar2 = [notesBar2_part1 arrayByAddingObjectsFromArray:notesBar2_part2];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];

      // Render beams
      [beam1 draw:ctx];
      [beam2 draw:ctx];

      // bar 3 - juxtaposing third bar next to second bar
      MNStaff* staffBar3 = [MNStaff staffWithRect:CGRectMake(staffBar2.width + staffBar2.x, staffBar2.y, 50, 0)];
      [staffBar3 draw:ctx];

      NSArray* notesBar3 = @[ [MNStaffNote noteWithKeys:@[ @"d/5" ] andDuration:@"wr"] ];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar3 withNotes:notesBar3];

      // bar 4 - juxtaposing third bar next to third bar
      MNStaff* staffBar4 = [MNStaff
          staffWithRect:CGRectMake(staffBar3.width + staffBar3.x, staffBar3.y, 250 - [staffBar1 getModifierXShift], 0)];

      [staffBar4 setBegBarType:MNBarLineRepeatBegin];
      [staffBar4 setEndBarType:MNBarLineRepeatEnd];
      [staffBar4 draw:ctx];

      NSArray* notesBar4 = @[
          [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q"],
          [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"q"],
          [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"qr"],
          [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"q"],
      ];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar4 withNotes:notesBar4];
    };
    return ret;
}

- (MNTestBlockStruct*)drawVoltaTest:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* mm1 = [MNStaff staffWithRect:CGRectMake(50, 100, 125, 0)];

      //      mm1.graphicsContext = ctx;
      mm1.begBarType = MNBarLineRepeatBegin;
      [mm1 setRepetitionTypeLeft:MNRepSegnoLeft atY:7];   //.repetitionTypeLeft =  MNRepSegnoLeft
      mm1.clefType = MNClefTreble;
      mm1.keySignature = [MNKeySignature keySignatureWithKey:@"A"];   // TODO: allow setting keysignature using nsstring
      mm1.measure = 1;
      [mm1 setSectionWithSection:@"A" atY:0];   // TODO: rename to more concise
      [mm1 draw:ctx];
      NSArray* notesmm1 = @[ [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"w"] ];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm1 withNotes:notesmm1];

      // bar 2 - juxtapose second measure
      MNStaff* mm2 = [MNStaff staffWithRect:CGRectMake(mm1.width + mm1.x, mm1.y, 60, 0)];
      //      mm2.graphicsContext = ctx;
      [mm2 setRepetitionTypeRight:MNRepCodaRight atY:30];
      mm2.measure = 2;
      [mm2 draw:ctx];
      NSArray* notesmm2 = @[ [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"w"] ];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm2 withNotes:notesmm2];

      // bar 3 - juxtapose third measure
      MNStaff* mm3 = [MNStaff staffWithRect:CGRectMake(mm2.width + mm2.x, mm1.y, 60, 0)];
      //      mm3.graphicsContext = ctx;
      [mm3 setVoltaType:MNVoltaBegin withNumber:@"1." atY:-5];
      mm3.measure = 3;
      [mm3 draw:ctx];
      NSArray* notesmm3 = @[ [MNStaffNote noteWithKeys:@[ @"e/4" ] andDuration:@"w"] ];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm3 withNotes:notesmm3];

      // bar 4 - juxtapose fourth measure
      MNStaff* mm4 = [MNStaff staffWithRect:CGRectMake(mm3.width + mm3.x, mm1.y, 60, 0)];
      //      mm4.graphicsContext = ctx;
      [mm4 setVoltaType:MNVoltaMid withNumber:@"" atY:-5];
      mm4.measure = 4;
      [mm4 draw:ctx];
      NSArray* notesmm4 = @[ [MNStaffNote noteWithKeys:@[ @"f/4" ] andDuration:@"w"] ];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm4 withNotes:notesmm4];

      // bar 5 - juxtapose fifth measure
      MNStaff* mm5 = [MNStaff staffWithRect:CGRectMake(mm4.width + mm4.x, mm1.y, 60, 0)];
      //      mm5.graphicsContext = ctx;
      mm5.endBarType = MNBarLineRepeatEnd;
      [mm5 setVoltaType:MNVoltaEnd withNumber:@"" atY:-5];
      mm5.measure = 5;
      [mm5 draw:ctx];
      NSArray* notesmm5 = @[ [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"w"] ];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm5 withNotes:notesmm5];

      // bar 6 - juxtapose sixth measure
      MNStaff* mm6 = [MNStaff staffWithRect:CGRectMake(mm5.width + mm5.x, mm1.y, 60, 0)];
      //      mm6.graphicsContext = ctx;
      [mm6 setVoltaType:MNVoltaBeginEnd withNumber:@"2." atY:-5];
      mm6.endBarType = MNBarLineDouble;
      mm6.measure = 6;
      [mm6 draw:ctx];
      NSArray* notesmm6 = @[ [MNStaffNote noteWithKeys:@[ @"a/4" ] andDuration:@"w"] ];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm6 withNotes:notesmm6];

      // bar 7 - juxtapose seventh measure
      MNStaff* mm7 = [MNStaff staffWithRect:CGRectMake(mm6.width + mm6.x, mm1.y, 60, 0)];
      //      mm7.graphicsContext = ctx;
      mm7.measure = 7;
      [mm7 setSectionWithSection:@"B" atY:0];
      [mm7 draw:ctx];
      NSArray* notesmm7 = @[ [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"w"] ];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm7 withNotes:notesmm7];

      // bar 8 - juxtapose eighth measure
      MNStaff* mm8 = [MNStaff staffWithRect:CGRectMake(mm7.width + mm7.x, mm1.y, 60, 0)];
      //      mm8.graphicsContext = ctx;
      mm8.endBarType = MNBarLineDouble;
      [mm8 setRepetitionTypeRight:MNRepDSALCoda atY:25];
      mm8.measure = 8;
      [mm8 draw:ctx];
      NSArray* notesmm8 = @[ [MNStaffNote noteWithKeys:@[ @"c/5" ] andDuration:@"w"] ];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm8 withNotes:notesmm8];

      // bar 9 - juxtapose ninth measure
      MNStaff* mm9 = [MNStaff staffWithRect:CGRectMake(mm8.width + mm8.x + 20, mm1.y, 125, 0)];
      //      mm9.graphicsContext = ctx;
      mm9.begBarType = MNBarLineRepeatEnd;
      [mm9 setRepetitionTypeLeft:MNRepCodaLeft atY:25];
      [mm9 addClefWithName:@"treble"];   //.clefType =  MNClefTreble;
      mm9.keySignature = [MNKeySignature keySignatureWithKey:@"A"];
      [mm9 draw:ctx];
      mm9.measure = 9;
      NSArray* notesmm9 = @[ [MNStaffNote noteWithKeys:@[ @"d/5" ] andDuration:@"w"] ];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:mm9 withNotes:notesmm9];
    };
    return ret;
}

- (MNTestBlockStruct*)drawTempo:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      float padding = 10;
      __block float x = 0;
      __block float y = 50;

      void (^drawTempostaffBar)(CGContextRef, float, NSDictionary*, float, NSArray*);
      drawTempostaffBar = ^(CGContextRef ctx, float width, NSDictionary* tempoDict, float tempo_y, NSArray* notes) {
        MNStaff* staffBar = [MNStaff staffWithRect:CGRectMake(padding + x, y, width, 0)];
        //        staffBar.graphicsContext = ctx;

        if(x == 0)
        {
            [staffBar addClefWithName:@"treble"];
        }

        [staffBar setTempoWithTempo:[[MNStaffTempoOptionsStruct alloc] initWithDictionary:tempoDict] atY:tempo_y];
        [staffBar draw:ctx];

        NSArray* notesBar = notes != nil ? notes : @[
            [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q"],
            [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"q"],
            [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"q"],
            [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"q"]
        ];
        [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar withNotes:notesBar];
        x += width;
      };

      drawTempostaffBar(ctx, 120, @{ @"duration" : @"q", @"dots" : @1, @"bpm" : @(80) }, 0, nil);
      drawTempostaffBar(ctx, 100, @{ @"duration" : @"8", @"dots" : @2, @"bpm" : @(90) }, 0, nil);
      drawTempostaffBar(ctx, 100, @{ @"duration" : @"16", @"dots" : @1, @"bpm" : @(96) }, 0, nil);
      drawTempostaffBar(ctx, 100, @{ @"duration" : @"32", @"bpm" : @(70) }, 0, nil);
      drawTempostaffBar(ctx, 250,
                        @{ @"name" : @"Andante",
                           @"note" : @"8",
                           @"bpm" : @(120) },
                        -20, @[
                            [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"e/5" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"e/4" ] andDuration:@"8"]
                        ]);

      x = 0;
      y += 150;

      drawTempostaffBar(ctx, 120, @{ @"duration" : @"w", @"bpm" : @(80) }, 0, nil);
      drawTempostaffBar(ctx, 100, @{ @"duration" : @"h", @"bpm" : @(90) }, 0, nil);
      drawTempostaffBar(ctx, 100, @{ @"duration" : @"q", @"bpm" : @(96) }, 0, nil);
      drawTempostaffBar(ctx, 100, @{ @"duration" : @"8", @"bpm" : @(70) }, 0, nil);
      drawTempostaffBar(ctx, 250,
                        @{ @"name" : @"Andante grazioso" }, 0, @[
                            [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"e/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"c/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"d/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"g/4" ] andDuration:@"8"],
                            [MNStaffNote noteWithKeys:@[ @"e/4" ] andDuration:@"8"]
                        ]);
      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)configureSingleLine:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(100, 10, 300, 0)];

    [staff setConfigForLine:0 withConfig:@{ @"visible" : @(YES) }];
    [staff setConfigForLine:1 withConfig:@{ @"visible" : @(NO) }];
    [staff setConfigForLine:2 withConfig:@{ @"visible" : @(YES) }];
    [staff setConfigForLine:3 withConfig:@{ @"visible" : @(NO) }];
    [staff setConfigForLine:4 withConfig:@{ @"visible" : @(YES) }];

    NSArray* config = [staff getConfigForLines];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      assertThatBool([[config[0] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 0", isTrue(), nil));
      assertThatBool([[config[1] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 1", isFalse(), nil));
      assertThatBool([[config[2] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 2", isTrue(), nil));
      assertThatBool([[config[3] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 3", isFalse(), nil));
      assertThatBool([[config[4] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 4", isTrue(), nil));
      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)configureAllLines:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(100, 10, 300, 0)];

      [staff setConfigForLines:@[
          @{ @"visible" : @(NO) },
          @{},
          @{ @"visible" : @(NO) },
          @{ @"visible" : @(YES) },
          @{ @"visible" : @(NO) },
      ]];

      NSArray* config = [staff getConfigForLines];

      [staff draw:ctx];
      assertThatBool([[config[0] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 0", isFalse(), nil));
      assertThatBool([[config[1] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 1", isTrue(), nil));
      assertThatBool([[config[2] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 2", isFalse(), nil));
      assertThatBool([[config[3] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 3", isTrue(), nil));
      assertThatBool([[config[4] objectForKey:@"visible"] boolValue],
                     describedAs(@"getLinesConfiguration() - Line 4", isFalse(), nil));

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawStaffText:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(100, 50, 300, 0)];

    [staff setTextWithText:@"Violin" atPosition:MNPositionLeft];
    [staff setTextWithText:@"Right Text" atPosition:MNPositionRight];
    [staff setTextWithText:@"Above Text" atPosition:MNPositionAbove];
    [staff setTextWithText:@"Below Text" atPosition:MNPositionBelow];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      ok(YES, @"all pass");
    };

    return ret;
}

- (MNTestBlockStruct*)drawStaffTextMultiLine:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(100, 50, 300, 0)];

    [staff setTextWithText:@"Violin" atPosition:MNPositionLeft withOptions:@{ @"shift_y" : @(-10) }];
    [staff setTextWithText:@"2nd line" atPosition:MNPositionLeft withOptions:@{ @"shift_y" : @(10) }];
    [staff setTextWithText:@"Right Text" atPosition:MNPositionRight withOptions:@{ @"shift_y" : @(-10) }];
    [staff setTextWithText:@"2nd line" atPosition:MNPositionRight withOptions:@{ @"shift_y" : @(10) }];
    [staff setTextWithText:@"Above Text" atPosition:MNPositionAbove withOptions:@{ @"shift_y" : @(-10) }];
    [staff setTextWithText:@"2nd line" atPosition:MNPositionAbove withOptions:@{ @"shift_y" : @(10) }];
    [staff setTextWithText:@"Left Text Below"
                atPosition:MNPositionBelow
               withOptions:@{
                   @"shift_y" : @(-10),
                   @"justification" : @(MNTextJustificationLeft)
               }];
    [staff setTextWithText:@"Right Text Below"
                atPosition:MNPositionBelow
               withOptions:@{
                   @"shift_y" : @(10),
                   @"justification" : @(MNTextJustificationRight)
               }];

    //    ret.staff = staff;

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

@end
