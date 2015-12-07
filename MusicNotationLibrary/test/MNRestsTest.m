//
//  MNRestsTest.m
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

#import "MNRestsTest.h"
#import "NSArray+MNAdditions.h"

@implementation MNRestsTest

- (void)start
{
    [super start];
    [self runTest:@"Rests - Dotted" func:@selector(basic:) frame:CGRectMake(10, 10, 720, 150)];
    [self runTest:@"Auto Align Rests - Beamed Notes Stems Up"
             func:@selector(beamsUp:)
            frame:CGRectMake(10, 10, 700, 200)];
    [self runTest:@"Auto Align Rests - Beamed Notes Stems Down"
             func:@selector(beamsDown:)
            frame:CGRectMake(10, 10, 700, 200)];
    [self runTest:@"Auto Align Rests - Tuplets Stems Up" func:@selector(tuplets:) frame:CGRectMake(10, 10, 700, 200)];
    [self runTest:@"Auto Align Rests - Tuplets Stems Down"
             func:@selector(tupletsDown:)
            frame:CGRectMake(10, 10, 700, 200)];
    [self runTest:@"Auto Align Rests - Single Voice (Default)"
             func:@selector(staffRests:)
            frame:CGRectMake(10, 10, 700, 200)];
    [self runTest:@"Auto Align Rests - Single Voice (Align All)"
             func:@selector(staffRestsAll:)
            frame:CGRectMake(10, 10, 700, 200)];
    [self runTest:@"Auto Align Rests - Multi Voice" func:@selector(multi:) frame:CGRectMake(10, 10, 700, 250)];
}

- (void)tearDown
{
    [super tearDown];
}

//// TODO: does this belong in superclass?
//+ (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(id<MNTestParentDelegate>)parent
//{
//    /*
//    Vex.Flow.Test.Rests.setupContext = function(options, contextBuilder, x, y) {
//        var ctx = new contextBuilder(options.canvas_sel, x || 350, y || 150);
//        ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
//        ctx.font = " 10pt Arial";
//         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 30, x || 350).addTrebleGlyph().
//        setContext(ctx).draw();
//
//        return {context: ctx, staff: staff};
//    }
//     */
//
//    NSUInteger w = size.width;
////    NSUInteger h = size.height;
//
//    w = w != 0 ? w : 350;
////    h = h != 0 ? h : 150;
////
//    //    // [MNFont setFont:@" 10pt Arial"];
//
//    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
//    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
//}

- (MNTestBlockStruct*)basic:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(700, 0) withParent:parent];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = c.staff;
      [staff draw:ctx];

      NSArray* notes = @[
          [newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"wr" }) addDotToAll],
          [newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"hr" }) addDotToAll],
          [newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"qr" }) addDotToAll],
          [newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"8r" }) addDotToAll],
          [newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"16r" }) addDotToAll],
          [newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"32r" }) addDotToAll],
          [newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"64r" }) addDotToAll]
      ];

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];

      [voice setStrict:NO];
      [voice addTickables:notes];
      [staff addTimeSignatureWithName:@"4/4"];
      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"Dotted Rest Test");
    };
    return ret;
}

- (MNTestBlockStruct*)beamsUp:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 60, 600, 160)] addTrebleGlyph];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"b/4", @"d/5", @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"b/4", @"d/5", @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),

    ];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNBeam* beam1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];
    MNBeam* beam3 = [MNBeam beamWithNotes:[notes slice:[@8:12]]];

    [voice1 setStrict:NO];
    [voice1 addTickables:notes];
    [staff addTimeSignatureWithName:@"4/4"];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beam1 draw:ctx];
      [beam2 draw:ctx];
      [beam3 draw:ctx];

      ok(YES, @"Auto Align Rests - Beams Up Test");
    };
    return ret;
}

- (MNTestBlockStruct*)beamsDown:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(600, 160) withParent:parent];
    MNStaff* staff = c.staff;

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"b/4", @"d/5", @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"b/4", @"d/5", @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

    ];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    MNBeam* beam1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];
    MNBeam* beam3 = [MNBeam beamWithNotes:[notes slice:[@8:12]]];

    [voice1 setStrict:NO];
    [voice1 addTickables:notes];
    [staff addTimeSignatureWithName:@"4/4"];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beam1 draw:ctx];
      [beam2 draw:ctx];
      [beam3 draw:ctx];

      ok(YES, @"Auto Align Rests - Beams Down Test");
    };
    return ret;
}

- (MNTestBlockStruct*)tuplets:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    // MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(600, 160) withParent:parent];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 70, 600, 160)] addTrebleGlyph];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"qr" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"qr" }),
    ];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes slice:[@3:6]]];
    MNTuplet* tuplet3 = [[MNTuplet alloc] initWithNotes:[notes slice:[@6:9]]];
    MNTuplet* tuplet4 = [[MNTuplet alloc] initWithNotes:[notes slice:[@9:12]]];
    [tuplet1 setTupletLocation:MNTupletLocationTop];
    [tuplet2 setTupletLocation:MNTupletLocationTop];
    [tuplet3 setTupletLocation:MNTupletLocationTop];
    [tuplet4 setTupletLocation:MNTupletLocationTop];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice1 setStrict:NO];
    [voice1 addTickables:notes];
    [staff addTimeSignatureWithName:@"4/4"];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [tuplet1 draw:ctx];
      [tuplet2 draw:ctx];
      [tuplet3 draw:ctx];
      [tuplet4 draw:ctx];

      ok(YES, @"Auto Align Rests - Tuplets Stem Up Test");
    };
    return ret;
}

- (MNTestBlockStruct*)tupletsDown:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(600, 160) withParent:parent];
    MNStaff* staff = c.staff;

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
    ];

    MNBeam* beam1 = [MNBeam beamWithNotes:[notes slice:[@0:3]]];
    MNBeam* beam2 = [MNBeam beamWithNotes:[notes slice:[@3:6]]];
    MNBeam* beam3 = [MNBeam beamWithNotes:[notes slice:[@6:9]]];
    MNBeam* beam4 = [MNBeam beamWithNotes:[notes slice:[@9:12]]];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes slice:[@3:6]]];
    MNTuplet* tuplet3 = [[MNTuplet alloc] initWithNotes:[notes slice:[@6:9]]];
    MNTuplet* tuplet4 = [[MNTuplet alloc] initWithNotes:[notes slice:[@9:12]]];
    [tuplet1 setTupletLocation:MNTupletLocationBottom];
    [tuplet2 setTupletLocation:MNTupletLocationBottom];
    [tuplet3 setTupletLocation:MNTupletLocationBottom];
    [tuplet4 setTupletLocation:MNTupletLocationBottom];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice1 setStrict:NO];
    [voice1 addTickables:notes];
    [staff addTimeSignatureWithName:@"4/4"];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [tuplet1 draw:ctx];
      [tuplet2 draw:ctx];
      [tuplet3 draw:ctx];
      [tuplet4 draw:ctx];

      [beam1 draw:ctx];
      [beam2 draw:ctx];
      [beam3 draw:ctx];
      [beam4 draw:ctx];

      ok(YES, @"Auto Align Rests - Tuplets Stem Down Test");
    };
    return ret;
}

- (MNTestBlockStruct*)staffRests:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(600, 160) withParent:parent];

    MNStaff* staff = c.staff;

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),

        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"qr" }),
    ];

    MNBeam* beam1 = [MNBeam beamWithNotes:[notes slice:[@5:9]]];
    MNTuplet* tuplet = [[MNTuplet alloc] initWithNotes:[notes slice:[@9:12]]];
    [tuplet setTupletLocation:MNTupletLocationTop];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice1 setStrict:NO];
    [voice1 addTickables:notes];
    [staff addTimeSignatureWithName:@"4/4"];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [tuplet draw:ctx];
      [beam1 draw:ctx];

      ok(YES, @"Auto Align Rests - Default Test");
    };
    return ret;
}

- (MNTestBlockStruct*)staffRestsAll:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(600, 160) withParent:parent];
    MNStaff* staff = c.staff;

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),

        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"qr" }),
    ];

    MNBeam* beam1 = [MNBeam beamWithNotes:[notes slice:[@5:9]]];
    MNTuplet* tuplet = [[MNTuplet alloc] initWithNotes:[notes slice:[@9:12]]];
    [tuplet setTupletLocation:MNTupletLocationTop];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice1 setStrict:NO];
    [voice1 addTickables:notes];
    [staff addTimeSignatureWithName:@"4/4"];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff draw:ctx];

      // Set option to position rests near the notes in the voice
      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staff
                                  withNotes:notes
                                 withParams:@{
                                     @"align_rests" : @(YES)
                                 }];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [tuplet draw:ctx];
      [beam1 draw:ctx];

      ok(YES, @"Auto Align Rests - Align All Test");
    };
    return ret;
}

- (MNTestBlockStruct*)multi:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(50, 10, 500, 0)] addTrebleGlyph];
    [staff addTimeSignatureWithName:@"4/4"];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"qr" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"d/4", @"a/4" ],
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"qr" })
    ];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8r" }),
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

    // Set option to position rests near the notes in each voice
    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatWith:@[ voice, voice2 ]
                                                       withJustifyWidth:400
                                                             andOptions:@{
                                                                 @"align_rests" : @YES
                                                             }];

    MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:4]]];
    MNBeam* beam2_2 = [MNBeam beamWithNotes:[notes2 slice:[@4:8]]];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beam2_1 draw:ctx];
      [beam2_2 draw:ctx];

      ok(YES, @"Strokes Test Multi Voice");
    };
    return ret;
}

@end
