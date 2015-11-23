//
//  MNCurveTests.m
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

#import "MNCurveTests.h"
#import "NSArray+MNAdditions.h"

@implementation MNCurveTests

- (void)start
{
    [super start];
    float w = 600, h = 150;
    [self runTest:@"Simple Curve" func:@selector(simple:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Rounded Curve" func:@selector(rounded:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Thick Thin Curves" func:@selector(thickThin:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Top Curve" func:@selector(topCurve:) frame:CGRectMake(10, 10, w, h)];
}

+ (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(MNTestCollectionItemView*)parent
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
    NSUInteger h = size.height;

    w = w != 0 ? w : 350;
    h = h != 0 ? h : 150;

    //     [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (MNTestTuple*)simple:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(350, 140) withParent:parent];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/6" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    // MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];

    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]] autoStem:YES];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]] autoStem:YES];

    MNCurve* curve1 = [MNCurve curveFromNote:notes[0]
                                      toNote:notes[3]
                              withDictionary:@{
                                  @"cps" : @[ @{@"x" : @(0), @"y" : @(10)}, @{@"x" : @(0), @"y" : @(50)} ]
                              }];

    MNCurve* curve2 = [MNCurve curveFromNote:notes[4]
                                      toNote:notes[7]
                              withDictionary:@{
                                  @"cps" : @[ @{@"x" : @(0), @"y" : @(10)}, @{@"x" : @(0), @"y" : @(20)} ]
                              }];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [c.staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      [curve1 draw:ctx];
      [curve2 draw:ctx];

      ok(YES, @"Simple Curve");
    };
    return ret;
}

- (MNTestTuple*)rounded:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(350, 140) withParent:parent];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/6" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/6" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    // MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]] autoStem:YES];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]] autoStem:YES];

    MNCurve* curve1 = [MNCurve curveFromNote:notes[0]
                                      toNote:notes[3]
                              withDictionary:@{
                                  @"x_shift" : @(-10),
                                  @"y_shift" : @(30),
                                  @"cps" : @[ @{@"x" : @(0), @"y" : @(20)}, @{@"x" : @(0), @"y" : @(50)} ]
                              }];

    MNCurve* curve2 = [MNCurve curveFromNote:notes[4]
                                      toNote:notes[7]
                              withDictionary:@{
                                  @"cps" : @[ @{@"x" : @(0), @"y" : @(50)}, @{@"x" : @(0), @"y" : @(50)} ]
                              }];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [c.staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      [curve1 draw:ctx];
      [curve2 draw:ctx];

      ok(YES, @"Rounded Curve");
    };
    return ret;
}

- (MNTestTuple*)thickThin:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(350, 140) withParent:parent];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/6" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/6" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    // MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]] autoStem:YES];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]] autoStem:YES];

    MNCurve* curve1 = [MNCurve curveFromNote:notes[0]
                                      toNote:notes[3]
                              withDictionary:@{
                                  @"thickness" : @(10),
                                  @"x_shift" : @(-10),
                                  @"y_shift" : @(30),
                                  @"cps" : @[ @{@"x" : @(0), @"y" : @(20)}, @{@"x" : @(0), @"y" : @(50)} ]
                              }];

    MNCurve* curve2 = [MNCurve curveFromNote:notes[4]
                                      toNote:notes[7]
                              withDictionary:@{
                                  @"thickness" : @(0),
                                  @"cps" : @[ @{@"x" : @(0), @"y" : @(50)}, @{@"x" : @(0), @"y" : @(50)} ]
                              }];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [c.staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      [curve1 draw:ctx];
      [curve2 draw:ctx];

      ok(YES, @"Thick Thin Curve");
    };
    return ret;
}

- (MNTestTuple*)topCurve:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNViewStaffStruct* c = [[self class] setupContextWithSize:MNUIntSizeMake(350, 140) withParent:parent];

    NSArray* notes = @[
        newNote(
            @{ @"keys" : @[ @"c/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"d/4" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/6" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"f/6" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" }),
        newNote(
            @{ @"keys" : @[ @"g/5" ],
               @"stem_direction" : @(1),
               @"duration" : @"8" })
    ];

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    // MNFormatter *formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];
    MNBeam* beam1_1 = [MNBeam beamWithNotes:[notes slice:[@0:4]] autoStem:YES];
    MNBeam* beam1_2 = [MNBeam beamWithNotes:[notes slice:[@4:8]] autoStem:YES];

    MNCurve* curve1 = [MNCurve curveFromNote:notes[0]
                                      toNote:notes[7]
                              withDictionary:@{
                                  @"x_shift" : @(-3),
                                  @"y_shift" : @(10),
                                  @"position" : @(MNCurveNearTop),
                                  @"position_end" : @(MNCurveNearHead),

                                  @"cps" : @[ @{@"x" : @(0), @"y" : @(20)}, @{@"x" : @(40), @"y" : @(80)} ]
                              }];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [c.staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:c.staff];
      [beam1_1 draw:ctx];
      [beam1_2 draw:ctx];

      [curve1 draw:ctx];

      ok(YES, @"Top Curve");
    };
    return ret;
}
@end
