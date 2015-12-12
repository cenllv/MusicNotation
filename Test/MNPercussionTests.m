//
//  MNPercussionTests.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Mike Corrigan 2012 <corrigan@gmail.com>
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

#import "MNPercussionTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNPercussionTests

- (void)start
{
    [super start];
    float w = 600, h = 150;
    [self runTest:@"Percussion Clef" func:@selector(draw:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Notes" func:@selector(drawNotes:) frame:CGRectMake(10, 10, w, 2 * h)];
    [self runTest:@"Percussion Basic0" func:@selector(drawBasic0:) frame:CGRectMake(10, 10, w, h + 100)];
    [self runTest:@"Percussion Basic1" func:@selector(drawBasic1:) frame:CGRectMake(10, 10, w, h + 100)];
    [self runTest:@"Percussion Basic2" func:@selector(drawBasic2:) frame:CGRectMake(10, 10, w, h + 100)];
    [self runTest:@"Percussion Snare0" func:@selector(drawSnare0:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Snare1" func:@selector(drawSnare1:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Percussion Snare2" func:@selector(drawSnare2:) frame:CGRectMake(10, 10, w, h)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNAnnotation*)newModifier:(NSString*)s
{
    MNAnnotation* ret = [MNAnnotation annotationWithText:s];
    [ret setFontName:@"Arial" withSize:12];
    [ret setVerticalJustification:MNVerticalJustifyBOTTOM];
    return ret;
}

- (MNArticulation*)newArticulation:(NSString*)symbol
{
    MNArticulationType type = [MNEnum typeArticulationTypeForString:symbol];
    MNArticulation* ret = [[MNArticulation alloc] initWithType:type];
    [ret setPosition:MNPositionAbove];
    return ret;
}

- (MNTremulo*)newTremolo:(NSUInteger)s
{
    MNTremulo* ret = [[MNTremulo alloc] initWithNum:s];
    return ret;
}

- (MNTestBlockStruct*)draw:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 300, 0)];
    [staff setBegBarType:MNBarLineRepeatBegin];
    [staff setEndBarType:MNBarLineSingle];
    [staff addClefWithName:@"percussion"];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

- (void)showNote:(MNStaffNote*)note staff:(MNStaff*)staff ctx:(CGContextRef)ctx x:(float)x
{
    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:note] preFormat];
    [tickContext setX:x];
    [tickContext setPointsUsed:20];
    note.staff = staff;
    [note draw:ctx];
}

- (MNTestBlockStruct*)drawNotes:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    NSArray<NSDictionary*>* notes_structs = @[
        @{ @"keys" : @[ @"g/5/d0" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"g/5/d1" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"g/5/d2" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"g/5/d3" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"x/" ],
           @"duration" : @"w" },

        @{ @"keys" : @[ @"g/5/t0" ],
           @"duration" : @"w" },
        @{ @"keys" : @[ @"g/5/t1" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"g/5/t2" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"g/5/t3" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"x/" ],
           @"duration" : @"w" },

        @{ @"keys" : @[ @"g/5/x0" ],
           @"duration" : @"w" },
        @{ @"keys" : @[ @"g/5/x1" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"g/5/x2" ],
           @"duration" : @"q" },
        @{ @"keys" : @[ @"g/5/x3" ],
           @"duration" : @"q" }
    ];
    //        expect(notes.length * 4);

    NSArray<MNStaffNote*>* notes = [notes_structs oct_map:^MNStaffNote*(NSDictionary* note_struct) {
      return [[MNStaffNote alloc] initWithDictionary:note_struct];
    }];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // Draw two staffs, one with up-stems and one with down-stems.
      for(NSUInteger h = 0; h < 2; ++h)
      {
          MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10 + h * 120, notes.count * 25 + 75, 0)];
          [staff addClefWithName:@"percussion"];
          [staff draw:ctx];

          for(NSUInteger i = 0; i < notes.count; ++i)
          {
              MNStaffNote* note = notes[i];
              note.stemDirection = (h == 0 ? -1 : 1);
              [self showNote:note staff:staff ctx:ctx x:(i + 1) * 25];

              //                ok(staffNote.getX() > 0, "Note " + i + " has X value");
              //                ok(staffNote.getYs().length > 0, "Note " + i + " has Y values");
          }
      }
      ok(YES, @"");
    };

    //        NSUInteger i = notes.count * 4;
    //        expect(i);

    return ret;
}

- (MNTestBlockStruct*)drawBasic0:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 420, 0)];
    [staff addClefWithName:@"percussion"];

    NSArray* notesUp = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }]
    ];
    MNBeam* beamUp = [MNBeam beamWithNotes:[notesUp slice:[@0:8]]];
    MNVoice* voiceUp = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceUp addTickables:notesUp];

    NSArray* notesDown = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5", @"d/4/x2" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5", @"d/4/x2" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        }]
    ];
    MNBeam* beamDown1 = [MNBeam beamWithNotes:[notesDown slice:[@0:2]]];
    MNBeam* beamDown2 = [MNBeam beamWithNotes:[notesDown slice:[@3:6]]];
    MNVoice* voiceDown = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceDown addTickables:notesDown];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voiceUp, voiceDown ]] formatToStaff:@[ voiceUp, voiceDown ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voiceUp draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voiceDown draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beamUp draw:ctx];
      [beamDown1 draw:ctx];
      [beamDown2 draw:ctx];

      ok(YES, @"");
    };
    return ret;
}

- (MNTestBlockStruct*)drawBasic1:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 420, 0)];
    [staff addClefWithName:@"percussion"];

    NSArray* notesUp = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/5/x2" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/5/x2" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/5/x2" ],
            @"duration" : @"q"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/5/x2" ],
            @"duration" : @"q"
        }]
    ];
    MNVoice* voiceUp = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceUp addTickables:notesUp];

    NSArray* notesDown = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5", @"d/4/x2" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5", @"d/4/x2" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        }]
    ];
    MNVoice* voiceDown = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceUp addTickables:notesDown];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voiceUp, voiceDown ]] formatToStaff:@[ voiceUp, voiceDown ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voiceUp draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voiceDown draw:ctx dirtyRect:CGRectZero toStaff:staff];
      ok(YES, @"");
    };
    return ret;
}

- (MNTestBlockStruct*)drawBasic2:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 50, 420, 0)];
    [staff addClefWithName:@"percussion"];

    NSArray* notesUp = @[
        [[[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"a/5/x3" ],
            @"duration" : @"8"
        }] addModifier:[MNAnnotation annotationWithText:@"<"]
                atIndex:0],   // addModifier(0, (new Vex.Flow.Annotation(@"<")).setFont()),
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"g/5/x2" ],
            @"duration" : @"8"
        }]
    ];
    MNBeam* beamUp = [MNBeam beamWithNotes:[notesUp slice:[@1:8]]];
    MNVoice* voiceUp = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceUp addTickables:notesUp];

    NSArray* notesDown = @[
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"8",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5", @"d/4/x2" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        }],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"f/4" ],
            @"duration" : @"q",
            @"stem_direction" : @(-1)
        }],
        [[[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5", @"d/4/x2" ],
            @"duration" : @"8d",
            @"stem_direction" : @(-1)
        }] addDotToAll],
        [[MNStaffNote alloc] initWithDictionary:@{
            @"keys" : @[ @"c/5" ],
            @"duration" : @"16",
            @"stem_direction" : @(-1)
        }]
    ];
    MNBeam* beamDown1 = [MNBeam beamWithNotes:[notesDown slice:[@0:2]]];
    MNBeam* beamDown2 = [MNBeam beamWithNotes:[notesDown slice:[@4:6]]];
    MNVoice* voiceDown = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceDown addTickables:notesDown];

    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voiceUp, voiceDown ]] formatToStaff:@[ voiceUp, voiceDown ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voiceUp draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [voiceDown draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [beamUp draw:ctx];
      [beamDown1 draw:ctx];
      [beamDown2 draw:ctx];
      ok(YES, @"");
    };
    return ret;
}

- (MNTestBlockStruct*)drawSnare0:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    float x = 10;

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(x, 10, 280, 0)];
    [staff setBegBarType:MNBarLineRepeatBegin];
    [staff setEndBarType:MNBarLineSingle];
    [staff addClefWithName:@"percussion"];
    NSArray* notesDown =
        @[
           [[[[MNStaffNote alloc] initWithDictionary:@{
               @"keys" : @[ @"c/5" ],
               @"duration" : @"q",
               @"stem_direction" : @(-1)
           }] addArticulation:[self newArticulation:@"a>"]
                       atIndex:0] addModifier:[self newModifier:@"L"]
                                      atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addModifier:[self newModifier:@"R"]
                                                                         atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addModifier:[self newModifier:@"L"]
                                                                         atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addModifier:[self newModifier:@"L"]
                                                                         atIndex:0],
        ];
    MNVoice* voiceDown = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceDown addTickables:notesDown];
    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voiceDown ]] formatToStaff:@[ voiceDown ] staff:staff];
    x += staff.width;

    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(x, 10, 280, 0)];
    [staff2 setBegBarType:MNBarLineNone];
    [staff2 setEndBarType:MNBarLineRepeatEnd];
    NSArray* notesDown2 =
        @[
           [[[[MNStaffNote alloc] initWithDictionary:@{
               @"keys" : @[ @"c/5" ],
               @"duration" : @"q",
               @"stem_direction" : @(-1)
           }] addArticulation:[self newArticulation:@"a>"]
                       atIndex:0] addModifier:[self newModifier:@"R"]
                                      atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addModifier:[self newModifier:@"L"]
                                                                         atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addModifier:[self newModifier:@"R"]
                                                                         atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addModifier:[self newModifier:@"R"]
                                                                         atIndex:0],
        ];
    MNVoice* voiceDown2 = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceDown2 addTickables:notesDown2];
    //    MNFormatter* formatter2 =
    [[[MNFormatter formatter] joinVoices:@[ voiceDown2 ]] formatToStaff:@[ voiceDown2 ] staff:staff2];
    // x += staff.width;

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      //      voiceDown.draw(ctx, staff);
      [voiceDown draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [staff2 draw:ctx];
      //      voiceDown2.draw(ctx, staff);
      [voiceDown2 draw:ctx dirtyRect:CGRectZero toStaff:staff2];

      ok(YES, @"");
    };
    return ret;
}

- (MNTestBlockStruct*)drawSnare1:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 280, 0)];
    [staff setBegBarType:MNBarLineRepeatBegin];
    [staff setEndBarType:MNBarLineSingle];
    [staff addClefWithName:@"percussion"];

    NSArray* notesDown =
        @[
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"g/5/x2" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addArticulation:[self newArticulation:@"ah"]
                                                                             atIndex:0],
           [[MNStaffNote alloc] initWithDictionary:@{
               @"keys" : @[ @"g/5/x2" ],
               @"duration" : @"q",
               @"stem_direction" : @(-1)
           }],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"g/5/x2" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addArticulation:[self newArticulation:@"ah"]
                                                                             atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"a/5/x3" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @(-1) }] addArticulation:[self newArticulation:@"a,"]
                                                                             atIndex:0],
        ];
    MNVoice* voiceDown = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];
    [voiceDown addTickables:notesDown];

    //    MNFormatter* formatter2 =
    [[[MNFormatter formatter] joinVoices:@[ voiceDown ]] formatToStaff:@[ voiceDown ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voiceDown draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"");
    };
    return ret;
}

- (MNTestBlockStruct*)drawSnare2:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 280, 0)];
    [staff setBegBarType:MNBarLineRepeatBegin];
    [staff setEndBarType:MNBarLineSingle];
    [staff addClefWithName:@"percussion"];

    NSArray* notesDown =
        @[
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @-1 }] addArticulation:[self newTremolo:0]
                                                                           atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @-1 }] addArticulation:[self newTremolo:1]
                                                                           atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @-1 }] addArticulation:[self newTremolo:3]
                                                                           atIndex:0],
           [[[MNStaffNote alloc] initWithDictionary:
                                     @{ @"keys" : @[ @"c/5" ],
                                        @"duration" : @"q",
                                        @"stem_direction" : @-1 }] addArticulation:[self newTremolo:5]
                                                                           atIndex:0],
        ];
    MNVoice* voiceDown = [[MNVoice alloc] initWithDictionary:@{
        @"num_beats" : @4,
        @"beat_value" : @4,
        @"resolution" : @(kRESOLUTION)
    }];

    [voiceDown addTickables:notesDown];

    //    MNFormatter* formatter2 =
    [[[MNFormatter formatter] joinVoices:@[ voiceDown ]] formatToStaff:@[ voiceDown ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voiceDown draw:ctx dirtyRect:CGRectZero toStaff:staff];
      ok(YES, @"");
    };
    return ret;
}

@end
