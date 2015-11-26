//
//  MNStaffText.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Taehoon Moon 2014
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

#import "MNStaffText.h"
#import "MNBoundingBox.h"
#import "MNEnum.h"
#import "MNStaff.h"
#import "MNUtils.h"
#import "MNFont.h"

@implementation MNStaffText
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.width = 16;
        self.justification = MNTextJustificationCenter;
        self.shift_x = 0;
        self.shift_y = 0;
        self.fontFamily = @"TimesNewRomanPS-BoldMT";
        self.fontSize = 16;
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)initWithText:(NSString*)text atPosition:(MNPositionType)position WithOptions:(NSDictionary*)optionsDict
{
    self = [self initWithDictionary:optionsDict];
    if(self)
    {
        self.text = text;
        self.position = position;
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"stafftext";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

#pragma mark - Methods
- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff
{
    [super draw:ctx];

    CGContextSaveGState(ctx);
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
    MNFont* font1 = [MNFont fontWithName:self.fontFamily size:self.fontSize];
    NSAttributedString* title = [[NSAttributedString alloc]
        initWithString:self.text
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];

    NSUInteger text_width = title.size.width;
    NSUInteger textHeight = title.size.height / 2;

    float x, y;
    switch(self.position)
    {
        case MNPositionLeft:
        case MNPositionRight:
        {
            y = ([staff getYForTopTextWithLine:0] + [staff getBottomY]) / 2 + self.shift_y;
            if(self.position == MNPositionLeft)
            {
                x = staff.x - text_width - 24 + self.shift_x;
            }
            else
            {
                x = staff.x + staff.width + 24 + self.shift_x;
            }
        }
        break;
        case MNPositionAbove:
        case MNPositionBelow:
        {
            x = staff.x + self.shift_x;
            if(self.justification == MNTextJustificationCenter)
            {
                x += staff.width / 2 - text_width / 2;
            }
            else if(self.justification == MNTextJustificationRight)
            {
                x += staff.width - text_width;
            }

            if(self.position == MNPositionAbove)
            {
                y = [staff getYForTopTextWithLine:2] + self.shift_y;
            }
            else
            {
                y = [staff getYForBottomTextWithLine:2] + self.shift_y;
            }
            break;
        }
        break;
        default:
        {
            MNLogError(@"InvalidPosition, Value Must be in Modifier.Position.");
        }
        break;
    }

    /* Values for NSTextAlignment
    typedef NS_ENUM(NSUInteger, NSTextAlignment) {
        NSTextAlignmentLeft      = 0,    // Visually left aligned
#if TARGET_OS_IPHONE
        NSTextAlignmentCenter    = 1,    // Visually centered
        NSTextAlignmentRight     = 2,    // Visually right aligned
#else / * !TARGET_OS_IPHONE * /
        NSTextAlignmentRight     = 1,    // Visually right aligned
        NSTextAlignmentCenter    = 2,    // Visually centered
#endif
        NSTextAlignmentJustified = 3,    // Fully-justified. The last line in a paragraph is natural-aligned.
        NSTextAlignmentNatural   = 4     // Indicates the default alignment for script
    };
    */

    y -= textHeight;

    [title drawAtPoint:CGPointMake(x, y)];

    //    MNBoundingBox* bb = [MNBoundingBox boundingBoxWithRect:CGRectMake(x, y, title.size.width, title.size.height)];
    //    [bb draw:ctx];

    CGContextRestoreGState(ctx);
}

@end
