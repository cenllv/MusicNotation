//
//  MNChordTest.m
//  MusicNotation
//
//  Created by Scott on 4/17/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexTab](http://vexflow.com) - Copyright (c) Mohit Muthanna 2012.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the @"Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED @"AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MNChordTest.h"
#import "IAModelBase.h"

@interface SectionStruct : IAModelBase

@property (strong, nonatomic) NSString* section;
@property (strong, nonatomic) NSString* sectionDescription;
@property (strong, nonatomic) NSArray* chords;

@end

@implementation SectionStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:@{}];
    if(self)
    {
        _section = optionsDict[@"section"];
        _sectionDescription = optionsDict[@"description"];
        _chords = optionsDict[@"chords"];
    }
    return self;
}

@end

@interface ChordStruct : IAModelBase

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray* chord;
@property (assign, nonatomic) NSUInteger position;
@property (strong, nonatomic) NSString* positionText;
@property (strong, nonatomic) NSArray* bars;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
- (instancetype)initWithKey:(NSString*)key string:(NSString*)string shape:(NSString*)shape;

@end

@implementation ChordStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.name = optionsDict[@"name"];
        self.chord = optionsDict[@"chord"];
        self.position = [optionsDict[@"position"] unsignedIntegerValue];
        self.positionText = optionsDict[@"position_text"] ? optionsDict[@"position_text"] : @"";
        self.bars = optionsDict[@"bars"];
    }
    return self;
}

- (instancetype)initWithKey:(NSString*)key string:(NSString*)string shape:(NSString*)shape
{
    self = [super initWithDictionary:@{}];
    if(self)
    {
        NSDictionary* optionsDict = MNChordTest.chordShapes[shape];
        self.name = [NSString stringWithFormat:@"%@%@", key, optionsDict[@"name"]];
        self.chord = optionsDict[@"chord"];
        self.position = [MNChordTest.positions[string][key] unsignedIntegerValue];
        //        self.positionText = [d objectForKey:@"position_text"] ? d[@"position_text"] : @"";
        NSArray* bars = optionsDict[@"bars"];
        self.bars = [bars oct_map:^MNChordBarStruct*(NSDictionary* d) {
          return [[MNChordBarStruct alloc] initWithDictionary:d];
        }];
    }
    return self;
}

@end

@interface MNChordTest ()

@property (strong, nonatomic) NSMutableArray* keys;
@property (strong, nonatomic) NSMutableArray* shapes;

@end

@implementation MNChordTest

#define W 250
#define H 250
#define S_W 700
#define S_H 50

- (void)start
{
    [super start];

    for(NSUInteger i = 0; i < self.class.chordChart.count; ++i)
    {
        SectionStruct* ss = [[SectionStruct alloc] initWithDictionary:self.class.chordChart[i]];
        [self runTest:ss.section func:@selector(sectionHeader:) frame:CGRectMake(10, 10, S_W, S_H)];

        MNChordBox* cb;
        for(NSUInteger j = 0; j < 10; ++j)
        {
            ChordStruct* cs = [[ChordStruct alloc] initWithDictionary:ss.chords[j]];
            cb = [[self class] createChord:cs];
            NSString* name = ss.chords[j][@"name"];

            [self runTest:name
                     func:@selector(singleShape:params:)
                    frame:CGRectMake(10, 10, W, H)
                   params:@{
                       @"obj" : cb
                   }];
        }
    }

    // Display shape chords for all keys
    NSArray* keys_E = @[ @"F", @"F#", @"Gb", @"G", @"G#", @"Ab", @"A", @"A#", @"Bb", @"C" ];
    NSArray* keys_A = @[ @"C#", @"Db", @"D", @"D#", @"Eb", @"F", @"F#", @"Gb", @"G" ];

    NSArray* shapes_E =
        @[ @"M E", @"m E", @"7 E", @"m7 E", @"M7 E", @"m7b5 E", @"dim E", @"sus4 E", @"7sus4 E", @"13 E" ];
    NSArray* shapes_A = @[
        @"M A",
        @"m A",
        @"7 A",
        @"m7 A",
        @"M7 A",
        @"m7b5 A",
        @"dim A",
        @"sus2 A",
        @"sus4 A",
        @"7sus4 A",
        @"9 A",
        @"7b9 A",
        @"7#9 A",
        @"13 A"
    ];

    //    ChordStruct* cs = [[ChordStruct alloc] initWithKey:keys_E string:shapes_E shape:@"E"];
    [self shapeChart:keys_E shapes:shapes_E shape:@"E"];

    //    cs = [[ChordStruct alloc] initWithKey:keys_A string:shapes_A shape:@"A"];
    [self shapeChart:keys_A shapes:shapes_A shape:@"A"];
}

- (void)tearDown
{
    [super tearDown];
}

+ (MNChordBox*)createChord:(ChordStruct*)chordStruct
{
    float y = 50;
    MNChordBox* chordBox = [[MNChordBox alloc] initWithRect:CGRectMake(20, y, W, H)];
    chordBox.chord = chordStruct.chord;
    chordBox.position = chordStruct.position;
    chordBox.bars = chordStruct.bars;
    if(chordStruct.positionText && chordStruct.positionText.length > 0)
    {
        chordBox.positionText = chordStruct.positionText;
    }

    return chordBox;
}

- (MNTestTuple*)sectionHeader:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

    };

    return ret;
}

- (MNTestTuple*)singleShape:(MNTestCollectionItemView*)parent params:(NSDictionary*)params
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    MNChordBox* cb = params[@"obj"];
    if(!cb || ![cb isKindOfClass:[MNChordBox class]])
    {
        abort();
    }

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [cb draw:ctx];
    };

    return ret;
}

- (void)shapeChart:(NSArray*)keys shapes:(NSArray*)shapes shape:(NSString*)shape
{
    /*
    function createShapeChart(keys, container, shapes, shape) {
     for (var i = 0; i < keys.length; ++i) {
       var key = keys[i];
       var section = createSectionElement({
         section: key + @" Chords (" + shape + @" Shape)",
         description: shape + @"-Shaped barre chords in the key of @" + key + @"." });

       for (var j = 0; j < shapes.length; ++j) {
         var chord_elem = createChordElement(
           createChordStruct(key, shape, shapes[j]));
         section.append(chord_elem);
       }

     }
    }
    */

    MNChordBox* cb;
    for(NSUInteger i = 0; i < keys.count; ++i)
    {
        NSString* key = keys[i];
        NSString* section;
        section = [NSString stringWithFormat:@"%@  Chords (%@ Shape)", key, shape];
        NSString* description;
        description = [NSString stringWithFormat:@"%@-Shaped barre chords in the key of %@.", shape, key];

        [self runTest:section func:@selector(sectionHeader:) frame:CGRectMake(10, 10, S_W, S_H)];

        for(NSUInteger j = 0; j < shapes.count; ++j)
        {
            ChordStruct* cs = [[ChordStruct alloc] initWithKey:key string:shape shape:shapes[j]];
            NSDictionary* d = self.class.positions[shape];
            if(d)
            {
                if(d[key])
                {
                    [cs setPositionText:[NSString stringWithFormat:@"%lu", [d[key] unsignedIntegerValue]]];
                }
            }

            cb = [[self class] createChord:cs];
            [self runTest:description   //@"Chords"
                     func:@selector(singleShape:params:)
                    frame:CGRectMake(10, 10, W, H)
                   params:@{
                       @"obj" : cb
                   }];
        }
    }
}

static NSArray* _chordChart;

+ (NSArray*)chordChart
{
    if(!_chordChart)
    {
        _chordChart = @[
            @{
                @"section" : @"Open Chords",
                @"description" : @"These chords are played in open position, and generally include open strings.",
                @"chords" : @[
                    @{
                       @"name" : @"C Major",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @1 ], @[ @3, @0 ], @[ @4, @2 ], @[ @5, @3 ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"D Major",
                       @"chord" :
                           @[ @[ @1, @2 ], @[ @2, @3 ], @[ @3, @2 ], @[ @4, @0 ], @[ @5, @"x" ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"E Major",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @0 ], @[ @3, @1 ], @[ @4, @2 ], @[ @5, @2 ], @[ @6, @0 ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"G Major",
                       @"chord" : @[ @[ @1, @3 ], @[ @2, @3 ], @[ @3, @0 ], @[ @4, @0 ], @[ @5, @2 ], @[ @6, @3 ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"A Major",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @2 ], @[ @3, @2 ], @[ @4, @2 ], @[ @5, @0 ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"D Minor",
                       @"chord" :
                           @[ @[ @1, @1 ], @[ @2, @3 ], @[ @3, @2 ], @[ @4, @0 ], @[ @5, @"x" ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"E Minor",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @0 ], @[ @3, @0 ], @[ @4, @2 ], @[ @5, @2 ], @[ @6, @0 ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"A Minor",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @1 ], @[ @3, @2 ], @[ @4, @2 ], @[ @5, @0 ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"C7",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @1 ], @[ @3, @3 ], @[ @4, @2 ], @[ @5, @3 ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"D7",
                       @"chord" :
                           @[ @[ @1, @2 ], @[ @2, @1 ], @[ @3, @2 ], @[ @4, @0 ], @[ @5, @"x" ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"E7",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @3 ], @[ @3, @1 ], @[ @4, @0 ], @[ @5, @2 ], @[ @6, @0 ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"G7",
                       @"chord" : @[ @[ @1, @1 ], @[ @2, @0 ], @[ @3, @0 ], @[ @4, @0 ], @[ @5, @2 ], @[ @6, @3 ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"A7",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @2 ], @[ @3, @0 ], @[ @4, @2 ], @[ @5, @0 ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"Dm7",
                       @"chord" :
                           @[ @[ @1, @1 ], @[ @2, @1 ], @[ @3, @2 ], @[ @4, @0 ], @[ @5, @"x" ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"Em7",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @3 ], @[ @3, @0 ], @[ @4, @2 ], @[ @5, @2 ], @[ @6, @0 ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                    @{
                       @"name" : @"Am7",
                       @"chord" : @[ @[ @1, @0 ], @[ @2, @1 ], @[ @3, @0 ], @[ @4, @2 ], @[ @5, @0 ], @[ @6, @"x" ] ],
                       @"position" : @0,
                       @"bars" : @[]
                    },
                ]
            }
        ];
    }
    return _chordChart;
}

static NSDictionary* _chordShapes;

+ (NSDictionary*)chordShapes
{
    if(!_chordShapes)
    {
        _chordShapes = @{
            @"M E" : @{
                @"name" : @"Maj",
                @"chord" : @[ @[ @3, @2 ], @[ @4, @3 ], @[ @5, @3 ] ],
                @"bars" : @[ @{@"from_string" : @6, @"to_string" : @1, @"fret" : @1} ]
            },
            @"m E" : @{
                @"name" : @"m",
                @"chord" : @[ @[ @4, @3 ], @[ @5, @3 ] ],
                @"bars" : @[ @{@"from_string" : @6, @"to_string" : @1, @"fret" : @1} ]
            },
            @"7 E" : @{
                @"name" : @"7",
                @"chord" : @[ @[ @2, @4 ], @[ @3, @2 ], @[ @5, @3 ] ],
                @"bars" : @[ @{@"from_string" : @6, @"to_string" : @1, @"fret" : @1} ]
            },
            @"m7 E" : @{
                @"name" : @"m7",
                @"chord" : @[ @[ @2, @4 ], @[ @5, @3 ] ],
                @"bars" : @[ @{@"from_string" : @6, @"to_string" : @1, @"fret" : @1} ]
            },
            @"M7 E" : @{
                @"name" : @"Maj7",
                @"chord" : @[ @[ @1, @"x" ], @[ @2, @1 ], @[ @3, @2 ], @[ @4, @2 ], @[ @5, @"x" ], @[ @6, @1 ] ]
            },
            @"dim E" : @{
                @"name" : @"dim",
                @"chord" : @[ @[ @1, @"x" ], @[ @3, @2 ], @[ @5, @"x" ], @[ @6, @2 ] ],
                @"position_text" : @1,
                @"bars" : @[ @{@"from_string" : @4, @"to_string" : @2, @"fret" : @1} ]
            },
            @"m7b5 E" : @{
                @"name" : @"m7b5",
                @"chord" : @[ @[ @1, @"x" ], @[ @2, @1 ], @[ @3, @2 ], @[ @4, @2 ], @[ @5, @"x" ], @[ @6, @2 ] ],
                @"position_text" : @1
            },
            @"sus4 E" : @{
                @"name" : @"sus4",
                @"chord" : @[],
                @"bars" : @[
                    @{@"from_string" : @6, @"to_string" : @1, @"fret" : @1},
                    @{@"from_string" : @5, @"to_string" : @3, @"fret" : @3}
                ]
            },
            @"7sus4 E" : @{
                @"name" : @"7sus4",
                @"chord" : @[ @[ @3, @3 ], @[ @5, @3 ] ],
                @"bars" : @[ @{@"from_string" : @6, @"to_string" : @1, @"fret" : @1} ]
            },
            @"13 E" : @{
                @"name" : @"13",
                @"chord" : @[ @[ @1, @"x" ], @[ @2, @4 ], @[ @3, @3 ], @[ @4, @2 ], @[ @5, @"x" ], @[ @6, @2 ] ],
                @"position_text" : @1
            },
            @"M A" : @{
                @"name" : @"Maj",
                @"chord" : @[ @[ @2, @3 ], @[ @3, @3 ], @[ @4, @3 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @1, @"fret" : @1} ]
            },
            @"m A" : @{
                @"name" : @"m",
                @"chord" : @[ @[ @2, @2 ], @[ @3, @3 ], @[ @4, @3 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @1, @"fret" : @1} ]
            },
            @"7 A" : @{
                @"name" : @"7",
                @"chord" : @[ @[ @2, @3 ], @[ @4, @3 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @1, @"fret" : @1} ]
            },
            @"m7 A" : @{
                @"name" : @"m7",
                @"chord" : @[ @[ @2, @2 ], @[ @4, @3 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @1, @"fret" : @1} ]
            },
            @"m7b5 A" : @{
                @"name" : @"m7b5",
                @"chord" : @[ @[ @2, @2 ], @[ @4, @2 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @3, @"fret" : @1} ]
            },
            @"dim A" : @{
                @"name" : @"dim",
                @"chord" : @[ @[ @1, @"x" ], @[ @2, @3 ], @[ @3, @1 ], @[ @4, @3 ], @[ @5, @2 ], @[ @6, @"x" ] ],
                @"position_text" : @1
            },
            @"M7 A" : @{
                @"name" : @"Maj7",
                @"chord" : @[ @[ @2, @3 ], @[ @3, @2 ], @[ @4, @3 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @1, @"fret" : @1} ]
            },
            @"sus2 A" : @{
                @"name" : @"sus2",
                @"chord" : @[ @[ @3, @3 ], @[ @4, @3 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @1, @"fret" : @1} ]
            },
            @"sus4 A" : @{
                @"name" : @"sus4",
                @"chord" : @[ @[ @2, @4 ], @[ @3, @3 ], @[ @4, @3 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @1, @"fret" : @1} ]
            },
            @"7sus4 A" : @{
                @"name" : @"7sus4",
                @"chord" : @[ @[ @2, @4 ], @[ @4, @3 ], @[ @6, @"x" ] ],
                @"bars" : @[ @{@"from_string" : @5, @"to_string" : @1, @"fret" : @1} ]
            },
            @"9 A" : @{
                @"name" : @"9",
                @"chord" : @[ @[ @1, @"x" ], @[ @2, @2 ], @[ @3, @2 ], @[ @4, @1 ], @[ @5, @2 ], @[ @6, @"x" ] ],
                @"position_text" : @1
            },
            @"7b9 A" : @{
                @"name" : @"7b9",
                @"chord" : @[ @[ @1, @"x" ], @[ @2, @1 ], @[ @3, @2 ], @[ @4, @1 ], @[ @5, @2 ], @[ @6, @"x" ] ],
                @"position_text" : @1
            },
            @"7#9 A" : @{
                @"name" : @"7#9",
                @"chord" : @[ @[ @1, @"x" ], @[ @2, @3 ], @[ @3, @2 ], @[ @4, @1 ], @[ @5, @2 ], @[ @6, @"x" ] ],
                @"position_text" : @1
            },
            @"13 A" : @{
                @"name" : @"13",
                @"chord" : @[ @[ @1, @4 ], @[ @2, @4 ], @[ @3, @2 ], @[ @4, @4 ], @[ @5, @2 ], @[ @6, @"x" ] ],
                @"position_text" : @1
            },
        };
    }
    return _chordShapes;
}

static NSDictionary* _positions;

+ (NSDictionary*)positions
{
    if(!_positions)
    {
        _positions = @{
            @"E" : @{
                @"A" : @5,
                @"A#" : @6,
                @"Bb" : @6,
                @"B" : @7,
                @"C" : @8,
                @"C#" : @9,
                @"Db" : @9,
                @"D" : @10,
                @"D#" : @11,
                @"Eb" : @11,
                @"E" : @12,
                @"F" : @1,
                @"F#" : @2,
                @"Gb" : @2,
                @"G" : @3,
                @"G#" : @4,
                @"Ab" : @4
            },
            @"A" : @{
                @"A" : @12,
                @"A#" : @1,
                @"Bb" : @1,
                @"B" : @2,
                @"C" : @3,
                @"C#" : @4,
                @"Db" : @4,
                @"D" : @5,
                @"D#" : @6,
                @"Eb" : @6,
                @"E" : @7,
                @"F" : @8,
                @"F#" : @9,
                @"Gb" : @9,
                @"G" : @10,
                @"G#" : @11,
                @"Ab" : @11
            }
        };
    }
    return _positions;
}

@end
