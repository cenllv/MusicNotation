//
//  MNAccidentalTests.m
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

#import "MNAccidentalTests.h"

@interface MNAccidentalTests ()

@end

@implementation MNAccidentalTests

- (void)start
{
    [super start];
    [self runTest:@"Basic" func:@selector(basic:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Stem Down" func:@selector(basicStemDown:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Accidental Arrangement Special Cases"
             func:@selector(specialCases:)
            frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Multi Voice" func:@selector(multiVoice:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Microtonal" func:@selector(microtonal:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Automatic Accidentals - Simple Tests" func:@selector(autoAccidentalWorking:)];
    [self runTest:@"Automatic Accidentals - Simple Tests"
             func:@selector(automaticAccidentals0:)
            frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Automatic Accidentals" func:@selector(automaticAccidentals0:) frame:CGRectMake(10, 10, 750, 210)];
    [self runTest:@"Automatic Accidentals - C major scale in Ab"
             func:@selector(automaticAccidentals1:)
            frame:CGRectMake(10, 10, 750, 160)];
    [self runTest:@"Automatic Accidentals - No Accidentals Necessary"
             func:@selector(automaticAccidentals2:)
            frame:CGRectMake(10, 10, 750, 160)];
    [self runTest:@"Automatic Accidentals - Multi Voice Inline"
             func:@selector(automaticAccidentalsMultiVoiceInline:)
            frame:CGRectMake(10, 10, 750, 160)];
    [self runTest:@"Automatic Accidentals - Multi Voice Offset"
             func:@selector(automaticAccidentalsMultiVoiceOffset:)
            frame:CGRectMake(10, 10, 750, 160)];
}

- (void)tearDown
{
    [super tearDown];
}

- (BOOL)hasAccidental:(MNNote*)note
{
    /*
    function hasAccidental(note) {
        return note.modifiers.reduce(function(hasAcc, modifier) {
            if (hasAcc) return hasAcc;

            return modifier.getCategory() === "accidentals";
        }, isFalse());
    }
     */

    //    NSNumber* arst = [@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10] reduce:^NSNumber*(NSNumber* a, NSNumber* b) {
    //        return @([a boolValue] && [b integerValue] < 0);
    //    }];

    //              ^NSNumber*(id hasAcc, id modifier) {
    ////      if(hasAcc)
    ////      {
    ////          return hasAcc;
    ////      }
    //      return @(hasAcc && [modifier isKindOfClass:[MNAccidental class]]);
    ////        return @(YES);
    //      //@([[modifier category] isEqualToString:@"accidentals"]);
    //    }];

    return ![[note.modifiers filter:^BOOL(MNModifier* modifier) {
             return [modifier isKindOfClass:[MNAccidental class]];
           }] isEmpty];
}

#define hasAccidental(note) [self hasAccidental:note]

- (MNStaffNote*)showNote:(MNStaffNote*)note staff:(MNStaff*)staff context:(CGContextRef)ctx atX:(float)x
{
    /*
    Vex.Flow.Test.Accidental.showNote = function(note, staff, ctx, x) {
        var mc = new Vex.Flow.ModifierContext();
        note.addToModifierContext(mc);

         MNTickContext *tickContext = [[MNTickContext alloc]init];
        [tickContext addTickable:note] preFormat].x = x).setPixelsUsed(65);

        note.staff = staff;
        [note draw:ctx]

        ctx.save();
        ctx.font = "10pt Arial"; ctx.strokeStyle = "#579"; ctx.fillStyle = "#345";
        ctx.fillText(@"w: " + note.getWidth(), note.getAbsoluteX() - 25, 200 / 1.5);

        ctx.beginPath();
        ctx.moveTo(note.getAbsoluteX() - (note.getWidth() / 2), 210/1.5);
        ctx.lineTo(note.getAbsoluteX() + (note.getWidth() / 2), 210/1.5);
        ctx.stroke();
        ctx.restore();
        return note;
    }
     */

    MNModifierContext* mc = [MNModifierContext modifierContext];
    [note addToModifierContext:mc];

    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [tickContext addTickable:note];
    [tickContext preFormat];
    [tickContext setX:x];
    [tickContext setPointsUsed:65];

    [[note setStaff:staff] draw:ctx];

    MNBoundingBox* bb = note.boundingBox;
    [bb draw:ctx];

    CGFloat y_shift = 50;
    static BOOL toggle = NO;
    if(toggle)
    {
        y_shift += 20;
    }
    else
    {
        y_shift -= 20;
    }
    toggle = !toggle;

    CGContextSaveGState(ctx);
    MNFont* font = [MNFont fontWithName:@"Arial" size:10];
    font.strokeColor = [MNColor colorWithHexString:@"579"];
    font.fillColor = [MNColor colorWithHexString:@"345"];
    [MNText drawText:ctx
            withFont:font
             atPoint:MNPointMake(note.absoluteX - 25, 200 / 1.5 + y_shift + 10)
            withText:[NSString stringWithFormat:@"w: %f", note.width]];

    CGContextBeginPath(ctx);
    //    CGContextMoveToPoint(ctx, note.absoluteX - note.width / 2, 210 / 1.5);
    //    CGContextAddLineToPoint(ctx, note.absoluteX + note.width / 2, 210 / 1.5);
    CGContextMoveToPoint(ctx, bb.xPosition, 210 / 1.5 + y_shift);
    CGContextAddLineToPoint(ctx, bb.xPosition + bb.width, 210 / 1.5 + y_shift);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);

    return note;
}
- (MNTestBlockStruct*)basic:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 40, 550, 0)];

    //    [staff draw:ctx];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    NSArray* notes = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"duration" : @"w" }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],

        [[[[[[[newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4", @"a/4", @"c/5", @"e/5", @"g/5" ],
               @"duration" : @"h" }) addAccidental:newAcc(@"##")
                                           atIndex:0] addAccidental:newAcc(@"n")
                                                            atIndex:1] addAccidental:newAcc(@"bb")
                                                                             atIndex:2] addAccidental:newAcc(@"b")
                                                                                              atIndex:3]
            addAccidental:newAcc(@"#")
                  atIndex:4] addAccidental:newAcc(@"n")
                                   atIndex:5] addAccidental:newAcc(@"bb")
                                                    atIndex:6],

        [[[[[[[newNote(
            @{ @"keys" : @[ @"f/4", @"g/4", @"a/4", @"b/4", @"c/5", @"e/5", @"g/5" ],
               @"duration" : @"16" }) addAccidental:newAcc(@"n")
                                            atIndex:0] addAccidental:newAcc(@"#")
                                                             atIndex:1] addAccidental:newAcc(@"#")
                                                                              atIndex:2] addAccidental:newAcc(@"b")
                                                                                               atIndex:3]
            addAccidental:newAcc(@"bb")
                  atIndex:4] addAccidental:newAcc(@"##")
                                   atIndex:5] addAccidental:newAcc(@"#")
                                                    atIndex:6],

        [[[[[[newNote(
            @{ @"keys" : @[ @"a/3", @"c/4", @"e/4", @"b/4", @"d/5", @"g/5" ],
               @"duration" : @"w" }) addAccidental:newAcc(@"#")
                                           atIndex:0] addAccidental:[newAcc(@"##") setAsCautionary]
                                                            atIndex:1] addAccidental:[newAcc(@"#") setAsCautionary]
                                                                             atIndex:2] addAccidental:newAcc(@"b")
                                                                                              atIndex:3]
            addAccidental:[newAcc(@"bb") setAsCautionary]
                  atIndex:4] addAccidental:[newAcc(@"b") setAsCautionary]
                                   atIndex:5],
    ];

    //
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(uint i = 0; i < notes.count; ++i)
      {
          [self showNote:notes[i] staff:staff context:ctx atX:(30 + (i * 125))];
          //          [parent showStaffNote:notes[i] onStaff:staff withContext:ctx atX:(30 + (i *
          //          125))withBoundingBox:NO];
          NSArray* accidentals = ((MNStaffNote*)notes[i]).accidentals;

          for(uint j = 0; j < accidentals.count; ++j)
          {
              //            assertThatFloat(((MNAccidental *)accidentals[i]).width, describedAs(@"Accidental has set
              //            width" ,greaterThan(0), nil));
              //                ok((((MNAccidental *)accidentals[i]).width > 0), [NSString
              //                stringWithFormat:@"Accidental
              //                %i has set width", j]);
              BOOL success = ((MNAccidental*)accidentals[i]).width > 0;
              NSString* msg = [NSString stringWithFormat:@"Accidental %tu has set width", j];
              ok(success, msg);
          }
      }
    };

    return ret;
}

- (MNTestBlockStruct*)specialCases:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 40, 550, 0)];

    //    [staff draw:ctx];

    NSArray* notes = @[
        [[newNote(
            @{ @"keys" : @[ @"f/4", @"d/5" ],
               @"duration" : @"w" }) addAccidental:newAcc(@"#")
                                           atIndex:0] addAccidental:newAcc(@"b")
                                                            atIndex:1],

        [[newNote(
            @{ @"keys" : @[ @"c/4", @"g/4" ],
               @"duration" : @"h" }) addAccidental:newAcc(@"##")
                                           atIndex:0] addAccidental:newAcc(@"##")
                                                            atIndex:1],

        [[[newNote(
            @{ @"keys" : @[ @"b/3", @"d/4", @"f/4" ],
               @"duration" : @"16" }) addAccidental:newAcc(@"#")
                                            atIndex:0] addAccidental:newAcc(@"#")
                                                             atIndex:1] addAccidental:newAcc(@"##")
                                                                              atIndex:2],

        [[[newNote(
            @{ @"keys" : @[ @"g/4", @"a/4", @"c/5", @"e/5" ],
               @"duration" : @"16" }) addAccidental:newAcc(@"b")
                                            atIndex:0] addAccidental:newAcc(@"b")
                                                             atIndex:1] addAccidental:newAcc(@"k")
                                                                              atIndex:3],

        [[[[newNote(
            @{ @"keys" : @[ @"e/4", @"g/4", @"b/4", @"c/5" ],
               @"duration" : @"4" }) addAccidental:[newAcc(@"b") setAsCautionary]
                                           atIndex:0] addAccidental:[newAcc(@"b") setAsCautionary]
                                                            atIndex:1] addAccidental:[newAcc(@"bb") setAsCautionary]
                                                                             atIndex:2]
            addAccidental:[newAcc(@"b") setAsCautionary]
                  atIndex:3],

        [[[[[newNote(
            @{ @"keys" : @[ @"b/3", @"e/4", @"a/4", @"d/5", @"g/5" ],
               @"duration" : @"8" }) addAccidental:newAcc(@"bb")
                                           atIndex:0] addAccidental:[newAcc(@"b") setAsCautionary]
                                                            atIndex:1] addAccidental:[newAcc(@"n") setAsCautionary]
                                                                             atIndex:2] addAccidental:newAcc(@"#")
                                                                                              atIndex:3]
            addAccidental:[newAcc(@"n") setAsCautionary]
                  atIndex:4],
    ];

    //
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(uint i = 0; i < notes.count; ++i)
      {
          [self showNote:notes[i] staff:staff context:ctx atX:30 + (i * 70)];
          //          [parent showStaffNote:notes[i] onStaff:staff withContext:ctx atX:(30 + (i *
          //          70))withBoundingBox:NO];
          NSArray* accidentals = ((MNStaffNote*)notes[i]).accidentals;
          BOOL success = accidentals.count > 0;
          NSString* msg = [NSString stringWithFormat:@"Note %i has accidentals", i];
          ok(success, msg);

          for(uint j = 0; j < accidentals.count; ++j)
          {
              BOOL success = ((MNStaffNote*)accidentals[j]).width > 0;
              NSString* msg = [NSString stringWithFormat:@"Accidental %i has set width", j];
              ok(success, msg);
          }
      }
    };

    ok(YES, @"Full Accidental");

    return ret;
}

- (MNTestBlockStruct*)basicStemDown:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 40, 550, 0)];

    NSArray* notes = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"duration" : @"w",
               @"stem_direction" : @(-1) }) addAccidental:newAcc(@"b")
                                                  atIndex:0] addAccidental:newAcc(@"#")
                                                                   atIndex:1],

        [[[[[[[newNote(@{
            @"keys" : @[ @"d/4", @"e/4", @"f/4", @"a/4", @"c/5", @"e/5", @"g/5" ],
            @"duration" : @"h",
            @"stem_direction" : @(-1)
        }) addAccidental:newAcc(@"##")
                  atIndex:0] addAccidental:newAcc(@"n")
                                   atIndex:1] addAccidental:newAcc(@"bb")
                                                    atIndex:2] addAccidental:newAcc(@"b")
                                                                     atIndex:3] addAccidental:newAcc(@"#")
                                                                                      atIndex:4]
            addAccidental:newAcc(@"n")
                  atIndex:5] addAccidental:newAcc(@"bb")
                                   atIndex:6],

        [[[[[[[newNote(@{
            @"keys" : @[ @"f/4", @"g/4", @"a/4", @"b/4", @"c/5", @"e/5", @"g/5" ],
            @"duration" : @"16",
            @"stem_direction" : @-1
        }) addAccidental:newAcc(@"n")
                  atIndex:0] addAccidental:newAcc(@"#")
                                   atIndex:1] addAccidental:newAcc(@"#")
                                                    atIndex:2] addAccidental:newAcc(@"b")
                                                                     atIndex:3] addAccidental:newAcc(@"bb")
                                                                                      atIndex:4]
            addAccidental:newAcc(@"##")
                  atIndex:5] addAccidental:newAcc(@"#")
                                   atIndex:6],
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(uint i = 0; i < notes.count; ++i)
      {
          [self showNote:notes[i] staff:staff context:ctx atX:(30 + (i * 125))];
          //          [parent showStaffNote:notes[i] onStaff:staff withContext:ctx atX:(30 + (i *
          //          125))withBoundingBox:NO];
          NSArray* accidentals = ((MNStaffNote*)notes[i]).accidentals;
          BOOL success = accidentals.count > 0;
          NSString* msg = [NSString stringWithFormat:@"Note %tu has accidentals", i];
          ok(success, msg);

          for(uint j = 0; j < accidentals.count; ++j)
          {
              BOOL success = ((MNAccidental*)accidentals[j]).width > 0;
              NSString* msg = [NSString stringWithFormat:@"Accidental %tu has set width", j];
              ok(success, msg);
          }
      }
    };
    ok(YES, @"Full Accidental");

    return ret;
}

- (void)showNotes:(MNStaffNote*)note1
            other:(MNStaffNote*)note2
            staff:(MNStaff*)staff
          context:(CGContextRef)ctx
              atX:(float)x
{
    /*
    Vex.Flow.Test.Accidental.showNotes = function(note1, note2, staff, ctx, x) {
        var mc = new Vex.Flow.ModifierContext();
        note1.addToModifierContext(mc);
        note2.addToModifierContext(mc);

         MNTickContext *tickContext = [[MNTickContext alloc]init];
        tickContext addTickable:note1) addTickable:note2).
        preFormat().x = x).setPixelsUsed(65);

        note1.setContext(ctx).setStaff(staff).draw();
        note2.setContext(ctx).setStaff(staff).draw();
        note1.getBoundingBox().draw(ctx);
        note2.getBoundingBox().draw(ctx);

        ctx.save();
        ctx.font = "10pt Arial"; ctx.strokeStyle = "#579"; ctx.fillStyle = "#345";
        ctx.fillText(@"w: " + note2.getWidth(), note2.getAbsoluteX() + 15, 20 / 1.5);
        ctx.fillText(@"w: " + note1.getWidth(), note1.getAbsoluteX() - 25, 220 / 1.5);

        ctx.beginPath();
        ctx.moveTo(note1.getAbsoluteX() - (note1.getWidth() / 2), 230/1.5);
        ctx.lineTo(note1.getAbsoluteX() + (note1.getWidth() / 2), 230/1.5);
        ctx.stroke();
        ctx.restore();
    }
     */

    MNModifierContext* mc = [MNModifierContext modifierContext];
    [note1 addToModifierContext:mc];
    [note2 addToModifierContext:mc];

    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:note1] addTickable:note2];
    [tickContext preFormat];
    [tickContext setX:x];
    [tickContext setPointsUsed:65];

    [[note1 setStaff:staff] draw:ctx];
    [[note2 setStaff:staff] draw:ctx];
    [note1.boundingBox draw:ctx];
    [note2.boundingBox draw:ctx];

    // TODO: not done use NSAttributedString draw instaed.

    //    CGContextSaveGState(ctx);
    //    // TODO: the following lines do nothing
    //     [MNFont setFont:@"10pt Arial"];
    //     [MNFont setStrokeStyle:@"#579"];
    //     [MNFont setFillStyle:@"#345"];
    //     [MNText drawText:ctx
    //                   atPoint:MNPointMake(note2.absoluteX + 15, 20 / 1.5)
    //                  withText:[NSString stringWithFormat:@"w: %f", note2.width]];
    //     [MNText drawText:ctx
    //                   atPoint:MNPointMake(note1.absoluteX - 25, 220 / 1.5)
    //                  withText:[NSString stringWithFormat:@"w: %f", note1.width]];
    //
    //    CGContextBeginPath(ctx);
    //    CGContextMoveToPoint(ctx, note1.absoluteX - note1.width / 2, 230 / 1.5);
    //    CGContextMoveToPoint(ctx, note1.absoluteX + note1.width / 2, 230 / 1.5);
    //    CGContextStrokePath(ctx);
    //    CGContextRestoreGState(ctx);
}

- (MNTestBlockStruct*)multiVoice:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 40, 420, 0)];
    //    [staff draw:ctx];

    MNStaffNote *note1, *note2, *note3, *note4, *note5, *note6;

    note1 = [[[newNote(
        @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
           @"duration" : @"h",
           @"stem_direction" : @-1 }) addAccidental:newAcc(@"b")
                                            atIndex:0] addAccidental:newAcc(@"n")
                                                             atIndex:1] addAccidental:newAcc(@"#")
                                                                              atIndex:2];

    note2 = [[[newNote(
        @{ @"keys" : @[ @"d/5", @"a/5", @"b/5" ],
           @"duration" : @"h",
           @"stem_direction" : @1 }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"bb")
                                                            atIndex:1] addAccidental:newAcc(@"##")
                                                                             atIndex:2];

    note3 = [[[newNote(
        @{ @"keys" : @[ @"c/4", @"e/4", @"c/5" ],
           @"duration" : @"h",
           @"stem_direction" : @-1 }) addAccidental:newAcc(@"b")
                                            atIndex:0] addAccidental:newAcc(@"n")
                                                             atIndex:1] addAccidental:newAcc(@"#")
                                                                              atIndex:2];

    note4 = [newNote(
        @{ @"keys" : @[ @"d/5", @"a/5", @"b/5" ],
           @"duration" : @"q",
           @"stem_direction" : @1 }) addAccidental:newAcc(@"b")
                                           atIndex:0];

    note5 = [[[newNote(
        @{ @"keys" : @[ @"d/4", @"c/5", @"d/5" ],
           @"duration" : @"h",
           @"stem_direction" : @-1 }) addAccidental:newAcc(@"b")
                                            atIndex:0] addAccidental:newAcc(@"n")
                                                             atIndex:1] addAccidental:newAcc(@"#")
                                                                              atIndex:2];

    note6 = [newNote(
        @{ @"keys" : @[ @"d/5", @"a/5", @"b/5" ],
           @"duration" : @"q",
           @"stem_direction" : @1 }) addAccidental:newAcc(@"b")
                                           atIndex:0];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [self showNotes:note1 other:note2 staff:staff context:ctx atX:60];
      [self showNotes:note3 other:note4 staff:staff context:ctx atX:150];
      [self showNotes:note5 other:note6 staff:staff context:ctx atX:250];
    };
    ok(YES, @"Full Accidental");

    return ret;
}

- (MNTestBlockStruct*)microtonal:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [MNStaff staffAtX:10 atY:10 width:550 height:0];

    NSArray* notes = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"duration" : @"w" }) addAccidental:newAcc(@"db")
                                           atIndex:0] addAccidental:newAcc(@"d")
                                                            atIndex:1],

        [[[[[[[newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4", @"a/4", @"c/5", @"e/5", @"g/5" ],
               @"duration" : @"h" }) addAccidental:newAcc(@"bbs")
                                           atIndex:0] addAccidental:newAcc(@"++")
                                                            atIndex:1] addAccidental:newAcc(@"+")
                                                                             atIndex:2] addAccidental:newAcc(@"d")
                                                                                              atIndex:3]
            addAccidental:newAcc(@"db")
                  atIndex:4] addAccidental:newAcc(@"+")
                                   atIndex:5] addAccidental:newAcc(@"##")
                                                    atIndex:6],

        [[[[[[[newNote(
            @{ @"keys" : @[ @"f/4", @"g/4", @"a/4", @"b/4", @"c/5", @"e/5", @"g/5" ],
               @"duration" : @"16" }) addAccidental:newAcc(@"++")
                                            atIndex:0] addAccidental:newAcc(@"bbs")
                                                             atIndex:1] addAccidental:newAcc(@"+")
                                                                              atIndex:2] addAccidental:newAcc(@"b")
                                                                                               atIndex:3]
            addAccidental:newAcc(@"db")
                  atIndex:4] addAccidental:newAcc(@"##")
                                   atIndex:5] addAccidental:newAcc(@"#")
                                                    atIndex:6],

        [[[[[[newNote(
            @{ @"keys" : @[ @"a/3", @"c/4", @"e/4", @"b/4", @"d/5", @"g/5" ],
               @"duration" : @"w" }) addAccidental:newAcc(@"#")
                                           atIndex:0] addAccidental:[newAcc(@"db") setAsCautionary]
                                                            atIndex:1] addAccidental:[newAcc(@"bbs") setAsCautionary]
                                                                             atIndex:2] addAccidental:newAcc(@"b")
                                                                                              atIndex:3]
            addAccidental:[newAcc(@"++") setAsCautionary]
                  atIndex:4] addAccidental:[newAcc(@"d") setAsCautionary]
                                   atIndex:5],
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(NSUInteger i = 0; i < notes.count; ++i)
      {
          [self showNote:notes[i] staff:staff context:ctx atX:(30 + (i * 125))];
          NSArray* accidentals = [notes[i] accidentals];
          for(NSUInteger j = 0; j < accidentals.count; ++j)
          {
              BOOL result = accidentals.count > 0;
              NSString* str = [NSString stringWithFormat:@"Accidental %tu has set width", j];
              ok(result, str);
          }
      }
      ok(YES, @"Microtonal Accidental");
    };

    return ret;
}

- (MNTestBlockStruct*)automaticAccidentals0:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(700, 200) withParent:parent];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4", @"c/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c#/4", @"c#/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c#/4", @"c#/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c##/4", @"c##/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c##/4", @"c##/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"c/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cn/4", @"cn/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cbb/4", @"cbb/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cbb/4", @"cbb/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cb/4", @"cb/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cb/4", @"cb/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"c/5" ],
               @"duration" : @"4" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    [MNAccidental applyAccidentals:@[ voice ] withKeySignature:@"C"];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    ok(YES, @"");

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [c.staff draw:ctx];
      [voice draw:ctx dirtyRect:c.view.frame toStaff:c.staff];
    };
    return ret;
}

- (MNTestBlockStruct*)automaticAccidentals1:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(700, 150) withParent:parent];

    [c.staff addKeySignature:@"Ab"];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"4" }),
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    [MNAccidental applyAccidentals:@[ voice ] withKeySignature:@"Ab"];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [c.staff draw:ctx];
      [voice draw:ctx dirtyRect:c.view.frame toStaff:c.staff];

      ok(YES, @"");

    };
    return ret;
}

- (MNTestBlockStruct*)automaticAccidentals2:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(700, 150) withParent:parent];

    MNStaff* staff = [c.staff addKeySignature:@"A"];   // WithSpec:@"A"];
    //    [staff draw:ctx];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c#/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"f#/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g#/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"4" }),
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    [MNAccidental applyAccidentals:@[ voice ] withKeySignature:@"A"];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:c.view.frame toStaff:staff];
      ok(YES, @"");
    };

    return ret;
}

- (MNTestBlockStruct*)automaticAccidentalsMultiVoiceInline:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(700, 150) withParent:parent];

    MNStaff* staff = [c.staff addKeySignature:@"Ab"];

    NSArray* notes0 = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 })
    ];

    NSArray* notes1 = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/6" ],
               @"duration" : @"4" })
    ];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice0.mode = MNModeSoft;
    [voice0 addTickables:notes0];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice1.mode = MNModeSoft;
    [voice1 addTickables:notes1];

    // Ab Major
    [MNAccidental applyAccidentals:@[ voice0, voice1 ] withKeySignature:@"Ab"];

    assertThatBool(hasAccidental(notes0[0]), isFalse());
    assertThatBool(hasAccidental(notes0[1]), isTrue());
    assertThatBool(hasAccidental(notes0[2]), isTrue());
    assertThatBool(hasAccidental(notes0[3]), isFalse());
    assertThatBool(hasAccidental(notes0[4]), isFalse());
    assertThatBool(hasAccidental(notes0[5]), isTrue());
    assertThatBool(hasAccidental(notes0[6]), isTrue());
    assertThatBool(hasAccidental(notes0[7]), isFalse());

    assertThatBool(hasAccidental(notes1[0]), isFalse());
    assertThatBool(hasAccidental(notes1[1]), isTrue());
    assertThatBool(hasAccidental(notes1[2]), isTrue());
    assertThatBool(hasAccidental(notes1[3]), isFalse());
    assertThatBool(hasAccidental(notes1[4]), isFalse());
    assertThatBool(hasAccidental(notes1[5]), isTrue());
    assertThatBool(hasAccidental(notes1[6]), isTrue());
    assertThatBool(hasAccidental(notes1[7]), isFalse());

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice0, voice1 ]] formatToStaff:@[ voice0, voice1 ] staff:staff];

    //    MNFormatter* formatter =
    //        [[[MNFormatter formatter] joinVoices:@[ voice0, /*voice1*/ ]] formatToStaff:@[ voice0, /*voice1*/ ]
    //        staff:staff];
    //    MNFormatter* formatter2 =
    //    [[[MNFormatter formatter] joinVoices:@[ /*voice0,*/ voice1 ]] formatToStaff:@[ /*voice0,*/ voice1 ]
    //    staff:staff];

    ok(YES, @"");

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice0 draw:ctx dirtyRect:c.view.frame toStaff:staff];
      [voice1 draw:ctx dirtyRect:c.view.frame toStaff:staff];
    };
    return ret;
}

- (MNTestBlockStruct*)automaticAccidentalsMultiVoiceOffset:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(700, 150) withParent:parent];

    MNStaff* staff = [c.staff addKeySignature:@"Cb"];   // WithSpec:@"Cb"];
    //    [staff draw:ctx];

    NSArray* notes0 = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"4",
               @"stem_direction" : @-1 })
    ];

    NSArray* notes1 = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/6" ],
               @"duration" : @"4" })
    ];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice0.mode = MNModeSoft;
    [voice0 addTickables:notes0];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice1.mode = MNModeSoft;
    [voice1 addTickables:notes1];

    // Cb Major (All flats)
    [MNAccidental applyAccidentals:@[ voice0, voice1 ] withKeySignature:@"Cb"];

    assertThatBool(hasAccidental(notes0[0]), isTrue());
    assertThatBool(hasAccidental(notes0[1]), isTrue());
    assertThatBool(hasAccidental(notes0[2]), isTrue());
    assertThatBool(hasAccidental(notes0[3]), isTrue());
    assertThatBool(hasAccidental(notes0[4]), isTrue());
    assertThatBool(hasAccidental(notes0[5]), isTrue());
    assertThatBool(hasAccidental(notes0[6]), isTrue());
    assertThatBool(hasAccidental(notes0[7]), describedAs(@"Natural Remembered", isFalse(), nil));

    assertThatBool(hasAccidental(notes1[0]), isTrue());
    assertThatBool(hasAccidental(notes1[1]), isFalse());
    assertThatBool(hasAccidental(notes1[2]), isFalse());
    assertThatBool(hasAccidental(notes1[3]), isFalse());
    assertThatBool(hasAccidental(notes1[4]), isFalse());
    assertThatBool(hasAccidental(notes1[5]), isFalse());
    assertThatBool(hasAccidental(notes1[6]), isFalse());
    assertThatBool(hasAccidental(notes1[7]), isFalse());

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice0, voice1 ]] formatToStaff:@[ voice0, voice1 ] staff:staff];

    ok(YES, @"");

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
    };
    return ret;
}

- (MNTestBlockStruct*)autoAccidentalWorking:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"bb/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"bb/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g#/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a#/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g#/4" ],
               @"duration" : @"4" }),
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    // F Major (Bb)
    [MNAccidental applyAccidentals:@[ voice ] withKeySignature:@"F"];

    assertThatBool(hasAccidental(notes[0]), describedAs(@"No flat because of key signature", isFalse(), nil));
    assertThatBool(hasAccidental(notes[1]), describedAs(@"No flat because of key signature", isFalse(), nil));
    assertThatBool(hasAccidental(notes[2]), describedAs(@"Added a sharp", isTrue(), nil));
    assertThatBool(hasAccidental(notes[3]), describedAs(@"Back to natural", isTrue(), nil));
    assertThatBool(hasAccidental(notes[4]), describedAs(@"Back to natural", isTrue(), nil));
    assertThatBool(hasAccidental(notes[5]), describedAs(@"Natural remembered", isFalse(), nil));
    assertThatBool(hasAccidental(notes[6]), describedAs(@"Added sharp", isTrue(), nil));
    assertThatBool(hasAccidental(notes[7]), describedAs(@"Added sharp", isTrue(), nil));

    notes = @[
        newNote(
            @{ @"keys" : @[ @"e#/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cb/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"fb/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"b#/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"b#/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cb/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"fb/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"e#/4" ],
               @"duration" : @"4" }),
    ];

    voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    // A Major (F#,G#,C#)
    [MNAccidental applyAccidentals:@[ voice ] withKeySignature:@"A"];

    assertThatBool(hasAccidental(notes[0]), describedAs(@"Added sharp", isTrue(), nil));
    assertThatBool(hasAccidental(notes[1]), describedAs(@"Added flat", isTrue(), nil));
    assertThatBool(hasAccidental(notes[2]), describedAs(@"Added flat", isTrue(), nil));
    assertThatBool(hasAccidental(notes[3]), describedAs(@"Added sharp", isTrue(), nil));
    assertThatBool(hasAccidental(notes[4]), describedAs(@"Sharp remembered", isFalse(), nil));
    assertThatBool(hasAccidental(notes[5]), describedAs(@"Flat remembered", isFalse(), nil));
    assertThatBool(hasAccidental(notes[6]), describedAs(@"Flat remembered", isFalse(), nil));
    assertThatBool(hasAccidental(notes[7]), describedAs(@"Sharp remembered", isFalse(), nil));

    notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cb/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cb/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c#/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c#/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cbb/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"cbb/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c##/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c##/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"4" }),
    ];

    voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    // C Major (no sharps/flats)
    [MNAccidental applyAccidentals:@[ voice ] withKeySignature:@"C"];

    assertThatBool(hasAccidental(notes[0]), describedAs(@"No accidental", isFalse(), nil));
    assertThatBool(hasAccidental(notes[1]), describedAs(@"Added flat", isTrue(), nil));
    assertThatBool(hasAccidental(notes[2]), describedAs(@"Flat remembered", isFalse(), nil));
    assertThatBool(hasAccidental(notes[3]), describedAs(@"Sharp added", isTrue(), nil));
    assertThatBool(hasAccidental(notes[4]), describedAs(@"Sharp remembered", isFalse(), nil));
    assertThatBool(hasAccidental(notes[5]), describedAs(@"Added doubled flat", isTrue(), nil));
    assertThatBool(hasAccidental(notes[6]), describedAs(@"Double flat remembered", isFalse(), nil));
    assertThatBool(hasAccidental(notes[7]), describedAs(@"Added double sharp", isTrue(), nil));
    assertThatBool(hasAccidental(notes[8]), describedAs(@"Double sharp remembered", isFalse(), nil));
    assertThatBool(hasAccidental(notes[9]), describedAs(@"Added natural", isTrue(), nil));
    assertThatBool(hasAccidental(notes[10]), describedAs(@"Natural remembered", isFalse(), nil));

    return ret;
}

@end
