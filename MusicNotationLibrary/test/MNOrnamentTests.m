//
//  MNOrnamentTests.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Cyril Silverman
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

#import "MNOrnamentTests.h"

@implementation MNOrnamentTests

- (void)start
{
    [super start];
    [self runTest:@"Ornaments" func:@selector(drawOrnaments:withTitle:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Ornaments Vertically Shifted"
             func:@selector(drawOrnamentDisplaced:withTitle:)
            frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Ornaments - Delayed turns"
             func:@selector(drawOrnamentsDelayed:withTitle:)
            frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Stacked" func:@selector(drawOrnamentsStacked:withTitle:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"With Upper/Lower Accidentals"
             func:@selector(drawOrnamentWithAccidentals:withTitle:)
            frame:CGRectMake(10, 10, 700, 250)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size
                                withParent:(MNTestCollectionItemView*)parent
                                 withTitle:(NSString*)title
{
    /*
     Vex.Flow.Test.ThreeVoices.setupContext = function(options, x, y) {
     Vex.Flow.Test.resizeCanvas(options.canvas_sel, x || 350, y || 150);
     var ctx = Vex.getCanvasContext(options.canvas_sel);
     ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
     ctx.font = " 10pt Arial";
      MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 30, x || 350, 0) addTrebleGlyph].
     setContext(ctx).draw();

     return {context: ctx, staff: staff};
     }
     */
    NSUInteger w = size.width;
//    NSUInteger h = size.height;

    w = w != 0 ? w : 350;
//    h = h != 0 ? h : 150;

    // [MNFont setFont:@" 10pt Arial"];

    // withParent:parent withTitle:title];
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (MNTestTuple*)drawOrnaments:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 700, 0)];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }]
      ];
      [notesBar1[0] addModifier:[MNOrnament ornamentWithType:@"mordent"] atIndex:0];
      [notesBar1[1] addModifier:[MNOrnament ornamentWithType:@"mordent_inverted"] atIndex:0];
      [notesBar1[2] addModifier:[MNOrnament ornamentWithType:@"turn"] atIndex:0];
      [notesBar1[3] addModifier:[MNOrnament ornamentWithType:@"turn_inverted"] atIndex:0];
      [notesBar1[4] addModifier:[MNOrnament ornamentWithType:@"tr"] atIndex:0];
      [notesBar1[5] addModifier:[MNOrnament ornamentWithType:@"upprall"] atIndex:0];
      [notesBar1[6] addModifier:[MNOrnament ornamentWithType:@"downprall"] atIndex:0];
      [notesBar1[7] addModifier:[MNOrnament ornamentWithType:@"prallup"] atIndex:0];
      [notesBar1[8] addModifier:[MNOrnament ornamentWithType:@"pralldown"] atIndex:0];
      [notesBar1[9] addModifier:[MNOrnament ornamentWithType:@"upmordent"] atIndex:0];
      [notesBar1[10] addModifier:[MNOrnament ornamentWithType:@"downmordent"] atIndex:0];
      [notesBar1[11] addModifier:[MNOrnament ornamentWithType:@"lineprall"] atIndex:0];
      [notesBar1[12] addModifier:[MNOrnament ornamentWithType:@"prallprall"] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];
    };
    return ret;
}

- (MNTestTuple*)drawOrnamentDisplaced:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 700, 0)];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"4",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"4",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"4",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"4",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"4",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"4",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/5" ],
              @"duration" : @"4",
              @"stem_direction" : @(-1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }]
      ];
      [notesBar1[0] addModifier:[MNOrnament ornamentWithType:@"mordent"] atIndex:0];
      [notesBar1[1] addModifier:[MNOrnament ornamentWithType:@"mordent_inverted"] atIndex:0];
      [notesBar1[2] addModifier:[MNOrnament ornamentWithType:@"turn"] atIndex:0];
      [notesBar1[3] addModifier:[MNOrnament ornamentWithType:@"turn_inverted"] atIndex:0];
      [notesBar1[4] addModifier:[MNOrnament ornamentWithType:@"tr"] atIndex:0];
      [notesBar1[5] addModifier:[MNOrnament ornamentWithType:@"upprall"] atIndex:0];
      [notesBar1[6] addModifier:[MNOrnament ornamentWithType:@"downprall"] atIndex:0];
      [notesBar1[7] addModifier:[MNOrnament ornamentWithType:@"prallup"] atIndex:0];
      [notesBar1[8] addModifier:[MNOrnament ornamentWithType:@"pralldown"] atIndex:0];
      [notesBar1[9] addModifier:[MNOrnament ornamentWithType:@"upmordent"] atIndex:0];
      [notesBar1[10] addModifier:[MNOrnament ornamentWithType:@"downmordent"] atIndex:0];
      [notesBar1[11] addModifier:[MNOrnament ornamentWithType:@"lineprall"] atIndex:0];
      [notesBar1[12] addModifier:[MNOrnament ornamentWithType:@"prallprall"] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];
    };
    return ret;
}

- (MNTestTuple*)drawOrnamentsDelayed:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 500, 0)];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }]
      ];

      [notesBar1[0] addModifier:[[MNOrnament ornamentWithType:@"turn"] setDelayed:YES] atIndex:0];
      [notesBar1[1] addModifier:[[MNOrnament ornamentWithType:@"turn_inverted"] setDelayed:YES] atIndex:0];
      [notesBar1[2] addModifier:[[MNOrnament ornamentWithType:@"turn_inverted"] setDelayed:YES] atIndex:0];
      [notesBar1[3] addModifier:[[MNOrnament ornamentWithType:@"turn"] setDelayed:YES] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];
    };
    return ret;
}

- (MNTestTuple*)drawOrnamentsStacked:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 30, 500, 0)];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"a/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }]
      ];
      [notesBar1[0] addModifier:[MNOrnament ornamentWithType:@"mordent"] atIndex:0];
      [notesBar1[1] addModifier:[MNOrnament ornamentWithType:@"turn_inverted"] atIndex:0];
      [notesBar1[2] addModifier:[MNOrnament ornamentWithType:@"turn"] atIndex:0];
      [notesBar1[3] addModifier:[MNOrnament ornamentWithType:@"turn_inverted"] atIndex:0];

      [notesBar1[0] addModifier:[MNOrnament ornamentWithType:@"turn"] atIndex:0];
      [notesBar1[1] addModifier:[MNOrnament ornamentWithType:@"prallup"] atIndex:0];
      [notesBar1[2] addModifier:[MNOrnament ornamentWithType:@"upmordent"] atIndex:0];
      [notesBar1[3] addModifier:[MNOrnament ornamentWithType:@"lineprall"] atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];
    };
    return ret;
}

- (MNTestTuple*)drawOrnamentWithAccidentals:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // bar 1
      MNStaff* staffBar1 = [MNStaff staffWithRect:CGRectMake(10, 60, 600, 0)];
      [staffBar1 draw:ctx];
      NSArray* notesBar1 = @[
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }],
          [[MNStaffNote alloc] initWithDictionary:@{
              @"keys" : @[ @"f/4" ],
              @"duration" : @"4",
              @"stem_direction" : @(1)
          }]
      ];

      [notesBar1[0]
          addModifier:[[[MNOrnament ornamentWithType:@"mordent"] setUpperAccidental:@"#"] setLowerAccidental:@"#"]
              atIndex:0];
      [notesBar1[1]
          addModifier:[[[MNOrnament ornamentWithType:@"turn_inverted"] setLowerAccidental:@"b"] setUpperAccidental:@"b"]
              atIndex:0];
      [notesBar1[2]
          addModifier:[[[MNOrnament ornamentWithType:@"turn"] setUpperAccidental:@"##"] setLowerAccidental:@"##"]
              atIndex:0];
      [notesBar1[3] addModifier:[[[MNOrnament ornamentWithType:@"mordent_inverted"] setLowerAccidental:@"db"]
                                    setUpperAccidental:@"db"]
                        atIndex:0];
      [notesBar1[4] addModifier:[[[MNOrnament ornamentWithType:@"turn_inverted"] setUpperAccidental:@"++"]
                                    setLowerAccidental:@"++"]
                        atIndex:0];
      [notesBar1[5] addModifier:[[[MNOrnament ornamentWithType:@"tr"] setUpperAccidental:@"n"] setLowerAccidental:@"n"]
                        atIndex:0];
      [notesBar1[6]
          addModifier:[[[MNOrnament ornamentWithType:@"prallup"] setUpperAccidental:@"d"] setLowerAccidental:@"d"]
              atIndex:0];
      [notesBar1[7]
          addModifier:[[[MNOrnament ornamentWithType:@"lineprall"] setUpperAccidental:@"db"] setLowerAccidental:@"db"]
              atIndex:0];
      [notesBar1[8]
          addModifier:[[[MNOrnament ornamentWithType:@"upmordent"] setUpperAccidental:@"bbs"] setLowerAccidental:@"bbs"]
              atIndex:0];
      [notesBar1[9]
          addModifier:[[[MNOrnament ornamentWithType:@"prallprall"] setUpperAccidental:@"bb"] setLowerAccidental:@"bb"]
              atIndex:0];
      [notesBar1[10]
          addModifier:[[[MNOrnament ornamentWithType:@"turn_inverted"] setUpperAccidental:@"+"] setLowerAccidental:@"+"]
              atIndex:0];

      // Helper function to justify and draw a 4/4 voice
      [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:staffBar1 withNotes:notesBar1];
    };
    return ret;
}

@end
