//
//  MNArticulationTests.m
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

#import "MNArticulationTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNArticulationTests

- (void)start
{
    [super start];
    float w = 530, h = 150;
    [self runTest:@"Articulation - Staccato/Staccatissimo" @"a." @"av"
             func:@selector(drawArticulations:params:)
            frame:CGRectMake(10, 10, w, h)
           params:@[ @"a.", @"av" ]];
    [self runTest:@"Articulation - Accent/Tenuto" @"a>" @"a-"
             func:@selector(drawArticulations:params:)
            frame:CGRectMake(10, 10, w, h)
           params:@[ @"a>", @"a-" ]];
    [self runTest:@"Articulation - Marcato/L.H. Pizzicato" @"a^" @"a+"
             func:@selector(drawArticulations:params:)
            frame:CGRectMake(10, 10, w, h)
           params:@[ @"a^", @"a+" ]];
    [self runTest:@"Articulation - Snap Pizzicato/Fermata" @"ao" @"ao"
             func:@selector(drawArticulations:params:)
            frame:CGRectMake(10, 10, w, h)
           params:@[ @"ao", @"ao" ]];
    [self runTest:@"Articulation - Up-stroke/Down-Stroke" @"a|" @"am"
             func:@selector(drawArticulations:params:)
            frame:CGRectMake(10, 10, w, h)
           params:@[ @"a|", @"am" ]];
    [self runTest:@"Articulation - Fermata Above/Below" @"a@a" @"a@u"
             func:@selector(drawFermata:params:)
            frame:CGRectMake(10, 10, w, 250)
           params:@[ @"a@a", @"a@u" ]];
    [self runTest:@"Articulation - Inline/Multiple" @"a." @"a."
             func:@selector(drawArticulations2:params:)
            frame:CGRectMake(10, 10, 750, 200)
           params:@[ @"a.", @"a." ]];
    [self runTest:@"TabNote Articulation" @"a." @"a."
             func:@selector(tabNotes:params:)
            frame:CGRectMake(10, 10, 650, 250)
           params:@[ @"a.", @"a." ]];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestBlockStruct*)drawArticulations:(id<MNTestParentDelegate>)parent
                                 params:(NSArray*)params   // withTitle:(NSString*)title
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    NSString* sym1 = params[0];
    NSString* sym2 = params[1];

    MNArticulation* (^newArticulation)(NSString*) = ^MNArticulation*(NSString* symbol)
    {
        MNArticulationType type = [MNEnum typeArticulationTypeForString:symbol];
        return [[MNArticulation alloc] initWithType:type];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 125, 0)];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/3" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }]
      ];
      [notesBar1[0] addArticulation:[newArticulation(sym1) setPosition:4] atIndex:0];
      [notesBar1[1] addArticulation:[newArticulation(sym1) setPosition:4] atIndex:0];
      [notesBar1[2] addArticulation:[newArticulation(sym1) setPosition:3] atIndex:0];
      [notesBar1[3] addArticulation:[newArticulation(sym1) setPosition:3] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];

      // bar 2 - juxtaposing second bar next to first bar
      MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 125, 0)];
      [staffBar2 setEndBarType:MNBarLineDouble];
      [staffBar2 draw:ctx];

      NSArray* notesBar2 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
      ];
      [notesBar2[0] addArticulation:[newArticulation(sym1) setPosition:3] atIndex:0];
      [notesBar2[1] addArticulation:[newArticulation(sym1) setPosition:3] atIndex:0];
      [notesBar2[2] addArticulation:[newArticulation(sym1) setPosition:4] atIndex:0];
      [notesBar2[3] addArticulation:[newArticulation(sym1) setPosition:4] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];

      // bar 3 - juxtaposing second bar next to first bar
      MNStaff* staffBar3 = [MNStaff staffWithRect:CGRectMake(staffBar2.width + staffBar2.x, staffBar2.y, 125, 0)];
      [staffBar3 draw:ctx];

      NSArray* notesBar3 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
      ];
      [notesBar3[0] addArticulation:[newArticulation(sym2) setPosition:4] atIndex:0];
      [notesBar3[1] addArticulation:[newArticulation(sym2) setPosition:4] atIndex:0];
      [notesBar3[2] addArticulation:[newArticulation(sym2) setPosition:3] atIndex:0];
      [notesBar3[3] addArticulation:[newArticulation(sym2) setPosition:3] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar3 withNotes:notesBar3];

      // bar 4 - juxtaposing second bar next to first bar
      MNStaff* staffBar4 = [MNStaff staffWithRect:CGRectMake(staffBar3.width + staffBar3.x, staffBar3.y, 125, 0)];
      [staffBar4 setEndBarType:MNBarLineEnd];
      [staffBar4 draw:ctx];

      NSArray* notesBar4 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
      ];
      [notesBar4[0] addArticulation:[newArticulation(sym2) setPosition:3] atIndex:0];
      [notesBar4[1] addArticulation:[newArticulation(sym2) setPosition:3] atIndex:0];
      [notesBar4[2] addArticulation:[newArticulation(sym2) setPosition:4] atIndex:0];
      [notesBar4[3] addArticulation:[newArticulation(sym2) setPosition:4] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar4 withNotes:notesBar4];
    };
    return ret;
}

- (MNTestBlockStruct*)drawFermata:(id<MNTestParentDelegate>)parent params:(NSArray*)params
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    NSString* sym1 = params[0];
    NSString* sym2 = params[1];

    MNArticulation* (^newArticulation)(NSString*) = ^MNArticulation*(NSString* symbol)
    {
        MNArticulationType type = [MNEnum typeArticulationTypeForString:symbol];
        return [[MNArticulation alloc] initWithType:type];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      expect(@"0");

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(50, 70, 150, 0)];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
      ];

      [notesBar1[0] addArticulation:[newArticulation(sym1) setPosition:3] atIndex:0];
      [notesBar1[1] addArticulation:[newArticulation(sym1) setPosition:3] atIndex:0];
      [notesBar1[2] addArticulation:[newArticulation(sym2) setPosition:4] atIndex:0];
      [notesBar1[3] addArticulation:[newArticulation(sym2) setPosition:4] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];

      // bar 2 - juxtaposing second bar next to first bar
      MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 150, 0)];
      [staffBar2 setEndBarType:MNBarLineDouble];
      [staffBar2 draw:ctx];

      NSArray* notesBar2 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
      ];
      [notesBar2[0] addArticulation:[newArticulation(sym1) setPosition:3] atIndex:0];
      [notesBar2[1] addArticulation:[newArticulation(sym1) setPosition:3] atIndex:0];
      [notesBar2[2] addArticulation:[newArticulation(sym2) setPosition:4] atIndex:0];
      [notesBar2[3] addArticulation:[newArticulation(sym2) setPosition:4] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];
    };
    return ret;
}

- (MNTestBlockStruct*)drawArticulations2:(id<MNTestParentDelegate>)parent params:(NSArray*)params
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNArticulation* (^newArticulation)(NSString*) = ^MNArticulation*(NSString* symbol)
    {
        MNArticulationType type = [MNEnum typeArticulationTypeForString:symbol];
        return [[MNArticulation alloc] initWithType:type];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 250, 0)];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"d/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"e/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"g/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"d/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"e/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"g/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/6" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"d/6" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
      ];

      for(NSUInteger i = 0; i < 16; i++)
      {
          [notesBar1[i] addArticulation:[newArticulation(@"a.") setPosition:4] atIndex:0];
          [notesBar1[i] addArticulation:[newArticulation(@"a>") setPosition:4] atIndex:0];

          if(i == 15)
          {
              [notesBar1[i] addArticulation:[newArticulation(@"a@u") setPosition:4]];
          }
      }

      MNBeam* beam1 = [MNBeam beamWithNotes:[notesBar1 slice:[@0:8]]];
      MNBeam* beam2 = [MNBeam beamWithNotes:[notesBar1 slice:[@8:16]]];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];
      [beam1 draw:ctx];
      [beam2 draw:ctx];

      // bar 2 - juxtaposing second bar next to first bar
      MNStaff* staffBar2 = [MNStaff staffWithRect:CGRectMake(staffBar1.width + staffBar1.x, staffBar1.y, 250, 0)];
      [staffBar2 draw:ctx];
      NSArray* notesBar2 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/3" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"g/3" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/3" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/3" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"d/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"e/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"g/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"b/4" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"d/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"e/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"g/5" ],
              @"duration" : @"16",
              @"stem_direction" : @(-1)
          }],
      ];
      for(NSUInteger i = 0; i < 16; i++)
      {
          [notesBar2[i] addArticulation:[newArticulation(@"a-") setPosition:3]];
          [notesBar2[i] addArticulation:[newArticulation(@"a^") setPosition:3]];

          if(i == 15)
          {
              [notesBar2[i] addArticulation:[newArticulation(@"a@u") setPosition:4]];
          }
      }

      MNBeam* beam3 = [MNBeam beamWithNotes:[notesBar2 slice:[@0:8]]];
      MNBeam* beam4 = [MNBeam beamWithNotes:[notesBar2 slice:[@8:16]]];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar2 withNotes:notesBar2];
      [beam3 draw:ctx];
      [beam4 draw:ctx];

      // bar 3 - juxtaposing second bar next to first bar
      MNStaff* staffBar3 = [MNStaff staffWithRect:CGRectMake(staffBar2.width + staffBar2.x, staffBar2.y, 75, 0)];
      [staffBar3 draw:ctx];

      NSArray* notesBar3 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/4" ],
              @"duration" : @"w",
              @"stem_direction" : @(1)
          }],
      ];
      [notesBar3[0] addArticulation:[newArticulation(@"a-") setPosition:3] atIndex:0];
      [notesBar3[0] addArticulation:[newArticulation(@"a>") setPosition:3] atIndex:0];
      [notesBar3[0] addArticulation:[newArticulation(@"a@a") setPosition:3] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar3 withNotes:notesBar3];
      // bar 4 - juxtaposing second bar next to first bar
      MNStaff* staffBar4 = [MNStaff staffWithRect:CGRectMake(staffBar3.width + staffBar3.x, staffBar3.y, 125, 0)];
      [staffBar4 setEndBarType:MNBarLineEnd];
      [staffBar4 draw:ctx];

      NSArray* notesBar4 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"c/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"q",
              @"stem_direction" : @(-1)
          }],
      ];
      for(NSUInteger i = 0; i < 4; i++)
      {
          NSUInteger position1 = 3;
          //          NSUInteger position2 = 4;
          if(i > 1)
          {
              position1 = 4;
              //              position2 = 3;
          }
          [notesBar4[i] addArticulation:[newArticulation(@"a-") setPosition:position1]];
      }

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar4 withNotes:notesBar4];
    };
    return ret;
}

- (MNTestBlockStruct*)tabNotes:(id<MNTestParentDelegate>)parent params:(NSArray*)params
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNArticulation* (^newArticulation)(NSString*) = ^MNArticulation*(NSString* symbol)
    {
        MNArticulationType type = [MNEnum typeArticulationTypeForString:symbol];
        return [[MNArticulation alloc] initWithType:type];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 50, 550, 0)];

      [staff draw:ctx];

      NSArray* specs = @[
          @{
              @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"25"} ],
              @"duration" : @"8"
          },
          @{
              @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(5), @"fret" : @"12"} ],
              @"duration" : @"8"
          },
          @{
              @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(3), @"fret" : @"5"} ],
              @"duration" : @"8"
          },
          @{
              @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(3), @"fret" : @"5"} ],
              @"duration" : @"8"
          }
      ];

      NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* tab_struct) {
        MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:tab_struct];
        [[tabNote renderOptions] setDraw_stem:YES];
        return tabNote;
      }];

      NSArray* notes2 = [specs oct_map:^MNTabNote*(NSDictionary* tab_struct) {
        MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:tab_struct];
        [[tabNote renderOptions] setDraw_stem:YES];
        [tabNote setStemDirection:-1];
        return tabNote;
      }];

      NSArray* notes3 = [specs oct_map:^MNTabNote*(NSDictionary* tab_struct) {
        MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:tab_struct];
        return tabNote;
      }];

      [notes[0] addModifier:[newArticulation(@"a>") setPosition:3] atIndex:0];   // U
      [notes[1] addModifier:[newArticulation(@"a>") setPosition:4] atIndex:0];   // D
      [notes[2] addModifier:[newArticulation(@"a.") setPosition:3] atIndex:0];   // U
      [notes[3] addModifier:[newArticulation(@"a.") setPosition:4] atIndex:0];   // D

      [notes2[0] addModifier:[newArticulation(@"a>") setPosition:3] atIndex:0];
      [notes2[1] addModifier:[newArticulation(@"a>") setPosition:4] atIndex:0];
      [notes2[2] addModifier:[newArticulation(@"a.") setPosition:3] atIndex:0];
      [notes2[3] addModifier:[newArticulation(@"a.") setPosition:4] atIndex:0];

      [notes3[0] addModifier:[newArticulation(@"a>") setPosition:3] atIndex:0];
      [notes3[1] addModifier:[newArticulation(@"a>") setPosition:4] atIndex:0];
      [notes3[2] addModifier:[newArticulation(@"a.") setPosition:3] atIndex:0];
      [notes3[3] addModifier:[newArticulation(@"a.") setPosition:4] atIndex:0];

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      voice.mode = MNModeSoft;

      [voice addTickables:notes];
      [voice addTickables:notes2];
      [voice addTickables:notes3];

      //        MNFormatter *formatter =
      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"TabNotes successfully drawn");
    };
    return ret;
}

@end
