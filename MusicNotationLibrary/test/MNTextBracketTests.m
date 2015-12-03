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

- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(MNTestCollectionItemView*)parent
{
    /*
     Vex.Flow.Test.ThreeVoices.setupContext = function(options, x, y) {
     Vex.Flow.Test.resizeCanvas(options.canvas_sel, x || 350, y || 150);
     var ctx = Vex.getCanvasContext(options.canvas_sel);
     ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
     ctx.font = " 10pt Arial";
      MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 30, x || 350, 0) addTrebleGlyph].
     setContext(ctx).draw();s

     return {context: ctx, staff: staff};
     }
     */
    NSUInteger w = size.width;
//    NSUInteger h = size.height;

    w = w != 0 ? w : 350;
//    h = h != 0 ? h : 150;

    // [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (MNTestTuple*)simple0:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(40, 40, 550, 0)] addTrebleGlyph];

    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      NSArray* notes = [@[
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

      /*
          var octave_top = new Vex.Flow.TextBracket({
          start: notes[0],
          stop: notes[3],
          text: "15",
          superscript: "va",
          position: 1
          });

          var octave_bottom = new Vex.Flow.TextBracket({
          start: notes[0],
          stop: notes[3],
          text: "8",
          superscript: "vb",
          position: -1
          });

          octave_bottom.setLine(3);

          [MNFormatter formatter] joinVoices:@[voice] formatToStaff([voice], staff);
          [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

          octave_top draw:ctx];
          octave_bottom draw:ctx];
      };
       */
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
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [octave_top draw:ctx];
      [octave_bottom draw:ctx];

    };
    return ret;
}

- (MNTestTuple*)simple1:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    /*
    Vex.Flow.Test.TextBracket.simple1 = function(options, contextBuilder) {
        expect(0);

        options.contextBuilder = contextBuilder;
        var ctx = new options.contextBuilder(options.canvas_sel, 650, 200);
        ctx.scale(1, 1); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
        ctx.font = " 10pt Arial";
        //ctx.translate(0.5, 0.5);
         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 40, 550).addTrebleGlyph();
        staff draw:ctx];

    */

    //    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    //    {
    //        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    //    };

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(40, 40, 550, 0)];

    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      /*

  / *
      function newNote(note_struct) { return [[[MNStaffNote alloc]initWithDictionary:(note_struct); }

      NSArray *notes = @[
                   @{ @"keys" : @[ @"c/4"], @"duration" : @"4"},
                   @{ @"keys" : @[ @"c/4"], @"duration" : @"4"},
                   @{ @"keys" : @[ @"c/4"], @"duration" : @"4"},
                   @{ @"keys" : @[ @"c/4"], @"duration" : @"4"},
                   @{ @"keys" : @[ @"c/4"], @"duration" : @"4"}
                   ].map(newNote);

       MNVoice *voice =  [MNVoice voiceWithTimeSignature:MNTime4_4] setStrict:NO];
      [voice addTickables:notes];
   */

      /*
          var octave_top0 = new Vex.Flow.TextBracket({
          start: notes[0],
          stop: notes[1],
          text: "Cool notes",
          superscript: "",
          position: 1
          });

          var octave_bottom0 = new Vex.Flow.TextBracket({
          start: notes[2],
          stop: notes[4],
          text: "Not cool notes",
          superscript: " super uncool",
          position: -1
          });

          octave_bottom0->_renderOptions setbracket_height = 40;
          octave_bottom0.setLine(4);

          var octave_top1 = new Vex.Flow.TextBracket({
          start: notes[2],
          stop: notes[4],
          text: "Testing",
          superscript: "superscript",
          position: 1
          });

          var octave_bottom1 = new Vex.Flow.TextBracket({
          start: notes[0],
          stop: notes[1],
          text: "8",
          superscript: "vb",
          position: -1
          });

          octave_top1->_renderOptions setline_width = 2;
          octave_top1->_renderOptions setshow_bracket = NO;
          octave_bottom1.setDashed(YES, [2, 2]);
          octave_top1.setFont({
          weight: "",
          family: "Arial",
          size: 15
          });

          octave_bottom1.font.size = 30;
          octave_bottom1.setDashed(NO);
          octave_bottom1->_renderOptions setunderline_superscript = NO;

          octave_bottom1.setLine(3);

          [MNFormatter formatter] joinVoices:@[voice] formatToStaff([voice], staff);
          [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

          octave_top0 draw:ctx];
          octave_bottom0 draw:ctx];

          octave_top1 draw:ctx];
          octave_bottom1 draw:ctx];
      };
       */
    };
    return ret;
}

@end
