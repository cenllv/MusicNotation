//
//  MNSheetMusicExamplesTests.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 12/4/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
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

#import "MNSheetMusicExamplesTests.h"
#import "NSArray+MNAdditions.h"

// SOURCE: http://www.musanim.com/pdf/debussyclairdelune.pdf
@implementation MNSheetMusicExamplesTests

- (void)start
{
    [super start];
    [self runTest:@"Clair de Lune" func:@selector(drawClairDeLune:) frame:CGRectMake(10, 10, 900, 950)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestBlockStruct*)drawClairDeLune:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    float x0 = 90, x = x0, y0 = 10, y = y0, h = 70;
    MNStaff* s111 = [MNStaff staffWithRect:CGRectMake(x, y, 300, 0)];
    x += s111.width;
    MNStaff* s121 = [MNStaff staffWithRect:CGRectMake(x, y, 200, 0)];
    x += s121.width;
    MNStaff* s131 = [MNStaff staffWithRect:CGRectMake(x, y, 250, 0)];
    [s111 addClefWithName:@"treble"];
    [s111 addKeySignature:@"Bbm"];
    [s111 addTimeSignatureWithName:@"9/8"];
    x = x0, y += h;
    MNStaff* s112 = [MNStaff staffWithRect:CGRectMake(x, y, s111.width, 0)];
    x += s112.width;
    MNStaff* s122 = [MNStaff staffWithRect:CGRectMake(x, y, s121.width, 0)];
    x += s122.width;
    MNStaff* s132 = [MNStaff staffWithRect:CGRectMake(x, y, s131.width, 0)];
    [s112 addClefWithName:@"treble"];
    [s112 addKeySignature:@"Bbm"];
    [s112 addTimeSignatureWithName:@"9/8"];
    NSMutableArray<MNStaff*>* staves = [NSMutableArray arrayWithArray:@[ s111, s121, s131, s112, s122, s132 ]];
    MNStaffConnector* conn = [MNStaffConnector staffConnectorWithTopStaff:s111 andBottomStaff:s112];
    MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:s111 andBottomStaff:s112];
    [conn setType:MNStaffConnectorBrace];
    [conn setText:@"Piano"];
    [line setType:MNStaffConnectorSingle];
    [s111 setBegBarType:MNBarLineDouble];
    [s111 setEndBarType:MNBarLineSingle];
    NSMutableArray<MNStaffModifier*>* drawables = [NSMutableArray arrayWithArray:@[ conn, line ]];

    NSArray* notes111 = @[
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8r" }),
        newNote(
            @{ @"keys" : @[ @"b/4" ],
               @"duration" : @"8r" }),
        newNote(@{
            @"keys" : @[ @"f/5", @"a/5" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1),
        }),
        [newNote(@{
            @"keys" : @[ @"f/5", @"a/5" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1),
        }) addDotToAll],
        [newNote(@{
            @"keys" : @[ @"d/5", @"f/5" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1),
        }) addDotToAll],

    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime9_8];
    [voice addTickables:notes111];
    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:s111.width / 2];
    NSMutableArray* voices_blocks = [NSMutableArray arrayWithArray:@[
        ^(CGContextRef ctx) {
          [voice draw:ctx dirtyRect:CGRectZero toStaff:s111];
        },
    ]];

    NSArray* notes121 = @[
        newNote(@{
            @"keys" : @[ @"d/5", @"f/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1),
        }),
        newNote(@{
            @"keys" : @[ @"c/5", @"e/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1),
        }),
        newNote(@{
            @"keys" : @[ @"d/5", @"f/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1),
        }),
        [newNote(@{
            @"keys" : @[ @"c/5", @"e/5" ],
            @"duration" : @"h",
            @"stem_direction" : @(-1),
        }) addDotToAll],

    ];

    MNBeam* beam1 = [MNBeam beamWithNotes:[notes121 slice:[@0:3]]];

    voice = [MNVoice voiceWithTimeSignature:MNTime9_8];
    [voice addTickables:notes121];
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:s121.width];
    [voices_blocks addObject:^(CGContextRef ctx) {
      [voice draw:ctx dirtyRect:CGRectZero toStaff:s121];
      [beam1 draw:ctx];
    }];

    NSArray* notes131 = @[
        newNote(@{
            @"keys" : @[ @"c/5", @"e/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"b/4", @"d/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"c/5", @"e/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"d/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"f/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"f/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"d/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
    ];

    beam1 = [MNBeam beamWithNotes:[notes131 slice:[@0:3]]];
    MNBeam* beam2 = [MNBeam beamWithNotes:[notes131 slice:[@3:5]]];
    MNBeam* beam3 = [MNBeam beamWithNotes:[notes131 slice:[@5:7]]];

    voice = [MNVoice voiceWithTimeSignature:MNTime9_8];
    [voice addTickables:notes131];

    NSArray* notes131b = @[
        [newNote(@{
            @"keys" : @[
                @"b/4",
            ],
            @"duration" : @"h",
            @"stem_direction" : @(-1),
        }) addDotToAll],
    ];
    MNVoice* voice2 = [MNVoice voiceWithTimeSignature:MNTime9_8];
    [voice2 addTickables:notes131b];

    MNStaffTie* tie = [[MNStaffTie alloc] initWithNoteTie:[[MNNoteTie alloc] initWithDictionary:@{
                                              @"first_note" : notes131b[0],
                                              @"last_note" : [NSNull null],
                                              @"first_indices" : @[ @0 ],
                                              @"last_indices" : @[ @0 ],
                                          }] andText:@""];
    tie.cp1 = -65;
    tie.cp2 = -70;

    [[[MNFormatter formatter] joinVoices:@[ voice, voice2 ]] formatWith:@[ voice, voice2 ] withJustifyWidth:s131.width];
    [voices_blocks addObject:^(CGContextRef ctx) {
      [voice draw:ctx dirtyRect:CGRectZero toStaff:s131];
      for(MNBeam* beam in @[ beam1, beam2, beam3 ])
      {
          [beam draw:ctx];
      }
      [voice2 draw:ctx dirtyRect:CGRectZero toStaff:s131];
      [tie draw:ctx];
    }];

    x0 = 50, x = x0, y0 = 200, y = y0;
    x = x0, y = y0;
    MNStaff* s211 = [MNStaff staffWithRect:CGRectMake(x, y, 260, 0)];
    [s211 addClefWithName:@"treble"];
    [s211 addKeySignature:@"Bbm"];
    x += s211.width;
    MNStaff* s221 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x += s221.width;
    MNStaff* s231 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x += s231.width;
    MNStaff* s241 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x = x0, y += h;
    MNStaff* s212 = [MNStaff staffWithRect:CGRectMake(x, y, s211.width, 0)];
    x += s212.width;
    [s212 addClefWithName:@"treble"];
    [s212 addKeySignature:@"Bbm"];
    MNStaff* s222 = [MNStaff staffWithRect:CGRectMake(x, y, s221.width, 0)];
    x += s222.width;
    MNStaff* s232 = [MNStaff staffWithRect:CGRectMake(x, y, s231.width, 0)];
    x += s232.width;
    MNStaff* s242 = [MNStaff staffWithRect:CGRectMake(x, y, s231.width, 0)];
    [staves addObjectsFromArray:@[ s211, s221, s231, s241, s212, s222, s232, s242 ]];
    conn = [MNStaffConnector staffConnectorWithTopStaff:s211 andBottomStaff:s212];
    line = [MNStaffConnector staffConnectorWithTopStaff:s211 andBottomStaff:s212];
    [conn setType:MNStaffConnectorBrace];
    [line setType:MNStaffConnectorSingle];
    [s211 setBegBarType:MNBarLineDouble];
    [s211 setEndBarType:MNBarLineSingle];
    [drawables addObjectsFromArray:@[ conn, line ]];

    NSArray* notes211 = @[
        newNote(@{
            @"keys" : @[ @"b/4", @"d/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"a/4", @"c/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"b/4", @"d/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        [newNote(@{
            @"keys" : @[ @"a/4", @"c/5" ],
            @"duration" : @"h",
            @"stem_direction" : @(1),
        }) addDotToAll],

    ];

    beam1 = [MNBeam beamWithNotes:[notes211 slice:[@0:3]]];

    voice = [MNVoice voiceWithTimeSignature:MNTime9_8];
    [voice addTickables:notes211];
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:s211.width / 2];
    [voices_blocks addObject:^(CGContextRef ctx) {
      [voice draw:ctx dirtyRect:CGRectZero toStaff:s211];
      [beam1 draw:ctx];
    }];

    NSArray* notes221 = @[
        newNote(@{
            @"keys" : @[ @"c/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"c/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"e/5" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"a/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"b/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
        newNote(@{
            @"keys" : @[ @"a/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(1),
        }),
    ];

    beam1 = [MNBeam beamWithNotes:[notes221 slice:[@0:3]]];
    beam2 = [MNBeam beamWithNotes:[notes221 slice:[@3:6]]];
    beam3 = [MNBeam beamWithNotes:[notes221 slice:[@6:9]]];

    voice = [MNVoice voiceWithTimeSignature:MNTime9_8];
    [voice addTickables:notes221];
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:s221.width / 1.2];
    [voices_blocks addObject:^(CGContextRef ctx) {
      [voice draw:ctx dirtyRect:CGRectZero toStaff:s221];
      for(MNBeam* beam in @[ beam1, beam2, beam3 ])
      {
          [beam draw:ctx];
      }
    }];

    x0 = 50, x = x0, y0 = 400, y = y0;
    x = x0, y = y0;
    MNStaff* s311 = [MNStaff staffWithRect:CGRectMake(x, y, 260, 0)];
    [s311 addClefWithName:@"treble"];
    [s311 addKeySignature:@"Bbm"];
    x += s311.width;
    MNStaff* s321 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x += s321.width;
    MNStaff* s331 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x += s331.width;
    MNStaff* s341 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x = x0, y += h;
    MNStaff* s312 = [MNStaff staffWithRect:CGRectMake(x, y, s311.width, 0)];
    x += s312.width;
    [s312 addClefWithName:@"treble"];
    [s312 addKeySignature:@"Bbm"];
    MNStaff* s322 = [MNStaff staffWithRect:CGRectMake(x, y, s321.width, 0)];
    x += s322.width;
    MNStaff* s332 = [MNStaff staffWithRect:CGRectMake(x, y, s331.width, 0)];
    x += s332.width;
    MNStaff* s342 = [MNStaff staffWithRect:CGRectMake(x, y, s331.width, 0)];
    [staves addObjectsFromArray:@[ s311, s321, s331, s341, s312, s322, s332, s342 ]];
    conn = [MNStaffConnector staffConnectorWithTopStaff:s311 andBottomStaff:s312];
    line = [MNStaffConnector staffConnectorWithTopStaff:s311 andBottomStaff:s312];
    [conn setType:MNStaffConnectorBrace];
    [line setType:MNStaffConnectorSingle];
    [s311 setBegBarType:MNBarLineDouble];
    [s311 setEndBarType:MNBarLineSingle];
    [drawables addObjectsFromArray:@[ conn, line ]];

    x0 = 50, x = x0, y0 = 600, y = y0;
    x = x0, y = y0;
    MNStaff* s411 = [MNStaff staffWithRect:CGRectMake(x, y, 260, 0)];
    [s411 addClefWithName:@"treble"];
    [s411 addKeySignature:@"Bbm"];
    x += s411.width;
    MNStaff* s421 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x += s421.width;
    MNStaff* s431 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x += s431.width;
    MNStaff* s441 = [MNStaff staffWithRect:CGRectMake(x, y, 180, 0)];
    x = x0, y += h;
    MNStaff* s412 = [MNStaff staffWithRect:CGRectMake(x, y, s411.width, 0)];
    x += s412.width;
    [s412 addClefWithName:@"treble"];
    [s412 addKeySignature:@"Bbm"];
    MNStaff* s422 = [MNStaff staffWithRect:CGRectMake(x, y, s421.width, 0)];
    x += s422.width;
    MNStaff* s432 = [MNStaff staffWithRect:CGRectMake(x, y, s431.width, 0)];
    x += s432.width;
    MNStaff* s442 = [MNStaff staffWithRect:CGRectMake(x, y, s431.width, 0)];
    [staves addObjectsFromArray:@[ s411, s421, s431, s441, s412, s422, s432, s442 ]];
    conn = [MNStaffConnector staffConnectorWithTopStaff:s411 andBottomStaff:s412];
    line = [MNStaffConnector staffConnectorWithTopStaff:s411 andBottomStaff:s412];
    [conn setType:MNStaffConnectorBrace];
    [line setType:MNStaffConnectorSingle];
    [s411 setBegBarType:MNBarLineDouble];
    [s411 setEndBarType:MNBarLineSingle];
    [drawables addObjectsFromArray:@[ conn, line ]];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      for(MNStaff* staff in staves)
      {
          [staff draw:ctx];
      }
      for(MNStaffModifier* drawable in drawables)
      {
          [drawable draw:ctx];
      }

      //      [voice draw:ctx dirtyRect:CGRectZero toStaff:s111];
      for(NSUInteger i = 0; i < voices_blocks.count; ++i)
      {
          void (^block)(CGContextRef ctx) = voices_blocks[i];
          block(ctx);
      }

    };
    return ret;
}

@end
