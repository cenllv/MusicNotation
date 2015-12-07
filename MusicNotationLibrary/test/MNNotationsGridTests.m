//
//  MNNotationsGrid.m
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

#import "MNNotationsGridTests.h"
//#import "MNCore.h"
//#import "GlyphLayer.h"
#import "MNCarrierLayer.h"

@interface MNNotationsGridTests ()
#if TARGET_OS_IPHONE
@property (strong, nonatomic) NSMutableArray<UILabel*>* labels;
#elif TARGET_OS_MAC
@property (strong, nonatomic) NSMutableArray<NSTextField*>* labels;
#endif
@end

@implementation MNNotationsGridTests

- (void)start
{
    [super start];
#if TARGET_OS_IPHONE
    [self runTest:@"Grid"
             func:@selector(grid:drawBoundingBox:)
            frame:CGRectMake(10, 10, 1000, 1700)];   // params:@(NO)];
#elif TARGET_OS_MAC
    [self runTest:@"Grid"
             func:@selector(grid:drawBoundingBox:)
            frame:CGRectMake(10, 10, 1000, 1900)];   // params:@(NO)];
#endif
}

- (void)tearDown
{
    [super tearDown];
#if TARGET_OS_IPHONE
#elif TARGET_OS_MAC
    dispatch_async(dispatch_get_main_queue(), ^{
      for(id label in self.labels)
      {
          [label removeFromSuperview];
      }
    });
#endif
}

#if TARGET_OS_IPHONE
- (NSMutableArray<UILabel*>*)labels
#elif TARGET_OS_MAC
- (NSMutableArray<NSTextField*>*)labels
#endif
{
    if(!_labels)
    {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (MNTestBlockStruct*)grid:(id<MNTestParentDelegate>)parent drawBoundingBox:(NSNumber*)drawBoundingBox
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
    };

    BOOL shouldDrawBoundingBox = drawBoundingBox.boolValue;

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentLeft;

    // http://iosfonts.com/
    // Programming iOS 6, 3rd Edition, Attributed Strings
    // http://goo.gl/CSmaQe

    MNFont* font1 = [MNFont fontWithName:@"TimesNewRomanPS-BoldMT" size:25];
    NSString* titleMessage = @"Vex Glyphs";
    NSAttributedString* title = [[NSAttributedString alloc]
        initWithString:titleMessage
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1.font}];

#if TARGET_OS_IPHONE
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(parent.bounds), 5, 0, 0)];
    textLabel.text = title.string;
#elif TARGET_OS_MAC
    NSTextField* textLabel = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(parent.bounds), 5, 0, 0)];
    textLabel.editable = NO;
    textLabel.selectable = NO;
    textLabel.bordered = NO;
    textLabel.drawsBackground = YES;
    textLabel.attributedStringValue = title;
#endif
    [textLabel sizeToFit];
    CGRect frame = textLabel.frame;
    frame.origin.x -= CGRectGetWidth(frame) / 2;
    textLabel.frame = frame;
    dispatch_async(dispatch_get_main_queue(), ^{
      [parent addSubview:textLabel];
    });

    MNFont* font2 = [MNFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:15];
    NSString* subTitleMessage = @"Cross indicates render coordinates.";
    NSAttributedString* subtitle = [[NSAttributedString alloc]
        initWithString:subTitleMessage
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font2.font}];
#if TARGET_OS_IPHONE
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(parent.bounds), 35, 0, 0)];
    textLabel.text = subtitle.string;
#elif TARGET_OS_MAC
    textLabel = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(parent.bounds), 35, 0, 0)];
    textLabel.editable = NO;
    textLabel.selectable = YES;
    textLabel.bordered = NO;
    textLabel.drawsBackground = NO;
    //          textLabel.stringValue = description.string; // ?: @"";
    textLabel.attributedStringValue = subtitle;
#endif
    [textLabel sizeToFit];
    frame = textLabel.frame;
    frame.origin.x -= CGRectGetWidth(frame) / 2;
    textLabel.frame = frame;
    dispatch_async(dispatch_get_main_queue(), ^{
      [parent addSubview:textLabel];
      [self.labels add:textLabel];
    });

    NSArray* glyphStructArray = [MNGlyphList sharedInstance].availableGlyphStructsArray;
    NSMutableArray* subLayers = [NSMutableArray arrayWithCapacity:glyphStructArray.count];
    NSMutableArray* textLabels = [NSMutableArray arrayWithCapacity:glyphStructArray.count];
    CFAbsoluteTime then = CFAbsoluteTimeGetCurrent();

    __block NSUInteger x, y, symbolsAcross;
#if TARGET_OS_IPHONE
    y = 40;
    x = 0;
    symbolsAcross = 7;
    [glyphStructArray enumerateObjectsUsingBlock:^(MNGlyphStruct* g, NSUInteger idx, BOOL* stop) {
      if(idx % symbolsAcross == 0)
      {
          x = 0;
          y += 50;
      }
      x += 50;
#elif TARGET_OS_MAC
    y = 70;
    x = 0;
    symbolsAcross = 10;
    [glyphStructArray enumerateObjectsUsingBlock:^(MNGlyphStruct* g, NSUInteger idx, BOOL* stop) {
      if(idx % symbolsAcross == 0)
      {
          x = 30;
          y += 90;
      }
      x += 90;
#endif

// label the glyph
#if TARGET_OS_IPHONE
      UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(x - 45, y - 10, 0, 0)];
#elif TARGET_OS_MAC
      NSTextField* textLabel = [[NSTextField alloc] initWithFrame:CGRectMake(x - 45, y - 10, 0, 0)];
      textLabel.editable = NO;
      textLabel.selectable = YES;
      textLabel.attributedStringValue = [[NSAttributedString alloc] initWithString:g.name];
#endif
      [textLabel sizeToFit];
      [textLabels addObject:textLabel];

#if TARGET_OS_IPHONE
#define GLYPH_SCALE 1.0
#elif TARGET_OS_MAC
#define GLYPH_SCALE 1.4
#endif
      MNCarrierLayer* carrierLayer =
          [MNGlyph createCarrierLayerWithCode:g.name withScale:GLYPH_SCALE hasCross:YES];   //[CarrierLayer layer];
      carrierLayer.position = CGPointMake(x, y);

      // alter the color of the glyph
      [((CAShapeLayer*)carrierLayer.sublayers[1])setFillColor:[MNColor crayolaRubyColor].CGColor];
      if(shouldDrawBoundingBox)
      {
          [((CAShapeLayer*)carrierLayer.sublayers[1])setBackgroundColor:[MNColor crayolaOrangeColor].CGColor];
      }

      [subLayers addObject:carrierLayer];
    }];

    // calculate how long it took
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    CFTimeInterval elapsed = now - then;
#if TARGET_OS_IPHONE
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(parent.bounds) - 160, 15, 0, 0)];
    textLabel.text = [NSString stringWithFormat:@"elapsed: %.03f (ms)", elapsed * 1000];
#elif TARGET_OS_MAC
    textLabel = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(parent.bounds) - 160, 15, 0, 0)];
    textLabel.editable = NO;
    textLabel.selectable = NO;
    textLabel.bordered = YES;
    textLabel.drawsBackground = YES;
    textLabel.stringValue = [NSString stringWithFormat:@"elapsed: %.03f (ms)", elapsed * 1000];
#endif
    [textLabel sizeToFit];
    frame = textLabel.frame;
    textLabel.frame = frame;

    // add all the stuff to the parent view
    dispatch_async(dispatch_get_main_queue(), ^{
      for(CALayer* layer in subLayers)
      {
          [parent.layer addSublayer:layer];
      }
      for(id textLabel in textLabels)
      {
          [parent addSubview:textLabel];
          [self.labels add:textLabel];
      }
      [parent addSubview:textLabel];
      [self.labels add:textLabel];
    });
    //#endif

    return ret;
}

//- (void)mouseDown:(NSEvent*)theEvent
//{
//    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//}

@end
