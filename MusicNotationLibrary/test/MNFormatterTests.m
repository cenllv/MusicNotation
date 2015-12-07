//
//  MNFormatterTests.m
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

#import "MNFormatterTests.h"
#import "MNMockTickable.h"
#import "NSArray+MNAdditions.h"

@implementation MNFormatterTests

- (void)start
{
    [super start];
    //    [self runTest:@"TickContext Building" func:@selector(buildTickContexts)];
    float w = 700;
    [self runTest:@"StaffNote Formatting" func:@selector(formatStaffNotes:) frame:CGRectMake(10, 10, 400, 200)];
    [self runTest:@"StaffNote Justification" func:@selector(justifyStaffNotes:) frame:CGRectMake(10, 10, w, 500)];
    [self runTest:@"Notes with Tab" func:@selector(notesWithTab:) frame:CGRectMake(10, 10, w, 450)];
    [self runTest:@"Format Multiple staffs - No Justification"
             func:@selector(multistaffs:params:)
            frame:CGRectMake(10, 10, w, 350)
           params:@{
               @"justify" : @(0)
           }];
    [self runTest:@"Format Multiple staffs - Justified"
             func:@selector(multistaffs:params:)
            frame:CGRectMake(10, 10, w, 350)
           params:@{
               @"justify" : @(200)
           }];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)buildTickContexts
{
    /*
    Vex.Flow.Test.Formatter.buildTickContexts = function() {
        function createTickable() {
            return new Vex.Flow.Test.MockTickable();
        }

        var R = kRESOLUTION;
        var BEAT = 1 * R / 4;

        var tickables1 = [
                          createTickable().setTicks(BEAT).setWidth(10),
                          createTickable().setTicks(BEAT * 2).setWidth(20),
                          createTickable().setTicks(BEAT).setWidth(30)
                          ];

        var tickables2 = [
                          createTickable().setTicks(BEAT * 2).setWidth(10),
                          createTickable().setTicks(BEAT).setWidth(20),
                          createTickable().setTicks(BEAT).setWidth(30)
                          ];

        var voice1 =  [MNVoice voiceWithTimeSignature:MNTime4_4];
        var voice2 =  [MNVoice voiceWithTimeSignature:MNTime4_4];

        voice1.addTickables(tickables1);
        voice2.addTickables(tickables2);

        MNFormatter *formatter = new Vex.Flow.Formatter();
        var tContexts = formatter.createTickContexts([voice1, voice2]);

        equal(tContexts.list.length, 4, "Voices should have four tick contexts");

        // TODO: add this after pull request #68 is merged to master
        // throws(
        //   function() { formatter.getMinTotalWidth(); },
        //   Vex.RERR,
        //   "Expected to throw exception"
        // );

        ok(formatter.preCalculateMinTotalWidth([voice1, voice2]),
           'Successfully runs preCalculateMinTotalWidth');
        equal(formatter.getMinTotalWidth(), 104,
              "Get minimum total width without passing voices");

        formatter preFormat];
        equal(formatter.getMinTotalWidth(), 104, "Minimum total width");

        equal(tickables1[0].getX(), tickables2[0].getX(),
              "First notes of both voices have the same X");
        equal(tickables1[2].getX(), tickables2[2].getX(),
              "Last notes of both voices have the same X");
        ok(tickables1[1].getX() < tickables2[1].getX(),
           "Second note of voice 2 is to the right of the second note of voice 1");
    }
     */

    MockTickable* (^createTickable)() = ^MockTickable*()
    {
        return [[MockTickable alloc] init];
    };

    NSUInteger R = kRESOLUTION;
    MNRational* BEAT = Rational(1 * R / 4, 1);

    NSArray* tickables1 = @[
        [[((MockTickable*)createTickable())setCustomTicks:BEAT] setCustomWidth:10],
        [[((MockTickable*)createTickable())setCustomTicks:[BEAT mult:2]] setCustomWidth:20],
        [[((MockTickable*)createTickable())setCustomTicks:BEAT] setCustomWidth:30],
    ];

    NSArray* tickables2 = @[
        [[((MockTickable*)createTickable())setCustomTicks:[BEAT mult:2]] setCustomWidth:10],
        [[((MockTickable*)createTickable())setCustomTicks:BEAT] setCustomWidth:20],
        [[((MockTickable*)createTickable())setCustomTicks:BEAT] setCustomWidth:30],
    ];

    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice1 addTickables:tickables1];
    [voice2 addTickables:tickables2];

    MNFormatter* formatter = [MNFormatter formatter];
    MNFormatterContext* tContexts = [formatter createTickContexts:@[ voice1, voice2 ]];

    assertThatInteger(tContexts.list.count,
                      describedAs(@"Voices should have four tick contexts", equalToInteger(4), nil));

    // TODO: add this after pull request #68 is merged to master
    // throws(
    //   function() { formatter.getMinTotalWidth(); },
    //   Vex.RERR,
    //   "Expected to throw exception"
    // );

    BOOL result = [formatter preCalculateMinTotalWidth:@[ voice1, voice2 ]];
    assertThatBool(result, describedAs(@"Successfully runs preCalculateMinTotalWidth", isTrue(), nil));

    assertThatInteger(formatter.minTotalWidth,
                      describedAs(@"Get minimum total width without passing voices", equalToInteger(104), nil));

    [formatter preFormat];
    assertThatInteger(formatter.minTotalWidth, describedAs(@"Minimum total width", equalToInteger(104), nil));

    assertThatInteger(((id<MNTickableDelegate>)tickables1[0]).x,
                      describedAs(@"First notes of both voices have the same X",
                                  equalToInteger(((id<MNTickableDelegate>)tickables2[0]).x), nil));
    assertThatInteger(((id<MNTickableDelegate>)tickables1[2]).x,
                      describedAs(@"Last notes of both voices have the same X",
                                  equalToInteger(((id<MNTickableDelegate>)tickables2[2]).x), nil));

    assertThat(
        [NSNumber numberWithUnsignedInteger:((id<MNTickableDelegate>)tickables1[1]).x],
        describedAs(@"Successfully runs preCalculateMinTotalWidth",
                    lessThan([NSNumber numberWithUnsignedInteger:((id<MNTickableDelegate>)tickables2[1]).x]), nil));
}

- (void)renderNotes:(NSArray*)notes1
           andNotes:(NSArray*)notes2
            context:(CGContextRef)ctx
          dirtyRect:(CGRect)dirtyRect
              staff:(MNStaff*)staff
            justify:(NSUInteger)justify
{
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice1 addTickables:notes1];
    [voice2 addTickables:notes2];

    MNFormatter* formatter = [MNFormatter formatter];
    [formatter joinVoices:@[ voice1, voice2 ]];
    [formatter formatWith:@[ voice1, voice2 ] withJustifyWidth:justify];

    [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
    [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
}

- (MNTestBlockStruct*)formatStaffNotes:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(20, 40, 300, 0)];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    NSArray* notes1 = @[
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }))addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
        ((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" })),
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }))addAccidental:newAcc(@"n")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1]
    ];

    NSArray* notes2 = @[
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"c/5", @"e/5", @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"h" }))addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
        ((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/5", @"e/5", @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" })),
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"f/5", @"a/5", @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }))addAccidental:newAcc(@"n")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1]
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [self renderNotes:notes1 andNotes:notes2 context:ctx dirtyRect:CGRectZero staff:staff justify:0];

      assertThatBool(YES, describedAs(@"", isTrue(), nil));
    };
    return ret;
}

+ (NSArray*)getNotes
{
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    NSArray* notes1 = @[
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }))addAccidental:newAcc(@"bb")
                                           atIndex:0] addAccidental:newAcc(@"n")
                                                            atIndex:1],
        ((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })),
        ((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4", @"f/4", @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })),
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"f/4", @"a/4", @"c/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }))addAccidental:newAcc(@"n")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1]
    ];

    NSArray* notes2 = @[
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"b/4", @"e/5", @"a/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }))addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
        ((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/5", @"e/5", @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"h" })),
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"f/5", @"a/5", @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }))addAccidental:newAcc(@"##")
                                           atIndex:0] addAccidental:newAcc(@"b")
                                                            atIndex:1]
    ];

    return @[ notes1, notes2 ];
}

- (MNTestBlockStruct*)justifyStaffNotes:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    // Get test voices.
    NSArray* notes = [MNFormatterTests getNotes];

    MNStaff* staff1 = [[MNStaff staffWithRect:CGRectMake(10, 30, 400, 0)] addTrebleGlyph];
    MNStaff* staff2 = [[MNStaff staffWithRect:CGRectMake(10, 180, 400, 0)] addTrebleGlyph];
    MNStaff* staff3 = [[MNStaff staffWithRect:CGRectMake(10, 330, 400, 0)] addTrebleGlyph];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff1 draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];
      [self renderNotes:notes[0] andNotes:notes[1] context:ctx dirtyRect:CGRectZero staff:staff1 justify:0];
      [self renderNotes:notes[0] andNotes:notes[1] context:ctx dirtyRect:CGRectZero staff:staff2 justify:300];
      [self renderNotes:notes[0] andNotes:notes[1] context:ctx dirtyRect:CGRectZero staff:staff3 justify:400];

      ok(YES, @"");
    };
    return ret;
}

+ (NSDictionary*)getTabNotes
{
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNTabNote* (^newTabNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    NSArray* notes1 = @[
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"h" }))addAccidental:newAcc(@"#")
                                           atIndex:0],
        ((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"c/4", @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })),
        ((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" })),
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"c/4", @"a/4", @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }))addAccidental:newAcc(@"#")
                                           atIndex:0]
    ];

    NSArray* tabs1 = @[
        [((MNTabNote*)newTabNote(
            @{ @"positions" : @[ @{@"str" : @3, @"fret" : @"6"} ],
               @"duration" : @"h" }))addModifier:[MNBend bendWithText:@"Full"]
                                         atIndex:0],
        [((MNTabNote*)newTabNote(@{
            @"positions" : @[ @{@"str" : @2, @"fret" : @"3"}, @{@"str" : @3, @"fret" : @"5"} ],
            @"duration" : @"8"
        }))addModifier:[MNBend bendWithText:@"Unison"]
                atIndex:0],
        ((MNTabNote*)newTabNote(
            @{ @"positions" : @[ @{@"str" : @3, @"fret" : @"7"} ],
               @"duration" : @"8" })),
        ((MNTabNote*)newTabNote(@{
            @"positions" :
                @[ @{@"str" : @3, @"fret" : @"6"}, @{@"str" : @4, @"fret" : @"7"}, @{@"str" : @2, @"fret" : @"5"} ],
            @"duration" : @"q"
        })),
    ];

    return @{ @"notes" : notes1, @"tabs" : tabs1 };
}

- (MNTestBlockStruct*)renderNotesWithTab:(NSDictionary*)notes
                                 context:(CGContextRef)ctx
                               dirtyRect:(CGRect)dirtyRect
                                  staffs:(NSDictionary*)staffs
                                 justify:(NSUInteger)justify
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* tabVoice = [MNVoice voiceWithTimeSignature:MNTime4_4];

    [voice addTickables:notes[@"notes"]];
    [tabVoice addTickables:notes[@"tabs"]];

    MNFormatter* formatter = [MNFormatter formatter];
    [formatter joinVoices:@[
        voice,
    ]];
    [formatter formatWith:@[ voice, tabVoice ] withJustifyWidth:justify];

    [voice draw:ctx dirtyRect:CGRectZero toStaff:staffs[@"notes"]];
    [tabVoice draw:ctx dirtyRect:CGRectZero toStaff:staffs[@"tabs"]];
    return ret;
}

- (MNTestBlockStruct*)notesWithTab:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    NSDictionary* notes = [MNFormatterTests getTabNotes];
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 400, 0)] addTrebleGlyph];

    MNTabStaff* tabStaff = [[MNTabStaff staffWithRect:CGRectMake(10, 100, 400, 0)] addTabGlyph];
    [tabStaff setNoteStartX:tabStaff.noteStartX];

    MNStaff* staff2 = [[MNStaff staffWithRect:CGRectMake(10, 200, 400, 0)] addTrebleGlyph];

    MNTabStaff* tabStaff2 = [[MNTabStaff staffWithRect:CGRectMake(10, 300, 400, 0)] addTabGlyph];
    [tabStaff2 setNoteStartX:tabStaff2.noteStartX];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [tabStaff draw:ctx];
      [self renderNotesWithTab:notes
                       context:ctx
                     dirtyRect:CGRectZero
                        staffs:@{
                            @"notes" : staff,
                            @"tabs" : tabStaff
                        }
                       justify:300];
      ok(YES, @"");

      [staff2 draw:ctx];
      [tabStaff2 draw:ctx];
      [self renderNotesWithTab:notes
                       context:ctx
                     dirtyRect:CGRectZero
                        staffs:@{
                            @"notes" : staff2,
                            @"tabs" : tabStaff2
                        }
                       justify:300];
      ok(YES, @"");
    };
    return ret;
}

- (MNTestBlockStruct*)multistaffs:(id<MNTestParentDelegate>)parent params:(NSDictionary*)params
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

    MNStaff* staff11 =
        [[[MNStaff staffWithRect:CGRectMake(20, 10, 255, 0)] addTrebleGlyph] addTimeSignatureWithName:@"6/8"];

    MNStaff* staff21 =
        [[[MNStaff staffWithRect:CGRectMake(20, 100, 255, 0)] addTrebleGlyph] addTimeSignatureWithName:@"6/8"];

    MNStaff* staff31 =
        [[[MNStaff staffWithRect:CGRectMake(20, 210, 255, 0)] addClefWithName:@"bass"] addTimeSignatureWithName:@"6/8"];
    MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff21 andBottomStaff:staff31];
    [connector setType:MNStaffConnectorBrace];

    NSArray* notes11 = @[
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"duration" : @"q" }))setStaff:staff11],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"duration" : @"8" }))setStaff:staff11],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"g/4" ],
               @"duration" : @"q" }))setStaff:staff11],
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"duration" : @"8" }))setStaff:staff11] addAccidental:newAcc(@"b")
                                                             atIndex:0]
    ];

    NSArray* notes21 = @[
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }))setStaff:staff21],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }))setStaff:staff21],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }))setStaff:staff21],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }))setStaff:staff21],
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }))setStaff:staff21] addAccidental:newAcc(@"b")
                                                             atIndex:0],
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }))setStaff:staff21] addAccidental:newAcc(@"b")
                                                             atIndex:0],
    ];

    NSArray* notes31 = @[
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff31],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff31],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff31],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff31],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff31],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff31]
    ];

    MNVoice* voice11 = [MNVoice voiceWithTimeSignature:MNTime6_8];
    [voice11 addTickables:notes11];
    MNVoice* voice21 = [MNVoice voiceWithTimeSignature:MNTime6_8];
    [voice21 addTickables:notes21];
    MNVoice* voice31 = [MNVoice voiceWithTimeSignature:MNTime6_8];
    [voice31 addTickables:notes31];

    if([params[@"justify"] floatValue] > 0)
    {
        float justify = [params[@"justify"] floatValue];
        [[[MNFormatter formatter] joinVoices:@[ voice11, voice21, voice31 ]] formatWith:@[ voice11, voice21, voice31 ]
                                                                       withJustifyWidth:justify];
    }
    else
    {
        [[[MNFormatter formatter] joinVoices:@[ voice11, voice21, voice31 ]] formatWith:@[ voice11, voice21, voice31 ]];
    }

    MNBeam* beam21a = [MNBeam beamWithNotes:notes21[[@0:3]]];
    MNBeam* beam21b = [MNBeam beamWithNotes:notes21[[@3:6]]];
    MNBeam* beam31a = [MNBeam beamWithNotes:notes31[[@0:3]]];
    MNBeam* beam31b = [MNBeam beamWithNotes:notes31[[@3:6]]];

    MNStaff* staff12 = [MNStaff staffWithRect:CGRectMake(staff11.width + staff11.x, staff11.y, 250, 0)];
    MNStaff* staff22 = [MNStaff staffWithRect:CGRectMake(staff21.width + staff21.x, staff21.y, 250, 0)];
    MNStaff* staff32 = [MNStaff staffWithRect:CGRectMake(staff31.width + staff31.x, staff31.y, 250, 0)];

    NSArray* notes12 = @[
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/4" ],
               @"duration" : @"q" }))setStaff:staff12] addAccidental:newAcc(@"b")
                                                             atIndex:0],
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8" }))setStaff:staff12] addAccidental:newAcc(@"b")
                                                             atIndex:0],
        [[[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"c/5", @"e/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }))setStaff:staff12]   //,
            addAccidental:newAcc(@"b")
                  atIndex:0] addAccidental:newAcc(@"b")
                                   atIndex:0],

        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff12],
    ];
    NSArray* notes22 = @[
        [[[[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/4", @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"qd" }))setStaff:staff22] addAccidental:newAcc(@"b")
                                                              atIndex:0] addAccidental:newAcc(@"b")
                                                                               atIndex:0] addDotToAll],
        [[[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"c/5", @"a/4", @"e/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"q" }))setStaff:staff22] addAccidental:newAcc(@"b")
                                                             atIndex:0] addAccidental:newAcc(@"b")
                                                                              atIndex:0],
        [[((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }))setStaff:staff22] addAccidental:newAcc(@"b")
                                                             atIndex:0]
    ];
    NSArray* notes32 = @[
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff32],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff32],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff32],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff32],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff32],
        [((MNStaffNote*)newNote(
            @{ @"keys" : @[ @"a/5" ],
               @"stem_direction" : @(-1),
               @"duration" : @"8" }))setStaff:staff32]
    ];

    MNVoice* voice12 = [MNVoice voiceWithTimeSignature:MNTime6_8];
    [voice12 addTickables:notes12];
    MNVoice* voice22 = [MNVoice voiceWithTimeSignature:MNTime6_8];
    [voice22 addTickables:notes22];
    MNVoice* voice32 = [MNVoice voiceWithTimeSignature:MNTime6_8];
    [voice32 addTickables:notes32];

    if([params[@"justify"] floatValue] > 0)
    {
        float justify = [params[@"justify"] floatValue];
        [[[MNFormatter formatter] joinVoices:@[ voice12, voice22, voice32 ]] formatWith:@[ voice12, voice22, voice32 ]
                                                                       withJustifyWidth:justify];
    }
    else
    {
        [[[MNFormatter formatter] joinVoices:@[ voice12, voice22, voice32 ]] formatWith:@[ voice12, voice22, voice32 ]];
    }

    MNBeam* beam32a = [MNBeam beamWithNotes:notes32[[@0:3]]];
    MNBeam* beam32b = [MNBeam beamWithNotes:notes32[[@3:6]]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff11 draw:ctx];
      [staff21 draw:ctx];
      [staff31 draw:ctx];
      [connector draw:ctx];
      [voice11 draw:ctx dirtyRect:CGRectZero toStaff:staff11];
      [voice21 draw:ctx dirtyRect:CGRectZero toStaff:staff21];
      [voice31 draw:ctx dirtyRect:CGRectZero toStaff:staff31];
      [beam21a draw:ctx];
      [beam21b draw:ctx];
      [beam31a draw:ctx];
      [beam31b draw:ctx];

      [staff12 draw:ctx];
      [staff22 draw:ctx];
      [staff32 draw:ctx];
      [voice12 draw:ctx dirtyRect:CGRectZero toStaff:staff12];
      [voice22 draw:ctx dirtyRect:CGRectZero toStaff:staff22];
      [voice32 draw:ctx dirtyRect:CGRectZero toStaff:staff32];
      [beam32a draw:ctx];
      [beam32b draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

@end
