//
//  MNAutoBeamFormattingTests.m
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

#import "MNAutoBeamFormattingTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNAutoBeamFormattingTests

- (void)start
{
    [super start];
    float w = 500;
    //        float h = 200;
    [self runTest:@"Simple Auto Beaming" func:@selector(simpleAuto:) frame:CGRectMake(0, 0, w, 150)];
    [self runTest:@"Even Group Stem Directions"
             func:@selector(evenGroupStemDirections:)
            frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Odd Group Stem Directions" func:@selector(oddGroupStemDirections:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Odd Beam Groups Auto Beaming" func:@selector(oddBeamGroups:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"More Simple Auto Beaming 0" func:@selector(moreSimple0:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"More Simple Auto Beaming 1" func:@selector(moreSimple1:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Break Beams on Rest" func:@selector(breakBeamsOnRests:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Beam Across All Rests" func:@selector(beamAcrossAllRests:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Beam Across All Rests with Stemlets"
             func:@selector(beamAcrossAllRestsWithStemlets:)
            frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Break Beams on Middle Rests Only"
             func:@selector(beamAcrossMiddleRests:)
            frame:CGRectMake(0, 0, w, 200)];
    //    [self runTest:@"Break Beams on Rest 2"
    //             func:@selector(breakBeamsOnRests2:)
    // frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Maintain Stem Directions" func:@selector(maintainStemDirections:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Maintain Stem Directions - Beam Over Rests"
             func:@selector(maintainStemDirectionsBeamAcrossRests:)
            frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Beat group with unbeamable note - 2/2"
             func:@selector(groupWithUnbeamableNote:)
            frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Offset beat grouping - 6/8 "
             func:@selector(groupWithUnbeamableNote1:)
            frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"Odd Time - Guessing Default Beam Groups"
             func:@selector(autoOddBeamGroups:)
            frame:CGRectMake(0, 0, w, 400)];
    [self runTest:@"Custom Beam Groups" func:@selector(customBeamGroups:) frame:CGRectMake(0, 0, w, 400)];
    [self runTest:@"Simple Tuplet Auto Beaming" func:@selector(simpleTuplets:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"More Simple Tuplet Auto Beaming" func:@selector(moreSimpleTuplets:) frame:CGRectMake(0, 0, w, 200)];
    [self runTest:@"More Automatic Beaming" func:@selector(moreBeaming:) frame:CGRectMake(0, 0, w, 200)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestBlockStruct*)simpleAuto:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    MNVoice* voice;
    MNFormatter* formatter;
    NSArray<MNBeam*>* beams;

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"32" })
    ];

    voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    beams = [MNBeam applyAndGetBeams:voice];

    formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beaming Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)evenGroupStemDirections:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
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

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice];

    assertThatInteger([beams[0] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[1] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[2] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[3] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[4] stemDirection], equalToInteger(MNStemDirectionDown));
    assertThatInteger([beams[5] stemDirection], equalToInteger(MNStemDirectionDown));

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beaming Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)oddGroupStemDirections:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
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
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    NSArray* groups = @[ Rational(3, 8) ];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice groups:groups];

    if(beams.count == 0)
    {
        MNLogError(@"No Beams");
    }
    else
    {
        assertThatInteger([beams[0] stemDirection], describedAs(@"Notes are equa-distant from middle line",
                                                                equalToInteger(MNStemDirectionDown), nil));
        assertThatInteger([beams[1] stemDirection], equalToInteger(MNStemDirectionDown));
        assertThatInteger([beams[2] stemDirection], equalToInteger(MNStemDirectionUp));
        assertThatInteger([beams[3] stemDirection], describedAs(@"Notes are equadistant from middle line",
                                                                equalToInteger(MNStemDirectionDown), nil));
    }

    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beaming Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)oddBeamGroups:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/3" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"duration" : @"16" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray* groups = @[ Rational(2, 8), Rational(3, 8), Rational(1, 8) ];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice groups:groups];

    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)moreSimple0:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" })
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)moreSimple1:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"e/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16" })
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)breakBeamsOnRests:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"g/4", @"e/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16" })
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam generateBeams:notes withDictionary:@{ @"beam_rests" : @(NO) }];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)beamAcrossAllRestsWithStemlets:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"g/4", @"e/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16" })
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams =
        [MNBeam generateBeams:notes withDictionary:@{
            @"beam_rests" : @(YES),
            @"show_stemlets" : @(YES)
        }];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)beamAcrossAllRests:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"g/4", @"e/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam generateBeams:notes withDictionary:@{ @"beam_rests" : @(YES) }];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)beamAcrossMiddleRests:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"g/4", @"e/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"16" })
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams =
        [MNBeam generateBeams:notes withDictionary:@{
            @"beam_rests" : @(YES),
            @"beam_middle_only" : @(YES)
        }];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)breakBeamsOnRests2:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    /*
     Vex.Flow.Test.AutoBeamFormatting.breakBeamsOnRests = function(options, contextBuilder) {
        options.contextBuilder = contextBuilder;
        var c = Vex.Flow.Test.AutoBeamFormatting.setupContext(options);

        NSArray *notes = @[
                     newNote(@{ @"keys" : @[@"c/5"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"g/5"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"c/5"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"b/4"], @"duration" : @"16r"}),
                     newNote(@{ @"keys" : @[@"b/4"], @"duration" : @"16r"}),
                     newNote(@{ @"keys" : @[@"c/4", @"e/4", @"g/4"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"d/4"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"a/5"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"c/4"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"g/4"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"b/4"], @"duration" : @"16"}),
                     newNote(@{ @"keys" : @[@"b/4"], @"duration" : @"16r"}),
                     newNote(@{ @"keys" : @[@"g/4", @"e/4"], @"duration" : @"32"}),
                     newNote(@{ @"keys" : @[@"b/4"], @"duration" : @"32r"}),
                     newNote(@{ @"keys" : @[@"b/4"], @"duration" : @"32r"}),
                     newNote(@{ @"keys" : @[@"a/4"], @"duration" : @"32"}),
                     newNote(@{ @"keys" : @[@"a/4"], @"duration" : @"16r"}),
                     newNote(@{ @"keys" : @[@"a/4"], @"duration" : @"16"})
                     ];

         MNVoice *voice =  [MNVoice voiceWithTimeSignature:MNTime4_4];
        voice.mode =  MNModeSoft;
        [voice addTickables:notes];

        NSArray<MNBeam*>* beams = Vex.Flow.Beam.generateBeams(notes, {
        beam_rests: NO
        });

        MNFormatter *formatter = [MNFormatter formatter] joinVoices:@[voice]
        formatTostaff([voice], staff);

    [staff draw:ctx];
        [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

        beams.forEach(function(beam){
            beam.setContext(c.context) draw:ctx];
        });
        ok(YES, @"Auto Beam Applicator Test");
    }
     */
    return ret;
}

- (MNTestBlockStruct*)maintainStemDirections:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams =
        [MNBeam generateBeams:notes withDictionary:@{
            @"beam_rests" : @(NO),
            @"maintain_stem_directions" : @(YES)
        }];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)maintainStemDirectionsBeamAcrossRests:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32",
               @"stem_direction" : @(-1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"32" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams =
        [MNBeam generateBeams:notes withDictionary:@{
            @"beam_rests" : @(YES),
            @"maintain_stem_directions" : @(YES)
        }];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)groupWithUnbeamableNote:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    [staff addTimeSignatureWithName:@"2/2"];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16",
               @"stem_direction" : @(1) }),
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam generateBeams:notes
                                     withDictionary:@{
                                         @"groups" : @[ Rational(2, 2) ],
                                         @"beam_rests" : @(NO),
                                         @"maintain_stem_directions" : @(YES)
                                     }];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)groupWithUnbeamableNote1:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    [staff addTimeSignatureWithName:@"6/8"];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"4",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8",
               @"stem_direction" : @(1) }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8",
               @"stem_direction" : @(1) })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam generateBeams:notes
                                     withDictionary:@{
                                         @"groups" : @[ Rational(3, 8) ],
                                         @"beam_rests" : @(NO),
                                         @"maintain_stem_directions" : @(YES)
                                     }];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)autoOddBeamGroups:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff1 = [[MNStaff staffWithRect:CGRectMake(10, 10, 450, 0)] addTrebleGlyph];
    [staff1 addTimeSignatureWithName:@"5/4"];

    MNStaff* staff2 = [[MNStaff staffWithRect:CGRectMake(10, 150, 450, 0)] addTrebleGlyph];
    [staff2 addTimeSignatureWithName:@"5/8"];

    MNStaff* staff3 = [[MNStaff staffWithRect:CGRectMake(10, 290, 450, 0)] addTrebleGlyph];
    [staff3 addTimeSignatureWithName:@"13/16"];

    NSArray* notes1 = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" })
    ];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" })
    ];

    NSArray* notes3 = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" })
    ];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice1.mode = MNModeSoft;
    [voice1 addTickables:notes1];

    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice2.mode = MNModeSoft;
    [voice2 addTickables:notes2];

    MNVoice* voice3 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice3.mode = MNModeSoft;
    [voice3 addTickables:notes3];

    NSArray<MNBeam*>* beams =
        [MNBeam applyAndGetBeams:voice1 groups:[MNBeam getDefaultBeamGroupsForTimeSignatureType:MNTime5_4]];
    NSArray<MNBeam*>* beams2 =
        [MNBeam applyAndGetBeams:voice2 groups:[MNBeam getDefaultBeamGroupsForTimeSignatureType:MNTime5_8]];
    NSArray<MNBeam*>* beams3 =
        [MNBeam applyAndGetBeams:voice3 groups:[MNBeam getDefaultBeamGroupsForTimeSignatureType:MNTime13_16]];

    //    MNFormatter* formatter1 =
    [[MNFormatter formatter] formatToStaff:@[ voice1 ] staff:staff1];
    //    MNFormatter* formatter2 =
    [[MNFormatter formatter] formatToStaff:@[ voice2 ] staff:staff2];
    //    MNFormatter* formatter3 =
    [[MNFormatter formatter] formatToStaff:@[ voice3 ] staff:staff3];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff1 draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      [voice3 draw:ctx dirtyRect:CGRectZero toStaff:staff3];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];
      [beams2 oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];
      [beams3 oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)customBeamGroups:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff1 = [[MNStaff staffWithRect:CGRectMake(10, 10, 450, 0)] addTrebleGlyph];
    [staff1 addTimeSignatureWithName:@"5/4"];

    MNStaff* staff2 = [[MNStaff staffWithRect:CGRectMake(10, 150, 450, 0)] addTrebleGlyph];
    [staff2 addTimeSignatureWithName:@"5/8"];

    MNStaff* staff3 = [[MNStaff staffWithRect:CGRectMake(10, 290, 450, 0)] addTrebleGlyph];
    [staff3 addTimeSignatureWithName:@"13/16"];

    NSArray* notes1 = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" })
    ];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" })
    ];

    NSArray* notes3 = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"16" })
    ];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice1.mode = MNModeSoft;
    [voice1 addTickables:notes1];

    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice2.mode = MNModeSoft;
    [voice2 addTickables:notes2];

    MNVoice* voice3 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice3.mode = MNModeSoft;
    [voice3 addTickables:notes3];

    NSArray* group1 = @[ Rational(5, 8) ];

    NSArray* group2 = @[ Rational(3, 8), Rational(2, 8) ];

    NSArray* group3 = @[ Rational(7, 16), Rational(2, 16), Rational(4, 16) ];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice1 groups:group1];
    NSArray<MNBeam*>* beams2 = [MNBeam applyAndGetBeams:voice2 groups:group2];
    NSArray<MNBeam*>* beams3 = [MNBeam applyAndGetBeams:voice3 groups:group3];

    MNFormatter* formatter1 = [MNFormatter formatter];
    MNFormatter* formatter2 = [MNFormatter formatter];
    MNFormatter* formatter3 = [MNFormatter formatter];
    [formatter1 formatToStaff:@[ voice1 ] staff:staff1];
    [formatter2 formatToStaff:@[ voice2 ] staff:staff2];
    [formatter3 formatToStaff:@[ voice3 ] staff:staff3];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff1 draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];

      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      [voice3 draw:ctx dirtyRect:CGRectZero toStaff:staff3];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];
      [beams2 oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];
      [beams3 oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)simpleTuplets:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5", @"e/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" })
    ];

    MNTuplet* triplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];
    MNTuplet* quintuplet = [[MNTuplet alloc] initWithNotes:[notes slice:[@5:notes.count]]];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      [triplet1 draw:ctx];
      [quintuplet draw:ctx];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)moreSimpleTuplets:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    //    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5", @"e/5" ],
               @"duration" : @"16" })
    ];

    MNTuplet* triplet1 = [[MNTuplet alloc] initWithNotes:[notes slice:[@0:3]]];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      [triplet1 draw:ctx];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestBlockStruct*)moreBeaming:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    //    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, 450, 0)] addTrebleGlyph];

    NSArray<MNStaffNote*>* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"4" }),
        [newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"duration" : @"8" }) addDotToAll],
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"4" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"c/5", @"e/5" ],
               @"duration" : @"16" }),
        newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:NO];
    [voice addTickables:notes];

    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beams oct_foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
        [beam draw:ctx];
      }];

      ok(YES, @"Auto Beam Applicator Test");
    };

    return ret;
}

@end
