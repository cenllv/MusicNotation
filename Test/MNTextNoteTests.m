//
//  MNTextNoteTests.m
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

#import "MNTextNoteTests.h"

#define DEBUG_TEXT_NOTE 0   // 1 or 0

@implementation MNTextNoteTests

- (void)start
{
    [super start];

    [self runTest:@"TextNote Formatting" func:@selector(formatTextNotes:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"TextNote Superscript and Subscript"
             func:@selector(superscriptAndSubscript:)
            frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"TextNote Formatting With Glyphs 0"
             func:@selector(formatTextGlyphs0:)
            frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"TextNote Formatting With Glyphs 1"
             func:@selector(formatTextGlyphs1:)
            frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Crescendo" func:@selector(crescendo:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Text Dynamics" func:@selector(textDynamics:) frame:CGRectMake(10, 10, 700, 250)];
}

- (void)tearDown
{
    [super tearDown];
}

+ (void)renderNotes:(NSArray*)notes1
              notes:(NSArray*)notes2
                ctx:(CGContextRef)ctx
            toStaff:(MNStaff*)staff
            justify:(float)justify
{
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice1 addTickables:notes1];
    [voice2 addTickables:notes2];

    MNFormatter* formatter = [[MNFormatter formatter] joinVoices:@[ voice1, voice2 ]];

    if(justify == 0)
    {
        [formatter formatToStaff:@[ voice1, voice2 ] staff:staff];
    }
    else
    {
        //        [formatter formatToStaff:<#(NSArray<MNVoice *> *)#> staff:<#(MNStaff *)#> options:<#(NSDictionary
        //        *)#>]
    }

    [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
    [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];

    if(DEBUG_TEXT_NOTE)
    {
        [notes1 oct_foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
          MNBoundingBox* bb = note.boundingBox;
          [bb draw:ctx];
        }];
    }
}

- (MNTestBlockStruct*)formatTextNotes:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNTextNote* (^newTextNote)(NSDictionary*) = ^MNTextNote*(NSDictionary* note_struct)
    {
        return [[MNTextNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 400, 0)];

    NSArray* notes1 = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
        newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        [[newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }) addAccidental:newAcc(@"n")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
    ];

    NSArray* notes2 = @[
        [newTextNote(
            @{ @"text" : @"Center Justification",
               @"duration" : @"h" }) setJustification:MNJustifyCENTER],
        [newTextNote(
            @{ @"text" : @"Left Line 1",
               @"duration" : @"q" }) setLine:1],
        [newTextNote(
            @{ @"text" : @"Right",
               @"duration" : @"q" }) setJustification:MNJustifyRIGHT],
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [[self class] renderNotes:notes1 notes:notes2 ctx:ctx toStaff:staff justify:0];
      ok(YES, @"");
    };

    return ret;
}

- (MNTestBlockStruct*)superscriptAndSubscript:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNTextNote* (^newTextNote)(NSDictionary*) = ^MNTextNote*(NSDictionary* note_struct)
    {
        return [[MNTextNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 500, 0)];

    NSArray* notes1 = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"h" }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
        newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        [[newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }) addAccidental:newAcc(@"n")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1]
    ];

    NSArray* notes2 = @[
        newTextNote(@{
            @"text" : [NSString stringWithFormat:@"%@%@", MNTable.unicode[@"flat"], @"I"],
            @"superscript" : @"+5",
            @"duration" : @"8"
        }),
        newTextNote(@{
            @"text" : [NSString stringWithFormat:@"%@%@%@", @"D", MNTable.unicode[@"sharp"], @"/F"],
            @"duration" : @"4d",
            @"superscript" : @"sus2"
        }),
        newTextNote(
            @{ @"text" : @"ii",
               @"superscript" : @"6",
               @"subscript" : @"4",
               @"duration" : @"8" }),
        newTextNote(@{
            @"text" : @"C",
            @"superscript" : [NSString stringWithFormat:@"%@%@", MNTable.unicode[@"triangle"], @"7"],
            @"subscript" : @"",
            @"duration" : @"8"
        }),
        newTextNote(@{
            @"text" : @"vii",
            @"superscript" : [NSString stringWithFormat:@"%@%@", MNTable.unicode[@"o-with-slash"], @"7"],
            @"duration" : @"8"
        }),
        newTextNote(
            @{ @"text" : @"V",
               @"superscript" : @"7",
               @"duration" : @"8" }),
    ];

    [notes2 oct_foreach:^(MNTextNote* note, NSUInteger i, BOOL* stop) {
      [note setLine:13];
      note.font = [MNFont fontWithName:@"Times" size:20];
      [note setJustification:MNJustifyLEFT];
    }];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      if(DEBUG_TEXT_NOTE)
      {
          [MNText showBoundingBox:YES];
      }

      [[self class] renderNotes:notes1 notes:notes2 ctx:ctx toStaff:staff justify:0];

      if(DEBUG_TEXT_NOTE)
      {
          [MNText showBoundingBox:NO];
      }

      ok(YES, @"");
    };

    return ret;
}

- (MNTestBlockStruct*)formatTextGlyphs0:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNTextNote* (^newTextNote)(NSDictionary*) = ^MNTextNote*(NSDictionary* note_struct)
    {
        return [[MNTextNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 600, 0)];

    NSArray* notes1 = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
        newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
    ];

    NSArray* notes2 = @[
        [newTextNote(
            @{ @"text" : @"Center",
               @"duration" : @"8" }) setJustification:MNJustifyCENTER],
        newTextNote(
            @{ @"glyph" : @"f",
               @"duration" : @"8" }),
        newTextNote(
            @{ @"glyph" : @"p",
               @"duration" : @"8" }),
        newTextNote(
            @{ @"glyph" : @"m",
               @"duration" : @"8" }),
        newTextNote(
            @{ @"glyph" : @"z",
               @"duration" : @"8" }),

        newTextNote(
            @{ @"glyph" : @"mordent_upper",
               @"duration" : @"16" }),
        newTextNote(
            @{ @"glyph" : @"mordent_lower",
               @"duration" : @"16" }),
        newTextNote(
            @{ @"glyph" : @"segno",
               @"duration" : @"8" }),
        newTextNote(
            @{ @"glyph" : @"coda",
               @"duration" : @"8" }),
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [[self class] renderNotes:notes1 notes:notes2 ctx:ctx toStaff:staff justify:0];
      ok(YES, @"");
    };

    return ret;
}

- (MNTestBlockStruct*)formatTextGlyphs1:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNTextNote* (^newTextNote)(NSDictionary*) = ^MNTextNote*(NSDictionary* note_struct)
    {
        return [[MNTextNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 600, 0)];

    NSArray* notes1 = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],

        newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })
    ];

    NSArray* notes2 = @[
        newTextNote(
            @{ @"glyph" : @"turn",
               @"duration" : @"16" }),
        newTextNote(
            @{ @"glyph" : @"turn_inverted",
               @"duration" : @"16" }),
        [newTextNote(
            @{ @"glyph" : @"pedal_open",
               @"duration" : @"8" }) setLine:10],
        [newTextNote(
            @{ @"glyph" : @"pedal_close",
               @"duration" : @"8" }) setLine:10],
        [newTextNote(
            @{ @"glyph" : @"caesura_curved",
               @"duration" : @"8" }) setLine:3],
        [newTextNote(
            @{ @"glyph" : @"caesura_straight",
               @"duration" : @"8" }) setLine:3],
        [newTextNote(
            @{ @"glyph" : @"breath",
               @"duration" : @"8" }) setLine:2],
        [newTextNote(
            @{ @"glyph" : @"tick",
               @"duration" : @"8" }) setLine:3],
        [newTextNote(
            @{ @"glyph" : @"tr",
               @"duration" : @"8",
               @"smooth" : @YES }) setJustification:MNJustifyCENTER]

    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [[self class] renderNotes:notes1 notes:notes2 ctx:ctx toStaff:staff justify:0];
      ok(YES, @"");
    };

    return ret;
}

- (MNTestBlockStruct*)crescendo:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNTextNote* (^newTextNote)(NSDictionary*) = ^MNTextNote*(NSDictionary* note_struct)
    {
        return [[MNTextNote alloc] initWithDictionary:note_struct];
    };

    MNCrescendo* (^newCrescendo)(NSDictionary*) = ^MNCrescendo*(NSDictionary* note_struct)
    {
        return [[MNCrescendo alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 500, 0)];

    NSArray* notes = @[
        newTextNote(
            @{ @"glyph" : @"p",
               @"duration" : @"16" }),
        [(MNCrescendo*)[newCrescendo(
            @{ @"duration" : @"4d" }) setLine:0] setHeight:25],
        newTextNote(
            @{ @"glyph" : @"f",
               @"duration" : @"16" }),
        [newCrescendo(
            @{ @"duration" : @"4" }) setLine:5],
        [(MNCrescendo*)[[newCrescendo(
            @{ @"duration" : @"4" }) setLine:10] setDescrescendo:YES] setHeight:5]
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    // MNFormatter* formatter =
    [[MNFormatter formatter] formatToStaff:@[ voice ] staff:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [notes oct_foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [note setStaff:staff];
        [note draw:ctx];
      }];

      ok(YES, @"");
    };

    return ret;
}

- (MNTestBlockStruct*)textDynamics:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNTextDynamics* (^newTextDynamics)(NSDictionary*) = ^MNTextDynamics*(NSDictionary* note_struct)
    {
        return [[MNTextDynamics alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 550, 0)];

    NSArray* notes = @[
        newTextDynamics(
            @{ @"text" : @"sfz",
               @"duration" : @"4" }),
        newTextDynamics(
            @{ @"text" : @"rfz",
               @"duration" : @"4" }),
        newTextDynamics(
            @{ @"text" : @"mp",
               @"duration" : @"4" }),
        newTextDynamics(
            @{ @"text" : @"ppp",
               @"duration" : @"4" }),
        newTextDynamics(
            @{ @"text" : @"fff",
               @"duration" : @"4" }),
        newTextDynamics(
            @{ @"text" : @"mf",
               @"duration" : @"4" }),
        newTextDynamics(
            @{ @"text" : @"sff",
               @"duration" : @"4" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    // MNFormatter* formatter =
    [[MNFormatter formatter] formatToStaff:@[ voice ] staff:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [notes oct_foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [note setStaff:staff];
        [note draw:ctx];
      }];

      ok(YES, @"");
    };

    return ret;
}

@end
