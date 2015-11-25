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

- (void)renderNotes
{
    /*
        renderNotes: function(notes1, notes2, ctx, staff, justify) {
            var voice1 =  [MNVoice voiceWithTimeSignature:MNTime4_4];
            var voice2 =  [MNVoice voiceWithTimeSignature:MNTime4_4];

            notes1.forEach(function(note) {note.setContext(ctx)});
            notes2.forEach(function(note) {note.setContext(ctx)});

            voice1.addTickables(notes1);
            voice2.addTickables(notes2);

            [MNFormatter formatter] joinVoices:@[voice1, voice2]).
            formatToStaff([voice1, voice2], staff);

            [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
            voice2.draw(ctx, staff);
        },
     */
}

- (MNTestTuple*)formatTextNotes:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
        formatTextNotes: function(options, contextBuilder) {
            var ctx = new contextBuilder(options.canvas_sel, 400, 150);
            ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 400);

            [staff draw:ctx];

            function newNote(note_struct) { return [[[MNStaffNote alloc]initWithDictionary:(note_struct); }
            function newTextNote(text_struct) { return new Vex.Flow.TextNote(text_struct); }
            function newAcc(type) { return new Vex.Flow.Accidental(type); }

            NSArray *notes1 = [
                          newNote(@{ @"keys" : @[@"c/4", @"e/4", @"a/4"], @"stem_direction" : @(-1), @"duration" :
       @"h"}).
                          addAccidental(0, newAcc(@"b")).
                          addAccidental(1, newAcc(@"#")),
                          newNote(@{ @"keys" : @[@"d/4", @"e/4", @"f/4"], @"stem_direction" : @(-1), @"duration" :
       @"q"}),
                          newNote(@{ @"keys" : @[@"f/4", @"a/4", @"c/4"], @"stem_direction" : @(-1), @"duration" :
       @"q"}).
                          addAccidental(0, newAcc(@"n")).
                          addAccidental(1, newAcc(@"#"))
                          ];

            NSArray *notes2 = [
                          newTextNote({text: "Center Justification",  duration: "h"}).
                          setJustification(Vex.Flow.TextNote.Justification.CENTER),
                          newTextNote({text: "Left Line 1", @"duration" : @"q"}).setLine(1),
                          newTextNote({text: "Right", @"duration" : @"q"}).
                          setJustification(Vex.Flow.TextNote.Justification.RIGHT),
                          ];

            Vex.Flow.Test.TextNote.renderNotes(notes1, notes2, ctx, staff);

            ok(YES);
        },
     */

    return ret;
}

- (MNTestTuple*)superscriptAndSubscript:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
        superscriptAndSubscript: function(options, contextBuilder) {
            var ctx = new contextBuilder(options.canvas_sel, 550, 200);
            ctx.scale(1, 1); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 500);

            [staff draw:ctx];

            function newNote(note_struct) { return [[[MNStaffNote alloc]initWithDictionary:(note_struct); }
            function newTextNote(text_struct) { return new Vex.Flow.TextNote(text_struct); }
            function newAcc(type) { return new Vex.Flow.Accidental(type); }

            NSArray *notes1 = [
                          newNote(@{ @"keys" : @[@"c/4", @"e/4", @"a/4"], @"stem_direction" : @(1), @"duration" :
       @"h"}).
                          addAccidental(0, newAcc(@"b")).
                          addAccidental(1, newAcc(@"#")),
                          newNote(@{ @"keys" : @[@"d/4", @"e/4", @"f/4"], @"stem_direction" : @(1), @"duration" :
       @"q"}),
                          newNote(@{ @"keys" : @[@"f/4", @"a/4", @"c/4"], @"stem_direction" : @(1), @"duration" :
       @"q"}).
                          addAccidental(0, newAcc(@"n")).
                          addAccidental(1, newAcc(@"#"))
                          ];

            NSArray *notes2 = [
                          newTextNote({text: Vex.Flow.unicode["flat"] + "I", superscript: "+5",  duration: "8"}),
                          newTextNote({text: "D" + Vex.Flow.unicode["sharp"] +"/F",  duration: "4d", superscript:
       "sus2"}),
                          newTextNote({text: "ii", superscript: "6", subscript: "4",  duration: "8"}),
                          newTextNote({text: "C" , superscript: Vex.Flow.unicode["triangle"] + "7", subscript: "",
       @"duration" : @"8"}),
                          newTextNote({text: "vii", superscript: Vex.Flow.unicode["o-with-slash"] + "7", @"duration" :
       @"8"}),
                          newTextNote({text: "V",superscript: "7",   duration: "8"}),
                          ];

            notes2.forEach(function(note) {
                note.setLine(13);
                note.font = {
                family: "Serif",
                size: 15,
                weight: ""
                };
                note.setJustification(Vex.Flow.TextNote.Justification.LEFT);
            });

            Vex.Flow.Test.TextNote.renderNotes(notes1, notes2, ctx, staff);

            ok(YES);
        },
     */
    return ret;
}

- (MNTestTuple*)formatTextGlyphs0:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
        formatTextGlyphs0: function(options, contextBuilder) {
            var ctx = new contextBuilder(options.canvas_sel, 600, 180);
            ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 20, 600);

            [staff draw:ctx];

            function newNote(note_struct) { return [[[MNStaffNote alloc]initWithDictionary:(note_struct); }
            function newTextNote(text_struct) { return new Vex.Flow.TextNote(text_struct); }
            function newAcc(type) { return new Vex.Flow.Accidental(type); }

            NSArray *notes1 = [
                          newNote(@{ @"keys" : @[@"c/4", @"e/4", @"a/4"], @"stem_direction" : @(-1), @"duration" :
       @"h"}).
                          addAccidental(0, newAcc(@"b")).
                          addAccidental(1, newAcc(@"#")),
                          newNote(@{ @"keys" : @[@"d/4", @"e/4", @"f/4"], @"stem_direction" : @(-1), @"duration" :
       @"8"}),
                          newNote(@{ @"keys" : @[@"f/4", @"a/4", @"c/4"], @"stem_direction" : @(-1), @"duration" :
       @"8"}),
                          newNote(@{ @"keys" : @[@"f/4", @"a/4", @"c/4"], @"stem_direction" : @(-1), @"duration" :
       @"8"}),
                          newNote(@{ @"keys" : @[@"f/4", @"a/4", @"c/4"], @"stem_direction" : @(-1), @"duration" :
       @"8"})
                          ];

            NSArray *notes2 = [
                          newTextNote({text: "Center",  duration: "8"}).
                          setJustification(Vex.Flow.TextNote.Justification.CENTER),
                          newTextNote({glyph: "f", @"duration" : @"8"}),
                          newTextNote({glyph: "p", @"duration" : @"8"}),
                          newTextNote({glyph: "m", @"duration" : @"8"}),
                          newTextNote({glyph: "z", @"duration" : @"8"}),

                          newTextNote({glyph: "mordent_upper", @"duration" : @"16"}),
                          newTextNote({glyph: "mordent_lower", @"duration" : @"16"}),
                          newTextNote({glyph: "segno", @"duration" : @"8"}),
                          newTextNote({glyph: "coda", @"duration" : @"8"}),
                          ];

            Vex.Flow.Test.TextNote.renderNotes(notes1, notes2, ctx, staff);

            ok(YES);
        },
     */
    return ret;
}

- (MNTestTuple*)formatTextGlyphs1:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
        formatTextGlyphs1: function(options, contextBuilder) {
            var ctx = new contextBuilder(options.canvas_sel, 600, 180);
            ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 20, 600);

            [staff draw:ctx];

            function newNote(note_struct) { return [[[MNStaffNote alloc]initWithDictionary:(note_struct); }
            function newTextNote(text_struct) { return new Vex.Flow.TextNote(text_struct); }
            function newAcc(type) { return new Vex.Flow.Accidental(type); }

            NSArray *notes1 = [
                          newNote(@{ @"keys" : @[@"c/4", @"e/4", @"a/4"], @"stem_direction" : @(-1), @"duration" :
       @"h"}).
                          addAccidental(0, newAcc(@"b")).
                          addAccidental(1, newAcc(@"#")),
                          newNote(@{ @"keys" : @[@"d/4", @"e/4", @"f/4"], @"stem_direction" : @(-1), @"duration" :
       @"8"}),
                          newNote(@{ @"keys" : @[@"f/4", @"a/4", @"c/4"], @"stem_direction" : @(-1), @"duration" :
       @"8"}),
                          newNote(@{ @"keys" : @[@"f/4", @"a/4", @"c/4"], @"stem_direction" : @(-1), @"duration" :
       @"8"}),
                          newNote(@{ @"keys" : @[@"f/4", @"a/4", @"c/4"], @"stem_direction" : @(-1), @"duration" :
       @"8"})
                          ];

            NSArray *notes2 = [
                          newTextNote({glyph: "turn",  duration: "16"}),
                          newTextNote({glyph: "turn_inverted",  duration: "16"}),
                          newTextNote({glyph: "pedal_open", @"duration" : @"8"}).setLine(10),
                          newTextNote({glyph: "pedal_close", @"duration" : @"8"}).setLine(10),
                          newTextNote({glyph: "caesura_curved", @"duration" : @"8"}).setLine(3),
                          newTextNote({glyph: "caesura_straight", @"duration" : @"8"}).setLine(3),
                          newTextNote({glyph: "breath", @"duration" : @"8"}).setLine(2),
                          newTextNote({glyph: "tick", @"duration" : @"8"}).setLine(3),
                          newTextNote({glyph: "tr", @"duration" : @"8", smooth: YES}).
                          setJustification(Vex.Flow.TextNote.Justification.CENTER),
                          ];

            Vex.Flow.Test.TextNote.renderNotes(notes1, notes2, ctx, staff);

            ok(YES);
        },
     */
    return ret;
}

- (MNTestTuple*)crescendo:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
        crescendo: function(options, contextBuilder) {
            var ctx = new contextBuilder(options.canvas_sel, 600, 180);
            ctx.scale(1, 1); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 20, 500);

            [staff draw:ctx];

            NSArray *notes = @[
                         new Vex.Flow.TextNote({glyph: "p", @"duration" : @"16"}).setContext(ctx),
                         new Vex.Flow.Crescendo({duration: "4d"}).setLine(0).setHeight(25),
                         new Vex.Flow.TextNote({glyph: "f", @"duration" : @"16"}).setContext(ctx),
                         new Vex.Flow.Crescendo({duration: "4"}).setLine(5),
                         new Vex.Flow.Crescendo({duration: "4"}).setLine(10).setDecrescendo(YES).setHeight(5)
                         ];

             MNVoice *voice =  [MNVoice voiceWithTimeSignature:MNTime4_4] setStrict:NO];
            [voice addTickables:notes];

            MNFormatter *formatter = [MNFormatter formatter] formatToStaff([voice], staff);

            notes.forEach(function(note) {
                note.setStaff(staff);
                note draw:ctx];
            });

            ok(YES);
        },
     */
    return ret;
}

- (MNTestTuple*)textDynamics:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
        textDynamics: function(options, contextBuilder) {
            var ctx = new contextBuilder(options.canvas_sel, 600, 180);
            ctx.scale(1, 1); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 20, 550);

            [staff draw:ctx];

            NSArray *notes = @[
                         new Vex.Flow.TextDynamics({ text: "sfz", @"duration" : @"4" }),
                         new Vex.Flow.TextDynamics({ text: "rfz", @"duration" : @"4" }),
                         new Vex.Flow.TextDynamics({ text: "mp", @"duration" : @"4" }),
                         new Vex.Flow.TextDynamics({ text: "ppp", @"duration" : @"4" }),
                         new Vex.Flow.TextDynamics({ text: "fff", @"duration" : @"4" }),
                         new Vex.Flow.TextDynamics({ text: "mf", @"duration" : @"4" }),
                         new Vex.Flow.TextDynamics({ text: "sff", @"duration" : @"4" })
                         ];

             MNVoice *voice =  [MNVoice voiceWithTimeSignature:MNTime4_4] setStrict:NO];
            [voice addTickables:notes];

            MNFormatter *formatter = [MNFormatter formatter] formatToStaff([voice], staff);

            notes.forEach(function(note) {
                note.setStaff(staff);
                note draw:ctx];
            });

            ok(YES);
        }
        }

        return TextNote;
    })()

    */

    return ret;
}

@end
