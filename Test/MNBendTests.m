//
//  MNBendTests.m
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

#import "MNBendTests.h"

@implementation MNBendTests

- (void)start
{
    [super start];
    float w = 600, h = 150;
    [self runTest:@"Double Bends" func:@selector(doubleBends:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Reverse Bends" func:@selector(reverseBends:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Bend Phrase" func:@selector(bendPhrase:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Double Bends With Release" func:@selector(doubleBendWithRelease:) frame:CGRectMake(10, 10, w+100, h)];
    [self runTest:@"Whako Bend" func:@selector(whackBends:) frame:CGRectMake(10, 10, w, h)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestBlockStruct*)doubleBends:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNBend* (^newBend)(NSString*) = ^MNBend*(NSString* text)
    {
        return [[MNBend alloc] initWithText:text];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];

      [staff draw:ctx];

      NSArray* notes = @[
          [[newNote(@{
              @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(4), @"fret" : @"9"} ],
              @"duration" : @"q"
          }) addModifier:newBend(@"Full")
                  atIndex:0] addModifier:newBend(@"1/2")
                                 atIndex:1],

          [[newNote(@{
              @"positions" : @[ @{@"str" : @(2), @"fret" : @"5"}, @{@"str" : @(3), @"fret" : @"5"} ],
              @"duration" : @"q"
          }) addModifier:newBend(@"1/4")
                  atIndex:0] addModifier:newBend(@"1/4")
                                 atIndex:1],

          newNote(
              @{ @"positions" : @[ @{@"str" : @(4), @"fret" : @"7"} ],
                 @"duration" : @"h" })
      ];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];

      ok(YES, @"Double Bends");
    };
    return ret;
}

- (MNTestBlockStruct*)doubleBendWithRelease:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNBend* (^newBend)(NSString*, BOOL) = ^MNBend*(NSString* text, BOOL release)
    {
        return [[MNBend alloc] initWithText:text release:release phrase:nil];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 650, 0)];

      [staff draw:ctx];

      NSArray* notes = @[
          [[newNote(@{
              @"positions" : @[ @{@"str" : @(1), @"fret" : @"10"}, @{@"str" : @(4), @"fret" : @"9"} ],
              @"duration" : @"q"
          }) addModifier:newBend(@"1/2", YES)
                  atIndex:0] addModifier:newBend(@"Full", YES)
                                 atIndex:1],

          [[[newNote(@{
              @"positions" : @[
                  @{@"str" : @(2), @"fret" : @"5"},
                  @{@"str" : @(3), @"fret" : @"5"},
                  @{@"str" : @(4), @"fret" : @"5"}
              ],
              @"duration" : @"q"
          }) addModifier:newBend(@"1/4", YES)
                  atIndex:0] addModifier:newBend(@"Monstrous", YES)
                                 atIndex:1] addModifier:newBend(@"1/4", YES)
                                                atIndex:2],

          newNote(
              @{ @"positions" : @[ @{@"str" : @(4), @"fret" : @"7"} ],
                 @"duration" : @"q" }),
          newNote(
              @{ @"positions" : @[ @{@"str" : @(4), @"fret" : @"7"} ],
                 @"duration" : @"q" })
      ];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];
      ok(YES, @"Bend Release");
    };
    return ret;
}

- (MNTestBlockStruct*)reverseBends:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNBend* (^newBend)(NSString*) = ^MNBend*(NSString* text)
    {
        return [[MNBend alloc] initWithText:text];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];

      [staff draw:ctx];

      NSArray* notes = @[
          [[newNote(@{
              @"positions" : @[ @{@"str" : @2, @"fret" : @"10"}, @{@"str" : @4, @"fret" : @"9"} ],
              @"duration" : @"w"
          }) addModifier:newBend(@"Full")
                  atIndex:1] addModifier:newBend(@"1/2")
                                 atIndex:0],
          [[newNote(@{
              @"positions" : @[ @{@"str" : @(2), @"fret" : @"5"}, @{@"str" : @(3), @"fret" : @"5"} ],
              @"duration" : @"w"
          }) addModifier:newBend(@"1/4")
                  atIndex:1] addModifier:newBend(@"1/4")
                                 atIndex:0],

          newNote(
              @{ @"positions" : @[ @{@"str" : @(4), @"fret" : @"7"} ],
                 @"duration" : @"w" })

      ];

      for(NSUInteger i = 0; i < notes.count; ++i)
      {
          MNTabNote* note = notes[i];
          MNModifierContext* mc = [MNModifierContext modifierContext];
          [note addToModifierContext:mc];

          MNTickContext* tickContext = [[MNTickContext alloc] init];
          [[tickContext addTickable:note] preFormat];
          tickContext.x = 75 * i;
          [tickContext setPointsUsed:95];

          note.staff = staff;
          [note draw:ctx];

          NSString* success = [NSString stringWithFormat:@"Bend %lu", (unsigned long)i];
          ok(YES, success);
      }
    };
    return ret;
}

- (MNTestBlockStruct*)bendPhrase:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNBend* (^newBend)(NSArray*) = ^MNBend*(NSArray* phrase)
    {
        return [[MNBend alloc] initWithText:nil release:NO phrase:phrase];
    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];

    NSArray* phrase1 = @[
        @{ @"type" : @(MNBendUP),
           @"text" : @"Full" },   //[MNBendStruct bendStructWithType:MNBendUP andText:@"Full"],
        @{ @"type" : @(MNBendDOWN),
           @"text" : @"Monstrous" },
        @{ @"type" : @(MNBendUP),
           @"text" : @"1/2" },
        @{ @"type" : @(MNBendDOWN),
           @"text" : @"" }
    ];

    MNBend* bend1 = newBend(phrase1);
    //      bend1.graphicsContext = ctx;

    NSArray* notes = @[
        [newNote(
            @{ @"positions" : @[ @{@"str" : @2, @"fret" : @"10"} ],
               @"duration" : @"w" }) addModifier:bend1
                                         atIndex:0],
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      for(NSUInteger i = 0; i < notes.count; ++i)
      {
          MNTabNote* note = notes[i];
          MNModifierContext* mc = [MNModifierContext modifierContext];
          [note addToModifierContext:mc];

          MNTickContext* tickContext = [[MNTickContext alloc] init];
          [[tickContext addTickable:note] preFormat];
          tickContext.x = 75 * i;
          [tickContext setPointsUsed:95];

          note.staff = staff;
          [note draw:ctx];

          NSString* success = [NSString stringWithFormat:@"Bend %lu", (unsigned long)i];
          ok(YES, success);
      }
    };
    return ret;
}

- (MNTestBlockStruct*)whackBends:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNBend* (^newBend)(NSArray*) = ^MNBend*(NSArray* phrase)
    {
        return [[MNBend alloc] initWithPhrase:phrase];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 30, 450, 0)];

      [staff draw:ctx];

      NSArray* phrase1 = @[
          @{ @"type" : @(MNBendUP),
             @"text" : @"Full" },
          @{ @"type" : @(MNBendDOWN),
             @"text" : @"" },
          @{ @"type" : @(MNBendUP),
             @"text" : @"1/2" },
          @{ @"type" : @(MNBendDOWN),
             @"text" : @"" }
      ];

      NSArray* phrase2 = @[
          @{ @"type" : @(MNBendUP),
             @"text" : @"Full" },
          @{ @"type" : @(MNBendUP),
             @"text" : @"Full" },
          @{ @"type" : @(MNBendUP),
             @"text" : @"1/2" },
          @{ @"type" : @(MNBendDOWN),
             @"text" : @"" },
          @{ @"type" : @(MNBendDOWN),
             @"text" : @"Full" },
          @{ @"type" : @(MNBendDOWN),
             @"text" : @"Full" },
          @{ @"type" : @(MNBendUP),
             @"text" : @"1/2" },
          @{ @"type" : @(MNBendDOWN),
             @"text" : @"" }
      ];

      NSArray* notes = @[
          [[newNote(@{
              @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(3), @"fret" : @"9"} ],
              @"duration" : @"q"
          }) addModifier:newBend(phrase1)
                  atIndex:0] addModifier:newBend(phrase2)
                                 atIndex:1]
      ];

      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staff withNotes:notes];
      ok(YES, @"Whako Release");
    };
    return ret;
}

@end
