//
//  MNStaffSection.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Larry Kuhns 2011
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

#import "MNStaffSection.h"
#import "MNStaff.h"
#import <CoreText/CoreText.h>
#import "MNBoundingBox.h"
#import "MNPoint.h"

@interface MNStaffSection (private)
@property (strong, nonatomic) NSString* category;
@property (assign, nonatomic) float width;
@end

@implementation MNStaffSection

+ (MNStaffSection*)staffSectionWithSection:(NSString*)section withX:(float)x yShift:(float)yShift
{
    return [[MNStaffSection alloc] initWithSection:section withX:x yShift:yShift];
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithSection:(NSString*)section withX:(float)x yShift:(float)yShift
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        self.width = 16;
        self.section = section;
        self.position = MNPositionAbove;
        self.point.x = x;
        //        self.x = x;
        self.xShift = 0;
        self.yShift = yShift;
        self.font = [MNFont systemFontWithSize:12];
        [self.font setBold:YES];
    }
    return self;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return @"stavesection";
}

/*!
 *  draws this modifier
 *  @param ctx    graphics context
 *  @param staff  staff to draw to
 *  @param shiftX amount to shift x from init position to match current measure
 */
//- (void)draw:(CGContextRef)ctx withStaff:(MNStaff*)staff withShiftX:(float)shiftX;
- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff withShiftX:(float)shiftX
{
    float x = self.point.x + shiftX;
    float textWidth = self.section.length;
    float y = [staff getYForTopTextWithLine:3] + self.yShift;
    float height = 20;
    float width = textWidth + 6;
    y += 3;   // CHANGE: 16

    // draw box
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 2);
    CGContextAddRect(ctx, CGRectMake(x, y, height, height));
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);

    x += (width - textWidth) / 2;

    // draw text
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;                         // kCTCenterTextAlignment;
    MNFont* font1 = [MNFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16];   // self.fontSize];
    NSAttributedString* title = [[NSAttributedString alloc]
        initWithString:self.section
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];
    //    [title drawInRect:CGRectMake(x, y, 50, 100)];
    [title drawAtPoint:CGPointMake(x, y)];
}

- (CGSize)getTextSize:(NSAttributedString*)attributedString
{
    CTFramesetterRef frameSetter =
        CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attributedString));
    CFRange ran = CFRangeMake(0, attributedString.length);
    return CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, ran, NULL, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX),
                                                        NULL);
}

@end
