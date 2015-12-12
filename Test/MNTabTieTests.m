//
//  MNTabTieTests.m
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

#import "MNTabTieTests.h"

@implementation MNTabTieTests

- (void)start
{
    [super start];
    float w = 600, h = 150;
    [self runTest:@"Simple TabTie" func:@selector(simple:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Hammerons" func:@selector(simpleHammeron:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Pulloffs" func:@selector(simplePulloff:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Tapping" func:@selector(tap:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Continuous" func:@selector(continuous:) frame:CGRectMake(10, 10, w, h)];
}

- (void)tearDown
{
    [super tearDown];
}


- (void)setupContext
{
    /*
    Vex.Flow.Test.TabTie.setupContext = function(options, x, y) {
        var ctx = options.contextBuilder(options.canvas_sel, x || 350, y || 160);
        ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.setFont(@"Arial"  func:@selector(size, "");
         MNStaff *staff = new Vex.Flow.TabStaff(10, 10, x || 350).addTabGlyph().
        setContext(ctx).draw();

        return {context: ctx, staff: staff};
    }
     */
}

+ (void)tieNotes:(NSArray*)notes
     withIndices:(NSArray*)indices
           staff:(MNTabStaff*)staff
         context:(CGContextRef)ctx
            text:(NSString*)text
{
    MNVoice* voice = [[MNVoice voiceWithTimeSignature:MNTime4_4] addTickables:notes];
    //      MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];

    [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

    NSString* annotation = [NSString stringWithString:text];

    if(!text || text.length == 0)
    {
        annotation = @"Annotation";
    }

    MNTabTie* tie = [[MNTabTie alloc] initWithNoteTie:[[MNNoteTie alloc] initWithDictionary:@{
                                          @"first_note" : notes[0],
                                          @"last_note" : notes[1],
                                          @"first_indices" : indices,
                                          @"last_indices" : indices,
                                      }] andText:annotation];

    [tie draw:ctx];
}

+ (void)drawTie:(NSArray*)notes
    withIndices:(NSArray*)indices
        options:(NSDictionary*)options
           text:(NSString*)text
        context:(CGContextRef)ctx
{
    MNTabStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 10, 400, 0)] addTabGlyph];
    [staff draw:ctx];
    [[self class] tieNotes:notes withIndices:indices staff:staff context:ctx text:text];
}

- (MNTestBlockStruct*)simple:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };

    //    MNTabStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 10, 350, 0)] addTabGlyph];

    NSArray* notes = @[
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"4"} ],
               @"duration" : @"h" }),
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"6"} ],
               @"duration" : @"h" }),
    ];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      //      [staff draw:ctx];

      //      [[self class] tieNotes:notes withIndices:@[] staff:staff context:ctx text:@""];
      [[self class] drawTie:notes
                withIndices:@[ @0 ]
                    options:@
                    {
                    } text:@""
                    context:ctx];

      ok(YES, @"Simple Test");
    };

    return ret;
}

- (MNTestBlockStruct*)tap:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };

    MNAnnotation* (^newAnnotation)(NSString*) = ^MNAnnotation*(NSString* text)
    {
        MNAnnotation* ret = [MNAnnotation annotationWithText:text];
        return ret;
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [[self class] drawTie:@[
          [newNote(
              @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"12"} ],
                 @"duration" : @"h" }) addAnnotation:newAnnotation(@"T")
                                             atIndex:0],
          newNote(
              @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"10"} ],
                 @"duration" : @"h" })
      ] withIndices:@[ @0 ]
                    options:@
                    {
                    } text:@"P"
                    context:ctx];

      ok(YES, @"Tapping Test");
    };

    return ret;
}

typedef MNTabTie* (^Factory)(NSDictionary*);

+ (MNTestBlockStruct*)multiTest:(NSDictionary*)options factory:(Factory)factory
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

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

- (MNTestBlockStruct*)simpleHammeron:(id<MNTestParentDelegate>)parent
{
    Factory factory = ^MNTabTie*(NSDictionary* dict)
    {
        return [MNTabTie createHammeron:[[MNNoteTie alloc] initWithDictionary:dict]];
    };

    return [[self class] multiTest:@
                         {
                         } factory:factory];
}

- (MNTestBlockStruct*)simplePulloff:(id<MNTestParentDelegate>)parent
{
    Factory factory = ^MNTabTie*(NSDictionary* dict)
    {
        return [MNTabTie createPulloff:[[MNNoteTie alloc] initWithDictionary:dict]];
    };

    return [[self class] multiTest:@
                         {
                         } factory:factory];
}

- (MNTestBlockStruct*)continuous:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* note_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:note_struct];
    };

    MNTabStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 10, 500, 0)] addTabGlyph];

    NSArray* notes = @[
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"4"} ],
               @"duration" : @"q" }),
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"5"} ],
               @"duration" : @"q" }),
        newNote(
            @{ @"positions" : @[ @{@"str" : @4, @"fret" : @"6"} ],
               @"duration" : @"h" })
    ];

    MNVoice* voice = [[MNVoice voiceWithTimeSignature:MNTime4_4] addTickables:notes];
    //    MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:300];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];

      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [[MNTabTie createHammeron:[[MNNoteTie alloc] initWithDictionary:@{
                     @"first_note" : notes[0],
                     @"last_note" : notes[1],
                     @"first_indices" : @[ @0 ],
                     @"last_indices" : @[ @0 ],
                 }]] draw:ctx];

      [[MNTabTie createPulloff:[[MNNoteTie alloc] initWithDictionary:@{
                     @"first_note" : notes[1],
                     @"last_note" : notes[2],
                     @"first_indices" : @[ @0 ],
                     @"last_indices" : @[ @0 ],
                 }]] draw:ctx];

      ok(YES, @"Continuous Hammeron");
    };
    return ret;
}

@end
