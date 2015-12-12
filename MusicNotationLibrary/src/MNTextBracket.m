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
#import "MNStaff.h"
#import "MNStaffNote.h"

@implementation MNTextBracket

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setupTextBracket];
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
    _fontFamily = @"Arial";   // @"Avenir-Black";
    _fontSize = 20;
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
            y = [self.start.staff getYForTopTextWithLine:(self.line + 1)];   // CHANGE: -> +1
            break;
        case MNTextBracketBottom:
            y = [self.start.staff getYForBottomTextWithLine:(self.line - 2)];   // CHANGE: -> -1
            break;
        default:
            MNLogError(@"InvalidBracketPosition, only top or bottom allowed");
    }

    MNPoint* start = [MNPoint pointWithX:self.start.absoluteX andY:y];
    MNPoint* stop = [MNPoint pointWithX:self.stop.absoluteX andY:y];

    MNLogDebug(@"Rendering TextBracket: start:%@ stop:%@", [start toString], [stop toString]);

    float bracketHeight = self.bracketHeight * self.position;

    CGContextSaveGState(ctx);

    [self applyStyle:ctx];

    [MNText setAlignment:MNTextAlignmentLeft];
    [MNText setVerticalAlignment:MNTextAlignmentTop];

    // Draw text
    MNFont* font = [MNFont fontWithName:self.fontFamily size:self.fontSize];
    CGSize size = [MNText measureText:self.text withFont:font];
    //    [MNText drawText:ctx withFont:font atPoint:MNPointMake(start.x, start.y) withText:self.text];
    [MNText drawText:ctx withFont:font atRect:CGRectMake(start.x, start.y, size.width, size.height) withText:self.text];

    // Get the width and height for the octave number
    float mainWidth = size.width;
    float mainHeight = size.height;

    // Calculate the y position for the super script
    float super_x = start.x + mainWidth + 1;
    float super_y = start.y;   // start.y - (mainHeight / 2.5);

    // Determine width and height of the superscript
    MNFont* super_font = [MNFont fontWithName:self.fontFamily size:(self.fontSize / 2)];   // / 1.4)];
    CGSize super_size = [MNText measureText:self.superscript withFont:super_font];
    float superscriptWidth = super_size.width;
    float superHeight = super_size.height;

    // Draw the superscript
    [MNText drawText:ctx
            withFont:super_font
              atRect:CGRectMake(super_x, super_y, super_size.width, super_size.height)
            withText:self.superscript];

    // Setup initial coordinates for the bracket line
    float start_x = start.x;
    float line_y = super_y;
    float end_x = stop.x + self.stop.glyphStruct.headWidth;

    // Adjust x and y coordinates based on position
    if(self.position == MNTextBrackTop)
    {
        start_x += mainWidth + superscriptWidth + 5;
         line_y = super_y + superHeight / 1.7;
    }
    else if(self.position == MNTextBracketBottom)
    {
        line_y = super_y + superHeight;
        start_x += mainWidth + 2;
        if(!self.underlineSuperscript)
        {
            start_x += superscriptWidth;
        }
    }

    if(_dashed)
    {
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
        //        CGContextClosePath(ctx);
    }

    CGContextRestoreGState(ctx);
}

@end
