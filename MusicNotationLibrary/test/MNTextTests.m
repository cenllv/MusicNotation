//
//  MNTextTests.m
//  MusicNotation
//
//  Created by Scott on 3/9/15.
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

#import "MNTextTests.h"

#import "MNFont.h"
#import "MNText.h"
#import "NSString+Ruby.h"

@implementation MNTextTests

- (void)start
{
    [super start];
    [self runTest:@"Draw Text" func:@selector(drawText:) frame:CGRectMake(10, 10, 700, 250)];
}

- (MNTestTuple*)drawText:(NSView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    //    TestCollectionItemView* test =
    //        self.currentCell;   //  MNTestView* test =  [MNTestView createCanvasTest:CGSizeMake(850, 1200)
    //        withParent:parent];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      // draw an outline of the frame
      //        NSBezierPath *outline = [NSBezierPath bezierPathWithRect:CGRectMake(bounds.origin.x,
      //                                                                            bounds.origin.y,
      //                                                                            bounds.size.width,
      //                                                                            bounds.size.height)];
      //        [outline setLineWidth:1.0];
      //        [SHEET_MUSIC_COLOR setFill];
      //        [MNColor.blackColor setStroke];
      //        [outline fill];
      //        [outline setLineWidth:3.0];
      //        [outline stroke];

      //         [MNText drawSimpleText:ctx atPoint:MNPointMake(0, 0) withBounds:bounds withText:@"Hello core text
      //        world!"];
      //         [MNText drawSimpleText:ctx atPoint:MNPointMake(30, 30) withBounds:bounds withText:@"Hello core text
      //        world!"];
      //         [MNText drawSimpleText:ctx atPoint:MNPointMake(60, 60) withBounds:bounds withText:@"Hello core text
      //        world!"];
      //         [MNText drawSimpleText:ctx atPoint:MNPointMake(0, 100) withBounds:bounds withText:@"Hello core text
      //        world!"];

      //      LoremIpsum* loremIpsum = [[LoremIpsum alloc] init];
      //      float x = 20;
      //      float y = 200;
      //      NSString* text = [NSString stringWithFormat:@"font count: %lu", (unsigned long)MNFont.fontNames.count];
      //      MNBoundingBox* boundingBox = MNBoundingBoxMake(x, y, 500, 30);
      //       [MNText drawTextWithContext:ctx
      //                          atPoint:MNPointMake(0, 0)
      //                       withBounds:boundingBox
      //                         withText:text
      //                     withFontName:@"TimesNewRomanPS-ItalicMT"
      //                         fontSize:12];
      //      NSUInteger i = 0;
      //      for(NSString* fontName in  MNFont.fontNames)
      //      {
      //          NSString* text = [loremIpsum words:3];
      //          text = [text concat:[NSString stringWithFormat:@" %lu", (unsigned long)i]];
      //          y += 15;
      //          MNBoundingBox* boundingBox = MNBoundingBoxMake(x, y, 400, 30);
      //           [MNText drawTextWithContext:ctx
      //                              atPoint:MNPointMake(0, 0)
      //                           withBounds:boundingBox
      //                             withText:text
      //                         withFontName:fontName
      //                             fontSize:12];
      //          if(y > 1150)
      //          {
      //              x += 200;
      //              y = 15;
      //              //                break;
      //          }
      //          ++i;
      //      }
    };
    return ret;
}

@end