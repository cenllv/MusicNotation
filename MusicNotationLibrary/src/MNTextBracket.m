//
//  MNTextBracket.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Cyril Silverman
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

#import "MNTextBracket.h"
#import "MNUtils.h"
#import "MNColor.h"
#import "MNText.h"
#import "MNFont.h"
#import "MNStaff.h"
#import "MNStaffNote.h"
#include "MNGlyph.h"

@implementation MNTextBracket

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithStart:(MNStaffNote*)start
                         stop:(MNStaffNote*)stop
                         text:(NSString*)text
                  superscript:(NSString*)superscript
                     position:(MNTextBracketPosition)position
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        self.start = start;
        self.stop = stop;
        self.text = (text != nil ? text : @"");
        self.superscript = (superscript != nil ? superscript : @"");
        if(position == MNTextBracketBottom || position == MNTextBrackTop)
        {
            self.position = position;
        }
        else
        {
            self.position = MNTextBrackTop;
        }
        [self setupTextBracket];
    }
    return self;
}

- (void)setupTextBracket
{
    _line = 1;
    _fontFamily = @"Verdana-Bold";   // @"Serif";
    _fontSize = 15;
    _fontBold = NO;
    _fontItalic = YES;
    _dashed = YES;
    _color = MNColor.blackColor;
    _dash = @[ @(5), @(5) ];
    _lineWidth = 1;
    _showBracket = YES;
    _bracketHeight = 8;
    // In the BOTTOM position, the bracket line can extend
    // under the superscript.
    _underlineSuperscript = YES;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

// Apply the text backet styling to the provided `context`
- (void)applyStyle:(CGContextRef)ctx
{
    // Apply style for the octave bracket
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
}

//// set the draw style of a stem:
//- (void)applyStyle:(DrawStyle)drawStyle {
//    _drawStyle = drawStyle;
//}
//- (DrawStyle)getStyle {
//    return _drawStyle;
//}

- (id)setDashed:(BOOL)dashed
{
    _dashed = dashed;
    return self;
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    float y = 0;
    switch(self.position)
    {
        case MNTextBrackTop:
            y = [self.start.staff getYForTopTextWithLine:self.line];
            break;
        case MNTextBracketBottom:
            y = [self.start.staff getYForBottomTextWithLine:self.line];
            break;
        default:
            [MNLog logError:@"InvalidBracketPosition, only top or bottom allowed"];
    }

    MNPoint* start = [MNPoint pointWithX:self.start.absoluteX andY:y];
    MNPoint* stop = [MNPoint pointWithX:self.stop.absoluteX andY:y];

    MNLogDebug(
        @"%@",
        [NSString stringWithFormat:@"Rendering TextBracket: start:%@ stop:%@", [start toString], [stop toString]]);

    float bracketHeight = self.bracketHeight * self.position;

    CGContextSaveGState(ctx);

    [self applyStyle:ctx];

    // Draw text
    MNFont* font = [MNFont fontWithName:self.fontFamily size:self.fontSize];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentLeft;

    NSAttributedString* title = [[NSAttributedString alloc]
        initWithString:self.text
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font.font}];

    //    font.bold = self.fontBold;
    // TODO: cannot set font size
    //    font.size = self.fontSize;
    //         context.setFont(self.font.family, self.font.size, self.font.weight);
    //     [MNText drawText:ctx withFont:font atPoint:[MNPoint pointWithX:start.x andY:start.y]
    //    withText:self.text];

    [title drawAtPoint:CGPointMake(start.x, start.y -= title.size.height / 2)];

    // Draw the superscript
    // TODO: cannot set font size
    //    font.size = font.size / 1.4;
    font = [MNFont fontWithName:self.fontFamily size:self.fontSize / 1.4];
    //     [MNText drawText:ctx
    //                  withFont:font
    //                   atPoint:[MNPoint pointWithX:(start.x + mainWidth + 1)andY:super_y]
    //                  withText:self.superscript];

    paragraphStyle.alignment = kCTTextAlignmentLeft;

    title = [[NSAttributedString alloc]
        initWithString:self.superscript
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font.font}];

    // Get the width and height for the octave number
    float mainWidth = title.size.width;
    float mainHeight = title.size.height;

    // Calculate the y position for the super script
    float super_y = start.y - (mainHeight / 2.5);

    [title drawAtPoint:CGPointMake((start.x + mainWidth + 1), super_y)];

    // Determine width and height of the superscript
    float superscript_width = [MNText measureText:self.superscript withFont:font].width;
    float super_height = [MNText measureText:@"M" withFont:font].height;

    // Setup initial coordinates for the bracket line
    float start_x = start.x;
    float line_y = super_y;
    float end_x = stop.x + self.stop.glyphStruct.headWidth;

    // Adjust x and y coordinates based on position
    if(self.position == MNTextBrackTop)
    {
        start_x += mainWidth + superscript_width + 5;
        line_y -= super_height / 2.7;
    }
    else if(self.position == MNTextBracketBottom)
    {
        line_y += super_height / 2.7;
        start_x += mainWidth + 2;
        if(!self.underlineSuperscript)
        {
            start_x += superscript_width;
        }
    }

    if(_dashed)
    {
        ////TODO: finish the following
        //        // Main line
        //         [MNRenderer drawDashedLine:ctx
        //                         withPhase:0
        //                       withLengths:self.dash
        //                          withLine:[MNLine lineAtStartX:start_x startY:line_y endX:end_x endY:line_y]];
        //
        //
        //        // Ending bracket
        //        if(self.showBracket)
        //        {
        //             [MNRenderer drawDashedLine:ctx
        //                             withPhase:0
        //                           withLengths:self.dash
        //                              withLine:[MNLine lineAtStartX:end_x
        //                                                     startY:line_y + (1 * self.position)
        //                                                       endX:end_x
        //                                                       endY:line_y + bracketHeight]];
        //        }

        const CGFloat arr[1] = {5.f};
        CGContextSetLineDash(ctx, 0, arr, 1);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, start_x, line_y);
        // Main line
        CGContextAddLineToPoint(ctx, end_x, line_y);
        if(self.showBracket)
        {
            // Ending bracket
            CGContextAddLineToPoint(ctx, end_x, line_y + bracketHeight);
        }
        CGContextStrokePath(ctx);
//        CGContextClosePath(ctx);
    }
    else
    {
        CGContextSetLineDash(ctx, 0, NULL, 0);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, start_x, line_y);
        // Main line
        CGContextAddLineToPoint(ctx, end_x, line_y);
        if(self.showBracket)
        {
            // Ending bracket
            CGContextAddLineToPoint(ctx, end_x, line_y + bracketHeight);
        }
        CGContextStrokePath(ctx);
        CGContextClosePath(ctx);
    }

    CGContextRestoreGState(ctx);
}

@end
