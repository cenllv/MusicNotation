//
//  MNStaffVolta.m
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

#import "MNStaffVolta.h"
#import "MNStaff.h"
#import "MNText.h"

@implementation MNStaffVolta

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithType:(MNVoltaType)type number:(NSString*)number atX:(float)x yShift:(float)yShift
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        self.type = type;
        _x = x;
        self.number = number;
        self.yShift = yShift;
        self.fontFamily = @"sans-serif";
        self.fontSize = 9;
        self.fontWeightBold = YES;
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"voltas";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

//- (void)draw:(CGContextRef)ctx staff:(MNStaff*)staff atX:(float)x;
- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff withShiftX:(float)shiftX
{
    float x = shiftX;
    //    if (self.staff.graphicsContext == NULL) {
    //         [MNLog logError:@"cannot draw without context"];
    //    }
    //    CGContextRef ctx = staff.graphicsContext;
    float width, top_y, vert_height;
    width = staff.width;
    top_y = [staff getYForTopTextWithLine:staff.options.numLines];
    vert_height = 1.5 * staff.spacingBetweenLines;
    switch(self.type)
    {
        case MNVoltaBegin:
            //             [MNRenderer fillRect:ctx withRect:CGRectMake(_x + x, top_y, 1, vert_height)];
            CGContextBeginPath(ctx);
            CGContextAddRect(ctx, CGRectMake(_x + x, top_y, 1, vert_height));
            CGContextClosePath(ctx);
            CGContextDrawPath(ctx, kCGPathFillStroke);
            break;
        case MNVoltaEnd:
            width -= 5;
            //             [MNRenderer fillRect:ctx withRect:CGRectMake(_x + x + width, top_y, 1, vert_height)];
            CGContextBeginPath(ctx);
            CGContextAddRect(ctx, CGRectMake(_x + x + width, top_y, 1, vert_height));
            CGContextClosePath(ctx);
            CGContextDrawPath(ctx, kCGPathFillStroke);
            break;
        case MNVoltaBeginEnd:
            width -= 3;
            //             [MNRenderer fillRect:ctx withRect:CGRectMake(_x + x, top_y, 1, vert_height)];
            CGContextBeginPath(ctx);
            CGContextAddRect(ctx, CGRectMake(_x + x, top_y, 1, vert_height));
            CGContextClosePath(ctx);
            CGContextDrawPath(ctx, kCGPathFillStroke);
            //             [MNRenderer fillRect:ctx withRect:CGRectMake(_x + x + width, top_y, 1, vert_height)];
            CGContextBeginPath(ctx);
            CGContextAddRect(ctx, CGRectMake(_x + x + width, top_y, 1, vert_height));
            CGContextClosePath(ctx);
            CGContextDrawPath(ctx, kCGPathFillStroke);
            break;
        default:
            break;
    }

    // If the beginning of a volta, draw measure number
    if(self.type == MNVoltaBegin || self.type == MNVoltaBeginEnd)
    {
        CGContextSaveGState(ctx);
        // TODO: set font
        // draw text better
        //[MNText drawText:ctx atPoint:MNPointMake(_x + x + 5, top_y + 15) withHeight:12 withText:self.number];

        //        CTTextAlignment justification = kCTTextAlignmentLeft;
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;   // NSTextAlignmentLeft; // justification;
        MNFont* font1 = [MNFont fontWithName:@"times" /*self.fontFamily*/ size:self.fontSize];
        NSAttributedString* title = [[NSAttributedString alloc]
            initWithString:self.number
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];
        float h = title.size.height;
        [title drawAtPoint:CGPointMake(_x + x + 5, top_y + 15 - h)];
        CGContextRestoreGState(ctx);
    }
    CGContextBeginPath(ctx);
    CGContextAddRect(ctx, CGRectMake(_x + x, top_y, width, 1));
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    return;
}

@end
