//
//  MNStaffTempo.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Radosaw Eichler 2012
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

#import "MNStaffTempo.h"
#import "MNStaff.h"
#import "MNUtils.h"
#import "MNText.h"
#import "MNFont.h"
#import "MNTempo.h"
#import "MNTable.h"
#import "MNGlyph.h"
#import "MNTableTypes.h"

@implementation TempoOptions

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

@end

@implementation TempoOptionsStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

@end

@implementation MNStaffTempo

@synthesize x = _x;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithTempo:(TempoOptionsStruct*)tempo atX:(float)x withShiftY:(float)shiftY;
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.tempo = tempo;
        self.x = x;
        self.shiftY = shiftY;
        [self setupStaffTempo];
    }
    return self;
}

- (void)setupStaffTempo
{
    self.shiftX = 10;
    self.position = MNPositionAbove;
    self.fontFamily = @"times";
    self.fontSize = 14;
    self.fontWeightBold = YES;
    self->_renderOptions = [[TempoOptions alloc] initWithDictionary:@{ @"glyphFontScale" : @(1) }];   // 30) }];
    //    self.options.glyphFontScale = 30;

    self.font = [MNFont fontWithName:self.fontFamily size:self.fontSize];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

+ (NSString*)CATEGORY
{
    return @"stavetempo";
}

- (void)setTempo:(TempoOptionsStruct*)tempo
{
    _tempo = tempo;
}

- (void)setShiftX:(float)shiftX
{
    _shiftX = shiftX;
}

- (void)setShiftY:(float)shiftY
{
    _shiftY = shiftY;
}

//- (void)draw:(CGContextRef)ctx toStaff:(MNStaff*)staff withShiftX:(float)shiftX
- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff withShiftX:(float)shiftX;
{
    [super draw:ctx];

    TempoOptions* options = self->_renderOptions;
    float scale = 1;   // options.glyphFontScale / 38;
    NSString* name = self.tempo.name;
    NSString* duration = self.tempo.duration;
    float dots = self.tempo.dots;
    float bpm = self.tempo.bpm;
    //     MNFont* font = self.font;
    float x = self.x + self.shiftX + shiftX;
    float y = [staff getYForTopTextWithLine:1] + self.shiftY;

    CGContextSaveGState(ctx);
    if(name)
    {
        //         [MNText setFont:font];
        //         [MNText drawSimpleText:ctx atPoint:MNPointMake(x, y) withText:name];

        //        CTTextAlignment justification = kCTTextAlignmentLeft;
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
        MNFont* font1 = [MNFont fontWithName:self.fontFamily size:self.fontSize];
        NSAttributedString* title = [[NSAttributedString alloc]
            initWithString:name
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];

        //            NSUInteger text_width = title.size.width;
        //            NSUInteger textHeight = title.size.height / 2;

        [title drawAtPoint:CGPointMake(x, y)];
    }

    if(duration > 0 && bpm > 0)
    {
        if(name)
        {
            x += [MNText measureText:@" "].width;
            //             [MNText drawSimpleText:ctx atPoint:MNPointMake(x, y) withText:@"("];

            //            CTTextAlignment justification = kCTTextAlignmentLeft;
            NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
            MNFont* font1 = [MNFont fontWithName:self.fontFamily size:self.fontSize];
            NSAttributedString* title = [[NSAttributedString alloc]
                initWithString:name
                    attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];

            //            NSUInteger text_width = title.size.width;
            //            NSUInteger textHeight = title.size.height / 2;

            [title drawAtPoint:CGPointMake(x, y)];

            x += [MNText measureText:@")"].width;
        }

        MNTableGlyphStruct* glyphStruct = [MNTable durationToGlyphStruct:duration];

        x += 3 * scale;
        [MNGlyph renderGlyph:ctx atX:x atY:y withScale:1 forGlyphCode:glyphStruct.codeHead];
        x += glyphStruct.headWidth * scale;

        // Draw stem and flags
        if(glyphStruct.stem)
        {
            float stem_height = 30;

            if(glyphStruct.beamCount)
            {
                stem_height += 3 * (glyphStruct.beamCount - 1);
            }
            stem_height *= scale;
            float y_top = y - stem_height;
            CGContextFillRect(ctx, CGRectMake(x, y_top, scale, stem_height));

            if(glyphStruct.flag)
            {
                [MNGlyph renderGlyph:ctx
                                 atX:x + scale
                                 atY:y_top
                           withScale:options.glyphFontScale
                        forGlyphCode:glyphStruct.codeFlagUpstem];
                if(!dots)
                {
                    x += 6 * scale;
                }
            }
        }

        // Draw dot
        for(NSUInteger i = 0; i < dots; ++i)
        {
            x += 6 * scale;
            CGContextBeginPath(ctx);
            CGContextAddArc(ctx, x, y + 2 * scale, 2 * scale, 0, kPI, YES);
            CGContextAddArc(ctx, x, y + 2 * scale, 2 * scale, kPI, 2 * kPI, YES);
            CGContextFillPath(ctx);
        }

        NSString* text;
        if(name.length > 0)
        {
            text = [NSString stringWithFormat:@" = %.0f)", bpm];
        }
        else
        {
            text = [NSString stringWithFormat:@" = %.0f", bpm];
        }
        //         [MNText drawSimpleText:ctx atPoint:MNPointMake(x + 3 * scale, y) withText:text];

        //        CTTextAlignment justification = kCTTextAlignmentLeft;
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
        MNFont* font1 = [MNFont fontWithName:self.fontFamily size:self.fontSize];
        NSAttributedString* title = [[NSAttributedString alloc]
            initWithString:text
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];

        //            NSUInteger text_width = title.size.width;
        //            NSUInteger textHeight = title.size.height / 2;
        float h = title.size.height;

        [title drawAtPoint:CGPointMake(x + 3 * scale, y - h)];
    }
    CGContextRestoreGState(ctx);
}
@end
