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
    [self runTest:@"StaffConnector Single Draw Test" func:@selector(drawSingle:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Single Draw Test, 1px Staff Line Thickness"
             func:@selector(drawSingle1pxBarlines:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Single Both Sides Test"
             func:@selector(drawSingleBoth:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Double Draw Test" func:@selector(drawDouble:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Line Left Draw Test"
             func:@selector(drawRepeatBegin:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Line Right Draw Test"
             func:@selector(drawRepeatEnd:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Thin Double Line Right Draw Test"
             func:@selector(drawThinDouble:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Lines Overlapping Draw Test"
             func:@selector(drawRepeatAdjacent:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Lines Offset Draw Test"
             func:@selector(drawRepeatOffset:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Bold Double Lines Offset Draw Test 2"
             func:@selector(drawRepeatOffset2:)
            frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Brace Draw Test" func:@selector(drawBrace:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Brace Wide Draw Test"
             func:@selector(drawBraceWide:)
            frame:CGRectMake(10, 10, w, 350)];
    [self runTest:@"StaffConnector Bracket Draw Test" func:@selector(drawBracket:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"StaffConnector Combined Draw Test" func:@selector(drawCombined:) frame:CGRectMake(10, 10, w, 750)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestBlockStruct*)drawSingle:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

    MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [connector setType:MNStaffConnectorSingle];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawSingle1pxBarlines:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    staff_LINE_THICKNESS = 1;

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

    MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [connector setType:MNStaffConnectorSingle];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      staff_LINE_THICKNESS = 2;

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawSingleBoth:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

    MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [connector setType:MNStaffConnectorSingleLeft];

    MNStaffConnector* connector2 = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [connector2 setType:MNStaffConnectorSingleRight];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [connector2 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawDouble:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

    MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [connector setType:MNStaffConnectorDouble];

    [line setType:MNStaffConnectorSingle];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawBrace:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(100, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(100, 120, 300, 0)];

    MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [connector setType:MNStaffConnectorBrace];

    [connector setText:@"Piano"];
    [line setType:MNStaffConnectorSingle];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawBraceWide:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 20, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 240, 300, 0)];

    MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [connector setType:MNStaffConnectorBrace];

    [line setType:MNStaffConnectorSingle];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawBracket:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

    MNStaffConnector* connector = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [connector setType:MNStaffConnectorBracket];

    [line setType:MNStaffConnectorSingle];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [connector draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawRepeatBegin:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

    [staff setBegBarType:MNBarLineRepeatBegin];
    [staff2 setBegBarType:MNBarLineRepeatBegin];

    MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [line setType:MNStaffConnectorBoldDoubleLeft];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawRepeatEnd:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

    [staff setEndBarType:MNBarLineRepeatEnd];
    [staff2 setEndBarType:MNBarLineRepeatEnd];

    MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [line setType:MNStaffConnectorBoldDoubleRight];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawThinDouble:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(25, 10, 300, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(25, 120, 300, 0)];

    [staff setEndBarType:MNBarLineDouble];
    [staff2 setEndBarType:MNBarLineDouble];

    MNStaffConnector* line = [MNStaffConnector staffConnectorWithTopStaff:staff andBottomStaff:staff2];
    [line setType:MNStaffConnectorThinDouble];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [staff2 draw:ctx];
      [line draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)drawRepeatAdjacent:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

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

- (MNTestBlockStruct*)drawRepeatOffset2:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

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

- (MNTestBlockStruct*)drawRepeatOffset:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

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

- (MNTestBlockStruct*)drawCombined:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

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

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

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
