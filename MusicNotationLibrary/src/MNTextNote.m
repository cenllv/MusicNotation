//
//  MNTextNote.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
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

#import "MNTextNote.h"
#import "MNUtils.h"
#import "MNGlyph.h"
#import "MNTable.h"
#import "MNStaff.h"
#import "MNText.h"
#import "MNTextNoteStruct.h"

@interface MNTextNote ()

@property (strong, nonatomic) MNTextNoteStruct* glyphTextNoteStruct;

@end

@implementation MNTextNote

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        // Note properties
        self.text = optionsDict[@"text"];
        self.glyph_type = optionsDict[@"glyph"];
        self.glyph = nil;
        //        self.font = {
        //        family: "Arial",
        //        size: 12,
        //        weight: ""
        //        }

        //        if (optionsDict.font) self.font = optionsDict.font;

        if(self.glyph_type)
        {
            NSDictionary* textNoteglyphTextNoteDictionary = [MNTable textNoteGlyphs][self.glyph_type];
            //            if (!struct) throw new Vex.RERR("Invalid glyph type: " + self.glyph_type);
            if(!textNoteglyphTextNoteDictionary)
            {
                MNLogError(@"Invalid glyph type: %@", self.glyph_type);
            }

            NSString* code = textNoteglyphTextNoteDictionary[@"code"];
            float pointSize = [textNoteglyphTextNoteDictionary[@"point"] floatValue];
            self.glyph = [[MNGlyph alloc] initWithCode:code withPointSize:pointSize];

            //            if(struct.width)
            //                self.setWidth(struct.width) else self.setWidth(self.glyph.getMetrics().width);

            self.glyphTextNoteStruct = [[MNTextNoteStruct alloc] initWithDictionary:textNoteglyphTextNoteDictionary];
        }
        else
        {
            self.width = [MNText measureText:self.text withFont:self.font].width;
        }
        self.line = optionsDict[@"line"] ? [optionsDict[@"line"] floatValue] : 0;
        self.smooth = optionsDict[@"smooth"] ? [optionsDict[@"smooth"] boolValue] : NO;
        self.ignoreTicks = optionsDict[@"ignore_ticks"] ? [optionsDict[@"ignore_ticks"] boolValue] : NO;
        self.justification = MNJustifyLEFT;
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (MNFont*)font
{
    if(!_font)
    {
        _font = [MNFont fontWithName:@"Arial" size:12];
    }
    return _font;
}

- (void)setFont:(MNFont*)font
{
    _font = font;
}

// Pre-render formatting
- (BOOL)preFormat
{
    if(self.preFormatted)
    {
        return YES;
    }

    if(self.smooth)
    {
        self.width = 0;
    }
    else
    {
        if(self.glyph)
        {
            // Width already set.
        }
        else
        {
            self.width = (float)self.text.length;   // TODO: measure text properly
        }
    }

    if(self.justification == MNJustifyCENTER)
    {
        self.extraLeftPx = self.width / 2;
    }
    else if(self.justification == MNJustifyRIGHT)
    {
        self.extraLeftPx = self.width;
    }

    self.preFormatted = YES;
    return YES;
}

- (void)draw:(CGContextRef)ctx
{
    /*

        if (self.justification == Vex.Flow.TextNote.Justification.CENTER) {
            x -= self.getWidth() / 2;
        } else if (self.justification == Vex.Flow.TextNote.Justification.RIGHT) {
            x -= self.getWidth();
        }

        if (self.glyph) {
            var y = self.Staff.getYForLine(self.line + (-3));
            self.glyph.render(self.context,
                              x + self.glyph_struct.x_shift,
                              y + self.glyph_struct.y_shift)
        } else {
            var y = self.Staff.getYForLine(self.line + (-3));
            ctx.save();
            ctx.setFont(self.font.family, self.font.size, self.font.weight);
            ctx.fillText(self.text, x, y);
            ctx.restore();
        }
    }

     */

    if(!self.staff)
    {
        MNLogError(@"NoStaff, Can't draw without a Staff.");
    }
    float x = self.absoluteX;

    if(self.glyph)
    {
        [self.glyph renderWithContext:ctx
                                  atX:(x + self.glyphTextNoteStruct.x_shift)
                                  atY:(x + self.glyphTextNoteStruct.y_shift)];
    }
    else
    {
        float y = [self.staff getYForLine:self.line + (-3)];
        MNFont* font = [MNFont fontWithName:@"ArialMT" size:8];

        //        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        paragraphStyle.alignment = kCTTextAlignmentCenter;
        NSAttributedString* description = [[NSAttributedString alloc]
            initWithString:self.text
                attributes:@{
                    //                                                          NSParagraphStyleAttributeName :
                    //                                                          paragraphStyle,
                    NSFontAttributeName : font.font,
                    //                                                          NSForegroundColorAttributeName :
                    //                                                          MNColor.blackColor
                }];
        // description drawAtPoint:CGPointMake(x, y)];
        [MNText drawText:ctx withFont:font atPoint:MNPointMake(x, y) withText:description];
    }
}

@end
