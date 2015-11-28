///
//  MNThreeVoiceTests.m
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

#import "MNThreeVoiceTests.h"

@implementation MNThreeVoiceTests

- (void)start
{
    [super start];
//    [self runTest:@"Three Voices - #1" func:@selector(threevoices:) frame:CGRectMake(10, 10, 600, 200)];
//    [self runTest:@"Three Voices - #2 Complex" func:@selector(threevoices2:) frame:CGRectMake(10, 10, 600, 200)];
//    [self runTest:@"Three Voices - #3" func:@selector(threevoices3:) frame:CGRectMake(10, 10, 600, 200)];
    [self runTest:@"Auto Adjust Rest Positions - Two Voices"
             func:@selector(autoresttwovoices:)
            frame:CGRectMake(10, 10, 900, 250)];
    [self runTest:@"Auto Adjust Rest Positions - Three Voices #1"
             func:@selector(autorestthreevoices:)
            frame:CGRectMake(10, 10, 850, 250)];
    [self runTest:@"Auto Adjust Rest Positions - Three Voices #2"
             func:@selector(autorestthreevoices2:)
            frame:CGRectMake(10, 10, 920, 250)];
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

- (MNTestTuple*)threevoices:(MNTestCollectionItemView*)parent
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
    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType pos)
    {
        MNFretHandFinger* ret = [[MNFretHandFinger alloc] init];
        ret.position = pos;
        ret.finger = num;
        return ret;
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(50, 30, 500, 0)] addTrebleGlyph];
    [staff addTimeSignatureWithName:@"4/4"];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"h" }),
        newNote(
            @{ @"keys" : @[ @"e/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"h" }),
    ];
    [notes[0] addModifier:newFinger(@"0", MNPositionLeft) atIndex:0];

    NSArray* notes1 = @[
        newNote(
            @{ @"keys" : @[ @"d/5", @"a/4", @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5", @"a/4", @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5", @"a/4", @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"c/5", @"a/4", @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
    ];
    [[[[notes1[0] addAccidental:newAcc(@"#") atIndex:2] addModifier:newFinger(@"0", MNPositionLeft) atIndex:0]
        addModifier:newFinger(@"2", MNPositionLeft)
            atIndex:1] addModifier:newFinger(@"4", MNPositionRight)
                           atIndex:2];

    NSArray* notes2 = @[
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"e/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"f/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
        newNote(
            @{ @"keys" : @[ @"a/3" ],
               @"stem_direction" : @(-1),
               @"duration" : @"q" }),
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];
    [voice1 addTickables:notes1];
    [voice2 addTickables:notes2];
    //    NSArray<MNBeam*>* beams = [MNBeam applyAndGetBeams:voice direction:MNStemDirectionUp groups:nil];
    NSArray<MNBeam*>* beams1 = [MNBeam applyAndGetBeams:voice1 direction:MNStemDirectionDown groups:nil];
    //    NSArray<MNBeam*>* beams2 = [MNBeam applyAndGetBeams:voice2 direction:MNStemDirectionDown groups:nil];

    // Set option to position rests near the notes in each voice
    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2 ]] formatWith:@[ voice, voice1, voice2 ]
                                                               withJustifyWidth:400];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      //      for(MNBeam* beam in beams)
      //      {
      //          [beam draw:ctx];
      //      }

      for(MNBeam* beam in beams1)
      {
          [beam draw:ctx];
      }
      //      for(MNBeam* beam in beams2)
      //      {
      //          [beam draw:ctx];
      //      }

      ok(YES, @"Three Voices - Test #1");
    };
    return ret;
}

- (MNTestTuple*)threevoices2:(MNTestCollectionItemView*)parent
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
    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType pos)
    {
        MNFretHandFinger* ret = [[MNFretHandFinger alloc] init];
        ret.position = pos;
        ret.finger = num;
        return ret;
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(50, 30, 500, 0)] addTrebleGlyph];

      [staff draw:ctx];

      //         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(50, 10, 500, 0) addTrebleGlyph];

      [staff addTimeSignatureWithName:@"4/4"];
      [staff draw:ctx];

      NSArray* notes = @[
          newNote(
              @{ @"keys" : @[ @"a/4", @"e/5" ],
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
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"e/5" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"8" }),

          newNote(
              @{ @"keys" : @[ @"e/5" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"h" }),
      ];
      [[notes[0] addModifier:newFinger(@"2", MNPositionLeft) atIndex:0] addModifier:newFinger(@"0", MNPositionAbove)
                                                                            atIndex:1];
      //    addModifier(1, newFinger(@"0",  MNPositionLeft).
      //    setOffsetY(-6));

      NSArray* notes1 = @[
          newNote(
              @{ @"keys" : @[ @"d/5", @"d/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"16" }),
          newNote(
              @{ @"keys" : @[ @"b/4", @"c/5" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"16" }),
          newNote(
              @{ @"keys" : @[ @"d/5" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"16" }),
          newNote(
              @{ @"keys" : @[ @"e/5" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"16" }),
          newNote(
              @{ @"keys" : @[ @"c/5", @"a/4", @"d/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"c/5", @"a/4", @"d/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"c/5", @"a/4", @"d/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"8" }),
      ];
      [[[notes1[0] addAccidental:newAcc(@"#") atIndex:1] addModifier:newFinger(@"0", MNPositionLeft) atIndex:0]
          addModifier:newFinger(@"4", MNPositionLeft)
              atIndex:1];

      NSArray* notes2 = @[
          newNote(
              @{ @"keys" : @[ @"b/3" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"b/3" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"e/3" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"q" }),

          newNote(
              @{ @"keys" : @[ @"f/3" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"a/3" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"q" }),
      ];

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice addTickables:notes];
      [voice1 addTickables:notes1];
      [voice2 addTickables:notes2];
      NSArray* beams = [MNBeam applyAndGetBeams:voice direction:MNStemDirectionUp groups:nil];
      NSArray* beams1 = [MNBeam applyAndGetBeams:voice1 direction:MNStemDirectionDown groups:nil];
      NSArray* beams2 = [MNBeam applyAndGetBeams:voice2 direction:MNStemDirectionDown groups:nil];

      // Set option to position rests near the notes in each voice
      //      MNFormatter* formatter =
      [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2 ]] formatWith:@[ voice, voice1, voice2 ]
                                                                 withJustifyWidth:400];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      for(NSUInteger i = 0; i < beams.count; i++)
      {
          [beams[i] draw:ctx];
      }
      for(NSUInteger i = 0; i < beams1.count; i++)
      {
          [beams1[i] draw:ctx];
      }
      for(NSUInteger i = 0; i < beams2.count; i++)
      {
          [beams2[i] draw:ctx];
      }
      ok(YES, @"Three Voices - Test #2 Complex");
    };
    return ret;
}

- (MNTestTuple*)threevoices3:(MNTestCollectionItemView*)parent
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
    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType pos)
    {
        MNFretHandFinger* ret = [[MNFretHandFinger alloc] initWithFingerNumber:num andPosition:pos];
        return ret;
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(50, 30, 500, 0)] addTrebleGlyph];

      [staff draw:ctx];

      //         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(50, 10, 500, 0) addTrebleGlyph];

      [staff addTimeSignatureWithName:@"4/4"];
      [staff draw:ctx];

      NSArray* notes = @[
          newNote(
              @{ @"keys" : @[ @"e/5", @"g/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"e/5" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"e/5", @"g/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"h" }),
      ];
      [[notes[0] addModifier:newFinger(@"0", MNPositionLeft) atIndex:0] addModifier:newFinger(@"0", MNPositionLeft)
                                                                            atIndex:0];

      NSArray* notes1 = @[
          newNote(
              @{ @"keys" : @[ @"c/5" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"8" }),
          newNote(
              @{ @"keys" : @[ @"b/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"8r" }),

          [newNote(
              @{ @"keys" : @[ @"a/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"qd" }) addDotToAll],
          newNote(
              @{ @"keys" : @[ @"g/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"8" }),
      ];
      [[notes1[0] addAccidental:newAcc(@"#") atIndex:0] addModifier:newFinger(@"1", MNPositionLeft) atIndex:0];

      NSArray* notes2 = @[
          newNote(
              @{ @"keys" : @[ @"c/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"b/3" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"q" }),

          newNote(
              @{ @"keys" : @[ @"a/3" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"q" }),
          newNote(
              @{ @"keys" : @[ @"g/3" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"q" }),
      ];
      [notes2[0] addModifier:newFinger(@"3", MNPositionLeft) atIndex:0];

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice addTickables:notes];
      [voice1 addTickables:notes1];
      [voice2 addTickables:notes2];

      // TODO: what is groups, inspect the following method carefully
      NSArray* beam = [MNBeam applyAndGetBeams:voice direction:MNStemDirectionUp groups:nil];
      NSArray* beam1 = [MNBeam applyAndGetBeams:voice1 direction:MNStemDirectionDown groups:nil];
      NSArray* beam2 = [MNBeam applyAndGetBeams:voice2 direction:MNStemDirectionDown groups:nil];

      // Set option to position rests near the notes in each voice
      //        MNFormatter *formatter =
      [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2 ]] formatWith:@[ voice, voice1, voice2 ]
                                                                 withJustifyWidth:400];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      for(NSUInteger i = 0; i < beam.count; i++)
      {
          [beam[i] draw:ctx];
      }
      for(NSUInteger i = 0; i < beam1.count; i++)
      {
          [beam1[i] draw:ctx];
      }
      for(NSUInteger i = 0; i < beam2.count; i++)
      {
          [beam2[i] draw:ctx];
      }

      ok(YES, @"Three Voices - Test #3");
    };
    return ret;
}

- (MNTestTuple*)autoresttwovoices:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    //    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    //    {
    //        return  [MNAccidental accidentalWithType:type];
    //    };
    //    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType
    //    pos)
    //    {
    //        MNFretHandFinger* ret = [[MNFretHandFinger alloc] init];
    //        ret.position = pos;
    //        ret.finger = num;
    //        return ret;
    //    };
    NSDictionary* (^getNotes)(NSString*) = ^NSDictionary*(NSString* text)
    {
        NSArray* notes = @[
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"duration" : @"8r" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"duration" : @"16r" }),

            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"duration" : @"8r" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"duration" : @"16r" }),

            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"duration" : @"8r" }),
            newNote(
                @{ @"keys" : @[ @"d/5" ],
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"duration" : @"16r" }),

            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"q" }),
        ];

        NSArray* notes1 = @[
            newNote(
                @{ @"keys" : @[ @"c/5" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"c/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"d/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),

            newNote(
                @{ @"keys" : @[ @"e/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"f/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"g/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),

            newNote(
                @{ @"keys" : @[ @"g/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"a/4" ],
                   @"stem_direction" : @(1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(1),
                   @"duration" : @"16" }),

            newNote(
                @{ @"keys" : @[ @"e/4" ],
                   @"duration" : @"q" }),
        ];

        NSArray* textNote = @[
            [[MNTextNote alloc] initWithDictionary:@{
                @"text" : text,
                @"line" : @(-1),
                @"duration" : @"w",
                @"smooth" : @(YES)
            }],
        ];

        return @{ @"notes" : notes, @"notes1" : notes1, @"textNote" : textNote };
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(50, 50, 400, 0)];

      [staff draw:ctx];

      NSDictionary* n = getNotes(@"Default Rest Positions");
      //        n[@@"textnote"][0]; //.setContext(c);
      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      MNVoice* voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice addTickables:n[@"notes"]];
      [voice1 addTickables:n[@"notes1"]];
      [voice2 addTickables:n[@"textNote"]];

      NSArray* beam = [MNBeam applyAndGetBeams:voice direction:MNStemDirectionUp groups:nil];
      NSArray* beam1 = [MNBeam applyAndGetBeams:voice1 direction:MNStemDirectionDown groups:nil];

      // Set option to position rests near the notes in each voice
      //        MNFormatter *formatter =
      [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2 ]] formatWith:@[ voice, voice1, voice2 ]
                                                                 withJustifyWidth:350
                                                                       andOptions:@{
                                                                           @"align_rests" : @NO
                                                                       }];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      for(NSUInteger i = 0; i < beam.count; i++)
      {
          [beam[i] draw:ctx];
      }
      for(NSUInteger i = 0; i < beam1.count; i++)
      {
          [beam1[i] draw:ctx];
      }

      // Draw After rest adjustment
      staff = [MNStaff staffWithRect:CGRectMake(staff.width + staff.x, staff.y, 400, 0)];

      [staff draw:ctx];

      n = getNotes(@"Rests Repositioned To Avoid Collisions");
      //      n.textnote[0].setContext(c);
      voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      voice1 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      voice2 = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice addTickables:n[@"notes"]];
      [voice1 addTickables:n[@"notes1"]];
      [voice2 addTickables:n[@"textNote"]];
      beam = [MNBeam applyAndGetBeams:voice direction:MNStemDirectionUp groups:nil];
      beam1 = [MNBeam applyAndGetBeams:voice1 direction:MNStemDirectionDown groups:nil];

      // Set option to position rests near the notes in each voice
      [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2 ]] formatWith:@[ voice, voice1, voice2 ]
                                                                 withJustifyWidth:350
                                                                       andOptions:@{
                                                                           @"align_rests" : @NO
                                                                       }];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      for(NSUInteger i = 0; i < beam.count; i++)
      {
          [beam[i] draw:ctx];
      }
      for(NSUInteger i = 0; i < beam1.count; i++)
      {
          [beam1[i] draw:ctx];
      }

      ok(YES, @"Auto Adjust Rests - Two Voices");
    };
    return ret;
}

- (MNTestTuple*)autorestthreevoices:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    //    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    //    {
    //        return  [MNAccidental accidentalWithType:type];
    //    };
    //    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType
    //    pos)
    //    {
    //        MNFretHandFinger* ret = [[MNFretHandFinger alloc] init];
    //        ret.position = pos;
    //        ret.finger = num;
    //        return ret;
    //    };
    NSDictionary* (^getNotes)(NSString*) = ^NSDictionary*(NSString* text)
    {
        NSArray* notes = @[
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"q" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"q" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"q" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"q" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"qr" }),
        ];

        NSArray* notes1 = @[
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
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
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"q" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"q" }),
        ];

        NSArray* notes2 = @[
            newNote(
                @{ @"keys" : @[ @"e/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"e/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"f/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"q" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"g/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"q" }),
            newNote(
                @{ @"keys" : @[ @"c/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"q" }),
            newNote(
                @{ @"keys" : @[ @"e/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"qr" }),
            newNote(
                @{ @"keys" : @[ @"c/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"q" }),
        ];

        NSArray* textNote = @[
            [[MNTextNote alloc] initWithDictionary:@{
                @"text" : text,
                @"duration" : @"w",
                @"line" : @(-1),
                @"smooth" : @(YES)
            }],
            [[MNTextNote alloc] initWithDictionary:@{
                @"text" : @"",
                @"duration" : @"w",
                @"line" : @(-1),
                @"smooth" : @(YES)
            }],
        ];

        return @{ @"notes" : notes, @"notes1" : notes1, @"notes2" : notes2, @"textNote" : textNote };
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(50, 50, 400, 0)] addTrebleGlyph];

      [staff draw:ctx];

      NSDictionary* n = getNotes(@"Default Rest Positions");
      //       n.textnote[0].setContext(c);
      //       n.textnote[1].setContext(c);
      MNVoice* voice = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(8),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      MNVoice* voice1 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(8),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      MNVoice* voice2 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(8),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      MNVoice* voice3 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(8),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      [voice addTickables:n[@"notes"]];
      [voice1 addTickables:n[@"notes1"]];
      [voice2 addTickables:n[@"notes2"]];
      [voice3 addTickables:n[@"textNote"]];

      // Set option to position rests near the notes in each voice

      //      MNFormatter* formatter =
      [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2, voice3 ]]
                formatWith:@[ voice, voice1, voice2, voice3 ]
          withJustifyWidth:350
                andOptions:@{
                    @"align_rests" : @NO
                }];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice3 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(staff.width + staff.x, staff.y, 350, 0)];

      [staff2 draw:ctx];

      n = getNotes(@"Rests Repositioned To Avoid Collisions");
      //       n.textnote[0].setContext(c);
      //       n.textnote[1].setContext(c);
      voice = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(8),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      voice1 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(8),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      voice2 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(8),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      voice3 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(8),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      [voice addTickables:n[@"notes"]];
      [voice1 addTickables:n[@"notes1"]];
      [voice2 addTickables:n[@"notes2"]];
      [voice3 addTickables:n[@"textNote"]];

      // Set option to position rests near the notes in each voice
      //       Vex.Debug = YES;
      //      MNFormatter* formatter2 =
      [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2, voice3 ]]
                formatWith:@[ voice, voice1, voice2, voice3 ]
          withJustifyWidth:350
                andOptions:@{
                    @"align_rests" : @YES
                }];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      [voice3 draw:ctx dirtyRect:CGRectZero toStaff:staff2];

      ok(YES, @"Auto Adjust Rests - three Voices #1");
    };
    return ret;
}

- (MNTestTuple*)autorestthreevoices2:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    //    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    //    {
    //        return  [MNAccidental accidentalWithType:type];
    //    };
    //    MNFretHandFinger* (^newFinger)(NSString*, MNPositionType) = ^MNFretHandFinger*(NSString* num, MNPositionType
    //    pos)
    //    {
    //        MNFretHandFinger* ret = [[MNFretHandFinger alloc] init];
    //        ret.position = pos;
    //        ret.finger = num;
    //        return ret;
    //    };

    NSDictionary* (^getNotes)(NSString*) = ^NSDictionary*(NSString* text)
    {
        NSArray* notes = @[
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"e/5" ],
                   @"duration" : @"16r" }),
        ];

        NSArray* notes1 = @[
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
        ];

        NSArray* notes2 = @[
            newNote(
                @{ @"keys" : @[ @"e/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"e/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"f/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"b/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"g/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"c/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
            newNote(
                @{ @"keys" : @[ @"e/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16r" }),
            newNote(
                @{ @"keys" : @[ @"c/4" ],
                   @"stem_direction" : @(-1),
                   @"duration" : @"16" }),
        ];

        MNTextNote* textNote = [[MNTextNote alloc] initWithDictionary:@{
            @"text" : text,
            @"duration" : @"h",
            @"line" : @(-1),
            @"smooth" : @(YES)
        }];

        return @{ @"notes" : notes, @"notes1" : notes1, @"notes2" : notes2, @"textnote" : textNote };
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(20, 50, 450, 0)] addTrebleGlyph];
      [staff draw:ctx];

      NSDictionary* n = getNotes(@"Default Rest Positions");
      //       n.textnote[0].setContext(c);
      MNVoice* voice = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(2),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      MNVoice* voice1 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(2),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      MNVoice* voice2 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(2),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      MNVoice* voice3 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(2),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      [voice addTickables:n[@"notes"]];
      [voice1 addTickables:n[@"notes1"]];
      [voice2 addTickables:n[@"notes2"]];
      [voice3 addTickables:n[@"textNote"]];

      // Set option to position rests near the notes in each voice

      //             MNFormatter *formatter =
      [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2, voice3 ]]
                formatWith:@[ voice, voice1, voice2, voice3 ]
          withJustifyWidth:400
                andOptions:@{
                    @"align_rests" : @NO
                }];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voice3 draw:ctx dirtyRect:CGRectZero toStaff:staff];

      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(staff.width + staff.x, staff.y, 425, 0)];
      [staff2 draw:ctx];

      n = getNotes(@"Rests Repositioned To Avoid Collisions");
      //             n.textnote[0].setContext(c);
      voice = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(2),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      voice1 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(2),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      voice2 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(2),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      voice3 = [[MNVoice alloc] initWithDictionary:@{
          @"num_beats" : @(2),
          @"beat_value" : @(4),
          @"resolution" : @(kRESOLUTION)
      }];
      [voice addTickables:n[@"notes"]];
      [voice1 addTickables:n[@"notes1"]];
      [voice2 addTickables:n[@"notes2"]];
      [voice3 addTickables:n[@"textNote"]];

      // Set option to position rests near the notes in each voice
      //             Vex.Debug = YES;
      //             MNFormatter *formatter2 =
      [[[MNFormatter formatter] joinVoices:@[ voice, voice1, voice2, voice3 ]]
                formatWith:@[ voice, voice1, voice2, voice3 ]
          withJustifyWidth:400
                andOptions:@{
                    @"align_rests" : @YES
                }];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      [voice1 draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:staff2];
      [voice3 draw:ctx dirtyRect:CGRectZero toStaff:staff2];

      ok(YES, @"Auto Adjust Rests - three Voices #2");
    };
    return ret;
}

@end
