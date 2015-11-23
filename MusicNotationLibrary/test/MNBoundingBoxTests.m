//
//  MNBoundingBoxTests.m
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

#import "MNBoundingBoxTests.h"

@implementation MNBoundingBoxTests

- (void)start
{
    [super start];
    [self runTest:@"Initialization Test" func:@selector(initialization)];
    [self runTest:@"Merging Text" func:@selector(merging)];
}

- (void)initialization
{
    MNBoundingBox* bb = MNBoundingBoxMake(4, 5, 6, 7);
    assertThatFloat(bb.xPosition, describedAs(@"Bad X", equalToFloat(4), nil));
    assertThatFloat(bb.yPosition, describedAs(@"Bad Y", equalToFloat(5), nil));
    assertThatFloat(bb.width, describedAs(@"Bad W", equalToFloat(6), nil));
    assertThatFloat(bb.height, describedAs(@"Bad H", equalToFloat(7), nil));
}

- (void)merging
{
    MNBoundingBox* bb1 = MNBoundingBoxMake(10, 10, 10, 10);
    MNBoundingBox* bb2 = MNBoundingBoxMake(15, 20, 10, 10);

    [bb1 mergeWithBox:bb2];

    assertThatFloat(bb1.xPosition, describedAs(@"Bad X", equalToFloat(10), nil));
    assertThatFloat(bb1.yPosition, describedAs(@"Bad Y", equalToFloat(10), nil));
    assertThatFloat(bb1.width, describedAs(@"Bad W", equalToFloat(15), nil));
    assertThatFloat(bb1.height, describedAs(@"Bad H", equalToFloat(20), nil));
}

@end
