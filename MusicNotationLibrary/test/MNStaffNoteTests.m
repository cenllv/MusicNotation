//
//  MNStaffNoteTests.m
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

#import "MNStaffNoteTests.h"
#import "MNStaffNote.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
#pragma clang diagnostic ignored "-Wconversion"

@implementation MNStaffNoteTests

- (void)start
{
    [super start];

    //    [self runTest:@"Tick" func:@selector(ticks)];
    //    [self runTest:@"Tick" func:@selector(ticksNewApi)];
    //    [self runTest:@"Stem" func:@selector(stem)];
    //    [self runTest:@"Automatic" func:@selector(autoStem)];
    //    [self runTest:@"Staffline" func:@selector(staffLine)];
    //    [self runTest:@"Width" func:@selector(width)];
    //    [self runTest:@"TickContext" func:@selector(tickContext)];

    [self runTest:@"StaffNote Draw - Treble"
             func:@selector(draw:options:)
            frame:CGRectMake(0, 0, 800, 180)
           params:@{
               @"clef" : @"treble",
               @"octaveShift" : @(0),
               @"restKey" : @"r/4"
           }];

    [self runTest:@"StaffNote BoundingBoxes - Treble"
             func:@selector(drawBoundingBoxes:options:)
            frame:CGRectMake(0, 0, 800, 180)
           params:@{
               @"clef" : @"treble",
               @"octaveShift" : @(0),
               @"restKey" : @"r/4"
           }];

    [self runTest:@"StaffNote Draw - Alto"
             func:@selector(draw:options:)
            frame:CGRectMake(0, 0, 800, 180)
           params:@{
               @"clef" : @"alto",
               @"octaveShift" : @(-1),
               @"restKey" : @"r/4"
           }];

    [self runTest:@"StaffNote Draw - Tenor"
             func:@selector(draw:options:)
            frame:CGRectMake(0, 0, 800, 180)
           params:@{
               @"clef" : @"tenor",
               @"octaveShift" : @(-1),
               @"restKey" : @"r/3"
           }];

    [self runTest:@"StaffNote Draw - Bass"
             func:@selector(draw:options:)
            frame:CGRectMake(0, 0, 800, 180)
           params:@{
               @"clef" : @"bass",
               @"octaveShift" : @(-2),
               @"restKey" : @"r/3"
           }];

    [self runTest:@"StaffNote Draw - Harmonic And Muted"
             func:@selector(drawHarmonicAndMuted:)
            frame:CGRectMake(0, 0, 800, 180)];

    [self runTest:@"StaffNote Draw - Slash" func:@selector(drawSlash:) frame:CGRectMake(0, 0, 800, 180)];

    [self runTest:@"Displacements" func:@selector(drawDisplacements:) frame:CGRectMake(0, 0, 800, 180)];

    [self runTest:@"StaffNote Draw - Bass" func:@selector(drawBass:) frame:CGRectMake(0, 0, 800, 180)];

    [self runTest:@"StaffNote Draw - Key Styles" func:@selector(drawKeyStyles:) frame:CGRectMake(0, 0, 600, 180)];

    [self runTest:@"StaffNote Draw - StaffNote Styles"
             func:@selector(drawNoteStyles:)
            frame:CGRectMake(0, 0, 600, 180)];

    [self runTest:@"Flag and Dot Placement - Stem Up"
             func:@selector(drawDotsAndFlagsStemUp:)
            frame:CGRectMake(0, 0, 1000, 180)];

    [self runTest:@"Flag and Dots Placement - Stem Down"
             func:@selector(drawDotsAndFlagsStemDown:)
            frame:CGRectMake(0, 0, 1000, 180)];

    [self runTest:@"Beam and Dot Placement - Stem Up"
             func:@selector(drawDotsAndBeamsUp:)
            frame:CGRectMake(0, 0, 1000, 180)];

    [self runTest:@"Beam and Dot Placement - Stem Down"
             func:@selector(drawDotsAndBeamsDown:)
            frame:CGRectMake(10, 10, 700, 180)];

    [self runTest:@"Center Aligned Note" func:@selector(drawCenterAlignedRest:) frame:CGRectMake(0, 0, 500, 150)];
    [self runTest:@"Center Aligned Note with Articulation"
             func:@selector(drawCenterAlignedRestFermata:)
            frame:CGRectMake(0, 0, 500, 150)];
    [self runTest:@"Center Aligned Note with Annotation"
             func:@selector(drawCenterAlignedRestAnnotation:)
            frame:CGRectMake(0, 0, 500, 150)];

    [self runTest:@"Center Aligned Note with Multiple Modifiers"
             func:@selector(drawCenterAlignedNoteMultiModifiers:)
            frame:CGRectMake(0, 0, 500, 150)];
    [self runTest:@"Center Aligned Note - Multi Voice"
             func:@selector(drawCenterAlignedMultiVoice:)
            frame:CGRectMake(0, 0, 500, 150)];
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

// TODO: move comments to NSLog

- (void)ticks
{
    MNLogInfo(@"");
    float BEAT = 1 * kRESOLUTION / 4;

    MNStaffNote* note;

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"1/2"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 8));   //, @"Breve note has 8 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                       //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"w"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 4));   //, @"Whole note has 4 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                       //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"q"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT));   //, @"Quarter note has 1 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                   //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"hd"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3));   //, @"Dotted half note has 3 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                       //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"hdd"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.5));   //, @"Double-dotted half note has 3.5 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                         //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"hddd"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.75));   //, @"Triple-dotted half note has 3.75
                                                                         //    beats");
    assertThat(note.noteNHMRSString, is(@"n"));                          //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"hdr"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3));   //, @"Dotted half rest has 3 beats");
    assertThat(note.noteNHMRSString, is(@"r"));                       //, @"Note type is 'r' for rest");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"hddr"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.5));   //, @"Double-dotted half rest has 3.5 beats");
    assertThat(note.noteNHMRSString, is(@"r"));                         //, @"Note type is 'r' for rest");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"hdddr"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.75));   //, @"Triple-dotted half rest has 3.75
                                                                         //    beats");
    assertThat(note.noteNHMRSString, is(@"r"));                          //, @"Note type is 'r' for rest");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"qdh"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 1.5));   //,
    //          @"Dotted harmonic quarter note has 1.5 beats");
    assertThat(note.noteNHMRSString, is(@"h"));   //, @"Note type is 'h' for harmonic note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"qddh"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 1.75));   //,
    //          @"Double-dotted harmonic quarter note has 1.75 beats");
    assertThat(note.noteNHMRSString, is(@"h"));   //, @"Note type is 'h' for harmonic note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"qdddh"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 1.875));   //,
    //          @"Triple-dotted harmonic quarter note has 1.875 beats");
    assertThat(note.noteNHMRSString, is(@"h"));   //, @"Note type is 'h' for harmonic note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8dm"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 0.75));   //, @"Dotted muted 8th note has 0.75 beats");
    assertThat(note.noteNHMRSString, is(@"m"));                          //, @"Note type is 'm' for muted note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8ddm"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 0.875));   //,
    //          @"Double-dotted muted 8th note has 0.875 beats");
    assertThat(note.noteNHMRSString, is(@"m"));   //, @"Note type is 'm' for muted note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8dddm"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 0.9375));   //,
    //          @"Triple-dotted muted 8th note has 0.9375 beats");
    assertThat(note.noteNHMRSString, is(@"m"));   //, @"Note type is 'm' for muted note");

    //    @try
    //    {
    //        note =  [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8.7dddm"];
    //        //        [NSException raise:@"" format:@""];
    //    }
    //    @catch(NSException* exception)
    //    {
    //        assertThat(exception.reason,
    //                   is(@"BadArguments"));   //, @"Invalid note duration '8.7' throws BadArguments exception"));
    //    }
    //
    //    @try
    //    {
    //        note =  [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"2Z"];
    //        //        [NSException raise:@"" format:@""];
    //    }
    //    @catch(NSException* exception)
    //    {
    //        assertThat(exception.reason,
    //                   is(@"BadArguments"));   //, @"Invalid note type 'Z' throws BadArguments exception");
    //    }
    //
    //    @try
    //    {
    //        note =  [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"2dddZ"];
    //        //        [NSException raise:@"" format:@""];
    //    }
    //    @catch(NSException* exception)
    //    {
    //        assertThat(exception.reason,
    //                   is(@"BadArguments"));   //, @"Invalid note type 'Z' for dotted note throws BadArguments
    //                                           //                   exception");
    //    }
}

- (void)ticksNewApi
{
    MNLogInfo(@"");
    float BEAT = 1 * kRESOLUTION / 4;

    MNStaffNote* note;
    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"1"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 4));   //, @"Whole note has 4 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                       //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"4"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT));   //, @"Quarter note has 1 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                   //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"2" dots:1];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3));   //, @"Dotted half note has 3 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                       //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"hdd" dots:2];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.5));   //, @"Double-dotted half note has 3.5 beats");
    assertThat(note.noteNHMRSString, is(@"n"));                         //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"hddd" dots:3];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.75));   //, @"Triple-dotted half note has 3.75
                                                                         //    beats ");
    assertThat(note.noteNHMRSString, is(@"n"));                          //, @"Note type is 'n' for normal note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"2" dots:1 type:@"r"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3));   //, @"Dotted half rest has 3 beats");
    assertThat(note.noteNHMRSString, is(@"r"));                       //, @"Note type is 'r' for rest");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"2" dots:2 type:@"r"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.5));   //, @"Double-dotted half rest has 3.5 beats");
    assertThat(note.noteNHMRSString, is(@"r"));                         //, @"Note type is 'r' for rest");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"2" dots:3 type:@"r"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.75));   //, @"Triple-dotted half rest has 3.75
                                                                         //    beats ");
    assertThat(note.noteNHMRSString, is(@"r"));                          //, @"Note type is 'r' for rest");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"4" dots:1 type:@"h"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 1.5));   //,
    //          @"Dotted harmonic quarter note has 1.5 beats");
    assertThat(note.noteNHMRSString, is(@"h"));   //, @"Note type is 'h' for harmonic note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"4" dots:2 type:@"h"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 1.75));   //,
    //          @"Double-dotted harmonic quarter note has 1.75 beats");
    assertThat(note.noteNHMRSString, is(@"h"));   //, @"Note type is 'h' for harmonic note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"4" dots:3 type:@"h"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 1.875));   //,
    //          @"Triple-dotted harmonic quarter note has 1.875 beats");
    assertThat(note.noteNHMRSString, is(@"h"));   //, @"Note type is 'h' for harmonic note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8" dots:1 type:@"m"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 0.75));   //, @"Dotted muted 8th note has 0.75 beats");
    assertThat(note.noteNHMRSString, is(@"m"));                          //, @"Note type is 'm' for muted note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8" dots:2 type:@"m"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 0.875));   //,
    //          @"Double-dotted muted 8th note has 0.875 beats");
    assertThat(note.noteNHMRSString, is(@"m"));   //, @"Note type is 'm' for muted note");

    note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8" dots:3 type:@"m"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 0.9375));   //,
    //          @"Triple-dotted muted 8th note has 0.9375 beats");
    assertThat(note.noteNHMRSString, is(@"m"));   //, @"Note type is 'm' for muted note");

    note = [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"1s"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 4));   //; //, @"Whole note has 4 beats");
    assertThat(note.noteNHMRSString, is(@"s"));                       //, @"Note type is 's' for slash note");

    note = [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"4s"];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT));   //, @"Quarter note has 1 beats");
    assertThat(note.noteNHMRSString, is(@"s"));                   //, @"Note type is 's' for slash note");

    note = [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"2s" dots:1];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3));   //, @"Dotted half note has 3 beats");
    assertThat(note.noteNHMRSString, is(@"s"));                       //, @"Note type is 's' for slash note");

    note = [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"2s" dots:2];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.5));   //, @"Double-dotted half note has 3.5 beats");
    assertThat(note.noteNHMRSString, is(@"s"));                         //, @"Note type is 's' for slash note");

    note = [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"2s" dots:3];
    assertThatFloat(note.ticks.floatValue, equalToFloat(BEAT * 3.75));   //,
    //          @"Triple-dotted half note has 3.75 beats");
    assertThat(note.noteNHMRSString, is(@"s"));   //, @"Note type is 's' for slash note");

    //    @try
    //    {
    //        note =  [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8.7"];
    //        [NSException raise:@"" format:@""];
    //    }
    //    @catch(NSException* exception)
    //    {
    //        assertThat(exception.reason, is(@"BadArguments"));   //,
    //        //              @"Invalid note duration '8.7' throws BadArguments exception");
    //    }
    //
    //    @try
    //    {
    //        note =  [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"8" dots:@"three"];
    //        [NSException raise:@"" format:@""];
    //    }
    //    @catch(NSException* exception)
    //    {
    //        assertThat(exception.reason,
    //                   is(@"BadArguments"));   //, @"Invalid note type 'Z' throws BadArguments exception");
    //    }
    //
    //    @try
    //    {
    //        note =  [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"2" dots:@"Z"];
    //        [NSException raise:@"" format:@""];
    //    }
    //    @catch(NSException* exception)
    //    {
    //        assertThat(exception.reason, is(@"BadArguments"));   //,
    //        //              @"Invalid note type 'Z' for dotted note throws BadArguments exception");
    //    }
}

- (void)stem
{
    MNLogInfo(@"");
    MNStaffNote* note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"w"];
    assertThatInt(note.stemDirection, equalToInt(MNStemDirectionUp));   //, @"Default note has UP stem");
}

- (void)autoStem
{
    MNLogInfo(@"");
    MNStaffNote* note = [MNStaffNote noteWithKeys:@[ @"c/5", @"e/5", @"g/5" ] andDuration:@"8" autoStem:YES];
    assertThatInt(note.stemDirection, equalToInt(MNStemDirectionDown));   //, @"Stem must be down");

    note = [MNStaffNote noteWithKeys:@[ @"c/5", @"e/4", @"g/4" ] andDuration:@"8" autoStem:YES];
    assertThatInt(note.stemDirection, equalToInt(MNStemDirectionUp));   //, @"Stem must be up");

    note = [MNStaffNote noteWithKeys:@[ @"c/5" ] andDuration:@"8" autoStem:YES];
    assertThatInt(note.stemDirection, equalToInt(MNStemDirectionUp));   //, @"Stem must be up");

    note = [MNStaffNote noteWithKeys:@[ @"a/4", @"e/5", @"g/5" ] andDuration:@"8" autoStem:YES];
    assertThatInt(note.stemDirection, equalToInt(MNStemDirectionDown));   //, @"Stem must be down");

    note = [MNStaffNote noteWithKeys:@[ @"b/4" ] andDuration:@"8" autoStem:YES];
    assertThatInt(note.stemDirection, equalToInt(MNStemDirectionUp));   //, @"Stem must be up");
}

- (void)staffLine
{
    MNLogInfo(@"");
    MNStaffNote* note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"w"];

    NSArray* props = note.keyProps;
    assertThatFloat(((MNKeyProperty*)props[0]).line, equalToFloat(0.f));
    NSLog(@"C/4 on line 0");

    assertThatFloat(((MNKeyProperty*)props[1]).line, equalToFloat(1.f));
    NSLog(@"E/4 on line 1");

    assertThatFloat(((MNKeyProperty*)props[2]).line, equalToFloat(2.5f));
    NSLog(@"A/4 on line 2.5");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 300, 0)];
    note.staff = staff;

    NSArray* ys = note.ys;
    assertThatUnsignedInt(ys.count, equalToUnsignedInt(3));
    NSLog(@"Chord should be rendered on three lines");
    assertThatFloat([ys[0] floatValue], equalToFloat(100.f));
    NSLog(@"Line for C/4");
    assertThatFloat([ys[1] floatValue], equalToFloat(90.f));
    NSLog(@"Line for E/4");
    assertThatFloat([ys[2] floatValue], equalToFloat(75.f));
    NSLog(@"Line for A/4");
}

/*

    try {
        id width = note.getWidth();
    } catch (e) {
        equal(e.code, @"UnformattedNote",
              @"Unformatted note should have no width");
    }
}
 */

- (void)width
{
    MNLogInfo(@"");
    MNStaffNote* note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"w"];

    @try
    {
        float width = note.width;
    }
    @catch(NSException* e)
    {
        assertThat(e.reason, is(@"UnformattedNote"));
        NSLog(@"Unformatted note should have no width");
    }
}

- (void)tickContext
{
    MNLogInfo(@"");
    MNStaffNote* note = [MNStaffNote noteWithKeys:@[ @"c/4", @"e/4", @"g/4" ] andDuration:@"w"];
    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [tickContext addTickable:note];
    [tickContext preFormat];
    tickContext.x = 10;
    tickContext.padding = 0;
    assertThatFloat(tickContext.width, equalToFloat(75.f));
}

//- (MNStaffNote*)showNote:(NSDictionary*)noteStruct onStaff:(MNStaff*)staff withContext:(CGContextRef)ctx atX:(float)x
//{
//    MNLogInfo(@"");
//    MNStaffNote* ret = [[MNStaffNote alloc] initWithDictionary:noteStruct];
//     MNTickContext* tickContext = [[MNTickContext alloc] init];
//    [[tickContext addTickable:ret] preFormat];
//    tickContext.x = x;
//    tickContext.pixelsUsed = 20;
//    ret.staff = staff;
//    [ret draw:ctx];
//    //    if(drawBoundingBox)
//    //    {
//    //        [note.boundingBox draw:ctx];
//    //    }
//    return ret;
//}
//
//- (MNStaffNote*)showNote:(NSDictionary*)noteStruct
//                 onStaff:(MNStaff*)staff
//             withContext:(CGContextRef)ctx
//                     atX:(float)x
//         withBoundingBox:(BOOL)drawBoundingBox
//{
//    MNLogInfo(@"");
//    MNStaffNote* ret = [[MNStaffNote alloc] initWithDictionary:noteStruct];
//     MNTickContext* tickContext = [[MNTickContext alloc] init];
//    [[tickContext addTickable:ret] preFormat];
//    tickContext.x = x;
//    tickContext.pixelsUsed = 20;
//    ret.staff = staff;
//    [ret draw:ctx];
//    if(drawBoundingBox)
//    {
//        [ret.boundingBox draw:ctx];
//    }
//    return ret;
//}

- (MNTestTuple*)draw:(MNTestCollectionItemView*)parent options:(NSDictionary*)options
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 750, 0)];

    NSString* clefName = (options[@"clef"] != nil ? options[@"clef"] : @"treble");

    NSString* restKey = options[@"restKey"];
    NSUInteger octaveShift = [options[@"octaveShift"] integerValue];

    MNClef* clef = [MNClef clefWithName:clefName];
    //      staff.clef = clef;
    [staff addClef:clef];

    staff.clef = clef;
    //        [staff draw:ctx];

    NSMutableArray* lowerKeys = [@[ @"c/", @"e/", @"a/" ] mutableCopy];
    NSMutableArray* higherKeys = [@[ @"c/", @"e/", @"a/" ] mutableCopy];
    for(int k = 0; k < lowerKeys.count; ++k)
    {
        lowerKeys[k] = [NSString stringWithFormat:@"%@%lu", lowerKeys[k], (4 + octaveShift)];
        higherKeys[k] = [NSString stringWithFormat:@"%@%lu", higherKeys[k], (5 + octaveShift)];
    }

    NSArray* restKeys = @[ restKey ];

    NSArray* notes = @[
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"1/2" },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"w" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"h" },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"q" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"8" },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"16" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"32" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"64" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"128" },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"1/2",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"w",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"h",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"q",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"8",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"16",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"64",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"128",
           @"stem_direction" : @(-1) },

        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"1/2r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"wr" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"hr" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"qr" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"8r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"16r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"32r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"64r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"128r" },
        @{ @"keys" : @[ @"x/4" ],
           @"duration" : @"h" }
    ];

    //      expect(notes.count * 2);   // TODO: does nothing right now

    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      for(int i = 0; i < notes.count; ++i)
      {
          NSDictionary* note = notes[i];
          MNStaffNote* staffNote = [parent showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 25];
          staffNote.staff = staff;

          NSString* descriptionX = [NSString stringWithFormat:@"Note %i has X value", i];
          assertThatInteger(staffNote.x, greaterThan(@(0.f)));
          MNLogInfo(@"%@", descriptionX);
          NSString* descriptionYs = [NSString stringWithFormat:@"Note %i has Y values", i];
          assertThatInteger(staffNote.ys.count, greaterThan(@(0)));
          MNLogInfo(@"%@", descriptionYs);
      }
    };

    return ret;
}

- (MNTestTuple*)drawBoundingBoxes:(MNTestCollectionItemView*)parent options:(NSDictionary*)options
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");



    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 750, 0)];

    NSString* clefName = (options[@"clef"] != nil ? options[@"clef"] : @"treble");

    NSString* restKey = options[@"restKey"];
    NSUInteger octaveShift = [options[@"octaveShift"] integerValue];

    MNClef* clef = [MNClef clefWithName:clefName];
    staff.clef = clef;

    staff.clef = clef;
    //    [staff draw:ctx];

    NSMutableArray* lowerKeys = [@[ @"c/", @"e/", @"a/" ] mutableCopy];
    NSMutableArray* higherKeys = [@[ @"c/", @"e/", @"a/" ] mutableCopy];
    for(int k = 0; k < lowerKeys.count; ++k)
    {
        lowerKeys[k] = [NSString stringWithFormat:@"%@%lu", lowerKeys[k], (4 + octaveShift)];
        higherKeys[k] = [NSString stringWithFormat:@"%@%lu", higherKeys[k], (5 + octaveShift)];
    }

    NSArray* restKeys = @[ restKey ];

    NSArray* notes = @[
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"1/2" },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"w" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"h" },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"q" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"8" },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"16" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"32" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"64" },
        @{ @"clef" : clef,
           @"keys" : higherKeys,
           @"duration" : @"128" },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"1/2",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"w",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"h",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"q",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"8",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"16",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"64",
           @"stem_direction" : @(-1) },
        @{ @"clef" : clef,
           @"keys" : lowerKeys,
           @"duration" : @"128",
           @"stem_direction" : @(-1) },

        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"1/2r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"wr" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"hr" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"qr" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"8r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"16r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"32r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"64r" },
        @{ @"clef" : clef,
           @"keys" : restKeys,
           @"duration" : @"128r" },
        @{ @"keys" : @[ @"x/4" ],
           @"duration" : @"h" }
    ];

    //      expect(notes.count * 2);   // TODO: does nothing right now
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(int i = 0; i < notes.count; ++i)
      {
          NSDictionary* note = [notes objectAtIndex:i];

          MNStaffNote* staffNote =
              [parent showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 25 withBoundingBox:YES];

          NSString* descriptionX = [NSString stringWithFormat:@"Note %i has X value", i];
          assertThatInteger(staffNote.x, greaterThan(@(0.f)));
          MNLogInfo(@"%@", descriptionX);
          NSString* descriptionYs = [NSString stringWithFormat:@"Note %i has Y values", i];
          assertThatInteger(staffNote.ys.count, greaterThan(@(0)));
          MNLogInfo(@"%@", descriptionYs);
      }
    };
    return ret;
}

- (MNTestTuple*)drawBass:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");


    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 650, 0)];
    NSString* clefName = @"bass";
    MNClef* clef = [MNClef clefWithName:clefName];
    staff.clef = clef;

    // NOTE: changed @{ @"clef" -> @{ @"clefName"

    NSArray* notes = @[
        @{ @"clefName" : @"bass",
           @"keys" : @[ @"c/3", @"e/3", @"a/3" ],
           @"duration" : @"1/2" },
        @{ @"clefName" : @"bass",
           @"keys" : @[ @"c/2", @"e/2", @"a/2" ],
           @"duration" : @"w" },
        @{ @"clefName" : @"bass",
           @"keys" : @[ @"c/3", @"e/3", @"a/3" ],
           @"duration" : @"h" },
        @{ @"clefName" : @"bass",
           @"keys" : @[ @"c/2", @"e/2", @"a/2" ],
           @"duration" : @"q" },
        @{ @"clefName" : @"bass",
           @"keys" : @[ @"c/3", @"e/3", @"a/3" ],
           @"duration" : @"8" },
        @{ @"clefName" : @"bass",
           @"keys" : @[ @"c/2", @"e/2", @"a/2" ],
           @"duration" : @"16" },
        @{ @"clefName" : @"bass",
           @"keys" : @[ @"c/3", @"e/3", @"a/3" ],
           @"duration" : @"32" },
        @{
            @"clefName" : @"bass",
            @"keys" : @[ @"c/2", @"e/2", @"a/2" ],
            @"duration" : @"h",
            @"stem_direction" : @(-1)
        },
        @{
            @"clefName" : @"bass",
            @"keys" : @[ @"c/2", @"e/2", @"a/2" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        },
        @{
            @"clefName" : @"bass",
            @"keys" : @[ @"c/2", @"e/2", @"a/2" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1)
        },
        @{
            @"clefName" : @"bass",
            @"keys" : @[ @"c/2", @"e/2", @"a/2" ],
            @"duration" : @"16",
            @"stem_direction" : @(-1)
        },
        @{
            @"clefName" : @"bass",
            @"keys" : @[ @"c/2", @"e/2", @"a/2" ],
            @"duration" : @"32",
            @"stem_direction" : @(-1)
        },

        @{ @"keys" : @[ @"r/4" ],
           @"duration" : @"1/2r" },
        @{ @"keys" : @[ @"r/4" ],
           @"duration" : @"wr" },
        @{ @"keys" : @[ @"r/4" ],
           @"duration" : @"hr" },
        @{ @"keys" : @[ @"r/4" ],
           @"duration" : @"qr" },
        @{ @"keys" : @[ @"r/4" ],
           @"duration" : @"8r" },
        @{ @"keys" : @[ @"r/4" ],
           @"duration" : @"16r" },
        @{ @"keys" : @[ @"r/4" ],
           @"duration" : @"32r" },
        @{ @"keys" : @[ @"x/4" ],
           @"duration" : @"h" }
    ];

    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(int i = 0; i < notes.count; ++i)
      {
          NSDictionary* note = notes[i];
          MNStaffNote* staffNote = [parent showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 30];
          staffNote.staff = staff;
          assertThatInteger(staffNote.x, greaterThan(@(0.f)));
          MNLogInfo(@"Note %i %@", i, @" has X value");
          assertThatInteger(staffNote.ys.count, greaterThan(@(0)));
          MNLogInfo(@"Note %i %@", i, @" has Y values");
      }
    };
    return ret;
}

- (MNTestTuple*)drawDisplacements:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 650, 0)];

    //    [staff draw:ctx];

    NSArray* notes = @[
        @{ @"keys" : @[ @"g/3", @"a/3", @"c/4", @"d/4", @"e/4" ],
           @"duration" : @"1/2" },
        @{ @"keys" : @[ @"g/3", @"a/3", @"c/4", @"d/4", @"e/4" ],
           @"duration" : @"w" },
        @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
           @"duration" : @"h" },
        @{ @"keys" : @[ @"f/4", @"g/4", @"a/4", @"b/4" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"e/3", @"b/3", @"c/4", @"e/4", @"f/4", @"g/5", @"a/5" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"a/3", @"c/4", @"e/4", @"g/4", @"a/4", @"b/4" ],
           @"duration" : @"16" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"32" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4", @"a/4" ],
           @"duration" : @"64" },
        @{ @"keys" : @[ @"g/3", @"c/4", @"d/4", @"e/4" ],
           @"duration" : @"h",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
           @"duration" : @"q",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"f/4", @"g/4", @"a/4", @"b/4" ],
           @"duration" : @"8",
           @"stem_direction" : @(-1) },
        @{
            @"keys" : @[ @"c/4", @"d/4", @"e/4", @"f/4", @"g/4", @"a/4" ],
            @"duration" : @"16",
            @"stem_direction" : @(-1)
        },
        @{
            @"keys" : @[ @"b/3", @"c/4", @"e/4", @"a/4", @"b/5", @"c/6", @"e/6" ],
            @"duration" : @"32",
            @"stem_direction" : @(-1)
        },
        @{
            @"keys" : @[ @"b/3", @"c/4", @"e/4", @"a/4", @"b/5", @"c/6", @"e/6", @"e/6" ],
            @"duration" : @"64",
            @"stem_direction" : @(-1)
        }
    ];
    //      expect(notes.count * 2);
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(int i = 0; i < notes.count; ++i)
      {
          NSDictionary* note = notes[i];
          MNStaffNote* staffNote = [parent showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 45];
          // showNote(note, Staff, ctx, (i + 1) * 45);
          staffNote.staff = staff;
          assertThatInteger(staffNote.x, greaterThan(@(0.f)));
          MNLogInfo(@"Note %i %@", i, @" has X value");
          assertThatInteger(staffNote.ys.count, greaterThan(@(0)));
          MNLogInfo(@"Note %i %@", i, @" has Y values");
      }
    };
    return ret;
}

- (MNTestTuple*)drawHarmonicAndMuted:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 280, 0)];

    //        [staff draw:ctx];

    NSArray* notes = @[
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"1/2h" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"wh" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"hh" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"qh" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"8h" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"16h" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"32h" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"64h" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"128h" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"1/2h",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"wh",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"hh",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"qh",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"8h",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"16h",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"32h",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"64h",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"128h",
           @"stem_direction" : @(-1) },

        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"1/2m" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"wm" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"hm" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"qm" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"8m" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"16m" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"32m" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"64m" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"128m" },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"1/2m",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"wm",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"hm",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"qm",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"8m",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"16m",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"32m",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"64m",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"128m",
           @"stem_direction" : @(-1) }
    ];
    //      expect(notes.count * 2);
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(int i = 0; i < notes.count; ++i)
      {
          NSDictionary* note = notes[i];
          //         MNStaffNote *staffNote = showNote(note, Staff, ctx, (i + 1) * 25);
          MNStaffNote* staffNote = [parent showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 25];
          staffNote.staff = staff;
          assertThatInteger(staffNote.x, greaterThan(@(0.f)));
          MNLogInfo(@"Note %i %@", i, @" has X value");
          assertThatInteger(staffNote.ys.count, greaterThan(@(0)));
          MNLogInfo(@"Note %i %@", i, @" has Y values");
      }
    };
    return ret;
}

- (MNTestTuple*)drawSlash:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 650, 0)];

    NSArray* notes = @[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"1/2s",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"ws",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"hs",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"qs",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8s",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"16s",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"32s",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"64s",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"128s",
           @"stem_direction" : @(-1) },

        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"1/2s",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"ws",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"hs",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"qs",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8s",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"16s",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"32s",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"64s",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"128s",
           @"stem_direction" : @(1) },

        // Beam
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8s",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8s",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8s",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8s",
           @"stem_direction" : @(1) }
    ];

    NSArray* Staff_notes = [notes oct_map:^MNStaffNote*(NSDictionary* d) {
      MNStaffNote* ret = [[MNStaffNote alloc] initWithDictionary:d];
      ret.staff = staff;
      return ret;
    }];

    MNBeam* beam1 = [MNBeam beamWithNotes:@[ Staff_notes[16], Staff_notes[17] ]];
    MNBeam* beam2 = [MNBeam beamWithNotes:@[ Staff_notes[18], Staff_notes[19] ]];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:Staff_notes];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.staves addObject:staff];
    [ret.beams addObject:@[ beam1, beam2 ]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [beam1 draw:ctx];
      //      [beam2 draw:ctx];
      ok(YES, @"Slash Note Heads");
    };

    return ret;
}

- (MNTestTuple*)drawKeyStyles:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(50, 50, 100, 0)];

    //        [staff draw:ctx];
    NSDictionary* note_struct = @{ @"keys" : @[ @"g/4", @"bb/4", @"d/5" ], @"duration" : @"q" };
    MNStaffNote* note = [[MNStaffNote alloc] initWithDictionary:note_struct];
    [note addAccidental:[MNAccidental accidentalWithType:@"b"] atIndex:1];
    note.styleBlock = ^(CGContextRef ctx) {
      //(1, {shadowBlur:15, shadowColor:'blue', fillStyle:'blue'});
      ////https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadows/dq_shadows.html#//apple_ref/doc/uid/TP30001066-CH208-TPXREF101
      CGSize myShadowOffset = CGSizeMake(1, 1);   // 2
      CGFloat myColorValues[] = {0, 0, 1, .6};    // 3
      CGColorRef myColor;                         // 4
      CGColorSpaceRef myColorSpace;               // 5

      //                  CGContextSaveGState(ctx);// 6

      CGContextSetShadow(ctx, myShadowOffset, 15);   // <--- 3rd arg is blur value
      // Your drawing code here// 8
      CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
      CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
      //                  CGContextFillRect (ctx, CGRectMake (wd/3 + 75, ht/2 , wd/4, ht/4));
      //
      myColorSpace = CGColorSpaceCreateDeviceRGB();                    // 9
      myColor = CGColorCreate(myColorSpace, myColorValues);            // 10
      CGContextSetShadowWithColor(ctx, myShadowOffset, 15, myColor);   // 11
      // Your drawing code here// 12
      //                  CGContextSetRGBFillColor (ctx, 0, 0, 1, 1);
      //                  CGContextFillRect (ctx, CGRectMake (wd/3-75,ht/2-100,wd/4,ht/4));

      CGColorRelease(myColor);             // 13
      CGColorSpaceRelease(myColorSpace);   // 14
                                           //
                                           //                  CGContextRestoreGState(ctx);
    };

    //    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      MNTickContext* tickContext = [[MNTickContext alloc] init];
      [[tickContext addTickable:note] preFormat];
      tickContext.x = 25;
      tickContext.pointsUsed = 20;
      note.staff = staff;
      [note draw:ctx];

      ok(note.x > 0, @"Note has X value");
      ok(note.ys.count > 0, @"Note has Y values");
    };
    return ret;
}

- (MNTestTuple*)drawNoteStyles:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(50, 50, 100, 0)];

    //    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      NSDictionary* note_struct = @{ @"keys" : @[ @"g/4", @"bb/4", @"d/5" ], @"duration" : @"q" };
      MNStaffNote* note = [[MNStaffNote alloc] initWithDictionary:note_struct];
      [note addAccidental:[MNAccidental accidentalWithType:@"b"] atIndex:1];
      note.styleBlock = ^(CGContextRef ctx) {
        // note.setStyle(@{shadowBlur:15, shadowColor:'blue', fillStyle:'blue', strokeStyle:'blue'});
      };
      MNTickContext* tickContext = [[MNTickContext alloc] init];
      [[tickContext addTickable:note] preFormat];
      tickContext.x = 25;
      tickContext.pointsUsed = 20;
      note.staff = staff;
      [note draw:ctx];

      ok(note.x > 0, @"Note has X value");
      ok(note.ys.count > 0, @"Note has Y values");
    };
    return ret;
}

+ (MNStaffNote*)renderNote:(MNTestCollectionItemView*)parent
                      note:(MNStaffNote*)note
                     staff:(MNStaff*)staff
               withContext:(CGContextRef)ctx
                       atX:(float)x
{
    MNLogInfo(@"");
    MNModifierContext* mc = [MNModifierContext modifierContext];
    [note addToModifierContext:mc];
    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:note] preFormat];
    tickContext.x = x;
    tickContext.pointsUsed = 65;
    note.staff = staff;
    [note draw:ctx];
    return note;
}

- (MNTestTuple*)drawDotsAndFlagsStemUp:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");


    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 975, 0)];

    //        [staff draw:ctx];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    MNDot* (^newAcc)(NSString*) = ^MNDot*(NSString* type)
    {
        return [MNDot dotWithType:type];
    };

    NSArray* notes = @[
        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"4",
               @"stem_direction" : @(1) }) addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"8",
               @"stem_direction" : @(1) }) addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }) addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"32",
               @"stem_direction" : @(1) }) addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"64",
               @"stem_direction" : @(1) }) addDotToAll],
        [[newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"128",
               @"stem_direction" : @(1) }) addDotToAll] addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"4",
               @"stem_direction" : @(1) }) addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8",
               @"stem_direction" : @(1) }) addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }) addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"32" }) addDotToAll],
        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"64",
               @"stem_direction" : @(1) }) addDotToAll],
        [[newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"128",
               @"stem_direction" : @(1) }) addDotToAll] addDotToAll]
    ];

    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [notes foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [[self class] renderNote:parent note:note staff:staff withContext:ctx atX:(i + 1) * 50];
      }];
    };
    return ret;
}

- (MNTestTuple*)drawDotsAndFlagsStemDown:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 975, 0)];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    MNDot* (^newAcc)(NSString*) = ^MNDot*(NSString* type)
    {
        return [MNDot dotWithType:type];
    };

    NSArray* notes = @[
        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"4",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"8",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"32",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"64",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"128",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"4",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"32",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"64",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"128",
               @"stem_direction" : @(-1) }) addDotToAll]
    ];

    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [notes foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [[self class] renderNote:parent note:note staff:staff withContext:ctx atX:(i + 1) * 50];
      }];
      ok(YES, @"Full Dot");
    };
    return ret;
}

- (MNTestTuple*)drawDotsAndBeamsUp:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");
    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 975, 0)];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    MNDot* (^newAcc)(NSString*) = ^MNDot*(NSString* type)
    {
        return [MNDot dotWithType:type];
    };

    NSArray* notes = @[
        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"8",
               @"stem_direction" : @(1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"32",
               @"stem_direction" : @(1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"64",
               @"stem_direction" : @(1) }) addDotToAll],

        [[newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"128",
               @"stem_direction" : @(1) }) addDotToAll] addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8",
               @"stem_direction" : @(1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"32" }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"64",
               @"stem_direction" : @(1) }) addDotToAll],

        [[newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"128",
               @"stem_direction" : @(1) }) addDotToAll] addDotToAll]
    ];

    MNBeam* beam = [MNBeam beamWithNotes:notes];
    //    [ret.staves addObject:staff];
    //    [ret.beams addObject:@[beam]];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [notes foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [[self class] renderNote:parent note:note staff:staff withContext:ctx atX:(i + 1) * 50];
      }];
      [beam draw:ctx];
      ok(YES, @"Full Dot");
    };

    return ret;
}

- (MNTestTuple*)drawDotsAndBeamsDown:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(50, 50, 600, 0)];

    //        [staff draw:ctx];

    NSArray* notes = @[

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"8",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"32",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"64",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"128",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"32",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"64",
               @"stem_direction" : @(-1) }) addDotToAll],

        [newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"128",
               @"stem_direction" : @(-1) }) addDotToAll]
    ];

    id beam = [MNBeam beamWithNotes:notes];
    //    [ret.staves addObject:staff];
    //    [ret.beams addObject:@[ beam ]];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [notes foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [[self class] renderNote:parent note:note staff:staff withContext:ctx atX:(i + 1) * 25];
      }];
      [beam draw:ctx];
      ok(YES, @"Full Dot");
    };

    return ret;
}

- (MNTestTuple*)drawCenterAlignedRest:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];

    [staff addClefWithName:@"treble"];
    [staff addTimeSignatureWithName:@"4/4"];

    //        [staff draw:ctx];
    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"1r",
           @"align_center" : @(YES) }
    ] oct_map:^MNStaffNote*(NSDictionary* note_struct) {
      return newNote(note_struct);
    }];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    [voice0 addTickables:notes0];
    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff];
    //        [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff];

    [ret.voices addObject:voice0];
    [ret.formatters addObject:formatter];
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      ok(YES, @"");
    };

    return ret;
}

- (MNTestTuple*)drawCenterAlignedRestFermata:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];

    [staff addClefWithName:@"treble"];
    [staff addTimeSignatureWithName:@"4/4"];

    //        [staff draw:ctx];
    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"1r",
           @"align_center" : @(YES) }
    ] oct_map:^MNStaffNote*(NSDictionary* note_struct) {
      return newNote(note_struct);
    }];

    [notes0[0] addArticulation:[[MNArticulation alloc] initWithCode:@"a@a"] atIndex:0];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    [voice0 addTickables:notes0];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff];
    //        [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff];

    [ret.voices addObject:voice0];
    [ret.formatters addObject:formatter];
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      ok(YES, @"");
    };

    return ret;
}

- (MNTestTuple*)drawCenterAlignedRestAnnotation:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];

    [staff addClefWithName:@"treble"];
    [staff addTimeSignatureWithName:@"4/4"];

    //        [staff draw:ctx];
    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"1r",
           @"align_center" : @(YES) }
    ] oct_map:^MNStaffNote*(NSDictionary* note_struct) {
      return newNote(note_struct);
    }];

    // TODO: setPosition is not hooked up to anything
    [notes0[0] addAnnotation:[[MNAnnotation annotationWithText:@"Whole measure rest"] setPosition:MNPositionAbove]
                     atIndex:0];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    [voice0 addTickables:notes0];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff];
    //        [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff];

    [ret.voices addObject:voice0];
    [ret.formatters addObject:formatter];
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      ok(YES, @"");
    };
    return ret;
}

- (MNTestTuple*)drawCenterAlignedNoteMultiModifiers:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };
    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) =
        ^MNFretHandFinger*(NSString* num, MNPositionType position)
    {
        return [[MNFretHandFinger alloc] initWithFingerNumber:num andPosition:position];
    };
    MNStringNumber* (^newStringNumber)(NSString*, MNPositionType) =
        ^MNStringNumber*(NSString* num, MNPositionType position)
    {
        MNStringNumber* ret = [[MNStringNumber alloc] initWithString:num];
        [ret setPosition:position];
        return ret;
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];

    [staff addClefWithName:@"treble"];
    [staff addTimeSignatureWithName:@"4/4"];

    //        [staff draw:ctx];
    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
           @"duration" : @"4",
           @"align_center" : @(YES) }
    ] oct_map:^MNStaffNote*(NSDictionary* note_struct) {
      return newNote(note_struct);
    }];

    [[[[[[[[notes0[0] addAnnotation:[[MNAnnotation annotationWithText:@"Test"] setPosition:MNPositionAbove] atIndex:0]
        addStroke:[MNStroke strokeWithType:MNStrokeBrushUp]
          atIndex:0] addAccidental:[MNAccidental accidentalWithType:@"#"]
                           atIndex:1] addModifier:newFinger(@"3", MNPositionLeft)
                                          atIndex:0] addModifier:newFinger(@"2", MNPositionLeft)
                                                         atIndex:2] addModifier:newFinger(@"1", MNPositionRight)
                                                                        atIndex:1]
        addModifier:newStringNumber(@"4", MNPositionBelow)
            atIndex:2] addDotToAll];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    [voice0 addTickables:notes0];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff];
    //        [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff];

    [ret.voices addObject:voice0];
    [ret.formatters addObject:formatter];
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      ok(YES, @"");
    };
    return ret;
}

- (MNTestTuple*)drawCenterAlignedMultiVoice:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNLogInfo(@"");
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];

    [staff addClefWithName:@"treble"];
    [staff addTimeSignatureWithName:@"3/8"];

    // Create custom duration
    MNRational* custom_duration = Rational(3, 8);

    NSArray* notes0 = [@[
        @{
            @"keys" : @[ @"c/4" ],
            @"duration" : @"1r",
            @"align_center" : @(YES),
            @"duration_override" : custom_duration
        }
    ] oct_map:^MNStaffNote*(NSDictionary* note_struct) {
      return newNote(note_struct);
    }];

    NSArray* notes1 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8" },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"8" },
    ] oct_map:^MNStaffNote*(NSDictionary* note_struct) {
      return newNote(note_struct);
    }];

    [notes1[1] addAccidental:[MNAccidental accidentalWithType:@"#"] atIndex:0];

    NSDictionary* TIME3_8 = @{ @"num_beats" : @3, @"beat_value" : @8, @"resolution" : @(kRESOLUTION) };

    MNBeam* beam = [MNBeam beamWithNotes:notes1];

    MNVoice* voice0 = [[MNVoice alloc] initWithTimeDict:TIME3_8];
    [voice0 setStrict:NO];
    [voice0 addTickables:notes0];

    MNVoice* voice1 = [[MNVoice alloc] initWithTimeDict:TIME3_8];
    [voice1 setStrict:NO];
    [voice1 addTickables:notes1];

//    MNFormatter* formatter =
        [[[MNFormatter formatter] joinVoices:@[ voice0, voice1 ]] formatToStaff:@[ voice0, voice1 ] staff:staff];

    //    [ret.voices addObjectsFromArray:@[ voice0, voice1 ]];
    //    [ret.formatters addObject:formatter];
    //    [ret.staves addObject:staff];
    //    [ret.beams addObject:@[beam]];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beam draw:ctx];
      ok(YES, @"");
    };

    return ret;
}

@end

#pragma clang diagnostic pop