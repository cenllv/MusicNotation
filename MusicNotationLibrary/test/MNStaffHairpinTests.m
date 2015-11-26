//
//  MNStaf.hairpinTests.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Raffaele Viglianti, 2012 http://itisnotsound.wordpress.com/
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

#import "MNStaffHairpinTests.h"

@implementation MNStaffHairpinTests

- (void)start
{
    [super start];
    float w = 600, h = 150;
    [self runTest:@"Simple StaffHairpin" func:@selector(simple:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Horizontal Offset StaffHairpin" func:@selector(ho:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Vertical Offset StaffHairpin" func:@selector(vo:withTitle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Height StaffHairpin" func:@selector(height:withTitle:) frame:CGRectMake(10, 10, w, h)];
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

+ (void)drawHairpin:(NSArray*)notes
              staff:(MNStaff*)staff
            context:(CGContextRef)ctx
               type:(MNStaffHairpinType)type
           position:(MNPositionType)position
            options:(NSDictionary*)options
{
    MNStaffHairpin* hp = [[MNStaffHairpin alloc] initWithNotes:notes withStaff:staff andType:type options:options];
    hp.position = position;
    [hp setRenderOptions:options];
    [hp draw:ctx];
}

+ (MNStaff*)hairpinNotes:(NSArray*)notes
                 options:(NSDictionary*)options
                 context:(CGContextRef)ctx
               dirtyRect:(CGRect)dirtyRect
{
    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 400, 0)];

    //    [staff addClefWithName:@"treble"];

    [staff draw:ctx];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:250];
    [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

    return staff;
}

static BOOL _debug = NO;
- (MNTestTuple*)simple:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      NSArray* notes = @[
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }) addAccidental:newAcc(@"b")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],

          newNote(
              @{ @"keys" : @[ @"d/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"e/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"f/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" })
      ];

      //      MNStaff* staff = [[self class] hairpinNotes:notes options:nil context:ctx];
      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 400, 0)] addTrebleGlyph];
      [staff draw:ctx];
      [notes foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [[self class] showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 50 withBoundingBox:_debug];
      }];

      [[self class] drawHairpin:@[ notes[0], notes[2] ]
                          staff:staff
                        context:ctx
                           type:MNStaffHairpinCres
                       position:MNPositionBelow
                        options:nil];

      [[self class] drawHairpin:@[ notes[1], notes[3] ]
                          staff:staff
                        context:ctx
                           type:MNStaffHairpinDescres
                       position:MNPositionAbove
                        options:nil];

      ok(YES, @"Simple Test");
    };
    return ret;
}

- (MNTestTuple*)ho:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, 400, 0)] addTrebleGlyph];
      [staff draw:ctx];
      NSArray* notes = @[
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }) addAccidental:newAcc(@"b")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],

          newNote(
              @{ @"keys" : @[ @"d/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"e/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"f/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" })
      ];

      [notes foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [[self class] showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 50 withBoundingBox:_debug];
      }];

      NSDictionary* renderOptions1 = @{
          @"height" : @(10),
          @"vo" : @(20),         // vertical offset
          @"left_ho" : @(20),    // left horizontal offset
          @"right_ho" : @(-20)   // right horizontal offset
      };
      [[self class] drawHairpin:@[ notes[0], notes[2] ]
                          staff:staff
                        context:ctx
                           type:MNStaffHairpinCres
                       position:MNPositionAbove
                        options:renderOptions1];

      NSDictionary* renderOptions2 = @{
          @"height" : @(10),
          @"y_shift" : @(0),           // vertical offset
          @"left_shift_px" : @(0),     // left horizontal offset
          @"right_shift_px" : @(120)   // right horizontal offset

      };
      [[self class] drawHairpin:@[ notes[3], notes[3] ]
                          staff:staff
                        context:ctx
                           type:MNStaffHairpinDescres
                       position:MNPositionBelow
                        options:renderOptions2];

      ok(YES, @"Horizontal Offset Test");
    };
    return ret;
}

- (MNTestTuple*)vo:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 400, 0)] addTrebleGlyph];
      [staff draw:ctx];
      NSArray* notes = @[
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }) addAccidental:newAcc(@"b")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],

          newNote(
              @{ @"keys" : @[ @"d/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"e/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"f/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" })
      ];

      [notes foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [[self class] showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 50 withBoundingBox:_debug];
      }];

      NSDictionary* renderOptions1 = @{
          @"height" : @(10),
          @"y_shift" : @(0),         // vertical offset
          @"left_shift_px" : @(0),   // left horizontal offset
          @"right_shift_px" : @(0)   // right horizontal offset
      };
      [[self class] drawHairpin:@[ notes[0], notes[2] ]
                          staff:staff
                        context:ctx
                           type:MNStaffHairpinCres
                       position:MNPositionBelow
                        options:renderOptions1];

      NSDictionary* renderOptions2 = @{
          @"height" : @(10),
          @"y_shift" : @(-10),       // vertical offset
          @"left_shift_px" : @(2),   // left horizontal offset
          @"right_shift_px" : @(0)   // right horizontal offset

      };
      [[self class] drawHairpin:@[ notes[2], notes[3] ]
                          staff:staff
                        context:ctx
                           type:MNStaffHairpinDescres
                       position:MNPositionBelow
                        options:renderOptions2];

      ok(YES, @"Vertical Offset Test");
    };
    return ret;
}

- (MNTestTuple*)height:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 400, 0)] addTrebleGlyph];
      [staff draw:ctx];
      NSArray* notes = @[
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }) addAccidental:newAcc(@"b")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],

          newNote(
              @{ @"keys" : @[ @"d/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"e/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"f/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" })
      ];

      [notes foreach:^(MNStaffNote* note, NSUInteger i, BOOL* stop) {
        [[self class] showNote:note onStaff:staff withContext:ctx atX:(i + 1) * 50 withBoundingBox:_debug];
      }];

      NSDictionary* renderOptions1 = @{
          @"height" : @(10),
          @"y_shift" : @(0),         // vertical offset
          @"left_shift_px" : @(0),   // left horizontal offset
          @"right_shift_px" : @(0)   // right horizontal offset

      };
      [[self class] drawHairpin:@[ notes[0], notes[2] ]
                          staff:staff
                        context:ctx
                           type:MNStaffHairpinCres
                       position:MNPositionBelow
                        options:renderOptions1];

      NSDictionary* renderOptions2 = @{
          @"height" : @(15),
          @"y_shift" : @(0),         // vertical offset
          @"left_shift_px" : @(2),   // left horizontal offset
          @"right_shift_px" : @(0)   // right horizontal offset

      };
      [[self class] drawHairpin:@[ notes[2], notes[3] ]
                          staff:staff
                        context:ctx
                           type:MNStaffHairpinDescres
                       position:MNPositionBelow
                        options:renderOptions2];

      ok(YES, @"Height Test");
    };
    return ret;
}

+ (MNStaffNote*)showNote:(MNStaffNote*)note
                 onStaff:(MNStaff*)staff
             withContext:(CGContextRef)ctx
                     atX:(float)x
         withBoundingBox:(BOOL)drawBoundingBox
{
    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:note] preFormat];
    tickContext.x = x;
    tickContext.pixelsUsed = 20;
    note.staff = staff;
    [note draw:ctx];
    if(drawBoundingBox)
    {
        [note.boundingBox draw:ctx];
    }
    return note;
}

@end
