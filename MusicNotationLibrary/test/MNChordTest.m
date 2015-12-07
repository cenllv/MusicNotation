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
#import "MNTableChords.h"
#import "MNChordTestStruct.h"

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

@interface MNChordTest ()

@property (strong, nonatomic) NSMutableArray* keys;
@property (strong, nonatomic) NSMutableArray* shapes;

@end

@implementation MNChordTest

#define W 250
#define H 250
#define S_W 700
#define S_H 50

// FIXME: bug with number on left hand side of chord bar chart

- (void)start
{
    [super start];

    for(NSUInteger i = 0; i < MNTableChords.chordChart.count; ++i)
    {
        SectionStruct* ss = [[SectionStruct alloc] initWithDictionary:MNTableChords.chordChart[i]];
        [self runTest:ss.section func:@selector(sectionHeader:) frame:CGRectMake(10, 10, S_W, S_H)];

        MNChordBox* cb;
        for(NSUInteger j = 0; j < 10; ++j)
        {
            MNChordTestStruct* cs = [[MNChordTestStruct alloc] initWithDictionary:ss.chords[j]];
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

+ (MNChordBox*)createChord:(MNChordTestStruct*)chordStruct
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

- (MNTestBlockStruct*)sectionHeader:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

    };

    return ret;
}

- (MNTestBlockStruct*)singleShape:(id<MNTestParentDelegate>)parent params:(NSDictionary*)params
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

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
            MNChordTestStruct* cs = [[MNChordTestStruct alloc] initWithKey:key string:shape shape:shapes[j]];
            NSDictionary* d = MNTableChords.positions[shape];
            if(d)
            {
                if(d[key])
                {
                    [cs setPositionText:[NSString stringWithFormat:@"%tu", [d[key] unsignedIntegerValue]]];
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

@end
