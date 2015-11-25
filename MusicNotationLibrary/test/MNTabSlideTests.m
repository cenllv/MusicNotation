//
//  MNTabSlideTests.m
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

#import "MNTabSlideTests.h"

@implementation MNTabSlideTests

- (void)start
{
    [super start];
    float w = 600, h = 150;
    [self runTest:@"Simple TabSlide" func:@selector(simple:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Slide Up" func:@selector(slideUp:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Slide Down" func:@selector(slideDown:) frame:CGRectMake(10, 10, w, h)];
}

+ (void)tieNotes:(NSArray*)notes withIndices:(NSArray*)indices staff:(MNTabStaff*)staff context:(CGContextRef)ctx
{
    MNVoice* voice = [[MNVoice voiceWithTimeSignature:MNTime4_4] addTickables:notes];
    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:100];

    [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

    //    NSString* annotation = [NSString stringWithString:text];
    //
    //    if(!text || text.length == 0)
    //    {
    //        annotation = [NSString stringWithString:@"Annotation"];
    //    }

    MNTabSlide* slide = [[MNTabSlide alloc] initWithNoteTie:[[MNNoteTie alloc] initWithDictionary:@{
                                                @"first_note" : notes[0],
                                                @"last_note" : notes[1],
                                                @"first_indices" : indices,
                                                @"last_indices" : indices,
                                            }] direction:MNTabSlideSLIDE_UP];

    [slide draw:ctx];
}

- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(MNTestCollectionItemView*)parent
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

    // [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (void)setupContext
{
    /*
    Vex.Flow.Test.TabSlide.setupContext = function(options, x, y) {
        var ctx = options.contextBuilder(options.canvas_sel, 350, 140);
        ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.font = "10pt Arial";
         MNStaff *staff = new Vex.Flow.TabStaff(10, 10, x || 350).addTabGlyph().
        setContext(ctx).draw();

        return {context: ctx, staff: staff};
    }

     */
}

- (MNTestTuple*)simple:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*

        Vex.Flow.Test.TabSlide.tieNotes([
                                         newNote({ positions: [{str:4, fret:4}], @"duration" : @"h"}),
                                         newNote({ positions: [{str:4, fret:6}], @"duration" : @"h"})
                                         ], [0], c.staff, c.context);

     */

    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };

    MNTabStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 10, 350, 0)] addTabGlyph];

    NSArray* notes = @[
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"4"} ],
               @"duration" : @"h" }),
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"6"} ],
               @"duration" : @"h" }),
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      //      [[self class] tieNotes:notes withIndices:@[] staff:staff context:ctx text:@""];
      [[self class] tieNotes:notes withIndices:@[ @0 ] staff:staff context:ctx];

      ok(YES, @"Simple Test");
    };

    return ret;
}

typedef MNTabTie* (^Factory)(NSDictionary*);

+ (MNTestTuple*)multiTest:(NSDictionary*)options factory:(Factory)factory
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };

    MNTabStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 10, 440, 0)] addTabGlyph];

    NSArray* notes = @[
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"4"} ],
               @"duration" : @"8" }),
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"4"} ],
               @"duration" : @"8" }),
        newNote(@{
            @"positions" : @[ @{@"str" : @4, @"fret" : @"4"}, @{@"str" : @5, @"fret" : @"4"} ],
            @"duration" : @"8"
        }),
        newNote(@{
            @"positions" : @[ @{@"str" : @4, @"fret" : @"6"}, @{@"str" : @5, @"fret" : @"6"} ],
            @"duration" : @"8"
        }),
        newNote(
            @{ @"positions" : @[ @{@"str" : @2, @"fret" : @"14"} ],
               @"duration" : @"8" }),
        newNote(
            @{ @"positions" : @[ @{@"str" : @2, @"fret" : @"16"} ],
               @"duration" : @"8" }),
        newNote(@{
            @"positions" : @[ @{@"str" : @2, @"fret" : @"14"}, @{@"str" : @3, @"fret" : @"14"} ],
            @"duration" : @"8"
        }),
        newNote(@{
            @"positions" : @[ @{@"str" : @2, @"fret" : @"16"}, @{@"str" : @3, @"fret" : @"16"} ],
            @"duration" : @"8"
        })
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      MNVoice* voice = [[MNVoice voiceWithTimeSignature:MNTime4_4] addTickables:notes];
      //      MNFormatter* formatter =
      [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [factory(@{
          @"first_note" : notes[0],
          @"last_note" : notes[1],
          @"first_indices" : @[
              @0,
          ],
          @"last_indices" : @[
              @0,
          ],
      }) draw:ctx];

      ok(YES, @"Single note");

      [factory(@{
          @"first_note" : notes[2],
          @"last_note" : notes[3],
          @"first_indices" : @[ @0, @1 ],
          @"last_indices" : @[ @0, @1 ],
      }) draw:ctx];

      ok(YES, @"Chord");

      [factory(@{
          @"first_note" : notes[4],
          @"last_note" : notes[5],
          @"first_indices" : @[
              @0,
          ],
          @"last_indices" : @[
              @0,
          ],
      }) draw:ctx];

      ok(YES, @"Single note high-fret");

      [factory(@{
          @"first_note" : notes[6],
          @"last_note" : notes[7],
          @"first_indices" : @[ @0, @1 ],
          @"last_indices" : @[ @0, @1 ],
      }) draw:ctx];

      ok(YES, @"Chord high-fret");
    };

    return ret;
}

- (MNTestTuple*)slideUp:(MNTestCollectionItemView*)parent
{
    /*
    Vex.Flow.Test.TabSlide.slideUp = function(options, contextBuilder) {
        options.contextBuilder = contextBuilder;
        Vex.Flow.Test.TabSlide.multiTest(options, Vex.Flow.TabSlide.createSlideUp);
    }
     */
    Factory factory = ^MNTabSlide*(NSDictionary* dict)
    {
        return [MNTabSlide createSlideUp:[[MNNoteTie alloc] initWithDictionary:dict]];
    };

    return [[self class] multiTest:@
                         {
                         } factory:factory];
}

- (MNTestTuple*)slideDown:(MNTestCollectionItemView*)parent
{
    /*
    Vex.Flow.Test.TabSlide.slideDown = function(options, contextBuilder) {
        options.contextBuilder = contextBuilder;
        Vex.Flow.Test.TabSlide.multiTest(options, Vex.Flow.TabSlide.createSlideDown);
    }

     */
    Factory factory = ^MNTabSlide*(NSDictionary* dict)
    {
        return [MNTabSlide createSlideDown:[[MNNoteTie alloc] initWithDictionary:dict]];
    };

    return [[self class] multiTest:@
                         {
                         } factory:factory];
}

@end
