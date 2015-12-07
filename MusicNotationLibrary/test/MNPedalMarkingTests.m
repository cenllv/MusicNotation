//
//  MNPedalMarkingTests.m
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

#import "MNPedalMarkingTests.h"

@implementation MNPedalMarkingTests

- (void)start
{
    [super start];
    float w = 600, h = 200;
    [self runTest:@"Simple Pedal" func:@selector(simpleText:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Simple Pedal" func:@selector(simpleBracket:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Simple Pedal" func:@selector(simpleMixed:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Release and Depress on Same Note"
             func:@selector(releaseDepressOnSameNoteBracketed:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Release and Depress on Same Note"
             func:@selector(releaseDepressOnSameNoteMixed:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Custom Text" func:@selector(customText:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Custom Text" func:@selector(customTextMixed:) frame:CGRectMake(10, 10, w, h)];
}

- (void)tearDown
{
    [super tearDown];
}

//- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(id<MNTestParentDelegate>)parent
//{
//    /*
//     Vex.Flow.Test.ThreeVoices.setupContext = function(options, x, y) {
//     Vex.Flow.Test.resizeCanvas(options.canvas_sel, x || 350, y || 150);
//     var ctx = Vex.getCanvasContext(options.canvas_sel);
//     ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
//     ctx.font = " 10pt Arial";
//      MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 30, x || 350, 0) addTrebleGlyph].
//     setContext(ctx).draw();
//
//     return {context: ctx, staff: staff};
//     }
//     */
//    NSUInteger w = size.width;
////    NSUInteger h = size.height;
//
//    w = w != 0 ? w : 350;
////    h = h != 0 ? h : 150;
//
//    //     // [MNFont setFont:@" 10pt Arial"];
//
//    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
//    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
//}

- (MNTestBlockStruct*)simpleText:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    //      expect(@"0");
    MNStaff* staff0 = [[MNStaff staffWithRect:CGRectMake(10, 10, 250, 0)] addTrebleGlyph];
    MNStaff* staff1 = [MNStaff staffWithRect:CGRectMake(260, 10, 250, 0)];

    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(-1) }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    NSArray* notes1 = [@[
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice1 setStrict:NO];
    [voice0 addTickables:notes0];
    [voice1 addTickables:notes1];

    [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff0];
    [[[MNFormatter formatter] joinVoices:@[ voice1 ]] formatToStaff:@[ voice1 ] staff:staff1];

    MNPedalMarking* pedal = [MNPedalMarking pedalMarkingWithNotes:@[ notes0[0], notes0[2], notes0[3], notes1[3] ]];

    pedal.style = MNPedalMarkingText;

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff0 draw:ctx];
      [staff1 draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff0];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [pedal draw:ctx];
    };
    return ret;
}

- (MNTestBlockStruct*)simpleBracket:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    //      expect(@"0");
    MNStaff* staff0 = [[MNStaff staffWithRect:CGRectMake(10, 10, 250, 0)] addTrebleGlyph];
    MNStaff* staff1 = [MNStaff staffWithRect:CGRectMake(260, 10, 250, 0)];

    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(-1) }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    NSArray* notes1 = [@[
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice1 setStrict:NO];
    [voice0 addTickables:notes0];
    [voice1 addTickables:notes1];

    [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff0];
    [[[MNFormatter formatter] joinVoices:@[ voice1 ]] formatToStaff:@[ voice1 ] staff:staff1];

    MNPedalMarking* pedal = [MNPedalMarking pedalMarkingWithNotes:@[ notes0[0], notes0[2], notes0[3], notes1[3] ]];

    pedal.style = MNPedalMarkingBracket;
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff0 draw:ctx];
      [staff1 draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff0];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [pedal draw:ctx];
    };
    return ret;
}

- (MNTestBlockStruct*)simpleMixed:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    //      expect(@"0");
    MNStaff* staff0 = [[MNStaff staffWithRect:CGRectMake(10, 10, 250, 0)] addTrebleGlyph];
    MNStaff* staff1 = [MNStaff staffWithRect:CGRectMake(260, 10, 250, 0)];

    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(-1) }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    NSArray* notes1 = [@[
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice1 setStrict:NO];
    [voice0 addTickables:notes0];
    [voice1 addTickables:notes1];

    [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff0];
    [[[MNFormatter formatter] joinVoices:@[ voice1 ]] formatToStaff:@[ voice1 ] staff:staff1];

    MNPedalMarking* pedal = [MNPedalMarking pedalMarkingWithNotes:@[ notes0[0], notes0[2], notes0[3], notes1[3] ]];

    pedal.style = MNPedalMarkingMixed;
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff0 draw:ctx];
      [staff1 draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff0];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [pedal draw:ctx];
    };
    return ret;
}

- (MNTestBlockStruct*)releaseDepressOnSameNoteBracketed:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    //      expect(@"0");
    MNStaff* staff0 = [[MNStaff staffWithRect:CGRectMake(10, 10, 250, 0)] addTrebleGlyph];
    MNStaff* staff1 = [MNStaff staffWithRect:CGRectMake(260, 10, 250, 0)];

    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(-1) }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    NSArray* notes1 = [@[
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice1 setStrict:NO];
    [voice0 addTickables:notes0];
    [voice1 addTickables:notes1];

    [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff0];
    [[[MNFormatter formatter] joinVoices:@[ voice1 ]] formatToStaff:@[ voice1 ] staff:staff1];

    MNPedalMarking* pedal =
        [MNPedalMarking pedalMarkingWithNotes:@[ notes0[0], notes0[3], notes0[3], notes1[1], notes1[1], notes1[3] ]];

    pedal.style = MNPedalMarkingBracket;
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff0 draw:ctx];
      [staff1 draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff0];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [pedal draw:ctx];
    };
    return ret;
}

- (MNTestBlockStruct*)releaseDepressOnSameNoteMixed:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    //      expect(@"0");
    MNStaff* staff0 = [[MNStaff staffWithRect:CGRectMake(10, 10, 250, 0)] addTrebleGlyph];
    MNStaff* staff1 = [MNStaff staffWithRect:CGRectMake(260, 10, 250, 0)];

    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(-1) }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    NSArray* notes1 = [@[
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice1 setStrict:NO];
    [voice0 addTickables:notes0];
    [voice1 addTickables:notes1];

    [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff0];
    [[[MNFormatter formatter] joinVoices:@[ voice1 ]] formatToStaff:@[ voice1 ] staff:staff1];

    MNPedalMarking* pedal =
        [MNPedalMarking pedalMarkingWithNotes:@[ notes0[0], notes0[3], notes0[3], notes1[1], notes1[1], notes1[3] ]];

    pedal.style = MNPedalMarkingMixed;
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff0 draw:ctx];
      [staff1 draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff0];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [pedal draw:ctx];
    };
    return ret;
}

- (MNTestBlockStruct*)customText:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    //      expect(@"0");
    MNStaff* staff0 = [[MNStaff staffWithRect:CGRectMake(10, 10, 250, 0)] addTrebleGlyph];
    MNStaff* staff1 = [MNStaff staffWithRect:CGRectMake(260, 10, 250, 0)];

    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(-1) }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    NSArray* notes1 = [@[
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice1 setStrict:NO];
    [voice0 addTickables:notes0];
    [voice1 addTickables:notes1];

    [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff0];
    [[[MNFormatter formatter] joinVoices:@[ voice1 ]] formatToStaff:@[ voice1 ] staff:staff1];

    MNPedalMarking* pedal = [MNPedalMarking pedalMarkingWithNotes:@[ notes0[0], notes1[3] ]];

    pedal.style = MNPedalMarkingText;

    [pedal setCustomTextDepress:@"una corda" release:@"tre corda"];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff0 draw:ctx];
      [staff1 draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff0];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [pedal draw:ctx];
    };
    return ret;
}

- (MNTestBlockStruct*)customTextMixed:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    //      expect(@"0");
    MNStaff* staff0 = [[MNStaff staffWithRect:CGRectMake(10, 10, 250, 0)] addTrebleGlyph];
    MNStaff* staff1 = [MNStaff staffWithRect:CGRectMake(260, 10, 250, 0)];

    NSArray* notes0 = [@[
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"b/4" ],
           @"duration" : @"4",
           @"stem_direction" : @(-1) }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    NSArray* notes1 = [@[
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"4" }
    ] oct_map:^MNStaffNote*(NSDictionary* spec) {
      return newNote(spec);
    }];

    MNVoice* voice0 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice0 setStrict:NO];
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice1 setStrict:NO];
    [voice0 addTickables:notes0];
    [voice1 addTickables:notes1];

    [[[MNFormatter formatter] joinVoices:@[ voice0 ]] formatToStaff:@[ voice0 ] staff:staff0];
    [[[MNFormatter formatter] joinVoices:@[ voice1 ]] formatToStaff:@[ voice1 ] staff:staff1];

    MNPedalMarking* pedal = [MNPedalMarking pedalMarkingWithNotes:@[ notes0[0], notes1[3] ]];
    pedal.style = MNPedalMarkingMixed;

    [pedal setCustomText:@"Sost. Ped."];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff0 draw:ctx];
      [staff1 draw:ctx];
      [voice0 draw:ctx dirtyRect:CGRectZero toStaff:staff0];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [pedal draw:ctx];
    };
    return ret;
}

@end
