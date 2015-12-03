//
//  MNDotTests.m
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

#import "MNDotTests.h"

@implementation MNDotTests

- (void)start
{
    [super start];
    [self runTest:@"Basic" func:@selector(basic:withTitle:) frame:CGRectMake(10, 10, 700, 250)];
    //    [self runTest:@"Multi Voice" func:@selector(multiVoice:withTitle:) frame:CGRectMake(10, 10, 700, 250)];
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

    //    TestCollectionItemView* test =
    //        self.currentCell;   //  MNTestView* test =  [MNTestView createCanvasTest:CGSizeMake(w, h)
    //        withParent:parent];
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

+ (MNStaffNote*)showNote:(MNStaffNote*)note staff:(MNStaff*)staff context:(CGContextRef)ctx x:(NSUInteger)x
{
    MNModifierContext* mc = [MNModifierContext modifierContext];
    [note addToModifierContext:mc];

    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [tickContext addTickable:note];
    [tickContext preFormat];
    [tickContext setX:x];
    [tickContext setPointsUsed:65];

    note.staff = staff;
    [note draw:ctx];
/*
    ctx.save();
    ctx.font = "10pt Arial"; ctx.strokeStyle = "#579"; ctx.fillStyle = "#345";
    ctx.fillText(@"w: " + note.getWidth(), note.getAbsoluteX() - 25, 200 / 1.5);
 */
// TODO: test the following text writing
//    [[[MNFont setFont:@"10 pt Arial"] setStrokeStyle:@"#579"] setFillStyle:@"#345"];
//     [MNText drawText:ctx
//                   atPoint:MNPointMake(note.absoluteX - 25, 200 / 1.5)
//                  withText:[NSString stringWithFormat:@"w: %f", note.width]];

#if TARGET_OS_IPHONE
    UIFont* descriptionFont = [UIFont fontWithName:@"ArialMT" size:12];
#elif TARGET_OS_MAC
    NSFont* descriptionFont = [NSFont fontWithName:@"ArialMT" size:12];
#endif

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    NSAttributedString* description;

    description = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"w: %.01f", note.width]
                                                  attributes:@{
                                                      NSParagraphStyleAttributeName : paragraphStyle,
                                                      NSFontAttributeName : descriptionFont,
                                                      NSForegroundColorAttributeName : MNColor.blackColor
                                                  }];

    [description drawAtPoint:CGPointMake(note.absoluteX - 25, 200 / 1.5)];
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, note.absoluteX - (note.width / 2), 210 / 1.5);
    CGContextMoveToPoint(ctx, note.absoluteX + (note.width / 2), 210 / 1.5);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    return note;
}

- (MNTestTuple*)basic:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 975, 0)];

      [staff draw:ctx];

      NSArray* notes = @[
          [newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"a/4", @"b/4" ],
                 @"duration" : @"w" }) addDotToAll],

          [newNote(
              @{ @"keys" : @[ @"c/5", @"b/4", @"a/4" ],
                 @"duration" : @"q",
                 @"stem_direction" : @(1) }) addDotToAll],

          [newNote(
              @{ @"keys" : @[ @"b/4", @"a/4", @"g/4" ],
                 @"duration" : @"q",
                 @"stem_direction" : @(-1) }) addDotToAll],

          [newNote(
              @{ @"keys" : @[ @"c/5", @"b/4", @"f/4", @"e/4" ],
                 @"duration" : @"q" }) addDotToAll],

          [newNote(@{
              @"keys" : @[ @"g/5", @"e/5", @"d/5", @"a/4", @"g/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }) addDotToAll],

          [newNote(
              @{ @"keys" : @[ @"e/5", @"d/5", @"b/4", @"g/4" ],
                 @"duration" : @"q",
                 @"stem_direction" : @(-1) }) addDotToAll],

          [newNote(
              @{ @"keys" : @[ @"c/5", @"b/4", @"g/4", @"e/4" ],
                 @"duration" : @"q",
                 @"stem_direction" : @(1) }) addDotToAll],

          [[newNote(
              @{ @"keys" : @[ @"d/4", @"e/4", @"f/4", @"a/4", @"c/5", @"e/5", @"g/5" ],
                 @"duration" : @"h" }) addDotToAll] addDotToAll],

          [[[newNote(@{
              @"keys" : @[ @"f/4", @"g/4", @"a/4", @"b/4", @"c/5", @"e/5", @"g/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }) addDotToAll] addDotToAll] addDotToAll]
      ];

      for(NSUInteger i = 0; i < notes.count; ++i)
      {
          [[self class] showNote:notes[i] staff:staff context:ctx x:30 + (i * 65)];
          NSArray* accidentals = [((MNStaffNote*)notes[i])getDots];
          BOOL result = accidentals.count > 0;
          NSString* message = [NSString stringWithFormat:@"Note %lu has accidentals", i];
          ok(result, message);

          for(NSUInteger j = 0; j < accidentals.count; ++j)
          {
              NSString* message = [NSString stringWithFormat:@"Dot %lu has set width", j];
              BOOL result = ((MNAccidental*)accidentals[j]).width > 0;
              ok(result, message);
          }
      }

      ok(YES, @"Full Dot");
    };
    return ret;
}

- (void)showNotes:(MNStaffNote*)note1
            note2:(MNStaffNote*)note2
            staff:(MNStaff*)staff
          context:(CGContextRef)ctx
                x:(NSUInteger)x
{
    MNModifierContext* mc = [MNModifierContext modifierContext];
    [note1 addToModifierContext:mc];
    [note2 addToModifierContext:mc];

    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:note1] addTickable:note2];
    [tickContext preFormat];
    [tickContext setX:x];
    [tickContext setPointsUsed:65];

    note1.staff = staff;
    [note1 draw:ctx];
    note2.staff = staff;
    [note2 draw:ctx];
/*
    ctx.save();
    ctx.font = "10pt Arial"; ctx.strokeStyle = "#579"; ctx.fillStyle = "#345";
    ctx.fillText(@"w: " + note2.getWidth(), note2.getAbsoluteX() + 15, 20 / 1.5);
    ctx.fillText(@"w: " + note1.getWidth(), note1.getAbsoluteX() - 25, 220 / 1.5);
 */
//    [[[MNFont setFont:@"10 pt Arial"] setStrokeStyle:@"#579"] setFillStyle:@"#345"];

#if TARGET_OS_IPHONE
    UIFont* descriptionFont = [UIFont fontWithName:@"ArialMT" size:12];
#elif TARGET_OS_MAC
    NSFont* descriptionFont = [NSFont fontWithName:@"ArialMT" size:12];
#endif

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    NSAttributedString* description;

    description = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"w: %.01f", note2.width]
                                                  attributes:@{
                                                      NSParagraphStyleAttributeName : paragraphStyle,
                                                      NSFontAttributeName : descriptionFont,
                                                      NSForegroundColorAttributeName : MNColor.blackColor
                                                  }];

    [description drawAtPoint:CGPointMake(note2.absoluteX + 15, 20 / 1.5)];
    //     [MNText drawText:ctx
    //                   atPoint:MNPointMake(note2.absoluteX + 15, 20 / 1.5)
    //                  withText:[NSString stringWithFormat:@"w: %f", note2.width]];

    description = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"w: %.01f", note1.width]
                                                  attributes:@{
                                                      NSParagraphStyleAttributeName : paragraphStyle,
                                                      NSFontAttributeName : descriptionFont,
                                                      NSForegroundColorAttributeName : MNColor.blackColor
                                                  }];

    [description drawAtPoint:CGPointMake(note1.absoluteX + 15, 220 / 1.5)];
    //     [MNText drawText:ctx
    //                   atPoint:MNPointMake(note1.absoluteX + 15, 220 / 1.5)
    //                  withText:[NSString stringWithFormat:@"w: %f", note1.width]];
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, note1.absoluteX - (note1.width / 2), 230 / 1.5);
    CGContextMoveToPoint(ctx, note1.absoluteX + (note1.width / 2), 230 / 1.5);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
}

- (MNTestTuple*)multiVoice:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 420, 0)];

      [staff draw:ctx];

      MNStaffNote* note1 = [[newNote(
          @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
             @"duration" : @"h",
             @"stem_direction" : @(-1) }) addDotToAll] addDotToAll];
      MNStaffNote* note2 = [newNote(
          @{ @"keys" : @[ @"d/5", @"a/5", @"b/5" ],
             @"duration" : @"h",
             @"stem_direction" : @(1) }) addDotToAll];

      [[self class] showNotes:note1 note2:note2 staff:staff context:ctx x:60];

      note1 = [[[[[[[newNote(
          @{ @"keys" : @[ @"c/4", @"e/4", @"c/5" ],
             @"duration" : @"h",
             @"stem_direction" : @(-1) }) addDotAtIndex:0] addDotAtIndex:0] addDotAtIndex:1] addDotAtIndex:1]
          addDotAtIndex:2] addDotAtIndex:2] addDotAtIndex:2];
      note2 = [[newNote(
          @{ @"keys" : @[ @"d/5", @"a/5", @"b/5" ],
             @"duration" : @"q",
             @"stem_direction" : @(1) }) addDotToAll] addDotToAll];

      [[self class] showNotes:note1 note2:note2 staff:staff context:ctx x:150];

      note1 = [[[newNote(
          @{ @"keys" : @[ @"d/4", @"c/5", @"d/5" ],
             @"duration" : @"h",
             @"stem_direction" : @(-1) }) addDotToAll] addDotToAll] addDotAtIndex:0];
      note2 = [newNote(
          @{ @"keys" : @[ @"d/5", @"a/5", @"b/5" ],
             @"duration" : @"q",
             @"stem_direction" : @(1) }) addDotToAll];

      [[self class] showNotes:note1 note2:note2 staff:staff context:ctx x:250];

      ok(YES, @"Full Dot");
    };
    return ret;
}
@end
