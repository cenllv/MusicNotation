//
//  MNGraceNoteTests.m
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

#import "MNGraceNoteTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNGraceNoteTests

- (void)start
{
    [super start];
    float w = 750, h = 200;
    [self runTest:@"Grace Note Basic" func:@selector(basic:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Grace Note Basic with Slurs" func:@selector(basicSlurred:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Grace Notes Multiple Voices" func:@selector(multipleVoices:) frame:CGRectMake(10, 10, w, h)];
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

- (void)helperWithCtxWidth:(NSUInteger)ctxWidth staffWidth:(NSUInteger)staffWidth
{
    /*
    Vex.Flow.Test.GraceNote.helper = function(options, contextBuilder, ctxWidth, staffWidth){
        var ctx = contextBuilder(options.canvas_sel, ctxWidth, 130);
        ctx.scale(1.0, 1.0); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10,
    staffWidth) addClefWithName:@"treble") draw:ctx];
        return {
        ctx: ctx,
        staff: staff,
        newNote: function newNote(note_struct) {
            return [[MNStaffNote alloc]initWithDictionary:(note_struct);
        }
        };
    };
     */
}

- (MNTestTuple*)basic:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNGraceNote* (^createNote)(NSDictionary*) = ^MNGraceNote*(NSDictionary* note_struct)
    {
        return [[MNGraceNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 700, 0)];
    MNStaffNote* note0 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"b/4" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    MNStaffNote* note1 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"c/5" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    MNStaffNote* note2 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"c/5", @"d/5" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    MNStaffNote* note3 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"a/4" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    MNStaffNote* note4 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"a/4" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    //      MNStaffNote* note5 = [[MNStaffNote alloc] initWithDictionary:@{
    //          @"keys" : @[ @"a/4" ],
    //          @"duration" : @"4",
    //          @"auto_stem" : @(YES)
    //      }];

    [note1 addAccidental:newAcc(@"#") atIndex:0];

    NSArray* gracenote_group0 = @[
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"f/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"g/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"a/4" ],
           @"duration" : @"32" }
    ];

    NSArray* gracenote_group1 = @[ @{ @"keys" : @[ @"b/4" ], @"duration" : @"8", @"slash" : @(NO) } ];

    NSArray* gracenote_group2 = @[ @{ @"keys" : @[ @"b/4" ], @"duration" : @"8", @"slash" : @(YES) } ];

    NSArray* gracenote_group3 = @[
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"f/4" ],
           @"duration" : @"16" },
        @{ @"keys" : @[ @"g/4", @"e/4" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"a/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"32" }
    ];

    NSArray* gracenote_group4 = @[
        @{ @"keys" : @[ @"g/4" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"g/4" ],
           @"duration" : @"16" },
        @{ @"keys" : @[ @"g/4" ],
           @"duration" : @"16" }
    ];

    NSArray<MNGraceNote*>* gracenotes = [gracenote_group0 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes1 = [gracenote_group1 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes2 = [gracenote_group2 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes3 = [gracenote_group3 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes4 = [gracenote_group4 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];

    [gracenotes[1] addAccidental:newAcc(@"##") atIndex:0];
    [gracenotes3[3] addAccidental:newAcc(@"bb") atIndex:0];

    [gracenotes4[0] addDotToAll];

    [note0 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes] beamNotes]];
    [note1 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes1] beamNotes]];
    [note2 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes2] beamNotes]];
    [note3 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes3] beamNotes]];
    [note4 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes4] beamNotes]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staff
                                  withNotes:@[ note0, note1, note2, note3, note4 ]
                           withJustifyWidth:0];
      ok(YES, @"GraceNoteBasic");
    };
    return ret;
}

- (MNTestTuple*)basicSlurred:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNGraceNote* (^createNote)(NSDictionary*) = ^MNGraceNote*(NSDictionary* note_struct)
    {
        return [[MNGraceNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 700, 0)];
    MNStaffNote* note0 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"b/4" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    MNStaffNote* note1 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"c/5" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    MNStaffNote* note2 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"c/5", @"d/5" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    MNStaffNote* note3 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"a/4" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    MNStaffNote* note4 = [[MNStaffNote alloc] initWithDictionary:@{
        @"keys" : @[ @"a/4" ],
        @"duration" : @"4",
        @"auto_stem" : @(YES)
    }];
    //      MNStaffNote* note5 = [[MNStaffNote alloc] initWithDictionary:@{
    //          @"keys" : @[ @"a/4" ],
    //          @"duration" : @"4",
    //          @"auto_stem" : @(YES)
    //      }];

    [note1 addAccidental:newAcc(@"#") atIndex:0];

    NSArray* gracenote_group0 = @[
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"f/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"g/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"a/4" ],
           @"duration" : @"32" }
    ];

    NSArray* gracenote_group1 = @[ @{ @"keys" : @[ @"b/4" ], @"duration" : @"8", @"slash" : @(NO) } ];

    NSArray* gracenote_group2 = @[ @{ @"keys" : @[ @"b/4" ], @"duration" : @"8", @"slash" : @(YES) } ];

    NSArray* gracenote_group3 = @[
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"f/4" ],
           @"duration" : @"16" },
        @{ @"keys" : @[ @"g/4", @"e/4" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"a/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"32" }
    ];

    NSArray* gracenote_group4 = @[
        @{ @"keys" : @[ @"a/4" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"a/4" ],
           @"duration" : @"16" },
        @{ @"keys" : @[ @"a/4" ],
           @"duration" : @"16" }
    ];

    NSArray<MNGraceNote*>* gracenotes = [gracenote_group0 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes1 = [gracenote_group1 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes2 = [gracenote_group2 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes3 = [gracenote_group3 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes4 = [gracenote_group4 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];

    [gracenotes[1] addAccidental:newAcc(@"#") atIndex:0];
    [gracenotes3[3] addAccidental:newAcc(@"b") atIndex:0];
    [gracenotes3[2] addAccidental:newAcc(@"n") atIndex:0];
    [gracenotes4[0] addDotToAll];

    [note0 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes showSlur:YES] beamNotes]
               atIndex:0];
    [note1 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes1 showSlur:YES] beamNotes]
               atIndex:0];
    [note2 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes2 showSlur:YES] beamNotes]
               atIndex:0];
    [note3 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes3 showSlur:YES] beamNotes]
               atIndex:0];
    [note4 addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes4 showSlur:YES] beamNotes]
               atIndex:0];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staff
                                  withNotes:@[ note0, note1, note2, note3, note4 ]
                           withJustifyWidth:0];
    };
    return ret;
}

- (MNTestTuple*)multipleVoices:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNGraceNote* (^createNote)(NSDictionary*) = ^MNGraceNote*(NSDictionary* note_struct)
    {
        return [[MNGraceNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 50, 450, 0)] addTrebleGlyph];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" })
    ];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" })
    ];

    NSArray* gracenote_group0 = @[ @{ @"keys" : @[ @"b/4" ], @"duration" : @"8", @"slash" : @(YES) } ];

    NSArray* gracenote_group1 = @[ @{ @"keys" : @[ @"f/4" ], @"duration" : @"8", @"slash" : @(YES) } ];

    NSArray* gracenote_group2 = @[
        @{ @"keys" : @[ @"f/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) }
    ];

    NSArray<MNGraceNote*>* gracenotes1 = [gracenote_group0 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes2 = [gracenote_group1 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];
    NSArray<MNGraceNote*>* gracenotes3 = [gracenote_group2 oct_map:^MNGraceNote*(NSDictionary* noteDict) {
      return createNote(noteDict);
    }];

    [gracenotes2[0] setStemDirection:-1];
    [gracenotes2[0] addAccidental:newAcc(@"#") atIndex:0];

    [notes[3] addModifier:[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes1] atIndex:0];
    [notes2[1] addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes2] beamNotes] atIndex:0];
    [notes2[5] addModifier:[[[MNGraceNoteGroup alloc] initWithGraceNoteGroups:gracenotes3] beamNotes] atIndex:0];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];
    [voice2 addTickables:notes2];

    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];

    MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:4]]];
    MNBeam* beam2_2 = [MNBeam beamWithNotes:[notes2 slice:[@4:8]]];

    [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatToStaff:@[ voice, voice2 ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      [beam2_1 draw:ctx];
      [beam2_2 draw:ctx];
      ok(YES, @"Sixteenth Test");
    };
    return ret;
}

@end
