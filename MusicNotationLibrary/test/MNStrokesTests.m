//
//  MNStrokesTests.m
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

#import "MNStrokesTests.h"
#import "NSArray+MNAdditions.h"
#import "OCTotallyLazy.h"

@interface NotesTabStavesStruct : IAModelBase
@property (strong, nonatomic) MNStaff* notesStaff;
@property (strong, nonatomic) MNStaff* tabStaff;
@end

@implementation NotesTabStavesStruct
@end

@interface NotesTabNotesStruct : IAModelBase
@property (strong, nonatomic) NSArray* notes;
@property (strong, nonatomic) NSArray* tabNotes;
@end

@implementation NotesTabNotesStruct
@end

@implementation MNStrokesTests

- (void)start
{
    [super start];
    [self runTest:@"Strokes - Brush/Arpeggiate/Rasquedo"
             func:@selector(drawMultipleMeasures:)
            frame:CGRectMake(10, 10, 600, 150)];
    [self runTest:@"Strokes - Multi Voice" func:@selector(multi:) frame:CGRectMake(10, 10, 600, 200)];
    [self runTest:@"Strokes - Notation and Tab" func:@selector(notesWithTab:) frame:CGRectMake(10, 10, 600, 250)];
    [self runTest:@"Strokes - Multi-Voice Notation and Tab"
             func:@selector(multiNotationAndTab:)
            frame:CGRectMake(10, 10, 600, 310)];
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
    //    NSUInteger h = size.height;

    w = w != 0 ? w : 350;
    //    h = h != 0 ? h : 150;

    // [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (MNTestTuple*)drawMultipleMeasures:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    // bar 1
    MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 250, 0)];
    [staffBar1 setEndBarType:MNBarLineDouble];

    NSArray* notesBar1 = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"a/3", @"e/4", @"a/4" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
            @"duration" : @"q"
        }]
    ];
    [notesBar1[0] addStroke:[MNStroke strokeWithType:MNStrokeBrushDown] atIndex:0];
    [notesBar1[1] addStroke:[MNStroke strokeWithType:MNStrokeBrushUp] atIndex:0];
    [notesBar1[2] addStroke:[MNStroke strokeWithType:MNStrokeBrushDown] atIndex:0];
    [notesBar1[3] addStroke:[MNStroke strokeWithType:MNStrokeBrushUp] atIndex:0];
    [notesBar1[1] addAccidental:[MNAccidental accidentalWithType:@"#"] atIndex:1];
    [notesBar1[1] addAccidental:[MNAccidental accidentalWithType:@"#"] atIndex:2];
    [notesBar1[1] addAccidental:[MNAccidental accidentalWithType:@"#"] atIndex:0];

    // bar 2
    MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 300, 0)];
    [staffBar2 setEndBarType:MNBarLineDouble];

    NSArray* notesBar2 = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"d/4", @"g/4" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"d/4", @"g/4" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"d/4", @"g/4" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/4", @"d/4", @"a/4" ],
            @"duration" : @"q"
        }]
    ];
    [notesBar2[0] addStroke:[MNStroke strokeWithType:MNStrokeRollDown] atIndex:0];
    [notesBar2[1] addStroke:[MNStroke strokeWithType:MNStrokeRollUp] atIndex:0];
    [notesBar2[2] addStroke:[MNStroke strokeWithType:MNStrokeRasquedoDown] atIndex:0];
    [notesBar2[3] addStroke:[MNStroke strokeWithType:MNStrokeRasquedoUp] atIndex:0];
    [notesBar2[3] addAccidental:[MNAccidental accidentalWithType:@"bb"] atIndex:0];
    [notesBar2[3] addAccidental:[MNAccidental accidentalWithType:@"bb"] atIndex:1];
    [notesBar2[3] addAccidental:[MNAccidental accidentalWithType:@"bb"] atIndex:2];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staffBar1 draw:ctx];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];
      [staffBar2 draw:ctx];
      ok(YES, @"Brush/Roll/Rasquedo");
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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(50, 10, 300, 0)];
      [staff draw:ctx];

      NSArray* notes = @[
          newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"c/4", @"d/4", @"a/4" ],
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"c/4", @"d/4", @"a/4" ],
                 @"duration" : @"q" })
      ];
      // Create the strokes
      MNStroke* stroke1 = [MNStroke strokeWithType:MNStrokeRasquedoDown];
      MNStroke* stroke2 = [MNStroke strokeWithType:MNStrokeRasquedoUp];
      MNStroke* stroke3 = [MNStroke strokeWithType:MNStrokeBrushUp];
      MNStroke* stroke4 = [MNStroke strokeWithType:MNStrokeBrushDown];
      [notes[0] addStroke:stroke1 atIndex:0];
      [notes[1] addStroke:stroke2 atIndex:0];
      [notes[2] addStroke:stroke3 atIndex:0];
      [notes[3] addStroke:stroke4 atIndex:0];

      [notes[1] addAccidental:[MNAccidental accidentalWithType:@"#"] atIndex:0];
      [notes[1] addAccidental:[MNAccidental accidentalWithType:@"#"] atIndex:2];

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

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice addTickables:notes];
      [voice2 addTickables:notes2];

      //      MNFormatter* formatter =
      [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatWith:@[ voice, voice2 ] withJustifyWidth:275];

      MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:4]]];
      MNBeam* beam2_2 = [MNBeam beamWithNotes:[notes2 slice:[@4:8]]];

      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam2_1 draw:ctx];
      [beam2_2 draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"Strokes Test Multi Voice");
    };
    return ret;
}

- (MNTestTuple*)multiNotationAndTab:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNTabNote* (^newTabNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 400, 0)] addTrebleGlyph];

    MNTabStaff* tabStaff = [[MNTabStaff staffWithRect:CGRectMake(10, 155, 400, 0)] addTabGlyph];
    tabStaff.noteStartX = staff.noteStartX;

    // notation upper voice notes
    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"g/4", @"b/4", @"e/5" ],
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/4", @"b/4", @"e/5" ],
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/4", @"b/4", @"e/5" ],
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/4", @"b/4", @"e/5" ],
               @"duration" : @"q" })
    ];

    // tablature upper voice notes
    NSArray* notes3 = @[
        newTabNote(@{
            @"positions" : @[
                @{@"str" : @(3), @"fret" : @"0"},
                @{@"str" : @(2), @"fret" : @"0"},
                @{@"str" : @(1), @"fret" : @"1"}
            ],
            @"duration" : @"q"
        }),
        newTabNote(@{
            @"positions" : @[
                @{@"str" : @(3), @"fret" : @"0"},
                @{@"str" : @(2), @"fret" : @"0"},
                @{@"str" : @(1), @"fret" : @"1"}
            ],
            @"duration" : @"q"
        }),
        newTabNote(@{
            @"positions" : @[
                @{@"str" : @(3), @"fret" : @"0"},
                @{@"str" : @(2), @"fret" : @"0"},
                @{@"str" : @(1), @"fret" : @"1"}
            ],
            @"duration" : @"q"
        }),
        newTabNote(@{
            @"positions" : @[
                @{@"str" : @(3), @"fret" : @"0"},
                @{@"str" : @(2), @"fret" : @"0"},
                @{@"str" : @(1), @"fret" : @"1"}
            ],
            @"duration" : @"q"
        })
    ];

    // Create the strokes for notation
    MNStroke* stroke1 = [MNStroke strokeWithType:MNStrokeRollDown allVoices:NO];
    MNStroke* stroke2 = [MNStroke strokeWithType:MNStrokeRasquedoUp];
    MNStroke* stroke3 = [MNStroke strokeWithType:MNStrokeBrushUp allVoices:NO];
    MNStroke* stroke4 = [MNStroke strokeWithType:MNStrokeBrushDown];
    // add strokes to notation
    [notes[0] addStroke:stroke1 atIndex:0];
    [notes[1] addStroke:stroke2 atIndex:0];
    [notes[2] addStroke:stroke3 atIndex:0];
    [notes[3] addStroke:stroke4 atIndex:0];

    // creae strokes for tab
    MNStroke* stroke5 = [MNStroke strokeWithType:MNStrokeRollDown allVoices:NO];
    MNStroke* stroke6 = [MNStroke strokeWithType:MNStrokeRasquedoUp];
    MNStroke* stroke7 = [MNStroke strokeWithType:MNStrokeBrushUp allVoices:NO];
    MNStroke* stroke8 = [MNStroke strokeWithType:MNStrokeBrushDown];
    // add strokes to tab
    [notes3[0] addStroke:stroke5 atIndex:0];
    [notes3[1] addStroke:stroke6 atIndex:0];
    [notes3[2] addStroke:stroke7 atIndex:0];
    [notes3[3] addStroke:stroke8 atIndex:0];

    // notation lower voice notes
    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"g/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" })
    ];

    // tablature lower voice notes
    NSArray* notes4 = @[
        newTabNote(
            @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"3"} ],
               @"duration" : @"q" }),
        newTabNote(
            @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"3"} ],
               @"duration" : @"q" }),
        newTabNote(
            @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"3"} ],
               @"duration" : @"q" }),
        newTabNote(
            @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"3"} ],
               @"duration" : @"q" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice3 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice4 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];
    [voice2 addTickables:notes2];
    [voice3 addTickables:notes3];
    [voice4 addTickables:notes4];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice, voice2, voice3, voice4 ]]
              formatWith:@[ voice, voice2, voice3, voice4 ]
        withJustifyWidth:275];
    //        [[[MNFormatter formatter] joinVoices:@[  voice3, voice4 ]]
    //         formatWith:@[ voice3, voice4 ]
    //         withJustifyWidth:275];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [tabStaff draw:ctx];

      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice4 draw:ctx dirtyRect:CGRectZero toStaff:tabStaff];
      [voice3 draw:ctx dirtyRect:CGRectZero toStaff:tabStaff];

      ok(YES, @"Strokes Test Notation & Tab Multi Voice");
    };
    return ret;
}

- (MNTestTuple*)drawTabStrokes:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNTabNote* (^newTabNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNTabStaff* staffBar1 = [MNTabStaff staffWithRect:CGRectMake(10, 50, 250, 0)];

      [staffBar1 setEndBarType:MNBarLineDouble];
      [staffBar1 draw:ctx];

      NSArray* notesBar1 = @[
          newTabNote(@{
              @"positions" : @[
                  @{@"str" : @(2), @"fret" : @"8"},
                  @{@"str" : @(3), @"fret" : @"9"},
                  @{@"str" : @(4), @"fret" : @"10"}
              ],
              @"duration" : @"q"
          }),
          newTabNote(@{
              @"positions" : @[
                  @{@"str" : @(3), @"fret" : @"7"},
                  @{@"str" : @(4), @"fret" : @"8"},
                  @{@"str" : @(5), @"fret" : @"9"}
              ],
              @"duration" : @"q"
          }),
          newTabNote(@{
              @"positions" : @[
                  @{@"str" : @(1), @"fret" : @"5"},
                  @{@"str" : @(2), @"fret" : @"6"},
                  @{@"str" : @(3), @"fret" : @"7"},
                  @{@"str" : @(4), @"fret" : @"7"},
                  @{@"str" : @(5), @"fret" : @"5"},
                  @{@"str" : @(6), @"fret" : @"5"}
              ],
              @"duration" : @"q"
          }),
          newTabNote(@{
              @"positions" : @[
                  @{@"str" : @(4), @"fret" : @"3"},
                  @{@"str" : @(5), @"fret" : @"4"},
                  @{@"str" : @(6), @"fret" : @"5"}
              ],
              @"duration" : @"q"
          }),

      ];

      MNStroke* stroke1 = [MNStroke strokeWithType:MNStrokeBrushDown];
      MNStroke* stroke2 = [MNStroke strokeWithType:MNStrokeBrushUp];
      MNStroke* stroke3 = [MNStroke strokeWithType:MNStrokeRollDown];
      MNStroke* stroke4 = [MNStroke strokeWithType:MNStrokeRollUp];

      [notesBar1[0] addStroke:stroke1 atIndex:0];
      [notesBar1[1] addStroke:stroke2 atIndex:0];
      [notesBar1[2] addStroke:stroke4 atIndex:0];
      [notesBar1[3] addStroke:stroke3 atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];

      // bar 2
      MNStaff* staffBar2 = [MNTabStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 300, 0)];
      [staffBar2 setEndBarType:MNBarLineDouble];
      [staffBar2 draw:ctx];
      NSArray* notesBar2 = @[
          newTabNote(@{
              @"positions" : @[
                  @{@"str" : @(2), @"fret" : @"7"},
                  @{@"str" : @(3), @"fret" : @"8"},
                  @{@"str" : @(4), @"fret" : @"9"}
              ],
              @"duration" : @"h"
          }),
          newTabNote(@{
              @"positions" : @[
                  @{@"str" : @(1), @"fret" : @"5"},
                  @{@"str" : @(2), @"fret" : @"6"},
                  @{@"str" : @(3), @"fret" : @"7"},
                  @{@"str" : @(4), @"fret" : @"7"},
                  @{@"str" : @(5), @"fret" : @"5"},
                  @{@"str" : @(6), @"fret" : @"5"}
              ],
              @"duration" : @"h"
          }),
      ];

      [notesBar2[0] addStroke:[MNStroke strokeWithType:MNStrokeRasquedoUp] atIndex:0];
      [notesBar2[1] addStroke:[MNStroke strokeWithType:MNStrokeRasquedoDown] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];

      ok(YES, @"Strokes Tab test");
    };
    return ret;
}

+ (NotesTabNotesStruct*)getTabNotes
{
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNTabNote* (^newTabNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };
    MNBend* (^newBend)(NSString*) = ^MNBend*(NSString* text)
    {
        return [[MNBend alloc] initWithText:text];
    };

    NSArray* notes1 = @[
        [[newNote(
            @{ @"keys" : @[ @"g/5", @"d/5", @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"b")
                                                            atIndex:0],
        newNote(
            @{ @"keys" : @[ @"c/5", @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/3", @"e/4", @"a/4", @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        [newNote(@{
            @"keys" : @[ @"a/3", @"e/4", @"a/4", @"c/5", @"e/5", @"a/5" ],
            @"stem_direction" : @(1),
            @"duration" : @"8"
        }) addAccidental:newAcc(@"#")
                  atIndex:3],
        newNote(
            @{ @"keys" : @[ @"b/3", @"e/4", @"a/4", @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        [[newNote(@{
            @"keys" : @[ @"a/3", @"e/4", @"a/4", @"c/5", @"f/5", @"a/5" ],
            @"stem_direction" : @(1),
            @"duration" : @"8"
        }) addAccidental:newAcc(@"#")
                  atIndex:3] addAccidental:newAcc(@"#")
                                   atIndex:4],
    ];

    NSArray* tabs1 = @[
        [newTabNote(@{
            @"positions" : @[
                @{@"str" : @(1), @"fret" : @"3"},
                @{@"str" : @(2), @"fret" : @"2"},
                @{@"str" : @(3), @"fret" : @"3"}
            ],
            @"duration" : @"q"
        }) addModifier:newBend(@"Full")
                atIndex:0],
        [newTabNote(@{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"3"}, @{@"str" : @(3), @"fret" : @"5"} ],
            @"duration" : @"q"
        }) addModifier:newBend(@"Unison")
                atIndex:1],
        newTabNote(@{
            @"positions" : @[
                @{@"str" : @(3), @"fret" : @"7"},
                @{@"str" : @(4), @"fret" : @"7"},
                @{@"str" : @(5), @"fret" : @"7"},
                @{@"str" : @(6), @"fret" : @"7"},
            ],
            @"duration" : @"8"
        }),
        newTabNote(@{
            @"positions" : @[
                @{@"str" : @(1), @"fret" : @"5"},
                @{@"str" : @(2), @"fret" : @"5"},
                @{@"str" : @(3), @"fret" : @"6"},
                @{@"str" : @(4), @"fret" : @"7"},
                @{@"str" : @(5), @"fret" : @"7"},
                @{@"str" : @(6), @"fret" : @"5"}
            ],
            @"duration" : @"8"
        }),
        newTabNote(@{
            @"positions" : @[
                @{@"str" : @(3), @"fret" : @"7"},
                @{@"str" : @(4), @"fret" : @"7"},
                @{@"str" : @(5), @"fret" : @"7"},
                @{@"str" : @(6), @"fret" : @"7"},
            ],
            @"duration" : @"8"
        }),
        newTabNote(@{
            @"positions" : @[
                @{@"str" : @(1), @"fret" : @"5"},
                @{@"str" : @(2), @"fret" : @"5"},
                @{@"str" : @(3), @"fret" : @"6"},
                @{@"str" : @(4), @"fret" : @"7"},
                @{@"str" : @(5), @"fret" : @"7"},
                @{@"str" : @(6), @"fret" : @"5"}
            ],
            @"duration" : @"8"
        })
    ];

    MNStroke* noteStr1 = [MNStroke strokeWithType:MNStrokeBrushDown];
    MNStroke* noteStr2 = [MNStroke strokeWithType:MNStrokeBrushUp];
    MNStroke* noteStr3 = [MNStroke strokeWithType:MNStrokeRollDown];
    MNStroke* noteStr4 = [MNStroke strokeWithType:MNStrokeRollUp];
    MNStroke* noteStr5 = [MNStroke strokeWithType:MNStrokeRasquedoDown];
    MNStroke* noteStr6 = [MNStroke strokeWithType:MNStrokeRasquedoUp];

    [notes1[0] addStroke:noteStr1 atIndex:0];
    [notes1[1] addStroke:noteStr2 atIndex:0];
    [notes1[2] addStroke:noteStr3 atIndex:0];
    [notes1[3] addStroke:noteStr4 atIndex:0];
    [notes1[4] addStroke:noteStr5 atIndex:0];
    [notes1[5] addStroke:noteStr6 atIndex:0];

    MNStroke* tabStr1 = [MNStroke strokeWithType:MNStrokeBrushDown];
    MNStroke* tabStr2 = [MNStroke strokeWithType:MNStrokeBrushUp];
    MNStroke* tabStr3 = [MNStroke strokeWithType:MNStrokeRollDown];
    MNStroke* tabStr4 = [MNStroke strokeWithType:MNStrokeRollUp];
    MNStroke* tabStr5 = [MNStroke strokeWithType:MNStrokeRasquedoDown];
    MNStroke* tabStr6 = [MNStroke strokeWithType:MNStrokeRasquedoUp];

    [tabs1[0] addStroke:tabStr1 atIndex:0];
    [tabs1[1] addStroke:tabStr2 atIndex:0];
    [tabs1[2] addStroke:tabStr3 atIndex:0];
    [tabs1[3] addStroke:tabStr4 atIndex:0];
    [tabs1[4] addStroke:tabStr5 atIndex:0];
    [tabs1[5] addStroke:tabStr6 atIndex:0];

    NotesTabNotesStruct* ret = [[NotesTabNotesStruct alloc] init];
    ret.notes = notes1;
    ret.tabNotes = tabs1;
    return ret;
}

+ (void)renderNotesWithTab:(NotesTabNotesStruct*)notes
                   context:(CGContextRef)ctx
                 dirtyRect:(CGRect)dirtyRect
                    staves:(NotesTabStavesStruct*)staves
                   justify:(NSUInteger)justify
{
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* tabVoice = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice addTickables:notes.notes];
    // Takes a voice and returns it's auto beamsj
    NSArray* beams = [MNBeam applyAndGetBeams:voice];   // Vex.Flow.Beam.applyAndGetBeams(voice);

    [tabVoice addTickables:notes.tabNotes];

    [[[MNFormatter formatter] joinVoices:@[ voice, tabVoice ]] formatWith:@[ voice, tabVoice ]
                                                         withJustifyWidth:justify];

    [voice draw:ctx dirtyRect:CGRectZero toStaff:staves.notesStaff];
    [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      [beam draw:ctx];
    }];
    [tabVoice draw:ctx dirtyRect:CGRectZero toStaff:staves.tabStaff];
}

- (MNTestTuple*)notesWithTab:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // Get test voices.
      NotesTabNotesStruct* notes = [[self class] getTabNotes];
      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(40, 10, 400, 0)] addTrebleGlyph];
      [staff draw:ctx];

      MNTabStaff* tabstaff = [[MNTabStaff staffWithRect:CGRectMake(40, 100, 400, 0)] addTabGlyph];
      [tabstaff setNoteStartX:staff.noteStartX];
      [tabstaff draw:ctx];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:tabstaff];
      MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:tabstaff];
      connector.type = MNStaffConnectorBracket;
      line.type = MNStaffConnectorSingleLeft;
      [connector draw:ctx];
      [line draw:ctx];

      //        Vex.Flow.Test.Strokes.renderNotesWithTab(notes, ctx,
      //                                                 { notes: staff, tabs: tabstaff });

      NotesTabStavesStruct* tmp = [[NotesTabStavesStruct alloc] init];
      tmp.notesStaff = staff;
      tmp.tabStaff = tabstaff;
      [[self class] renderNotesWithTab:notes context:ctx dirtyRect:CGRectZero staves:tmp justify:staff.width];

      //      ok(@"YES");
    };
    return ret;
}

@end
