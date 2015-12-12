//
//  MNTextBracketTests.m
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

#import "MNTextBracketTests.h"

#define DEBUG_TEXT_BRACKET 0   // 1

@implementation MNTextBracketTests

- (void)start
{
    [super start];
    [self runTest:@"Simple TextBracket" func:@selector(simple0:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"TextBracket Styles" func:@selector(simple1:) frame:CGRectMake(10, 10, 700, 250)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestBlockStruct*)simple0:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    // SOURCE: http://stackoverflow.com/a/13521502/629014
    dispatch_group_t d_group = dispatch_group_create();
    dispatch_queue_t bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(d_group, bg_queue, ^{

      MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
      {
          return [[MNStaffNote alloc] initWithDictionary:note_struct];
      };

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(40, 60, 550, 0)] addTrebleGlyph];

      NSArray<MNStaffNote*>* notes = [@[
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" },
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" },
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" },
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" }
      ] oct_map:^MNStaffNote*(NSDictionary* spec) {
        return newNote(spec);
      }];

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice setStrict:NO];
      [voice addTickables:notes];

      MNTextBracket* octave_top = [[MNTextBracket alloc] initWithStart:notes[0]
                                                                  stop:notes[3]
                                                                  text:@"15"
                                                           superscript:@"va"
                                                              position:MNTextBrackTop];

      MNTextBracket* octave_bottom = [[MNTextBracket alloc] initWithStart:notes[0]
                                                                     stop:notes[3]
                                                                     text:@"8"
                                                              superscript:@"vb"
                                                                 position:MNTextBracketBottom];

      [octave_bottom setLine:3];

      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

      ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
        dispatch_group_wait(d_group, DISPATCH_TIME_FOREVER);

        [staff draw:ctx];

        [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

        if(DEBUG_TEXT_BRACKET)
        {
            [MNText showBoundingBox:YES];
        }

        [octave_top draw:ctx];
        [octave_bottom draw:ctx];

        if(DEBUG_TEXT_BRACKET)
        {
            [MNText showBoundingBox:NO];
        }

      };
    });

    return ret;
}

- (MNTestBlockStruct*)simple1:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    dispatch_group_t d_group = dispatch_group_create();
    dispatch_queue_t bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(d_group, bg_queue, ^{

      MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
      {
          return [[MNStaffNote alloc] initWithDictionary:note_struct];
      };

      MNTextBracket* (^newTextBracket)(NSDictionary*) = ^MNTextBracket*(NSDictionary* note_struct)
      {
          return [[MNTextBracket alloc] initWithDictionary:note_struct];
      };

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(40, 60, 550, 0)] addTrebleGlyph];

      NSArray<MNStaffNote*>* notes = [@[
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" },
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" },
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" },
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" },
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4" }
      ] oct_map:^MNStaffNote*(NSDictionary* d) {
        return newNote(d);
      }];

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice setStrict:NO];
      [voice addTickables:notes];

      MNTextBracket* octave_top0 = newTextBracket(@{
          @"start" : notes[0],
          @"stop" : notes[1],
          @"text" : @"Cool notes",
          @"superscript" : @"",
          @"position" : @(MNTextBrackTop)
      });

      MNTextBracket* octave_bottom0 = newTextBracket(@{
          @"start" : notes[2],
          @"stop" : notes[4],
          @"text" : @"Not cool notes",
          @"superscript" : @" super uncool",
          @"position" : @(MNTextBracketBottom)
      });

      [octave_bottom0 setBracketHeight:40];
      [octave_bottom0 setLine:4];

      MNTextBracket* octave_top1 = newTextBracket(@{
          @"start" : notes[2],
          @"stop" : notes[4],
          @"text" : @"Testing",
          @"superscript" : @"superscript",
          @"position" : @(MNTextBrackTop)
      });

      MNTextBracket* octave_bottom1 = newTextBracket(@{
          @"start" : notes[0],
          @"stop" : notes[1],
          @"text" : @"8",
          @"superscript" : @"vb",
          @"position" : @(MNTextBracketBottom)
      });

      [octave_top1 setLineWidth:2];
      [octave_top1 setShowBracket:NO];
      [[octave_bottom1 setDashed:YES] setDash:@[ @2, @2 ]];
      [octave_top1 setFontFamily:@"HelveticaNeue-BoldItalic"];   // :[MNFont fontWithName: size:15]]; // @"PTSerif"
      octave_bottom1.fontSize = 30;                              //.font.size = 30;
      [octave_bottom1 setDashed:NO];
      [octave_bottom1 setUnderlineSuperscript:NO];
      [octave_bottom1 setLine:3];

      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

      ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
        dispatch_group_wait(d_group, DISPATCH_TIME_FOREVER);

        [staff draw:ctx];

        [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

        if(DEBUG_TEXT_BRACKET)
        {
            [MNText showBoundingBox:YES];
        }

        [octave_top0 draw:ctx];
        [octave_bottom0 draw:ctx];

        [octave_top1 draw:ctx];
        [octave_bottom1 draw:ctx];

        if(DEBUG_TEXT_BRACKET)
        {
            [MNText showBoundingBox:NO];
        }

      };
    });

    return ret;
}

@end
