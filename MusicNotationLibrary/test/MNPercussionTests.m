//
//  MNPercussionTests.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Mike Corrigan 2012 <corrigan@gmail.com>
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

#import "MNPercussionTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNPercussionTests

- (void)start
{
    [super start];
    float w = 600, h = 150;
    [self runTest:@"Percussion Clef" func:@selector(draw:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Notes" func:@selector(drawNotes:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Basic0" func:@selector(drawBasic0:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Basic1" func:@selector(drawBasic1:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Basic2" func:@selector(drawBasic2:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Snare0" func:@selector(drawSnare0:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Snare1" func:@selector(drawSnare1:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Snare2" func:@selector(drawSnare2:withTitle:) frame:CGRectMake(10, 10, w, h)];
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

- (void)runBoth
{
    /*
    Vex.Flow.Test.Percussion.runBoth = function(title, func) {
        Vex.Flow.Test.runTests(title, func);

    }
     */
}

- (void)newModifier
{
    /*
    Vex.Flow.Test.Percussion.newModifier = function(s) {
        return new Vex.Flow.Annotation(s).setFont(@"Arial", 12)
        .setVerticalJustification(Vex.Flow.Annotation.VerticalJustify.BOTTOM);
    }
     */
}

- (void)newArticulation
{
    /*
    Vex.Flow.Test.Percussion.newArticulation = function(s) {
        return new Vex.Flow.Articulation(s).setPosition(MNPositionAbove);
    }
     */
}

- (void)newTremolo
{
    /*
    Vex.Flow.Test.Percussion.newTremolo = function(s) {
        return new Vex.Flow.Tremolo(s);
    }
     */
}

- (MNTestTuple*)draw:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Percussion.draw = function(options, contextBuilder) {
        var ctx = new contextBuilder(options.canvas_sel, 400, 120);

         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 300);
        staff addClefWithName:@"percussion");

        [staff draw:ctx];

        ok(YES, @"");
    }
     */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 300, 0)];
      [staff setBegBarType:MNBarLineRepeatBegin];
      [staff setEndBarType:MNBarLineSingle];
      [staff addClefWithName:@"percussion"];
      [staff draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

- (void)showNote
{
    /*
    Vex.Flow.Test.Percussion.showNote = function(note_struct, staff, ctx, x) {
        var note = [[MNStaffNote alloc]initWithDictionary:(note_struct);
         MNTickContext *tickContext = [[MNTickContext alloc]init];
        [tickContext addTickable:note] preFormat].x = x).setPixelsUsed(20);
        note.staff = staff;
        [note draw:ctx]
        return note;
    }
     */
}

- (MNTestTuple*)drawNotes:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Percussion.drawNotes = function(options, contextBuilder) {
        NSArray *notes = @[
                     @{ @"keys" : @[@"g/5/d0"], @"duration" : @"q"},
                     @{ @"keys" : @[@"g/5/d1"], @"duration" : @"q"},
                     @{ @"keys" : @[@"g/5/d2"], @"duration" : @"q"},
                     @{ @"keys" : @[@"g/5/d3"], @"duration" : @"q"},
                     @{ @"keys" : @[@"x/"], @"duration" : @"w"},

                     @{ @"keys" : @[@"g/5/t0"], @"duration" : @"w"},
                     @{ @"keys" : @[@"g/5/t1"], @"duration" : @"q"},
                     @{ @"keys" : @[@"g/5/t2"], @"duration" : @"q"},
                     @{ @"keys" : @[@"g/5/t3"], @"duration" : @"q"},
                     @{ @"keys" : @[@"x/"], @"duration" : @"w"},

                     @{ @"keys" : @[@"g/5/x0"], @"duration" : @"w"},
                     @{ @"keys" : @[@"g/5/x1"], @"duration" : @"q"},
                     @{ @"keys" : @[@"g/5/x2"], @"duration" : @"q"},
                     @{ @"keys" : @[@"g/5/x3"], @"duration" : @"q"}
                     ];
        expect(notes.length * 4);

        var ctx = new contextBuilder(options.canvas_sel,
                                     notes.length * 25 + 100, 240);

        // Draw two staffs, one with up-stems and one with down-stems.
        for (var h = 0; h < 2; ++h) {
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10 + h * 120, notes.length * 25 + 75);
            staff addClefWithName:@"percussion");

            [staff draw:ctx];

            var showNote = Vex.Flow.Test.Percussion.showNote;

            for (var i = 0; i < notes.length; ++i) {
                var note = notes[i];
                note.stem_direction = (h == 0 ? -1 : 1);
                 MNStaff *staffNote = showNote(note, staff, ctx, (i + 1) * 25);

                ok(staffNote.getX() > 0, "Note " + i + " has X value");
                ok(staffNote.getYs().length > 0, "Note " + i + " has Y values");
            }
        }
    }
     */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 280, 0)];
      [staff addClefWithName:@"percussion"];
      [staff draw:ctx];

      //        NSUInteger i = notes.count * 4;
      //        expect(i);

      ok(YES, @"");
    };
    return ret;
}

- (MNTestTuple*)drawBasic0:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Percussion.drawBasic0 = function(options, contextBuilder) {
        var ctx = contextBuilder(options.canvas_sel, 500, 120);
        ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.setFont(@"Arial", 15, "");
         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 420);
        staff addClefWithName:@"percussion");

        [staff draw:ctx];

        NSArray* notesUp = @[
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" })
                   ];
         MNBeam* beamUp = [MNBeam beamWithNotes:notesUp.slice(0,8));
         MNVoice* voiceUp = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
            resolution: kRESOLUTION });
        voiceUp.addTickables(notesUp);

        notesDown = [
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"8",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"8",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5", @"d/4/x2"], @"duration" : @"q",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"8",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"8",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5", @"d/4/x2"], @"duration" : @"q",
            stem_direction: -1 })
                     ];
         MNBeam* beamDown1 = [MNBeam beamWithNotes:notesDown.slice(0,2));
         MNBeam* beamDown2 = [MNBeam beamWithNotes:notesDown.slice(3,6));
         MNVoice* voiceDown = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
            resolution: kRESOLUTION });
        voiceDown.addTickables(notesDown);

        MNFormatter *formatter = [MNFormatter formatter] joinVoices:@[voiceUp, voiceDown]).
        formatToStaff([voiceUp, voiceDown], staff);

        voiceUp.draw(ctx, staff);
        voiceDown.draw(ctx, staff);

        [beamUp draw:ctx];
        beamDown1 draw:ctx];
        beamDown2 draw:ctx];

        ok(YES, @"");
    }
     */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 420, 0)];
      [staff addClefWithName:@"percussion"];
      [staff draw:ctx];

      //      NSArray* notesUp = @[
      //          [[MNStaffNote alloc] initWithDictionary:@{
      //              @"keys" : @[ @"g/5/x2" ],
      //              @"duration" : @"8"
      //          }],
      //          [[MNStaffNote alloc] initWithDictionary:@{
      //              @"keys" : @[ @"g/5/x2" ],
      //              @"duration" : @"8"
      //          }],
      //          [[MNStaffNote alloc] initWithDictionary:@{
      //              @"keys" : @[ @"g/5/x2" ],
      //              @"duration" : @"8"
      //          }],
      //          [[MNStaffNote alloc] initWithDictionary:@{
      //              @"keys" : @[ @"g/5/x2" ],
      //              @"duration" : @"8"
      //          }],
      //          [[MNStaffNote alloc] initWithDictionary:@{
      //              @"keys" : @[ @"g/5/x2" ],
      //              @"duration" : @"8"
      //          }],
      //          [[MNStaffNote alloc] initWithDictionary:@{
      //              @"keys" : @[ @"g/5/x2" ],
      //              @"duration" : @"8"
      //          }],
      //          [[MNStaffNote alloc] initWithDictionary:@{
      //              @"keys" : @[ @"g/5/x2" ],
      //              @"duration" : @"8"
      //          }],
      //          [[MNStaffNote alloc] initWithDictionary:@{
      //              @"keys" : @[ @"g/5/x2" ],
      //              @"duration" : @"8"
      //          }]
      //      ];

      ok(YES, @"");
    };
    return ret;
}

- (MNTestTuple*)drawBasic1:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Percussion.drawBasic1 = function(options, contextBuilder) {
        var ctx = contextBuilder(options.canvas_sel, 500, 120);
        ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.setFont(@"Arial", 15, "");
         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 420);
        staff addClefWithName:@"percussion");

        [staff draw:ctx];

        NSArray* notesUp = @[
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/5/x2"], @"duration" : @"q" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/5/x2"], @"duration" : @"q" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/5/x2"], @"duration" : @"q" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/5/x2"], @"duration" : @"q" })
                   ];
         MNVoice* voiceUp = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
            resolution: kRESOLUTION });
        voiceUp.addTickables(notesUp);

        notesDown = [
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"q",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5", @"d/4/x2"], @"duration" : @"q",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"q",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5", @"d/4/x2"], @"duration" : @"q",
            stem_direction: -1 })
                     ];
         MNVoice* voiceDown = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
            resolution: kRESOLUTION });
        voiceDown.addTickables(notesDown);

        MNFormatter *formatter = [MNFormatter formatter] joinVoices:@[voiceUp, voiceDown]).
        formatToStaff([voiceUp, voiceDown], staff);

        voiceUp.draw(ctx, staff);
        voiceDown.draw(ctx, staff);

        ok(YES, @"");
    }
     */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 420, 0)];
      [staff addClefWithName:@"percussion"];
      [staff draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

- (MNTestTuple*)drawBasic2:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Percussion.drawBasic2 = function(options, contextBuilder) {
        var ctx = contextBuilder(options.canvas_sel, 500, 120);
        ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.setFont(@"Arial", 15, "");
         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 420);
        staff addClefWithName:@"percussion");

        [staff draw:ctx];

        NSArray* notesUp = @[
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"a/5/x3"], @"duration" : @"8" }).
                   addModifier(0, (new Vex.Flow.Annotation(@"<")).setFont()),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" }),
                   [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"8" })
                   ];
         MNBeam* beamUp = [MNBeam beamWithNotes:notesUp.slice(1,8));
         MNVoice* voiceUp = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
            resolution: kRESOLUTION });
        voiceUp.addTickables(notesUp);

        notesDown = [
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"8",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"8",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5", @"d/4/x2"], @"duration" : @"q",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"f/4"], @"duration" : @"q",
            stem_direction: -1 }),
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5", @"d/4/x2"], @"duration" : @"8d",
            stem_direction: -1 }) addDotToAll],
                     [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"16",
            stem_direction: -1 })
                     ];
         MNBeam* beamDown1 = [MNBeam beamWithNotes:notesDown.slice(0,2));
         MNBeam* beamDown2 = [MNBeam beamWithNotes:notesDown.slice(4,6));
         MNVoice* voiceDown = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
            resolution: kRESOLUTION });
        voiceDown.addTickables(notesDown);

        MNFormatter *formatter = [MNFormatter formatter] joinVoices:@[voiceUp, voiceDown]).
        formatToStaff([voiceUp, voiceDown], staff);

        voiceUp.draw(ctx, staff);
        voiceDown.draw(ctx, staff);

        [beamUp draw:ctx];
        beamDown1 draw:ctx];
        beamDown2 draw:ctx];

        ok(YES, @"");
    }
     */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 420, 0)];
      [staff addClefWithName:@"percussion"];
      [staff draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

- (MNTestTuple*)drawSnare0:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Percussion.drawSnare0 = function(options, contextBuilder) {
        var ctx = contextBuilder(options.canvas_sel, 600, 120);
        ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.setFont(@"Arial", 15, "");

        x = 10;
        y = 10;
        w = 280;

        {
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(x, y, w);
            staff setBegBarType:Vex.Flow.Barline.type.REPEAT_BEGIN);
            staff setEndBarType:Vex.Flow.Barline.type.SINGLE);
            staff addClefWithName:@"percussion");

            [staff draw:ctx];

            NSArray* notesDown = @[
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newArticulation(@"a>")).
                         addModifier(0  func:@selector(newModifier(@"L")),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addModifier(0  func:@selector(newModifier(@"R")),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addModifier(0  func:@selector(newModifier(@"L")),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addModifier(0  func:@selector(newModifier(@"L"))
                         ];
             MNVoice* voiceDown = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
                resolution: kRESOLUTION });
            voiceDown.addTickables(notesDown);

            MNFormatter *formatter = [MNFormatter formatter]
            joinVoices([voiceDown]).formatToStaff([voiceDown], staff);

            voiceDown.draw(ctx, staff);

            x += staff.width;
        }

        {
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(x, y, w);
            staff setBegBarType:Vex.Flow.Barline.type.NONE);
            staff setEndBarType:Vex.Flow.Barline.type.REPEAT_END);

            [staff draw:ctx];

            NSArray* notesDown = @[
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newArticulation(@"a>")).
                         addModifier(0  func:@selector(newModifier(@"R")),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addModifier(0  func:@selector(newModifier(@"L")),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addModifier(0  func:@selector(newModifier(@"R")),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addModifier(0  func:@selector(newModifier(@"R"))
                         ];
             MNVoice* voiceDown = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
                resolution: kRESOLUTION });
            voiceDown.addTickables(notesDown);

            MNFormatter *formatter = [MNFormatter formatter]
            joinVoices([voiceDown]).formatToStaff([voiceDown], staff);

            voiceDown.draw(ctx, staff);

            x += staff.width;
        }

        ok(YES, @"");
    }
     */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 280, 0)];
      [staff setBegBarType:MNBarLineRepeatBegin];
      [staff setEndBarType:MNBarLineSingle];
      [staff addClefWithName:@"percussion"];
      [staff draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

- (MNTestTuple*)drawSnare1:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Percussion.drawSnare1 = function(options, contextBuilder) {
        var ctx = contextBuilder(options.canvas_sel, 600, 120);
        ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.setFont(@"Arial", 15, "");

        x = 10;
        y = 10;
        w = 280;

        {
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(x, y, w);
            staff setBegBarType:Vex.Flow.Barline.type.REPEAT_BEGIN);
            staff setEndBarType:Vex.Flow.Barline.type.SINGLE);
            staff addClefWithName:@"percussion");

            [staff draw:ctx];

            NSArray* notesDown = @[
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newArticulation(@"ah")),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"q",
                stem_direction: -1 }),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"g/5/x2"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newArticulation(@"ah")),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"a/5/x3"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newArticulation(@"a,")),
                         ];
             MNVoice* voiceDown = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
                resolution: kRESOLUTION });
            voiceDown.addTickables(notesDown);

            MNFormatter *formatter = [MNFormatter formatter]
            joinVoices([voiceDown]).formatToStaff([voiceDown], staff);

            voiceDown.draw(ctx, staff);

            x += staff.width;
        }

        ok(YES, @"");
    }
     */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 280, 0)];
      [staff setBegBarType:MNBarLineRepeatBegin];
      [staff setEndBarType:MNBarLineSingle];
      [staff addClefWithName:@"percussion"];
      [staff draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

- (MNTestTuple*)drawSnare2:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.Percussion.drawSnare2 = function(options, contextBuilder) {
        var ctx = contextBuilder(options.canvas_sel, 600, 120);
        ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.setFont(@"Arial", 15, "");

        x = 10;
        y = 10;
        w = 280;

        {
             MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(x, y, w);
            staff setBegBarType:Vex.Flow.Barline.type.REPEAT_BEGIN);
            staff setEndBarType:Vex.Flow.Barline.type.SINGLE);
            staff addClefWithName:@"percussion");

            [staff draw:ctx];

            NSArray* notesDown = @[
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newTremolo(0)),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newTremolo(1)),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newTremolo(3)),
                         [[MNStaffNote alloc]initWithDictionary:@{ @"keys" : @[@"c/5"], @"duration" : @"q",
                stem_direction: -1 }).
                         addArticulation(0  func:@selector(newTremolo(5)),
                         ];
             MNVoice* voiceDown = new Vex.Flow.Voice({ num_beats: 4, beat_value: 4,
                resolution: kRESOLUTION });
            voiceDown.addTickables(notesDown);

            MNFormatter *formatter = [MNFormatter formatter]
            joinVoices([voiceDown]).formatToStaff([voiceDown], staff);

            voiceDown.draw(ctx, staff);

            x += staff.width;
        }

        ok(YES, @"");
    }
    */

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 280, 0)];
      [staff setBegBarType:MNBarLineRepeatBegin];
      [staff setEndBarType:MNBarLineSingle];
      [staff addClefWithName:@"percussion"];
      [staff draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

@end
