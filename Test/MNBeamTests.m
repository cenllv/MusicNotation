//
//  MNBeamTests.m
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

#import "MNBeamTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNBeamTests

- (void)start
{
    [super start];
    [self runTest:@"Simple Beam" func:@selector(simple:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Multi Beam" func:@selector(multi:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Sixteenth Beam" func:@selector(sixteenth:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Slopey Beam" func:@selector(slopey:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Auto-stemmed Beam" func:@selector(autoStem:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Mixed Beam 1" func:@selector(mixed:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Mixed Beam 2" func:@selector(mixed2:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Dotted Beam" func:@selector(dotted:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Close Trade-offs Beam" func:@selector(tradeoffs:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Insane Beam" func:@selector(insane:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Lengthy Beam" func:@selector(lengthy:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Outlier Beam" func:@selector(outlier:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Break Secondary Beams" func:@selector(breakSecondaryBeams:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"TabNote Beams Up" func:@selector(tabBeamsUp:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"TabNote Beams Down" func:@selector(tabBeamsDown:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"TabNote Auto Create Beams" func:@selector(autoTabBeams:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"TabNote Beams Auto Stem" func:@selector(tabBeamsAutoStem:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Complex Beams with Annotations"
             func:@selector(complexWithAnnotation:)
            frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Complex Beams with Articulations"
             func:@selector(complexWithArticulation:)
            frame:CGRectMake(10, 10, 700, 250)];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)beamNotes:(NSArray*)notes staff:(MNStaff*)staff context:(CGContextRef)ctx dirtyRect:(CGRect)dirtyRect
{
    /*
     Vex.Flow.Test.Beam.beamNotes = function(notes, staff, ctx) {
      MNVoice* voice =  [MNVoice voiceWithTimeSignature:MNTime4_4];
     [voice addTickables:notes];

     MNFormatter *formatter = [[[MNFormatter formatter] joinVoices:@[voice]
     formatWith:@[voice] withJustifyWidth:300];
      MNBeam *beam = [MNBeam beamWithNotes:[notes slice:[@(1) : notes.count]]];

     [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
     beam draw:ctx];
     }
     */

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam = [MNBeam beamWithNotes:[notes slice:[@1:notes.count]]];
    [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
    [beam draw:ctx];
}

- (MNTestBlockStruct*)simple:(id<MNTestParentDelegate>)parent
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

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 700, 0)];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [self beamNotes:@[
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
                 @"stem_direction" : @1,
                 @"duration" : @"h" }) addAccidental:newAcc(@"b")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
                 @"stem_direction" : @1,
                 @"duration" : @"8" }) addAccidental:newAcc(@"b")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],
          newNote(
              @{ @"keys" : @[ @"d/4", @"f/4", @"a/4" ],
                 @"stem_direction" : @1,
                 @"duration" : @"8" }),
          [[newNote(
              @{ @"keys" : @[ @"e/4", @"g/4", @"b/4" ],
                 @"stem_direction" : @1,
                 @"duration" : @"8" }) addAccidental:newAcc(@"bb")
                                             atIndex:0] addAccidental:newAcc(@"##")
                                                              atIndex:1],
          newNote(
              @{ @"keys" : @[ @"f/4", @"a/4", @"c/5" ],
                 @"stem_direction" : @1,
                 @"duration" : @"8" }),
      ] staff:staff
              context:ctx
            dirtyRect:CGRectZero];
      ok(YES, @"Simple Test");
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

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 700, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];
    [voice2 addTickables:notes2];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatWith:@[ voice, voice2 ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];

    MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:4]]];
    MNBeam* beam2_2 = [MNBeam beamWithNotes:[notes2 slice:[@4:8]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      [beam2_1 draw:ctx];
      [beam2_2 draw:ctx];

      ok(YES, @"Multi Test");
    };
    return ret;
}

- (MNTestBlockStruct*)sixteenth:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 700, 0)];

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
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"h" })
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
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" })
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];
    [voice2 addTickables:notes2];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatWith:@[ voice, voice2 ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];

    MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:4]]];
    MNBeam* beam2_2 = [MNBeam beamWithNotes:[notes2 slice:[@4:8]]];

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

- (MNTestBlockStruct*)breakSecondaryBeams:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 600, 0)];

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
            @{ @"keys" : @[ @"c/5" ],
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
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
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
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice2 setStrict:NO];
    [voice addTickables:notes];
    [voice2 addTickables:notes2];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice, voice2 ] withJustifyWidth:500];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:6]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@6:12]]];

    [beam1_1 breakSecondaryAt:@[ @1, @3 ]];
    [beam1_2 breakSecondaryAt:@[ @2 ]];

    MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:12]]];
    MNBeam* beam2_2 = [MNBeam beamWithNotes:[notes2 slice:[@12:18]]];

    [beam2_1 breakSecondaryAt:@[ @3, @7, @11 ]];
    [beam2_2 breakSecondaryAt:@[ @3 ]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      [beam2_1 draw:ctx];
      [beam2_2 draw:ctx];

      ok(YES, @"Breaking Secondary Beams Test");
    };
    return ret;
}

- (MNTestBlockStruct*)slopey:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };



          MNStaff* staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/6" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      ok(YES, @"Slopey Test");
    };
    return ret;
}

- (MNTestBlockStruct*)autoStem:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];


    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

          MNStaff* staff =  [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];

    MNBeam* beam1 = [MNBeam beamWithNotes:[notes slice:[@0:2]]];
    beam1.autoStem = YES;
    MNBeam* beam2 = [MNBeam beamWithNotes:[notes slice:[@2:4]]];
    beam2.autoStem = YES;
    MNBeam* beam3 = [MNBeam beamWithNotes:[notes slice:[@4:6]]];
    beam3.autoStem = YES;
    MNBeam* beam4 = [MNBeam beamWithNotes:[notes slice:[@6:8]]];
    beam4.autoStem = YES;
    MNBeam* beam5 = [MNBeam beamWithNotes:[notes slice:[@8:10]]];
    beam5.autoStem = YES;
    MNBeam* beam6 = [MNBeam beamWithNotes:[notes slice:[@10:12]]];
    beam6.autoStem = YES;

    assertThatInteger(beam1.stemDirection, equalToInteger(MNStemDirectionUp));
    assertThatInteger(beam2.stemDirection, equalToInteger(MNStemDirectionUp));
    assertThatInteger(beam3.stemDirection, equalToInteger(MNStemDirectionUp));
    assertThatInteger(beam4.stemDirection, equalToInteger(MNStemDirectionUp));
    assertThatInteger(beam5.stemDirection, equalToInteger(MNStemDirectionDown));
    assertThatInteger(beam6.stemDirection, equalToInteger(MNStemDirectionDown));

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1 draw:ctx];
      [beam2 draw:ctx];
      [beam3 draw:ctx];
      [beam4 draw:ctx];
      [beam5 draw:ctx];
      [beam6 draw:ctx];

      ok(YES, @"AutoStem Beam Test");
    };
    return ret;
}

- (MNTestBlockStruct*)mixed:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 600, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
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
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
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
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),

        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),

        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice2 setStrict:NO];
    [voice addTickables:notes];
    [voice2 addTickables:notes2];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatWith:@[ voice, voice2 ] withJustifyWidth:390];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];

    MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:4]]];
    MNBeam* beam2_2 = [MNBeam beamWithNotes:[notes2 slice:[@4:8]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      [beam2_1 draw:ctx];
      [beam2_2 draw:ctx];

      ok(YES, @"Multi Test");
    };
    return ret;
}

- (MNTestBlockStruct*)mixed2:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 600, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"64" }),

        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"128" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"32" }),

        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"64" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"128" })
    ];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"64" }),

        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"128" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),

        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"64" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"128" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice2 setStrict:NO];
    [voice addTickables:notes];
    [voice2 addTickables:notes2];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatWith:@[ voice, voice2 ] withJustifyWidth:390];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:12]]];

    MNBeam* beam2_1 = [MNBeam beamWithNotes:[notes2 slice:[@0:12]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam2_1 draw:ctx];

      ok(YES, @"Multi Test");
    };
    return ret;
}

- (MNTestBlockStruct*)dotted:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 700, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        [newNote(
            @{ @"keys" : @[ @"b/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"8d" }) addDotToAll],
        newNote(
            @{ @"keys" : @[ @"a/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),

        [newNote(
            @{ @"keys" : @[ @"b/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"8d" }) addDotToAll],
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),

        [newNote(
            @{ @"keys" : @[ @"a/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"8d" }) addDotToAll],
        newNote(
            @{ @"keys" : @[ @"a/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" }),
        [newNote(
            @{ @"keys" : @[ @"b/3" ],
               @"stem_direction" : @(1),
               @"duration" : @"8d" }) addDotToAll],
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"16" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    //        [voice setMode:MNModeSoft];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:390];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];
    MNBeam* beam1_3 = [MNBeam beamWithNotes:[notes slice:[@8:12]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];
      [beam1_3 draw:ctx];

      ok(YES, @"Dotted Test");
    };
    return ret;
}

- (MNTestBlockStruct*)tradeoffs:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 700, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      ok(YES, @"Close Trade-offs Test");
    };
    return ret;
}

- (MNTestBlockStruct*)insane:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 700, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:7]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      ok(YES, @"Insane Test");
    };
    return ret;
}

- (MNTestBlockStruct*)lengthy:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 700, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];

      ok(YES, @"Lengthy Test");
    };
    return ret;
}

- (MNTestBlockStruct*)outlier:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 500, 0)];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]]];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      ok(YES, @"Outlier Test");
    };
    return ret;
}

- (MNTestBlockStruct*)tabBeamsUp:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    //    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(500, 200) withParent:parent];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 500, 0)];

    NSArray* specs = @[
        @{
            @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"25"} ],
            @"duration" : @"4"
        },
        @{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(5), @"fret" : @"12"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"16"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"32"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"64"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"128"
        },
        @{ @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"} ],
           @"duration" : @"8" }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:noteSpec];
      [[tabNote renderOptions] setDraw_stem:YES];
      return tabNote;
    }];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    MNBeam* beam1 = [MNBeam beamWithNotes:[notes slice:[@1:7]]];
    MNBeam* beam2 = [MNBeam beamWithNotes:[notes slice:[@8:11]]];

    MNTuplet* tuplet = [[MNTuplet alloc] initWithNotes:[notes slice:[@8:11]]];
    tuplet.ratioed = YES;

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1 draw:ctx];
      [beam2 draw:ctx];

      [tuplet draw:ctx];

      ok(YES, @"All objects have been drawn");
    };
    return ret;
}

- (MNTestBlockStruct*)tabBeamsDown:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 550, 0) optionsDict:@{ @"numLines" : @(10) }];
    staff.numberOfLines = 10;

    NSArray* specs = @[
        @{
            @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"25"} ],
            @"duration" : @"4"
        },
        @{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(5), @"fret" : @"12"} ],
            @"duration" : @"8dd"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"16"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"32"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"64"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"128"
        },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(7), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(7), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(10), @"fret" : @"6"} ],
           @"duration" : @"8" },
        @{ @"positions" : @[ @{@"str" : @(10), @"fret" : @"6"} ],
           @"duration" : @"8" }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:noteSpec];
      [[tabNote renderOptions] setDraw_stem:YES];
      tabNote.stemDirection = -1;
      [[tabNote renderOptions] setDraw_dots:YES];
      return tabNote;
    }];

    [notes[1] addDot];
    [notes[1] addDot];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    MNBeam* beam1 = [MNBeam beamWithNotes:[notes slice:[@1:7]]];
    MNBeam* beam2 = [MNBeam beamWithNotes:[notes slice:[@8:11]]];

    MNTuplet* tuplet = [[MNTuplet alloc] initWithNotes:[notes slice:[@8:11]]];
    MNTuplet* tuplet2 = [[MNTuplet alloc] initWithNotes:[notes slice:[@11:14]]];
    [tuplet setTupletLocation:-1];
    [tuplet2 setTupletLocation:-1];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam1 draw:ctx];
      [beam2 draw:ctx];
      [tuplet draw:ctx];
      [tuplet2 draw:ctx];

      ok(YES, @"All objects have been drawn");
    };
    return ret;
}

- (MNTestBlockStruct*)autoTabBeams:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 10, 550, 0) optionsDict:@{ @"num_lines" : @(6) }];
    staff.numberOfLines = 6;

    NSArray* specs = @[
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"16"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"16"
        },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"32" },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"32" },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"32" },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"32" },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"16" },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"16" },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"16" },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"16" }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:noteSpec];
      [[tabNote renderOptions] setDraw_stem:YES];
      [[tabNote renderOptions] setDraw_dots:YES];
      return tabNote;
    }];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice direction:-1 groups:nil];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"All objects have been drawn");
    };
    return ret;
}

// This tests makes sure the auto_stem functionality is works.
// TabNote stems within a beam group should end up normalized
- (MNTestBlockStruct*)tabBeamsAutoStem:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 550, 0) optionsDict:@{ @"num_lines" : @(6) }];
    // FIXME: cannot set number of lines correctly
    staff.numberOfLines = 6;

    NSArray* specs = @[
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"8",
            @"stem_direction" : @(-1)
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"8",
            @"stem_direction" : @(1)
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"16",
            @"stem_direction" : @(-1)
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"16",
            @"stem_direction" : @(1)
        },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"32",
           @"stem_direction" : @(1) },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"} ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"16",
           @"stem_direction" : @(1) },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"16",
           @"stem_direction" : @(1) },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"16",
           @"stem_direction" : @(1) },
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"16",
           @"stem_direction" : @(-1) }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:noteSpec];
      [[tabNote renderOptions] setDraw_stem:YES];
      [[tabNote renderOptions] setDraw_dots:YES];
      return tabNote;
    }];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    //        MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    NSArray<MNBeam*>* beams = @[
        [MNBeam beamWithNotes:[notes slice:[@0:8]] autoStem:YES],    // Stems should format down
        [MNBeam beamWithNotes:[notes slice:[@8:12]] autoStem:YES],   // Stems should format up
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"All objects have been drawn");
    };
    return ret;
}

- (MNTestBlockStruct*)complexWithAnnotation:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(50, 60, 400, 0)];
    [staff addClefWithName:@"treble"];

    NSArray* notes = @[
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"128",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"d/4" ],
           @"duration" : @"16",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"8",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"g/4", @"c/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(1) }
    ];

    NSArray* notes2 = @[
        @{ @"keys" : @[ @"e/5" ],
           @"duration" : @"128",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"d/5" ],
           @"duration" : @"16",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"e/5" ],
           @"duration" : @"8",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"g/5", @"c/5" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/5" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/5" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/5" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) }
    ];

    notes = [notes oct_map:^MNStaffNote*(NSDictionary* spec) {
      return [newNote(spec) addModifier:[[MNAnnotation annotationWithText:@"1"] setVerticalJustification:1] atIndex:0];
    }];

    notes2 = [notes2 oct_map:^MNStaffNote*(NSDictionary* spec) {
      return [newNote(spec) addModifier:[[MNAnnotation annotationWithText:@"1"] setVerticalJustification:3] atIndex:0];
    }];

    MNBeam* beam = [MNBeam beamWithNotes:notes];
    MNBeam* beam2 = [MNBeam beamWithNotes:notes2];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];
    [voice addTickables:notes2];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam draw:ctx];
      [beam2 draw:ctx];

      ok(YES, @"Complex beam annotations");
    };
    return ret;
}

- (MNTestBlockStruct*)complexWithArticulation:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(50, 60, 400, 0)];
    [staff addClefWithName:@"treble"];

    NSArray* notes = @[
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"128",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"d/4" ],
           @"duration" : @"16",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"e/4" ],
           @"duration" : @"8",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"g/4", @"c/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(1) },
        @{ @"keys" : @[ @"c/4" ],
           @"duration" : @"32",
           @"stem_direction" : @(1) }
    ];

    NSArray* notes2 = @[
        @{ @"keys" : @[ @"e/5" ],
           @"duration" : @"128",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"d/5" ],
           @"duration" : @"16",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"e/5" ],
           @"duration" : @"8",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"g/5", @"c/5" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/5" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/5" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) },
        @{ @"keys" : @[ @"c/5" ],
           @"duration" : @"32",
           @"stem_direction" : @(-1) }
    ];

    notes = [notes oct_map:^MNStaffNote*(NSDictionary* spec) {
      MNArticulationType t = [MNEnum typeArticulationTypeForString:@"am"];
      return [newNote(spec) addModifier:[[[MNArticulation alloc] initWithType:t] setPosition:3] atIndex:0];
    }];

    notes2 = [notes2 oct_map:^MNStaffNote*(NSDictionary* spec) {
      MNArticulationType t = [MNEnum typeArticulationTypeForString:@"a>"];
      return [newNote(spec) addModifier:[[[MNArticulation alloc] initWithType:t] setPosition:4] atIndex:0];
    }];

    MNBeam* beam = [MNBeam beamWithNotes:notes];
    MNBeam* beam2 = [MNBeam beamWithNotes:notes2];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];
    [voice addTickables:notes2];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beam draw:ctx];
      [beam2 draw:ctx];

      ok(YES, @"Complex beam articulations");
    };
    return ret;
}

@end
