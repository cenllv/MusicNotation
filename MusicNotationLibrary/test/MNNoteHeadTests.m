//
//  MNNot.headTests.m
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

#import "MNNoteHeadTests.h"
#import "MNNoteHead.h"

@implementation MNNoteHeadTests

- (void)start
{
    [super start];
    float w = 600, h = 140;
    [self runTest:@"Basic" func:@selector(basic:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Bounding Boxes" func:@selector(basicBoundingBox:) frame:CGRectMake(10, 10, w, h)];
}

- (void)tearDown
{
    [super tearDown];
}


/*
Vex.Flow.Test.NoteHead.setupContext = function(options, x, y) {

    var ctx = new options.contextBuilder(options.canvas_sel, x || 450, y || 140);
    ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
    ctx.font = " 10pt Arial";
     MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 10, x || 450).addTrebleGlyph();

    return {context: ctx, staff: staff};
};
 */
//+ (void)setupContext:(NSView *)parent {
//     MNTestView *test =  [MNTestView createCanvasTest:CGSizeMake(450, 140) withParent:parent];
//
//    test.drawBlock = ^(CGRect dirtyRect, CGRect bounds, NSGraphicsContext *context) {
//
//         MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(300, 10, 300, 0)];
//
//
//
//
//    };
//}

- (MNTestBlockStruct*)basic:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 300, 0)];

    [staff addTrebleGlyph];

    MNFormatter* formatter = [MNFormatter formatter];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:MNModeSoft];
    MNNoteHead* note_head1 = [MNNoteHead noteHeadWithOptionsDict:@{ @"duration" : @"4", @"line" : @3 }];
    MNNoteHead* note_head2 = [MNNoteHead noteHeadWithOptionsDict:@{ @"duration" : @"2", @"line" : @2.5 }];
    MNNoteHead* note_head3 = [MNNoteHead noteHeadWithOptionsDict:@{ @"duration" : @"1", @"line" : @0 }];

    [voice addTickables:@[ note_head1, note_head2, note_head3 ]];
    [formatter joinVoices:@[ voice ]];
    [formatter formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      MNLogInfo(@"Basic NoteHead test");
    };
    return ret;
}

- (MNTestBlockStruct*)basicBoundingBox:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 300, 0)] addTrebleGlyph];

    MNFormatter* formatter = [MNFormatter formatter];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice setStrict:MNModeSoft];
    MNNoteHead* note_head1 = [MNNoteHead noteHeadWithOptionsDict:@{ @"duration" : @"4", @"line" : @3 }];
    MNNoteHead* note_head2 = [MNNoteHead noteHeadWithOptionsDict:@{ @"duration" : @"2", @"line" : @2.5 }];
    MNNoteHead* note_head3 = [MNNoteHead noteHeadWithOptionsDict:@{ @"duration" : @"1", @"line" : @0 }];

    [voice addTickables:@[ note_head1, note_head2, note_head3 ]];
    [formatter joinVoices:@[ voice ]];
    [formatter formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      [note_head1.boundingBox draw:ctx];
      [note_head2.boundingBox draw:ctx];
      [note_head3.boundingBox draw:ctx];

      MNLogInfo(@"NoteHead Bounding Boxes");
    };
    return ret;
}

@end
