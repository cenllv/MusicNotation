//
//  MNFontTes.m
//  MusicNotation
//
//  Created by Scott on 4/15/15.
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

#import "MNFontTests.h"

@implementation MNFontTests

- (void)start
{
    [super start];
    [self runTest:@"Draw Sizes" func:@selector(drawSizes:) frame:CGRectMake(10, 10, 700, 400)];
    [self runTest:@"All Fonts" func:@selector(drawFonts:) frame:CGRectMake(10, 10, 900, 1100)];
}

- (void)tearDown
{
    [super tearDown];
}

- (MNTestTuple*)drawSizes:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNFont* font = [MNFont fontWithName:@"verdana" size:12];
      float x = 30, y = 50;

      NSString* str = @"QWFPGJLUYARSTDHNEIOZXCVBKMqwfpgjluyarstdhneiozxcvbkm";

      [MNText showBoundingBox:YES];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(x, y += 50) withText:str];

      font.size += 2;
      font.italic = YES;
      [MNText showBoundingBox:NO];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(x, y += 50) withText:str];

      font.italic = NO;
      font.bold = YES;
      font.size += 2;
      [MNText showBoundingBox:YES];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(x, y += 50) withText:str];

      font.family = @"Times-Roman";
      font.size += 2;
      [MNText showBoundingBox:NO];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(x, y += 50) withText:str];

      font.family = @"Times-Bold";
      font.size += 2;
      [MNText showBoundingBox:YES];
      [MNText drawText:ctx withFont:font atPoint:MNPointMake(x, y += 50) withText:str];
    };

    return ret;
}

- (MNTestTuple*)drawFonts:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNFont* font = [MNFont fontWithName:@"verdana" size:12];
      float x = 30, y = 50;

      NSString* str = @"QWE123abc";
      [MNText showBoundingBox:NO];

      BOOL skip = YES;
      for(NSString* fontFamily in [MNFont availableFonts])
      {
          if(skip)
          {
              skip = !skip;
              continue;
          }
          else
          {
              skip = !skip;
          }
          font.family = fontFamily;
          if(y >= bounds.size.height - 60)
          {
              y = 50, x += 100;
          }
          NSUInteger len = 8;
          str = fontFamily.length > len ? [fontFamily substringWithRange:NSMakeRange(0, len)] : fontFamily;
          [MNText drawText:ctx withFont:font atPoint:MNPointMake(x, y += 20) withText:str];
      }

    };

    return ret;
}

@end