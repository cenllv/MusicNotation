//
//  MNTupletTests.m
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

#import "MNTupletTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNTupletTests

- (void)start
{
    [super start];
    float w = 550, h = 160;
    //    [self runTest:@"Simple Tuplet" func:@selector(simple:) frame:CGRectMake(10, 10, w, h)];
    //    [self runTest:@"Beamed Tuplet" func:@selector(beamed:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Ratioed Tuplet" func:@selector(ratio:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Bottom Tuplet" func:@selector(bottom:) frame:CGRectMake(10, 10, w, h + 50)];
    [self runTest:@"Bottom Ratioed Tuplet" func:@selector(bottom_ratio:) frame:CGRectMake(10, 10, w, h + 50)];
    [self runTest:@"Awkward Tuplet" func:@selector(awkward:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Complex Tuplet" func:@selector(complex:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Mixed Stem Direction Tuplet" func:@selector(mixedTop:) frame:CGRectMake(10, 10, w, h + 50)];
    [self runTest:@"Mixed Stem Direction Bottom Tuplet"
             func:@selector(mixedBottom:)
            frame:CGRectMake(10, 10, w, h + 50)];
}

- (void)tearDown
{
    [super tearDown];
}



- (MNTestBlockStruct*)simple:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"3/4"];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes slice:[@3:6]]];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime3_4];
    [voice setStrict:YES];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [tuplet1 draw:ctx];
      [tuplet2 draw:ctx];

      ok(YES, @"Simple Test");
    };

    return ret;
}

- (MNTestBlockStruct*)beamed:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"3/8"];

    MNBeam* beam1 = [[MNBeam alloc] initWithNotes:[notes slice:[@0:3]]];
    MNBeam* beam2 = [[MNBeam alloc] initWithNotes:[notes slice:[@3:10]]];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes slice:[@3:10]]];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime3_8];
    [voice setStrict:YES];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [tuplet1 draw:ctx];
      [tuplet2 draw:ctx];

      [beam1 draw:ctx];
      [beam2 draw:ctx];

      ok(YES, @"Beamed Test");
    };
    return ret;
}

- (MNTestBlockStruct*)ratio:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"4/4"];

    MNBeam* beam1 = [[MNBeam alloc] initWithNotes:[notes slice:[@3:6]]];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];
    MNTuplet* tuplet2 =
        [[MNTuplet alloc] initWithNotes:[notes slice:[@3:6]] andOptionsDict:@{
            @"beats_occupied" : @4
        }];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:YES];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [[tuplet1 setRatioed:YES] draw:ctx];
      [[tuplet2 setRatioed:YES] draw:ctx];

      [beam1 draw:ctx];

      ok(YES, @"Ratioed Test");
    };
    return ret;
}

- (MNTestBlockStruct*)bottom:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })
    ];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"3/4"];

    MNBeam* beam = [[MNBeam alloc] initWithNotes:[notes slice:[@3:6]]];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes slice:[@3:6]]];

    [tuplet1 setTupletLocation:MNTupletLocationBottom];
    [tuplet2 setTupletLocation:MNTupletLocationBottom];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime3_4];
    [voice setStrict:YES];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beam draw:ctx];

      [tuplet1 draw:ctx];
      [tuplet2 draw:ctx];

      ok(YES, @"Bottom Test");
    };
    return ret;
}

- (MNTestBlockStruct*)bottom_ratio:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })
    ];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"5/8"];

    MNBeam* beam = [[MNBeam alloc] initWithNotes:[notes slice:[@3:6]]];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes slice:[@3:6]]];

    [tuplet2 setBeatsOccupied:1];
    [tuplet1 setTupletLocation:MNTupletLocationBottom];
    [tuplet2 setTupletLocation:MNTupletLocationBottom];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime5_8];
    [voice setStrict:YES];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beam draw:ctx];

      [[tuplet1 setRatioed:YES] draw:ctx];
      [[tuplet2 setRatioed:YES] draw:ctx];

      ok(YES, @"Bottom Ratioed Test");
    };
    return ret;
}

- (MNTestBlockStruct*)awkward:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"4/4"];

    MNBeam* beam = [[MNBeam alloc] initWithNotes:[notes slice:[@0:11]]];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:11]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes slice:[@11:14]]];
    [tuplet1 setBeatsOccupied:142];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:YES];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beam draw:ctx];

      [[tuplet1 setRatioed:YES] draw:ctx];
      [[[tuplet2 setRatioed:YES] setBracketed:YES] draw:ctx];

      ok(YES, @"Awkward Test");
    };

    return ret;
}

- (MNTestBlockStruct*)complex:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes1 = @[
        [newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8d" }) addDotToAll],
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];
    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" })
    ];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    MNBeam* beam1 = [[MNBeam alloc] initWithNotes:[notes1 slice:[@0:3]]];
    MNBeam* beam2 = [[MNBeam alloc] initWithNotes:[notes1 slice:[@5:9]]];
    MNBeam* beam3 = [[MNBeam alloc] initWithNotes:[notes1 slice:[@11:16]]];

    MNTuplet* tuplet1 = [[MNTuplet alloc] initWithNotes:[notes1 slice:[@0:3]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes1 slice:[@3:11]]
                                         andOptionsDict:@{
                                             @"num_notes" : @7,
                                             @"beats_occupied" : @4
                                         }];
    MNTuplet* tuplet3 =
        [[MNTuplet alloc] initWithNotes:[notes1 slice:[@11:16]] andOptionsDict:@{
            @"beats_occupied" : @4
        }];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"4/4"];

    [voice1 setStrict:YES];
    [voice1 addTickables:notes1];

    [voice2 setStrict:YES];
    [voice2 addTickables:notes2];

    //        MNFormatter *formatter = [MNFormatter formatter] joinVoices:@[voice1, voice2]).
    //        format([voice1, voice2], c.staff.getNoteEndX() - c.staff.getNoteStartX() - 50);

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice1, voice2 ]] formatWith:@[ voice1, voice2 ] withJustifyWidth:400];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [tuplet1 draw:ctx];
      [tuplet2 draw:ctx];
      [tuplet3 draw:ctx];

      [beam1 draw:ctx];
      [beam2 draw:ctx];
      [beam3 draw:ctx];

      ok(YES, @"Complex Test");
    };

    return ret;
}

- (MNTestBlockStruct*)mixedTop:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/6" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/6" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" })
    ];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 60, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"4/4"];

    MNTuplet* tuplet1 =
        [[MNTuplet alloc] initWithNotes:[notes slice:[@0:2]] andOptionsDict:@{
            @"beats_occupied" : @(3)
        }];
    MNTuplet* tuplet2 =
        [[MNTuplet alloc] initWithNotes:[notes slice:[@2:4]] andOptionsDict:@{
            @"beats_occupied" : @(3)
        }];
    MNTuplet* tuplet3 =
        [[MNTuplet alloc] initWithNotes:[notes slice:[@4:6]] andOptionsDict:@{
            @"beats_occupied" : @(3)
        }];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [tuplet1 draw:ctx];
      [tuplet2 draw:ctx];
      [tuplet3 draw:ctx];

      ok(YES, @"Mixed Stem Direction Tuplet");
    };

    return ret;
}

- (MNTestBlockStruct*)mixedBottom:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* dict)
    {
        return [[MNStaffNote alloc] initWithDictionary:dict];
    };

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"f/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"4" })
    ];

    MNTuplet* tuplet1 =
        [[MNTuplet alloc] initWithNotes:[notes slice:[@0:2]] andOptionsDict:@{
            @"beats_occupied" : @(3)
        }];
    MNTuplet* tuplet2 =
        [[MNTuplet alloc] initWithNotes:[notes slice:[@2:4]] andOptionsDict:@{
            @"beats_occupied" : @(3)
        }];
    MNTuplet* tuplet3 =
        [[MNTuplet alloc] initWithNotes:[notes slice:[@4:6]] andOptionsDict:@{
            @"beats_occupied" : @(3)
        }];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];
    [[staff addTrebleGlyph] addTimeSignatureWithName:@"4/4"];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [tuplet1 setTupletLocation:MNTupletLocationBottom];
      [tuplet2 setTupletLocation:MNTupletLocationBottom];
      [tuplet3 setTupletLocation:MNTupletLocationBottom];

      [tuplet1 draw:ctx];
      [tuplet2 draw:ctx];
      [tuplet3 draw:ctx];

      ok(YES, @"Mixed Stem Direction Bottom Tuplet");
    };

    return ret;
}

@end
