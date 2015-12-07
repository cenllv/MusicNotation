//
//  MNTextTests.m
//  MusicNotation
//
//  Created by Scott on 3/9/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
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

#import "MNTextTests.h"

@implementation MNTextTests

- (void)start
{
    [super start];
    [self runTest:@"Draw Sizes" func:@selector(drawFonts:) frame:CGRectMake(10, 10, 650, 400)];
    [self runTest:@"Draw Alignment" func:@selector(drawAlignment:) frame:CGRectMake(10, 10, 600, 550)];
    [self runTest:@"Draw Colors" func:@selector(drawColors:) frame:CGRectMake(10, 10, 600, 450)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestBlockStruct*)drawFonts:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNFont* font = [MNFont fontWithName:@"times" size:12];
      float y = 50;

      NSString* str = @"QWFPGJLUYARSTDHNEIOZXCVBKMqwfpgjluyarstdhneiozxcvbkm";

      [MNText showBoundingBox:YES];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 50) withText:str];
      font.size += 2;
      [MNText showBoundingBox:NO];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 50) withText:str];
      font.size += 2;
      [MNText showBoundingBox:YES];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 50) withText:str];
      font.size += 2;
      [MNText showBoundingBox:NO];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 50) withText:str];
      font.size += 2;
      [MNText showBoundingBox:YES];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 50) withText:str];
    };

    return ret;
}

- (MNTestBlockStruct*)drawAlignment:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNFont* font = [MNFont fontWithName:@"times" size:12];
      font.bold = YES;
      float y = 50, x = 40, w = 500, h = 30, step = 50;

      [MNText showBoundingBox:YES];
      [MNText setAlignment:MNTextAlignmentRight];
      [MNText drawText:ctx withFont:font atRect:CGRectMake(x, y, w, h) withText:@"MNTextAlignmentRight"];

      [MNText setAlignment:MNTextAlignmentLeft];
      [MNText drawText:ctx withFont:font atRect:CGRectMake(x, y += step, w, h) withText:@"MNTextAlignmentLeft"];

      [MNText setAlignment:MNTextAlignmentCenter];
      [MNText drawText:ctx withFont:font atRect:CGRectMake(x, y += step, w, h) withText:@"MNTextAlignmentCenter"];

      [MNText setAlignment:MNTextAlignmentJustified];
      [MNText drawText:ctx withFont:font atRect:CGRectMake(x, y += step, w, h) withText:@"MNTextAlignmentJustified"];

      [MNText setAlignment:MNTextAlignmentNatural];
      [MNText drawText:ctx withFont:font atRect:CGRectMake(x, y += step, w, h) withText:@"MNTextAlignmentNatural"];

      [MNText setVerticalAlignment:MNTextAlignmentTop];
      [MNText drawText:ctx
              withFont:font
                atRect:CGRectMake(x, y += step, w, h)
              withText:@"MNTextAlignmentCenter | MNTextAlignmentTop"];

      [MNText setVerticalAlignment:MNTextAlignmentBottom];
      [MNText drawText:ctx
              withFont:font
                atRect:CGRectMake(x, y += step, w, h)
              withText:@"MNTextAlignmentCenter | MNTextAlignmentBottom"];

      [MNText setVerticalAlignment:MNTextAlignmentMiddle];
      [MNText drawText:ctx
              withFont:font
                atRect:CGRectMake(x, y += step, w, h)
              withText:@"MNTextAlignmentCenter | MNTextAlignmentMiddle"];
    };
    return ret;
}

- (MNTestBlockStruct*)drawColors:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNFont* font = [MNFont fontWithName:@"times" size:26];

      float y = 50;

      NSString* str = @"QWFPGJLUYARSTDHNEIOZXCVBKMqwfpgjl";

      [MNText showBoundingBox:NO];

      //        font.fillColor = MNColor.greenColor;
      //        font.strokeColor = MNColor.redColor;
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 30) withText:str];
      font.fillColor = nil;
      font.strokeColor = (MNColor*)MNColor.redColor;
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 30) withText:str];
      font.fillColor = nil;
      font.strokeColor = (MNColor*)MNColor.greenColor;
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 30) withText:str];
      font.fillColor = (MNColor*)MNColor.greenColor;
      font.strokeColor = (MNColor*)MNColor.redColor;
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 30) withText:str];
      font.fillColor = nil;
      font.strokeColor = nil;
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 30) withText:str];
      //        font.fillColor = ;
      //        font.strokeColor = nil;
      font.strokeColor = [MNColor colorWithHexString:@"579"];
      font.fillColor = [MNColor colorWithHexString:@"345"];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(50, y += 30) withText:str];
    };

    return ret;
}

@end