//
//  MNStringNumberTests.m
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

#import "MNStringNumberTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNStringNumberTests

- (void)start
{
    [super start];
    //    [self runTest:@"String Number In Notation"
    //             func:@selector(drawMultipleMeasures:)
    //            frame:CGRectMake(10, 10, 760, 180)];
    //    [self runTest:@"Fret Hand Finger In Notation"
    //             func:@selector(drawFretHandFingers:)
    //            frame:CGRectMake(10, 10, 700, 200)];
    [self runTest:@"Multi Voice With Strokes, String & Finger Numbers"
             func:@selector(multi:)
            frame:CGRectMake(10, 10, 600, 200)];
    [self runTest:@"Complex Measure With String & Finger Numbers"
             func:@selector(drawAccidentals:)
            frame:CGRectMake(10, 10, 600, 200)];
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

- (MNTestTuple*)drawMultipleMeasures:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };
    MNStringNumber* (^newStringNumber)(NSString*, MNPositionType) = ^MNStringNumber*(NSString* nums, MNPositionType pos)
    {
        MNStringNumber* ret = [[MNStringNumber alloc] initWithString:nums];
        ret.position = pos;
        return ret;
    };

    // bar 1
    MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 290, 0)];
    [staffBar1 setEndBarType:MNBarLineDouble];
    [staffBar1 addClefWithName:@"treble"];

    NSArray* notesBar1 = @[
        [[[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
            @"stem_direction" : @(-1),
            @"duration" : @"q"
        }] addDotToAll],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5", @"e/5", @"g/5" ],
            @"stem_direction" : @(-1),
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"f/4", @"g/4" ],
            @"stem_direction" : @(-1),
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"f/4", @"g/4" ],
            @"stem_direction" : @(-1),
            @"duration" : @"q"
        }],
    ];

    [[[notesBar1[0] addModifier:newStringNumber(@"5", MNPositionRight) atIndex:0]
        addModifier:newStringNumber(@"4", MNPositionLeft)
            atIndex:1] addModifier:newStringNumber(@"3", MNPositionRight)
                           atIndex:2];

    [[[[notesBar1[1] addAccidental:newAcc(@"#") atIndex:0] addModifier:newStringNumber(@"5", MNPositionBelow) atIndex:0]
        addAccidental:[newAcc(@"#") setAsCautionary]
              atIndex:1]
        addModifier:[[newStringNumber(@"3", MNPositionAbove) setLastNote:notesBar1[3]] setLineEndType:MNLineEndTypeDOWN]
            atIndex:2];

    [[[notesBar1[2] addModifier:newStringNumber(@"5", MNPositionLeft) atIndex:0]
        addModifier:newStringNumber(@"3", MNPositionLeft)
            atIndex:2] addAccidental:newAcc(@"#")
                             atIndex:1];

    [[[notesBar1[3]

        // Position string 5 below default
        addModifier:[newStringNumber(@"5", MNPositionRight) setYOffset:7]
            atIndex:0]

        // Position string 4 below default
        addModifier:[newStringNumber(@"4", MNPositionRight) setYOffset:6]
            atIndex:1]

        // Position string 3 above default
        addModifier:[newStringNumber(@"3", MNPositionRight) setYOffset:-6]
            atIndex:2];

    // bar 2 - juxtaposing second bar next to first bar
    MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 300, 0)];
    [staffBar2 setEndBarType:MNBarLineDouble];

    NSArray* notesBar2 = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
            @"stem_direction" : @(1),
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5", @"e/5", @"g/5" ],
            @"stem_direction" : @(1),
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"f/4", @"g/4" ],
            @"stem_direction" : @(1),
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"f/4", @"g/4" ],
            @"stem_direction" : @(1),
            @"duration" : @"q"
        }],
    ];

    [[[notesBar2[0] addModifier:newStringNumber(@"5", MNPositionRight) atIndex:0]
        addModifier:newStringNumber(@"4", MNPositionLeft)
            atIndex:1] addModifier:newStringNumber(@"3", MNPositionRight)
                           atIndex:2];

    [[[[notesBar2[1] addAccidental:newAcc(@"#") atIndex:0] addModifier:newStringNumber(@"5", MNPositionBelow) atIndex:0]
        addAccidental:newAcc(@"#")
              atIndex:1] addModifier:[[newStringNumber(@"3", MNPositionAbove) setLastNote:notesBar2[3]] setDashed:NO]
                             atIndex:2];

    [[notesBar2[2] addModifier:newStringNumber(@"3", MNPositionLeft) atIndex:2] addAccidental:newAcc(@"#") atIndex:1];

    [[[notesBar2[3]

        // Position string 5 below default
        addModifier:[newStringNumber(@"5", MNPositionRight) setYOffset:7]
            atIndex:0]

        // Position string 4 below default
        addModifier:[newStringNumber(@"4", MNPositionRight) setYOffset:6]
            atIndex:1]

        // Position string 5 above default
        addModifier:[newStringNumber(@"3", MNPositionRight) setYOffset:-6]
            atIndex:2];

    // bar 3 - juxtaposing third bar next to second bar
    MNStaff* staffBar3 = [MNStaff staffWithRect:CGRectMake(staffBar2.width + staffBar2.x, staffBar2.y, 150, 0)];
    [staffBar3 setEndBarType:MNBarLineEnd];

    NSArray* notesBar3 = @[
        [[[MNStaffNote alloc] initWithDictionary:
                                  @{ @"keys" : @[ @"c/4", @"e/4", @"g/4", @"a/4" ],
                                     @"duration" : @"w" }] addDotToAll],
    ];

    [[[[notesBar3[0] addModifier:newStringNumber(@"5", MNPositionBelow) atIndex:0]
        addModifier:newStringNumber(@"4", MNPositionRight)
            atIndex:1] addModifier:newStringNumber(@"3", MNPositionLeft)
                           atIndex:2] addModifier:newStringNumber(@"2", MNPositionAbove)
                                          atIndex:3];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staffBar1 draw:ctx];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];
      [staffBar2 draw:ctx];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];
      [staffBar3 draw:ctx];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar3 withNotes:notesBar3];
      ok(YES, @"String Number");
    };
    return ret;
}

- (MNTestTuple*)drawFretHandFingers:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };
    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType pos)
    {
        MNFretHandFinger* ret = [[MNFretHandFinger alloc] init];
        ret.position = pos;
        ret.finger = num;
        return ret;
    };
    MNStringNumber* (^newStringNumber)(NSString*, MNPositionType) = ^MNStringNumber*(NSString* nums, MNPositionType pos)
    {
        MNStringNumber* ret = [[MNStringNumber alloc] initWithString:nums];
        ret.position = pos;
        return ret;
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 50, 290, 0)];
      [staffBar1 setEndBarType:MNBarLineDouble];
      [[staffBar1 addClefWithName:@"treble"] draw:ctx];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
              @"stem_direction" : @(-1),
              @"duration" : @"q"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5", @"e/5", @"g/5" ],
              @"stem_direction" : @(-1),
              @"duration" : @"q"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"f/4", @"g/4" ],
              @"stem_direction" : @(-1),
              @"duration" : @"q"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"f/4", @"g/4" ],
              @"stem_direction" : @(-1),
              @"duration" : @"q"
          }],
      ];

      [[[notesBar1[0] addModifier:newFinger(@"3", MNPositionLeft) atIndex:0] addModifier:newFinger(@"2", MNPositionLeft)
                                                                                 atIndex:1]
          addModifier:newFinger(@"0", MNPositionLeft)
              atIndex:2];

      [[[[[notesBar1[1] addAccidental:newAcc(@"#") atIndex:0] addModifier:newFinger(@"3", MNPositionLeft) atIndex:0]
          addModifier:newFinger(@"2", MNPositionLeft)
              atIndex:1] addAccidental:newAcc(@"#")
                               atIndex:1] addModifier:newFinger(@"0", MNPositionLeft)
                                              atIndex:2];

      [[[[[notesBar1[2] addModifier:newFinger(@"3", MNPositionBelow) atIndex:0]
          addModifier:newFinger(@"4", MNPositionLeft)
              atIndex:1] addModifier:newStringNumber(@"4", MNPositionLeft)
                             atIndex:1] addModifier:newFinger(@"0", MNPositionAbove)
                                            atIndex:2] addAccidental:newAcc(@"#")
                                                             atIndex:1];

      [[[[[[notesBar1[3] addModifier:newFinger(@"3", MNPositionRight) atIndex:0]
          // Position string 5 below default
          addModifier:[newStringNumber(@"5", MNPositionRight) setYOffset:7]
              atIndex:0] addModifier:newFinger(@"4", MNPositionRight)
                             atIndex:1]
          // Position String 4 below default
          addModifier:[newStringNumber(@"4", MNPositionRight) setYOffset:6]
              atIndex:1]
          // Position finger 0 above default
          addModifier:[newFinger(@"0", MNPositionRight) setYOffset:-5]
              atIndex:2]
          // Position string 3 above default
          addModifier:[newStringNumber(@"3", MNPositionRight) setYOffset:-6]
              atIndex:2];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];

      // bar 2 - juxtaposing second bar next to first bar
      MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 300, 0)];
      [staffBar2 setEndBarType:MNBarLineEnd];
      [staffBar2 draw:ctx];

      NSArray* notesBar2 = @[
          [[[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
              @"stem_direction" : @(1),
              @"duration" : @"q"
          }] addDotToAll],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5", @"e/5", @"g/5" ],
              @"stem_direction" : @(1),
              @"duration" : @"8"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"f/4", @"g/4" ],
              @"stem_direction" : @(1),
              @"duration" : @"8"
          }],
          [[[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"f/4", @"g/4" ],
              @"stem_direction" : @(-1),
              @"duration" : @"q"
          }] addDotToAll],
      ];

      [[[[notesBar2[0] addModifier:newFinger(@"3", MNPositionRight) atIndex:0]
          addModifier:newFinger(@"2", MNPositionLeft)
              atIndex:1] addModifier:newStringNumber(@"4", MNPositionRight)
                             atIndex:1] addModifier:newFinger(@"0", MNPositionAbove)
                                            atIndex:2];

      [[[[[notesBar2[1] addAccidental:newAcc(@"#") atIndex:0] addModifier:newFinger(@"3", MNPositionRight) atIndex:0]
          addModifier:newFinger(@"2", MNPositionLeft)
              atIndex:1] addAccidental:newAcc(@"#")
                               atIndex:1] addModifier:newFinger(@"0", MNPositionLeft)
                                              atIndex:2];

      [[[[[notesBar2[2] addModifier:newFinger(@"3", MNPositionBelow) atIndex:0]
          addModifier:newFinger(@"2", MNPositionLeft)
              atIndex:1] addModifier:newStringNumber(@"4", MNPositionLeft)
                             atIndex:1]
          //  addModifier(2, newFinger(@"1",  MNPositionAbove)).
          addModifier:newFinger(@"1", MNPositionRight)
              atIndex:2] addAccidental:newAcc(@"#")
                               atIndex:2];

      [[[[[[notesBar2[3] addModifier:newFinger(@"3", MNPositionRight) atIndex:0]
          // position string 5 below default
          addModifier:[newStringNumber(@"5", MNPositionRight) setYOffset:7]
              atIndex:0]
          // position finger 4 below default
          addModifier:newFinger(@"4", MNPositionRight)
              atIndex:1]
          // position string 4 below default
          addModifier:[newStringNumber(@"4", MNPositionRight) setYOffset:6]
              atIndex:1]
          // position finger 1 above default
          addModifier:[newFinger(@"1", MNPositionRight) setYOffset:-6]
              atIndex:2]
          // position string 3 above default
          addModifier:[newStringNumber(@"3", MNPositionRight) setYOffset:-6]
              atIndex:2];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];

      ok(YES, @"String Number");
    };
    return ret;
}

- (MNTestTuple*)multi:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };
    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType pos)
    {
        MNFretHandFinger* ret = [[MNFretHandFinger alloc] init];
        ret.position = pos;
        ret.finger = num;
        return ret;
    };
    MNStringNumber* (^newStringNumber)(NSString*, MNPositionType) = ^MNStringNumber*(NSString* nums, MNPositionType pos)
    {
        MNStringNumber* ret = [[MNStringNumber alloc] initWithString:nums];
        ret.position = pos;
        return ret;
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 600, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"e/4", @"a/3", @"g/4" ],
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"d/4", @"a/4" ],
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"d/4", @"a/4" ],
               @"duration" : @"q" })
    ];
    // Create the strokes
    MNStroke* stroke1 = [MNStroke strokeWithType:5];
    MNStroke* stroke2 = [MNStroke strokeWithType:6];
    MNStroke* stroke3 = [MNStroke strokeWithType:2];
    MNStroke* stroke4 = [MNStroke strokeWithType:1];
    [notes[0] addStroke:stroke1 atIndex:0];
    [notes[0] addModifier:newFinger(@"3", MNPositionLeft) atIndex:0];
    [notes[0] addModifier:newFinger(@"2", MNPositionLeft) atIndex:1];
    [notes[0] addModifier:newFinger(@"0", MNPositionLeft) atIndex:2];
    [notes[0] addModifier:newStringNumber(@"4", MNPositionLeft) atIndex:1];
    [notes[0] addModifier:newStringNumber(@"3", MNPositionAbove) atIndex:2];

    [notes[1] addStroke:stroke2 atIndex:0];
    [notes[1] addModifier:newStringNumber(@"4", MNPositionRight) atIndex:1];
    [notes[1] addModifier:newStringNumber(@"3", MNPositionAbove) atIndex:1];
    [notes[1] addAccidental:newAcc(@"#") atIndex:0];
    [notes[1] addAccidental:newAcc(@"#") atIndex:1];
    [notes[1] addAccidental:newAcc(@"#") atIndex:2];

    [notes[2] addStroke:stroke3 atIndex:0];
    [notes[2] addModifier:newFinger(@"3", MNPositionLeft) atIndex:0];
    [notes[2] addModifier:newFinger(@"0", MNPositionRight) atIndex:1];
    [notes[2] addModifier:newStringNumber(@"4", MNPositionRight) atIndex:1];
    [notes[2] addModifier:newFinger(@"1", MNPositionLeft) atIndex:2];
    [notes[2] addModifier:newStringNumber(@"3", MNPositionRight) atIndex:2];

    [notes[3] addStroke:stroke4 atIndex:0];
    [notes[3] addModifier:newStringNumber(@"3", MNPositionLeft) atIndex:2];
    [notes[3] addModifier:newStringNumber(@"4", MNPositionRight) atIndex:1];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })
    ];

    [notes2[0] addModifier:newFinger(@"0", MNPositionLeft) atIndex:0];
    [notes2[0] addModifier:newStringNumber(@"6", MNPositionBelow) atIndex:0];
    [notes2[2] addAccidental:newAcc(@"#") atIndex:0];
    [notes2[4] addModifier:newFinger(@"0", MNPositionLeft) atIndex:0];
    // Position string number 6 beneath the strum arrow: left (15) and down (18)
    [notes2[4] addModifier:[[newStringNumber(@"6", MNPositionLeft) setXOffset:15] setYOffset:18] atIndex:0];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];
    [voice2 addTickables:notes2];

    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatWith:@[ voice, voice2 ] withJustifyWidth:500];

    MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:4]]];
    MNBeam* beam2_2 = [MNBeam beamWithNotes:[notes2 slice:[@4:8]]];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam2_1 draw:ctx];
      [beam2_2 draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"Strokes Test Multi Voice");
    };
    return ret;
}

- (MNTestTuple*)drawAccidentals:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };
    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType pos)
    {
        MNFretHandFinger* ret = [[MNFretHandFinger alloc] init];
        ret.position = pos;
        ret.finger = num;
        return ret;
    };
    MNStringNumber* (^newStringNumber)(NSString*, MNPositionType) = ^MNStringNumber*(NSString* nums, MNPositionType pos)
    {
        MNStringNumber* ret = [[MNStringNumber alloc] initWithString:nums];
        ret.position = pos;
        return ret;
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 50, 475, 0)];
      [staffBar1 setEndBarType:MNBarLineDouble];
      [[staffBar1 addClefWithName:@"treble"] draw:ctx];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"e/4", @"g/4", @"c/5", @"e/5", @"g/5" ],
              @"stem_direction" : @(1),
              @"duration" : @"q"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"e/4", @"g/4", @"d/5", @"e/5", @"g/5" ],
              @"stem_direction" : @(1),
              @"duration" : @"q"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"e/4", @"g/4", @"d/5", @"e/5", @"g/5" ],
              @"stem_direction" : @(-1),
              @"duration" : @"q"
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4", @"e/4", @"g/4", @"d/5", @"e/5", @"g/5" ],
              @"stem_direction" : @(-1),
              @"duration" : @"q"
          }],
      ];

      [[[[[[[[[
          [[[[[notesBar1[0] addModifier:newFinger(@"3", MNPositionLeft) atIndex:0] addAccidental:newAcc(@"#") atIndex:0]
              addModifier:newFinger(@"2", MNPositionLeft)
                  atIndex:1] addModifier:newStringNumber(@"2", MNPositionLeft)
                                 atIndex:1] addAccidental:newAcc(@"#")
                                                  atIndex:1] addModifier:newFinger(@"0", MNPositionLeft)
                                                                 atIndex:2] addAccidental:newAcc(@"#")
                                                                                  atIndex:2]
          addModifier:newFinger(@"3", MNPositionLeft)
              atIndex:3] addAccidental:newAcc(@"#")
                               atIndex:3] addModifier:newFinger(@"2", MNPositionRight)
                                              atIndex:4] addModifier:newStringNumber(@"3", MNPositionRight)
                                                             atIndex:4] addAccidental:newAcc(@"#")
                                                                              atIndex:4]
          addModifier:newFinger(@"0", MNPositionLeft)
              atIndex:5] addAccidental:newAcc(@"#")
                               atIndex:5];

      [[[[[[notesBar1[1] addAccidental:newAcc(@"#") atIndex:0] addAccidental:newAcc(@"#") atIndex:1]
          addAccidental:newAcc(@"#")
                atIndex:2] addAccidental:newAcc(@"#")
                                 atIndex:3] addAccidental:newAcc(@"#")
                                                  atIndex:4] addAccidental:newAcc(@"#")
                                                                   atIndex:5];

      [[[[[[[[[
          [[[[[notesBar1[2] addModifier:newFinger(@"3", MNPositionLeft) atIndex:0] addAccidental:newAcc(@"#") atIndex:0]
              addModifier:newFinger(@"2", MNPositionLeft)
                  atIndex:1] addModifier:newStringNumber(@"2", MNPositionLeft)
                                 atIndex:1] addAccidental:newAcc(@"#")
                                                  atIndex:1] addModifier:newFinger(@"0", MNPositionLeft)
                                                                 atIndex:2] addAccidental:newAcc(@"#")
                                                                                  atIndex:2]
          addModifier:newFinger(@"3", MNPositionLeft)
              atIndex:3] addAccidental:newAcc(@"#")
                               atIndex:3] addModifier:newFinger(@"2", MNPositionRight)
                                              atIndex:4] addModifier:newStringNumber(@"3", MNPositionRight)
                                                             atIndex:4] addAccidental:newAcc(@"#")
                                                                              atIndex:4]
          addModifier:newFinger(@"0", MNPositionLeft)
              atIndex:5] addAccidental:newAcc(@"#")
                               atIndex:5];

      [[[[[[notesBar1[3] addAccidental:newAcc(@"#") atIndex:0] addAccidental:newAcc(@"#") atIndex:1]
          addAccidental:newAcc(@"#")
                atIndex:2] addAccidental:newAcc(@"#")
                                 atIndex:3] addAccidental:newAcc(@"#")
                                                  atIndex:4] addAccidental:newAcc(@"#")
                                                                   atIndex:5];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];

      ok(YES, @"String Number");
    };
    return ret;
}

@end
