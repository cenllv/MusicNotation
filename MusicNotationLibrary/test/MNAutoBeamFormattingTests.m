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
    [self runTest:@"Simple Auto Beaming" func:@selector(simpleAuto:withTitle:) frame:CGRectMake(0, 0, 600, 150)];
    [self runTest:@"Even Group Stem Directions"
             func:@selector(evenGroupStemDirections:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Odd Group Stem Directions"
             func:@selector(oddGroupStemDirections:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Odd Beam Groups Auto Beaming"
             func:@selector(oddBeamGroups:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"More Simple Auto Beaming 0"
             func:@selector(moreSimple0:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"More Simple Auto Beaming 1"
             func:@selector(moreSimple1:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Break Beams on Rest" func:@selector(breakBeamsOnRests:withTitle:) frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Beam Across All Rests"
             func:@selector(beamAcrossAllRests:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Beam Across All Rests with Stemlets"
             func:@selector(beamAcrossAllRestsWithStemlets:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Break Beams on Middle Rests Only"
             func:@selector(beamAcrossMiddleRests:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Break Beams on Rest 2"
             func:@selector(breakBeamsOnRests2:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Maintain Stem Directions"
             func:@selector(maintainStemDirections:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Maintain Stem Directions - Beam Over Rests"
             func:@selector(maintainStemDirectionsBeamAcrossRests:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Beat group with unbeamable note - 2/2"
             func:@selector(groupWithUnbeamableNote:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Offset beat grouping - 6/8 "
             func:@selector(groupWithUnbeamableNote1:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"Odd Time - Guessing Default Beam Groups"
             func:@selector(autoOddBeamGroups:withTitle:)
            frame:CGRectMake(0, 0, 600, 400)];
    [self runTest:@"Custom Beam Groups" func:@selector(customBeamGroups:withTitle:) frame:CGRectMake(0, 0, 600, 400)];
    [self runTest:@"Simple Tuplet Auto Beaming"
             func:@selector(simpleTuplets:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"More Simple Tuplet Auto Beaming"
             func:@selector(moreSimpleTuplets:withTitle:)
            frame:CGRectMake(0, 0, 600, 200)];
    [self runTest:@"More Automatic Beaming" func:@selector(moreBeaming:withTitle:) frame:CGRectMake(0, 0, 600, 200)];
}

+ (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size
                              withParent:(MNTestCollectionItemView*)parent
                               withTitle:(NSString*)title
{
    NSUInteger w = size.width;
    NSUInteger h = size.height;

    w = w != 0 ? w : 450;
    h = h != 0 ? h : 140;

//    [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (MNTestTuple*)simpleAuto:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    MNVoice* voice;
    MNFormatter* formatter;
    NSArray* beams;

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    NSArray* notes = @[
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

    // Takes a voice and returns it's auto beamsj
    beams = [MNBeam applyAndGetBeams:voice];

    formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      /*
    [staff draw:ctx];
    [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
    [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      [beam draw:ctx];
    }];
       */

      ok(YES, @"Auto Beaming Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)evenGroupStemDirections:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

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

    // Takes a voice and returns it's auto beamsj
    NSArray* beams = [MNBeam applyAndGetBeams:voice];

    //      MNFormatter* formatter =
    //    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    assertThatInteger([beams[0] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[1] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[2] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[3] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[4] stemDirection], equalToInteger(MNStemDirectionDown));
    assertThatInteger([beams[5] stemDirection], equalToInteger(MNStemDirectionDown));

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beaming Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)oddGroupStemDirections:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    // Takes a voice and returns it's auto beamsj
    NSArray* beams = [MNBeam applyAndGetBeams:voice groups:groups];

    assertThatInteger([beams[0] stemDirection], describedAs(@"Notes are equa-distant from middle line",
                                                            equalToInteger(MNStemDirectionDown), nil));
    assertThatInteger([beams[1] stemDirection], equalToInteger(MNStemDirectionDown));
    assertThatInteger([beams[2] stemDirection], equalToInteger(MNStemDirectionUp));
    assertThatInteger([beams[3] stemDirection],
                      describedAs(@"Notes are equadistant from middle line", equalToInteger(MNStemDirectionDown), nil));

    //      MNFormatter* formatter =
    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beaming Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)oddBeamGroups:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    // Takes a voice and returns it's auto beamsj
    NSArray* beams = [MNBeam applyAndGetBeams:voice groups:groups];

    //      MNFormatter* formatter =
    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)moreSimple0:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam applyAndGetBeams:voice];

    //      MNFormatter* formatter =
    //    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];
    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)moreSimple1:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam applyAndGetBeams:voice];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)breakBeamsOnRests:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam generateBeams:notes withDictionary:@{ @"beam_rests" : @(NO) }];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)beamAcrossAllRestsWithStemlets:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam generateBeams:notes withDictionary:@{ @"beam_rests" : @(YES), @"show_stemlets" : @(YES) }];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)beamAcrossAllRests:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam generateBeams:notes withDictionary:@{ @"beam_rests" : @(YES) }];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)beamAcrossMiddleRests:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams =
        [MNBeam generateBeams:notes withDictionary:@{
            @"beam_rests" : @(YES),
            @"beam_middle_only" : @(YES)
        }];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)breakBeamsOnRests2:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
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

        NSArray* beams = Vex.Flow.Beam.generateBeams(notes, {
        beam_rests: NO
        });

        MNFormatter *formatter = [MNFormatter formatter] joinVoices:@[voice]
        formatTostaff([voice], c.staff);

    [c.staff draw:ctx];
        [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];

        beams.forEach(function(beam){
            beam.setContext(c.context) draw:ctx];
        });
        ok(YES, @"Auto Beam Applicator Test");
    }
     */
    return ret;
}

- (MNTestTuple*)maintainStemDirections:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(450, 200) withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams =
        [MNBeam generateBeams:notes withDictionary:@{
            @"beam_rests" : @(NO),
            @"maintain_stem_directions" : @(YES)
        }];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)maintainStemDirectionsBeamAcrossRests:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(450, 200) withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams =
        [MNBeam generateBeams:notes withDictionary:@{
            @"beam_rests" : @(YES),
            @"maintain_stem_directions" : @(YES)
        }];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)groupWithUnbeamableNote:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(450, 200) withParent:parent withTitle:title];

    [c.staff addTimeSignatureWithName:@"2/2"];

    //      [c.staff draw:ctx];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam generateBeams:notes
                            withDictionary:@{
                                @"groups" : @[ Rational(2, 2) ],
                                @"beam_rests" : @(NO),
                                @"maintain_stem_directions" : @(YES)
                            }];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)groupWithUnbeamableNote1:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(450, 200) withParent:parent withTitle:title];

    [c.staff addTimeSignatureWithName:@"6/8"];

    //      [c.staff draw:ctx];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam generateBeams:notes
                            withDictionary:@{
                                @"groups" : @[ Rational(3, 8) ],
                                @"beam_rests" : @(NO),
                                @"maintain_stem_directions" : @(YES)
                            }];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.voices addObject:voice];
    [ret.formatters addObject:formatter];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)autoOddBeamGroups:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff1 = [[MNStaff staffWithRect:CGRectMake(10, 10, 450, 0)] addTrebleGlyph];
    [staff1 addTimeSignatureWithName:@"5/4"];

    MNStaff* staff2 = [[MNStaff staffWithRect:CGRectMake(40, 150, 450, 0)] addTrebleGlyph];
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

    //      [staff1 draw:ctx];
    //      [staff2 draw:ctx];
    //      [staff3 draw:ctx];

    //      NSArray* groups1316 = @[ Rational(3, 16), Rational(2, 16) ];

    NSArray* beams =
        [MNBeam applyAndGetBeams:voice1 groups:[MNBeam getDefaultBeamGroupsForTimeSignatureType:MNTime5_4]];
    NSArray* beams2 =
        [MNBeam applyAndGetBeams:voice2 groups:[MNBeam getDefaultBeamGroupsForTimeSignatureType:MNTime5_8]];
    NSArray* beams3 =
        [MNBeam applyAndGetBeams:voice3 groups:[MNBeam getDefaultBeamGroupsForTimeSignatureType:MNTime13_16]];

    MNFormatter* formatter1 = [[MNFormatter formatter] formatToStaff:@[ voice1 ] staff:staff1];
    MNFormatter* formatter2 = [[MNFormatter formatter] formatToStaff:@[ voice2 ] staff:staff2];
    MNFormatter* formatter3 = [[MNFormatter formatter] formatToStaff:@[ voice3 ] staff:staff3];

    [ret.staves addObjectsFromArray:@[ staff1, staff2, staff3 ]];
    [ret.voices addObjectsFromArray:@[ voice1, voice2, voice3 ]];
    [ret.formatters addObjectsFromArray:@[ formatter1, formatter2, formatter3 ]];
    [ret.beams addObjectsFromArray:@[ beams, beams2, beams3 ]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      /*
    [staff1 draw:ctx];
    [staff2 draw:ctx];
    [staff3 draw:ctx];

    [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
    [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff2];
    [voice3 draw:ctx dirtyRect:CGRectZero toStaff:staff3];

    [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      [beam draw:ctx];
    }];
    [beams2 foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      [beam draw:ctx];
    }];
    [beams3 foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      [beam draw:ctx];
    }];
       */

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)customBeamGroups:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
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

    //      [staff1 draw:ctx];
    //      [staff2 draw:ctx];
    //      [staff3 draw:ctx];

    NSArray* group1 = @[ Rational(5, 8) ];

    NSArray* group2 = @[ Rational(3, 8), Rational(2, 8) ];

    NSArray* group3 = @[ Rational(7, 16), Rational(2, 16), Rational(4, 16) ];

    NSArray* beams = [MNBeam applyAndGetBeams:voice1 groups:group1];
    NSArray* beams2 = [MNBeam applyAndGetBeams:voice2 groups:group2];
    NSArray* beams3 = [MNBeam applyAndGetBeams:voice3 groups:group3];

    MNFormatter* formatter1 = [MNFormatter formatter];
    MNFormatter* formatter2 = [MNFormatter formatter];
    MNFormatter* formatter3 = [MNFormatter formatter];
    [formatter1 formatToStaff:@[ voice1 ] staff:staff1];
    [formatter2 formatToStaff:@[ voice2 ] staff:staff2];
    [formatter3 formatToStaff:@[ voice3 ] staff:staff3];

    [ret.staves addObjectsFromArray:@[ staff1, staff2, staff3 ]];
    [ret.voices addObjectsFromArray:@[ voice1, voice2, voice3 ]];
    [ret.formatters addObjectsFromArray:@[ formatter1, formatter2, formatter3 ]];
    [ret.beams addObjectsFromArray:@[ beams, beams2, beams3 ]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      //      [staff1 draw:ctx];
      //      [staff2 draw:ctx];
      //      [staff3 draw:ctx];
      //
      //      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff1];
      //      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      //      [voice3 draw:ctx dirtyRect:CGRectZero toStaff:staff3];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];
      //      [beams2 foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];
      //      [beams3 foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)simpleTuplets:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam applyAndGetBeams:voice];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.formatters addObject:formatter];
    [ret.voices addObject:voice];
    [ret.beams addObject:beams];
    [ret.drawables addObjectsFromArray:@[ triplet1, quintuplet ]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      //      [c.staff draw:ctx];
      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];
      //
      //      [triplet1 draw:ctx];
      //      [quintuplet draw:ctx];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)moreSimpleTuplets:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam applyAndGetBeams:voice];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.formatters addObject:formatter];
    [ret.voices addObject:voice];
    [ret.beams addObject:beams];
    [ret.drawables addObjectsFromArray:@[ triplet1 ]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];
      //
      //      [triplet1 draw:ctx];

      ok(YES, @"Auto Beam Applicator Test");
    };
    return ret;
}

- (MNTestTuple*)moreBeaming:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeZero() withParent:parent withTitle:title];

    NSArray* notes = @[
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

    NSArray* beams = [MNBeam applyAndGetBeams:voice];

    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:c.staff];

    [ret.staves addObject:c.staff];
    [ret.formatters addObject:formatter];
    [ret.voices addObject:voice];
    [ret.beams addObject:beams];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      //
      //      [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
      //        [beam draw:ctx];
      //      }];

      ok(YES, @"Auto Beam Applicator Test");
    };

    return ret;
}

@end
