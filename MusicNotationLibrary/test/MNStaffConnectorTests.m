//
//  MNStaffConnectorTests.m
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

#import "MNStaffConnectorTests.h"

@implementation MNStaffConnectorTests

// TODO: is staff_LINE_THICKNESS a constant inside of vfstaff?
static NSUInteger staff_LINE_THICKNESS;

- (void)start
{
    [super start];
    staff_LINE_THICKNESS = 1;
    float w = 600, h = 250;
    [self runTest:@"StaffConnector Single Draw Test"
             func:@selector(drawSingle:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Single Draw Test, 1px Staff Line Thickness"
             func:@selector(drawSingle1pxBarlines:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Single Both Sides Test"
             func:@selector(drawSingleBoth:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Double Draw Test"
             func:@selector(drawDouble:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Line Left Draw Test"
             func:@selector(drawRepeatBegin:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Line Right Draw Test"
             func:@selector(drawRepeatEnd:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Thin Double Line Right Draw Test"
             func:@selector(drawThinDouble:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Lines Overlapping Draw Test"
             func:@selector(drawRepeatAdjacent:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Lines Offset Draw Test"
             func:@selector(drawRepeatOffset:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Lines Offset Draw Test 2"
             func:@selector(drawRepeatOffset2:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Brace Draw Test"
             func:@selector(drawBrace:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Brace Wide Draw Test"
             func:@selector(drawBraceWide:withTitle:)
            frame:CGRectMake(10, 10, w, 350)];
    [self runTest:@"StaffConnector Bracket Draw Test"
             func:@selector(drawBracket:withTitle:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Combined Draw Test"
             func:@selector(drawCombined:withTitle:)
            frame:CGRectMake(10, 10, w, 750)];
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
     setContext(ctx).draw();

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

- (MNTestTuple*)drawSingle:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector setType:MNStaffConnectorSingle];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawSingle1pxBarlines:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      staff_LINE_THICKNESS = 1;

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector setType:MNStaffConnectorSingle];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      staff_LINE_THICKNESS = 2;

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawSingleBoth:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector setType:MNStaffConnectorSingleLeft];

      MNStaffConnector* connector2 = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector2 setType:MNStaffConnectorSingleRight];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [connector2 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawDouble:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector setType:MNStaffConnectorDouble];

      [line setType:MNStaffConnectorSingle];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawBrace:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(100, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(100, 120, 300, 0)];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector setType:MNStaffConnectorBrace];

      [connector setText:@"Piano"];
      [line setType:MNStaffConnectorSingle];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawBraceWide:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 20, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 240, 300, 0)];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector setType:MNStaffConnectorBrace];

      [line setType:MNStaffConnectorSingle];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawBracket:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [connector setType:MNStaffConnectorBracket];

      [line setType:MNStaffConnectorSingle];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawRepeatBegin:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

      [staff setBegBarType:MNBarLineRepeatBegin];
      [staff2 setBegBarType:MNBarLineRepeatBegin];

      MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [line setType:MNStaffConnectorBoldDoubleLeft];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawRepeatEnd:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

      [staff setEndBarType:MNBarLineRepeatEnd];
      [staff2 setEndBarType:MNBarLineRepeatEnd];

      MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [line setType:MNStaffConnectorBoldDoubleRight];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawThinDouble:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

      [staff setEndBarType:MNBarLineDouble];
      [staff2 setEndBarType:MNBarLineDouble];

      MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      [line setType:MNStaffConnectorThinDouble];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawRepeatAdjacent:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 150, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 150, 0)];
      MNStaff* staff3 = [MNStaff staffWithRect:CGRectMake(175, 10, 150, 0)];
      MNStaff* staff4 = [MNStaff staffWithRect:CGRectMake(175, 120, 150, 0)];

      [staff setEndBarType:MNBarLineRepeatEnd];
      [staff2 setEndBarType:MNBarLineRepeatEnd];
      [staff3 setEndBarType:MNBarLineEnd];
      [staff4 setEndBarType:MNBarLineEnd];

      [staff setBegBarType:MNBarLineRepeatBegin];
      [staff2 setBegBarType:MNBarLineRepeatBegin];
      [staff3 setBegBarType:MNBarLineRepeatBegin];
      [staff4 setBegBarType:MNBarLineRepeatBegin];
      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* connector2 = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* connector3 = [MNStaffConnector staffConnectorWithTopStaff:staff3 andBottomStaff:staff4];
      MNStaffConnector* connector4 = [MNStaffConnector staffConnectorWithTopStaff:staff3 andBottomStaff:staff4];

      [connector setType:MNStaffConnectorBoldDoubleLeft];
      [connector2 setType:MNStaffConnectorBoldDoubleRight];
      [connector3 setType:MNStaffConnectorBoldDoubleLeft];
      [connector4 setType:MNStaffConnectorBoldDoubleRight];
      [staff draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];
      [staff4 draw:ctx];
      [connector draw:ctx];
      [connector2 draw:ctx];
      [connector3 draw:ctx];
      [connector4 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawRepeatOffset2:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 150, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 150, 0)];
      MNStaff* staff3 = [MNStaff staffWithRect:CGRectMake(175, 10, 150, 0)];
      MNStaff* staff4 = [MNStaff staffWithRect:CGRectMake(175, 120, 150, 0)];

      [staff addClefWithName:@"treble"];
      [staff2 addClefWithName:@"bass"];

      [staff3 addClefWithName:@"alto"];
      [staff4 addClefWithName:@"treble"];

      [staff addTimeSignatureWithName:@"4/4"];
      [staff2 addTimeSignatureWithName:@"4/4"];

      [staff3 addTimeSignatureWithName:@"6/8"];
      [staff4 addTimeSignatureWithName:@"6/8"];

      [staff setEndBarType:MNBarLineRepeatEnd];
      [staff2 setEndBarType:MNBarLineRepeatEnd];
      [staff3 setEndBarType:MNBarLineEnd];
      [staff4 setEndBarType:MNBarLineEnd];

      [staff setBegBarType:MNBarLineRepeatBegin];
      [staff2 setBegBarType:MNBarLineRepeatBegin];
      [staff3 setBegBarType:MNBarLineRepeatBegin];
      [staff4 setBegBarType:MNBarLineRepeatBegin];
      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* connector2 = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* connector3 = [MNStaffConnector staffConnectorWithTopStaff:staff3 andBottomStaff:staff4];
      MNStaffConnector* connector4 = [MNStaffConnector staffConnectorWithTopStaff:staff3 andBottomStaff:staff4];
      MNStaffConnector* connector5 = [MNStaffConnector staffConnectorWithTopStaff:staff3 andBottomStaff:staff4];

      [connector setType:MNStaffConnectorBoldDoubleLeft];
      [connector2 setType:MNStaffConnectorBoldDoubleRight];
      [connector3 setType:MNStaffConnectorBoldDoubleLeft];
      [connector4 setType:MNStaffConnectorBoldDoubleRight];
      [connector5 setType:MNStaffConnectorSingleLeft];

      [connector setXShift:[staff getModifierXShift]];
      [connector3 setXShift:[staff3 getModifierXShift]];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];
      [staff4 draw:ctx];
      [connector draw:ctx];
      [connector2 draw:ctx];
      [connector3 draw:ctx];
      [connector4 draw:ctx];
      [connector5 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawRepeatOffset:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 150, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 150, 0)];
      MNStaff* staff3 = [MNStaff staffWithRect:CGRectMake(175, 10, 150, 0)];
      MNStaff* staff4 = [MNStaff staffWithRect:CGRectMake(175, 120, 150, 0)];

      [staff addClefWithName:@"bass"];
      [staff2 addClefWithName:@"alto"];

      [staff3 addClefWithName:@"treble"];
      [staff4 addClefWithName:@"tenor"];

      [staff3 addKeySignature:@"Ab"];
      [staff4 addKeySignature:@"Ab"];

      [staff addTimeSignatureWithName:@"4/4"];
      [staff2 addTimeSignatureWithName:@"4/4"];

      [staff3 addTimeSignatureWithName:@"6/8"];
      [staff4 addTimeSignatureWithName:@"6/8"];

      [staff setEndBarType:MNBarLineRepeatEnd];
      [staff2 setEndBarType:MNBarLineRepeatEnd];
      [staff3 setEndBarType:MNBarLineEnd];
      [staff4 setEndBarType:MNBarLineEnd];

      [staff setBegBarType:MNBarLineRepeatBegin];
      [staff2 setBegBarType:MNBarLineRepeatBegin];
      [staff3 setBegBarType:MNBarLineRepeatBegin];
      [staff4 setBegBarType:MNBarLineRepeatBegin];
      MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* connector2 = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
      MNStaffConnector* connector3 = [MNStaffConnector staffConnectorWithTopStaff:staff3 andBottomStaff:staff4];
      MNStaffConnector* connector4 = [MNStaffConnector staffConnectorWithTopStaff:staff3 andBottomStaff:staff4];
      MNStaffConnector* connector5 = [MNStaffConnector staffConnectorWithTopStaff:staff3 andBottomStaff:staff4];

      [connector setType:MNStaffConnectorBoldDoubleLeft];
      [connector2 setType:MNStaffConnectorBoldDoubleRight];
      [connector3 setType:MNStaffConnectorBoldDoubleLeft];
      [connector4 setType:MNStaffConnectorBoldDoubleRight];
      [connector5 setType:MNStaffConnectorSingleLeft];

      [connector setXShift:[staff getModifierXShift]];
      [connector3 setXShift:[staff3 getModifierXShift]];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];
      [staff4 draw:ctx];
      [connector draw:ctx];
      [connector2 draw:ctx];
      [connector3 draw:ctx];
      [connector4 draw:ctx];
      [connector5 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)drawCombined:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(150, 10, 300, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(150, 100, 300, 0)];
      MNStaff* staff3 = [MNStaff staffWithRect:CGRectMake(150, 190, 300, 0)];
      MNStaff* staff4 = [MNStaff staffWithRect:CGRectMake(150, 280, 300, 0)];
      MNStaff* staff5 = [MNStaff staffWithRect:CGRectMake(150, 370, 300, 0)];
      MNStaff* staff6 = [MNStaff staffWithRect:CGRectMake(150, 460, 300, 0)];
      MNStaff* staff7 = [MNStaff staffWithRect:CGRectMake(150, 560, 300, 0)];
      [staff setTextWithText:@"Violin" atPosition:MNPositionLeft];

      MNStaffConnector* conn_single = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff7];
      MNStaffConnector* conn_double = [MNStaffConnector staffConnectorWithTopStaff:staff2 andBottomStaff:staff3];
      MNStaffConnector* conn_bracket = [MNStaffConnector staffConnectorWithTopStaff:staff4 andBottomStaff:staff5];
      MNStaffConnector* conn_brace = [MNStaffConnector staffConnectorWithTopStaff:staff6 andBottomStaff:staff7];
      [conn_single setType:MNStaffConnectorSingle];
      [conn_double setType:MNStaffConnectorDouble];
      [conn_bracket setType:MNStaffConnectorBracket];
      [conn_brace setType:MNStaffConnectorBrace];
      [conn_double setText:@"Piano"];
      [conn_bracket setText:@"Celesta"];
      [conn_brace setText:@"Harpsichord"];

      [MNStaffConnector setDebugMode:YES];

      [staff draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];
      [staff4 draw:ctx];
      [staff5 draw:ctx];
      [staff6 draw:ctx];
      [staff7 draw:ctx];
      [conn_single draw:ctx];
      [conn_double draw:ctx];
      [conn_bracket draw:ctx];
      [conn_brace draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

@end
