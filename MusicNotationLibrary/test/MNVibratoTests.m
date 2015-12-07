//
//  MNVibratoTests.m
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

#import "MNVibratoTests.h"

@implementation MNVibratoTests

- (void)start
{
    [super start];
    [self runTest:@"Simple Vibrato" func:@selector(simple:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Harsh Vibrato" func:@selector(harsh:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Vibrato with Bend" func:@selector(withBend:) frame:CGRectMake(10, 10, 700, 250)];
}

- (void)tearDown
{
    [super tearDown];
}



- (MNTestBlockStruct*)simple:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };
    MNVibrato* (^newVibrato)() = ^MNVibrato*()
    {
        return [[MNVibrato alloc] init];
    };
    MNStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 10, 450, 0)] addTabGlyph];
    NSArray* notes = @[
        [newNote(@{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(4), @"fret" : @"9"} ],
            @"duration" : @"h"
        }) addModifier:[newVibrato() setHarsh:NO]
                atIndex:0],
        [newNote(
            @{ @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"} ],
               @"duration" : @"h" }) addModifier:[newVibrato() setHarsh:NO]
                                         atIndex:0],
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];

      ok(YES, @"Simple Vibrato");
    };
    return ret;
}

- (MNTestBlockStruct*)harsh:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };
    MNVibrato* (^newVibrato)() = ^MNVibrato*()
    {
        return [[MNVibrato alloc] init];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 10, 450, 0)] addTabGlyph];
      [staff draw:ctx];

      NSArray* notes = @[
          [newNote(@{
              @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(4), @"fret" : @"9"} ],
              @"duration" : @"h"
          }) addModifier:[newVibrato() setHarsh:YES]
                  atIndex:0],
          [newNote(
              @{ @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"} ],
                 @"duration" : @"h" }) addModifier:[newVibrato() setHarsh:YES]
                                           atIndex:0],
      ];
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];
      ok(YES, @"Harsh Vibrato");
    };
    return ret;
}

- (MNTestBlockStruct*)withBend:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };
    MNBend* (^newBend)(NSString*, BOOL) = ^MNBend*(NSString* text, BOOL release)
    {
        return [[MNBend alloc] initWithText:text release:release phrase:nil];
    };
    MNVibrato* (^newVibrato)() = ^MNVibrato*()
    {
        return [[MNVibrato alloc] init];
    };

    MNStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 10, 450, 0)] addTabGlyph];

    NSArray* notes = @[
        [[[newNote(@{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"9"}, @{@"str" : @(3), @"fret" : @"9"} ],
            @"duration" : @"q"
        }) addModifier:newBend(@"1/2", YES)
                atIndex:0] addModifier:newBend(@"1/2", YES)
                               atIndex:1] addModifier:newVibrato()
                                              atIndex:0],
        [[newNote(
            @{ @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"} ],
               @"duration" : @"q" }) addModifier:newBend(@"Full", NO)
                                         atIndex:0] addModifier:[newVibrato() setVibratoWidth:60]
                                                        atIndex:0],
        [newNote(
            @{ @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"} ],
               @"duration" : @"h" }) addModifier:[[newVibrato() setVibratoWidth:120] setHarsh:YES]
                                         atIndex:0]
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];
      ok(YES, @"Vibrato with Bend");
    };
    return ret;
}

@end
