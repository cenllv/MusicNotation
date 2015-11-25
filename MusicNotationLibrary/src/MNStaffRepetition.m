//
//  MNStaffRepetition.m
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

#import "MNStaffRepetition.h"
#import "MNStaff.h"
#import "MNText.h"
#import "MNGlyph.h"

@interface MNStaffRepetition ()
@end

@implementation MNStaffRepetition

@synthesize x = _x;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupStaffRepetition];
    }
    return self;
}

- (void)setupStaffRepetition
{
    self.xShift = 0;
    _x = 0;
    self.fontName = @"times";
    self.fontSize = 12;
    self.fontBold = YES;
    self.fontItalic = YES;
}

- (instancetype)initWithType:(MNRepetitionType)type x:(float)x y_shift:(float)y_shift
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupStaffRepetition];
        self.symbol_type = type;
        _x = x;   // TODO: self.x causeing error for unknown reason
        self.yShift = y_shift;
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return @"repetitions";
}

- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff withShiftX:(float)shiftX
{
    float x = shiftX;
    switch(self.symbol_type)
    {
        case MNRepCodaRight:
            [self drawCodaFixed:ctx staff:staff x:staff.x + staff.width];   // CHANGE: x:x -> x:staff.x
            break;
        case MNRepCodaLeft:
            [self drawSymbolText:ctx staff:staff x:x withText:@"Coda" isCoda:YES];
            break;
        case MNRepSegnoLeft:
            [self drawSignoFixed:ctx staff:staff x:_x + shiftX];
            break;
        case MNRepSegnoRight:
            [self drawSignoFixed:ctx staff:staff x:x + staff.width];
            break;
        case MNRepDC:
            [self drawSymbolText:ctx staff:staff x:x withText:@"D.C." isCoda:NO];
            break;
        case MNRepDCALCoda:
            [self drawSymbolText:ctx staff:staff x:x withText:@"D.C. al" isCoda:YES];
            break;
        case MNRepDCALFine:
            [self drawSymbolText:ctx staff:staff x:x withText:@"D.C. al Fine" isCoda:NO];
            break;
        case MNRepDS:
            [self drawSymbolText:ctx staff:staff x:x withText:@"D.S." isCoda:NO];
            break;
        case MNRepDSALCoda:
            [self drawSymbolText:ctx staff:staff x:x withText:@"D.S. al" isCoda:YES];
            break;
        case MNRepDSALFine:
            [self drawSymbolText:ctx staff:staff x:x withText:@"D.S. al Fine" isCoda:NO];
            break;
        case MNRepFine:
            [self drawSymbolText:ctx staff:staff x:x withText:@"Fine" isCoda:NO];
            break;
        case MNRepNone:
            break;
        default:
            break;
    }
}

- (void)drawCodaFixed:(CGContextRef)ctx staff:(MNStaff*)staff x:(float)x
{
    float y = [staff getYForTopTextWithLine:staff.options.numLines] + self.yShift;
    [MNGlyph renderGlyph:ctx atX:x atY:y withScale:1 forGlyphCode:@"v4d"];
}

- (void)drawSignoFixed:(CGContextRef)ctx staff:(MNStaff*)staff x:(float)x
{
    float y = [staff getYForTopTextWithLine:staff.options.numLines] + self.yShift;
    [MNGlyph renderGlyph:ctx atX:x atY:y withScale:1 forGlyphCode:@"v8c"];
}

- (void)drawSymbolText:(CGContextRef)ctx
                 staff:(MNStaff*)staff
                     x:(float)x
              withText:(NSString*)text
                isCoda:(BOOL)drawCoda
{
    //    CTTextAlignment justification = kCTTextAlignmentLeft;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
    MNFont* font1 = [MNFont fontWithName:@"times" /*self.fontFamily*/ size:self.fontSize];
    NSAttributedString* title = [[NSAttributedString alloc]
        initWithString:text
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];

    CGContextSaveGState(ctx);
    // Default to right symbol
    float text_x = 0 + self.xShift;
    float symbol_x = x + self.xShift;
    if(self.symbol_type == MNRepCodaLeft)
    {
        // Offset Coda text to right of stave beginning
        text_x = self.x + staff.options.verticalBarWidth;
        symbol_x = text_x + title.size.width + 10;
    }
    else
    {
        // Offset Signo text to left stave end
        symbol_x = self.x + x + staff.width - 5 + self.xShift;
        text_x = symbol_x - title.size.width - 15;
    }

    float y = [staff getYForTopTextWithLine:staff.options.numLines] + self.yShift;
    if(drawCoda)
    {
        [MNGlyph renderGlyph:ctx atX:symbol_x atY:y withScale:1 forGlyphCode:@"v4d"];
    }

    float h = title.size.height;
    [title drawAtPoint:CGPointMake(text_x, y + 5 - h)];

    CGContextRestoreGState(ctx);
}

@end
