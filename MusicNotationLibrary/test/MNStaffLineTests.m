//
//  MNStaffLineTests.m
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

#import "MNStaffLineTests.h"
#import "MNStaffLineNotesStruct.h"
#import "OCTotallyLazy.h"

@implementation MNStaffLineTests

- (void)start
{
    [super start];
    [self runTest:@"Simple StaffLine" func:@selector(simple0:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"StaffLine Arrow Options" func:@selector(simple1:) frame:CGRectMake(10, 10, 700, 250)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestBlockStruct*)simple0:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    //    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    //    {
    //        return  [MNAccidental accidentalWithType:type];
    //    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 550, 0)] addTrebleGlyph];

      [staff draw:ctx];

      NSArray* notes = [@[
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4",
             @"clefName" : @"treble" },
          @{ @"keys" : @[ @"c/5" ],
             @"duration" : @"4",
             @"clefName" : @"treble" },
          @{ @"keys" : @[ @"c/4", @"g/4", @"b/4" ],
             @"duration" : @"4",
             @"clefName" : @"treble" },
          @{ @"keys" : @[ @"f/4", @"a/4", @"f/5" ],
             @"duration" : @"4",
             @"clefName" : @"treble" }
      ] oct_map:^MNStaffNote*(NSDictionary* d) {
        return newNote(d);
      }];

      MNStaffLine* staffLine = [[MNStaffLine alloc] initWithNotes:[[MNStaffLineNotesStruct alloc] initWithDictionary:@{
                                                        @"first_note" : notes[0],
                                                        @"last_note" : notes[1],
                                                        @"first_indices" : @[ @(0) ],
                                                        @"last_indices" : @[ @(0) ]
                                                    }]];

      MNStaffLine* staffLine2 = [[MNStaffLine alloc] initWithNotes:[[MNStaffLineNotesStruct alloc] initWithDictionary:@{
                                                         @"first_note" : notes[2],
                                                         @"last_note" : notes[3],
                                                         @"first_indices" : @[ @(2), @(1), @(0) ],
                                                         @"last_indices" : @[ @(0), @(1), @(2) ]
                                                     }]];

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice setStrict:NO];
      [voice addTickables:notes];

      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];
      [staffLine setText:@"gliss."];

      [staffLine2 setText:@"gliss."];

      // TODO: fix this
      //        [staffLine setFont:@{
      //        @"family" : @"serif",
      //        @"size" : @12,
      //        @"weight" : @"italic"
      //        }];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [staffLine draw:ctx];
      [staffLine2 draw:ctx];

      ok(YES, @"YES");
    };
    return ret;
}

- (MNTestBlockStruct*)simple1:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 750, 0)] addTrebleGlyph];

      [staff draw:ctx];

      NSArray* notes = [@[
          @{ @"keys" : @[ @"c#/5", @"d/5" ],
             @"duration" : @"4",
             @"clefName" : @"treble",
             @"stem_direction" : @(-1) },
          @{ @"keys" : @[ @"c/4" ],
             @"duration" : @"4",
             @"clefName" : @"treble" },
          @{ @"keys" : @[ @"c/4", @"e/4", @"g/4" ],
             @"duration" : @"4",
             @"clefName" : @"treble" },
          @{ @"keys" : @[ @"f/4", @"a/4", @"c/5" ],
             @"duration" : @"4",
             @"clefName" : @"treble" },
          @{
              @"keys" : @[
                  @"c/4",
              ],
              @"duration" : @"4",
              @"clefName" : @"treble"
          },
          @{ @"keys" : @[ @"c#/5", @"d/5" ],
             @"duration" : @"4",
             @"clefName" : @"treble",
             @"stem_direction" : @(-1) },
          @{ @"keys" : @[ @"c/4", @"d/4", @"g/4" ],
             @"duration" : @"4",
             @"clefName" : @"treble" },
          @{ @"keys" : @[ @"f/4", @"a/4", @"c/5" ],
             @"duration" : @"4",
             @"clefName" : @"treble" }
      ] oct_map:^MNStaffNote*(NSDictionary* d) {
        return newNote(d);
      }];

      [notes[0] addDotToAll];
      [notes[1] addAccidental:newAcc(@"#") atIndex:0];   //.addAccidental(0, new Vex.Flow.Accidental(@"#"));
      [notes[3] addAccidental:newAcc(@"#") atIndex:2];   //.addAccidental(2, new Vex.Flow.Accidental(@"#"));
      [notes[4] addAccidental:newAcc(@"#") atIndex:0];   //.addAccidental(0, new Vex.Flow.Accidental(@"#"));
      [notes[7] addAccidental:newAcc(@"#") atIndex:2];   //.addAccidental(2, new Vex.Flow.Accidental(@"#"));

      MNStaffLine* staffLine0 = [[MNStaffLine alloc] initWithNotes:[[MNStaffLineNotesStruct alloc] initWithDictionary:@{
                                                         @"first_note" : notes[0],
                                                         @"last_note" : notes[1],
                                                         @"first_indices" : @[ @(0) ],
                                                         @"last_indices" : @[ @(0) ]
                                                     }]];

      MNStaffLine* staffLine4 = [[MNStaffLine alloc] initWithNotes:[[MNStaffLineNotesStruct alloc] initWithDictionary:@{
                                                         @"first_note" : notes[2],
                                                         @"last_note" : notes[3],
                                                         @"first_indices" : @[ @(1) ],
                                                         @"last_indices" : @[ @(1) ]
                                                     }]];

      MNStaffLine* staffLine1 = [[MNStaffLine alloc] initWithNotes:[[MNStaffLineNotesStruct alloc] initWithDictionary:@{
                                                         @"first_note" : notes[4],
                                                         @"last_note" : notes[5],
                                                         @"first_indices" : @[ @(0) ],
                                                         @"last_indices" : @[ @(0) ]
                                                     }]];

      MNStaffLine* staffLine2 = [[MNStaffLine alloc] initWithNotes:[[MNStaffLineNotesStruct alloc] initWithDictionary:@{
                                                         @"first_note" : notes[6],
                                                         @"last_note" : notes[7],
                                                         @"first_indices" : @[ @(1) ],
                                                         @"last_indices" : @[ @(0) ]
                                                     }]];

      MNStaffLine* staffLine3 = [[MNStaffLine alloc] initWithNotes:[[MNStaffLineNotesStruct alloc] initWithDictionary:@{
                                                         @"first_note" : notes[6],
                                                         @"last_note" : notes[7],
                                                         @"first_indices" : @[ @(2) ],
                                                         @"last_indices" : @[ @(2) ]
                                                     }]];

      MNStaffLineRenderOptions* render_options = [staffLine0 renderOptions];
      render_options.draw_end_arrow = YES;
      [staffLine0 setText:@"Left"];
      render_options.text_justification = 1;
      render_options.text_position_vertical = 2;

      render_options = [staffLine1 renderOptions];
      render_options.draw_end_arrow = YES;
      render_options.arrowhead_length = 30;
      render_options.lineWidth = 5;
      [staffLine1 setText:@"Center"];
      render_options.text_justification = 2;
      render_options.text_position_vertical = 2;

      render_options = [staffLine4 renderOptions];
      render_options.lineWidth = 2;
      render_options.draw_end_arrow = YES;
      render_options.draw_start_arrow = YES;
      render_options.arrowhead_angle = 0.5;
      render_options.arrowhead_length = 20;
      [staffLine4 setText:@"Right"];
      render_options.text_justification = 3;
      render_options.text_position_vertical = 2;

      render_options.draw_start_arrow = YES;
      render_options.line_dash = @[ @5, @4 ];

      render_options = [staffLine3 renderOptions];
      render_options.draw_end_arrow = YES;
      render_options.draw_start_arrow = YES;
      render_options.color = @"red";
      [staffLine3 setText:@"Top"];
      render_options.text_position_vertical = 1;

      MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
      [voice setStrict:NO];
      [voice addTickables:notes];

      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [staffLine0 draw:ctx];
      [staffLine1 draw:ctx];
      [staffLine2 draw:ctx];
      [staffLine3 draw:ctx];
      [staffLine4 draw:ctx];

      ok(YES, @"YES");
    };
    return ret;
}

@end
