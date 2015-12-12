//
//  MNTabNoteTests.m
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

#import "MNTabNoteTests.h"
#import "NSMutableDictionary+MNAdditions.h"

@implementation MNTabNoteTests

- (void)start
{
    [super start];
    float w = 600, h = 200;
    [self runTest:@"Tick" func:@selector(ticks)];
    [self runTest:@"TabStaff Line" func:@selector(tabStaffLine)];
    [self runTest:@"Width" func:@selector(width)];
    [self runTest:@"TickContext" func:@selector(tickContext)];
    [self runTest:@"TabNote Draw" func:@selector(draw:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"TabNote Stems Up" func:@selector(drawStemsUp:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"TabNote Stems Down" func:@selector(drawStemsDown:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"TabNote Stems Up Through Staff" func:@selector(drawStemsUpThrough:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"TabNote Stems Down Through Staff"
             func:@selector(drawStemsDownThrough:)
            frame:CGRectMake(10, 10, w, h+20)];
    [self runTest:@"TabNote Stems with Dots" func:@selector(drawStemsDotted:) frame:CGRectMake(10, 10, w, h)];
}

- (void)tearDown
{
    [super tearDown];
}


- (void)ticks
{
    float BEAT = 1 * kRESOLUTION / 4;

    MNTabNote* note = [[MNTabNote alloc] initWithDictionary:@{
        @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
        @"duration" : @"w"
    }];
    assertThatFloat(note.ticks.floatValue, describedAs(@"Whole note has 4 beats", closeTo(BEAT * 4, 0.01), nil));

    note = [[MNTabNote alloc] initWithDictionary:@{
        @"positions" : @[ @{@"str" : @(3), @"fret" : @"4"} ],
        @"duration" : @"q"
    }];
    assertThatFloat(note.ticks.floatValue, describedAs(@"Quarter note has 1 beat", closeTo(BEAT, 0.01), nil));
}

- (void)tabStaffLine
{
    MNTabNote* note = [[MNTabNote alloc] initWithDictionary:@{
        @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
        @"duration" : @"w"
    }];
    NSArray* positions = note.positions;
    assertThatUnsignedInteger(((MNTabNotePositionsStruct*)positions[0]).str,
                              describedAs(@"String 6, Fret 6", equalToUnsignedInteger(6), nil));
    //    assertThatUnsignedInteger(((TabNotePositionsStruct*)positions[0]).fret,
    //                              describedAs(@"String 6, Fret 6", equalToUnsignedInteger(6), nil));
    assertThatUnsignedInteger(((MNTabNotePositionsStruct*)positions[1]).str,
                              describedAs(@"String 4, Fret 5", equalToUnsignedInteger(4), nil));
    //    assertThatUnsignedInteger(((TabNotePositionsStruct*)positions[1]).fret,
    //                              describedAs(@"String 4, Fret 5", equalToUnsignedInteger(5), nil));

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 300, 0)];
    note.staff = staff;

    NSArray* ys = note.ys;
    assertThatUnsignedInteger(ys.count,
                              describedAs(@"Chord should be rendered on two lines", equalToUnsignedInteger(2), nil));
    assertThatUnsignedInteger(((NSNumber*)ys[0]).unsignedIntegerValue,
                              describedAs(@"Line for String 6, Fret 6", equalToUnsignedInteger(99), nil));
    assertThatUnsignedInteger(((NSNumber*)ys[1]).unsignedIntegerValue,
                              describedAs(@"Line for String 4, Fret 5", equalToUnsignedInteger(79), nil));
}

- (void)width
{
    expect(@"1");
    MNTabNote* note = [[MNTabNote alloc] initWithDictionary:@{
        @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
        @"duration" : @"w"
    }];

    MNLogInfo(@"expect: \"UnformattedNote\" error");
    assertThatFloat(note.width, describedAs(@"Unformatted note should have no width", equalToFloat(MAXFLOAT), nil));
}

- (void)tickContext
{
    MNTabNote* note = [[MNTabNote alloc] initWithDictionary:@{
        @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
        @"duration" : @"w"
    }];

    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [tickContext addTickable:note];
    [tickContext preFormat];
    tickContext.x = 10;
    tickContext.padding = 0;
    assertThatFloat(tickContext.width, describedAs(@"", equalToFloat(6), nil));
}

+ (MNTabNote*)showNote:(NSDictionary*)tabStruct staff:(MNTabStaff*)staff context:(CGContextRef)ctx x:(float)x
{
    MNTabNote* note = [[MNTabNote alloc] initWithDictionary:tabStruct];
    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:note] preFormat];
    tickContext.x = x;
    tickContext.pointsUsed = 20;
    note.staff = staff;
    [note draw:ctx];
    return note;
}

- (MNTestBlockStruct*)draw:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    // ctx.font = "10pt Arial";
    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 30, 550, 0)];

    NSArray* notes = @[
        @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"6"} ],
           @"duration" : @"q" },
        @{
            @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"25"} ],
            @"duration" : @"q"
        },
        @{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"x"}, @{@"str" : @(5), @"fret" : @"15"} ],
            @"duration" : @"q"
        },
        @{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"x"}, @{@"str" : @(5), @"fret" : @"5"} ],
            @"duration" : @"q"
        },
        @{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(5), @"fret" : @"12"} ],
            @"duration" : @"q"
        },
        @{
            @"positions" : @[
                @{@"str" : @(6), @"fret" : @"0"},
                @{@"str" : @(5), @"fret" : @"5"},
                @{@"str" : @(4), @"fret" : @"5"},
                @{@"str" : @(3), @"fret" : @"4"},
                @{@"str" : @(2), @"fret" : @"3"},
                @{@"str" : @(1), @"fret" : @"0"}
            ],
            @"duration" : @"q"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"q"
        }
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [notes oct_foreach:^(NSDictionary* note, NSUInteger i, BOOL* stop) {

        MNTabNote* staffNote = [[self class] showNote:note staff:staff context:ctx x:(i + 1) * 25];

        BOOL success = staffNote.x > 0;
        NSString* message = [NSString stringWithFormat:@"Note %tu has X value", i];
        ok(success, message);
        success = staffNote.ys.count > 0;
        message = [NSString stringWithFormat:@"Note %tu has Y values", i];
        ok(success, message);
      }];
    };
    return ret;
}

- (MNTestBlockStruct*)drawStemsUp:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 30, 550, 0)];

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
        }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:noteSpec];
      [[tabNote renderOptions] setDraw_stem:YES];
      return tabNote;
    }];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"TabNotes successfully drawn");
    };
    return ret;
}

- (MNTestBlockStruct*)drawStemsDown:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    // ctx.font = "10pt Arial";
    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 10, 550, 0)];

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
        }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:noteSpec];
      [[tabNote renderOptions] setDraw_stem:YES];    // .draw_stem = YES;
      tabNote.stemDirection = MNStemDirectionDown;   //(-1);
      return tabNote;
    }];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"All objects have been drawn");
    };
    return ret;
}

- (MNTestBlockStruct*)drawStemsUpThrough:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    // ctx.font = "10pt Arial";
    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 30, 550, 0)];

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
        }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:noteSpec];
      [[tabNote renderOptions] setDraw_stem:YES];
      [[tabNote renderOptions] setDraw_stem_through_staff:YES];
      return tabNote;
    }];

    // ctx.setFont(@"sans-serif", 10, @"bold");

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    // MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"TabNotes successfully drawn");
    };
    return ret;
}

- (MNTestBlockStruct*)drawStemsDownThrough:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    // ctx.font = "10pt Arial";
    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 10, 550, 0)];
    staff.numberOfLines = 8;

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
            @"positions" : @[
                @{@"str" : @(1), @"fret" : @"6"},
                @{@"str" : @(4), @"fret" : @"5"},
                @{@"str" : @(6), @"fret" : @"10"}
            ],
            @"duration" : @"32"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"64"
        },
        @{
            @"positions" : @[
                @{@"str" : @(1), @"fret" : @"6"},
                @{@"str" : @(3), @"fret" : @"5"},
                @{@"str" : @(5), @"fret" : @"5"},
                @{@"str" : @(7), @"fret" : @"5"}
            ],
            @"duration" : @"128"
        }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:noteSpec];
      [[tabNote renderOptions] setDraw_stem:YES];
      [[tabNote renderOptions] setDraw_stem_through_staff:YES];
      tabNote.stemDirection = MNStemDirectionDown;   // (-1);
      return tabNote;
    }];

    // ctx.setFont(@"Arial", 10, @"bold");

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    // MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"All objects have been drawn");
    };
    return ret;
}

- (MNTestBlockStruct*)drawStemsDotted:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 30, 550, 0)];

    NSArray* specs = @[
        @{
            @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"25"} ],
            @"duration" : @"4d"
        },
        @{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(5), @"fret" : @"12"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"4dd",
            @"stem_direction" : @(-1)
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"5"} ],
            @"duration" : @"16",
            @"stem_direction" : @(-1)
        },
    ];

    NSArray<MNTabNote*>* notes = [specs oct_map:^MNTabNote*(NSDictionary* noteSpec) {
      id tmp_dict = [NSMutableDictionary merge:@{ @"draw_stem" : @(YES) } with:noteSpec];
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:tmp_dict];
      tabNote.drawStem = YES;
      return tabNote;
    }];

    [notes[0] addDot];
    [notes[2] addDot];
    [notes[2] addDot];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];

    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      ok(YES, @"TabNotes successfully drawn");
    };
    return ret;
}

@end
