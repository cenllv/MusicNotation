//
//  MNStem.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
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

#import "MNStem.h"
#import "MNBoundingBox.h"
#import "MNUtils.h"
#import "MNExtentStruct.h"
#import "MNPoint.h"
#import "MNStaff.h"
#import "MNConstants.h"

@implementation MNStem

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        if(!optionsDict)
        {
            self.x_begin = 0;
            self.x_end = 0;

            // Y bounds for top/bottom most notehead
            self.y_top = 0;
            self.y_bottom = 0;

            // Stem base extension
            self.y_extend = 0;
            // Stem top extension
            self.stem_extension = 0;

            // Direction of the stem
            self.stemDirection = MNStemDirectionNone;
        }
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (void)setupStem
{
    // Flag to override all draw calls
    self.hide = NO;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);   // return @"stem";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

// Set the x bounds for the default notehead
- (void)setNoteHeadXBoundsBegin:(float)x_begin andEnd:(float)x_end
{
    self.x_begin = x_begin;
    self.x_end = x_end;
}

// Set the direction of the stem in relation to the noteheads
- (id)setStemDirection:(MNStemDirectionType)direction
{
    _stemDirection = direction;
    return self;
}

- (MNStemDirectionType)stemDirection
{
    return _stemDirection;
}

// Set the extension for the stem, generally for flags or beams
- (void)setExtension:(float)extension
{
    self.stem_extension = extension;
}

// The the y bounds for the top and bottom noteheads
- (void)setYBoundsTop:(float)y_top andBottom:(float)y_bottom
{
    self.y_top = y_top;
    self.y_bottom = y_bottom;
}

//
//// Set the canvas context to render on
//- (void)setGraphicsContext:(CGContextRef)ctx {
//    _graphicsContext = ctx;
//}

// Gets the entire height for the stem
- (float)height
{
    return ((self.y_bottom - self.y_top) * ((float)self.stemDirection)) +
           ((kSTEM_HEIGHT + self.stem_extension) * ((float)self.stemDirection));
}

- (MNBoundingBox*)getBoundingBox
{
    float x, y, w, h;
    x = self.x_begin;
    y = self.y_top;
    w = ABS(self.x_end - x);
    h = ABS(self.y_bottom - y);

    return [MNBoundingBox boundingBoxAtX:x atY:y withWidth:w andHeight:h];
}

- (MNExtentStruct*)extents
{
    NSArray* ys = @[ @(self.y_top), @(self.y_bottom) ];

    float top_pixel = self.y_top;
    float base_pixel = self.y_bottom;
    float stem_height = kSTEM_HEIGHT + self.stem_extension;

    for(NSUInteger i = 0; i < ys.count; ++i)
    {
        float stem_top = [ys[i] floatValue] + (stem_height * -((float)self.stemDirection));
        if(((float)self.stemDirection) == MNStemDirectionDown)
        {
            top_pixel = (top_pixel > stem_top) ? top_pixel : stem_top;
            base_pixel = (base_pixel < [ys[i] floatValue]) ? base_pixel : [ys[i] floatValue];
        }
        else
        {
            top_pixel = (top_pixel < stem_top) ? top_pixel : stem_top;
            base_pixel = (base_pixel > [ys[i] floatValue]) ? base_pixel : [ys[i] floatValue];
        }
    }

    return [MNExtentStruct extentWithTopY:top_pixel andBaseY:base_pixel];
}

// set the draw style of a stem:
- (void)applyStyle:(DrawStyle)drawStyle
{
    _drawStyle = drawStyle;
}
- (DrawStyle)getStyle
{
    return _drawStyle;
}
/*
    // Apply current style to Canvas `context`
applyStyle: function(context) {
    var style = self.getStyle();
    if(style) {
        if (style.shadowColor) context.setShadowColor(style.shadowColor);
        if (style.shadowBlur) context.setShadowBlur(style.shadowBlur);
        if (style.strokeStyle) context.setStrokeStyle(style.strokeStyle);
    }
    return this;
},
 */

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    if(self.hide)
    {
        return;
    }

    float stem_x = 0, stem_y = 0;

    if(self.stemDirection == MNStemDirectionDown)
    {
        // Down stems are rendered to the left of the head.
        stem_x = self.x_begin + (kSTEM_WIDTH / 2);
        stem_y = self.y_top + 2;
    }
    else if(self.stemDirection == MNStemDirectionUp)
    {
        // Up stems are rendered to the right of the head.
        stem_x = self.x_end + (kSTEM_WIDTH / 2);
        stem_y = self.y_bottom - 2;
    }
    else
    {
        MNLogError(@"MNStemDirectionError, stem direction not set.");
    }

    stem_y += self.y_extend * ((float)self.stemDirection);

    MNLogDebug(@"Rendering stem: (%f, %f)", self.y_top, self.y_bottom);

    StyleBlock styleBlock = self.styleBlock;
    if(styleBlock)
    {
        CGContextSaveGState(ctx);
        styleBlock(ctx);
    }
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, kSTEM_WIDTH);
    CGContextMoveToPoint(ctx, stem_x, stem_y);
    CGContextAddLineToPoint(ctx, stem_x, stem_y - self.height);

    CGContextStrokePath(ctx);
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    if(styleBlock)
    {
        CGContextRestoreGState(ctx);
    }
}

#pragma mark - CALayer methods

- (CGMutablePathRef)pathConvertPoint:(CGPoint)convertPoint
{
    convertPoint = CGCombinePoints(self.point.CGPoint, convertPoint);
    CGMutablePathRef path = [super pathConvertPoint:convertPoint];

    if(self.hide)
    {
        return path;
    }

    float stem_x = 0, stem_y = 0;

    if(self.stemDirection == MNStemDirectionDown)
    {
        // Down stems are rendered to the left of the head.
        stem_x = self.x_begin + (kSTEM_WIDTH / 2);
        stem_y = self.y_top + 2;
    }
    else if(self.stemDirection == MNStemDirectionUp)
    {
        // Up stems are rendered to the right of the head.
        stem_x = self.x_end + (kSTEM_WIDTH / 2);
        stem_y = self.y_bottom - 2;
    }
    else
    {
        MNLogError(@"MNStemDirectionError, stem direction not set.");
    }

    stem_y += self.y_extend * ((float)self.stemDirection);
    stem_y -= self.staff.y;

    stem_x += [self.parent width];

    CGMutablePathRef subPath = CGPathCreateMutable();

    CGPathMoveToPoint(subPath, NULL, stem_x, stem_y);
    CGPathAddLineToPoint(subPath, NULL, stem_x, stem_y - self.height);
    CGPathAddLineToPoint(subPath, NULL, stem_x + kSTEM_WIDTH, stem_y - self.height);
    CGPathAddLineToPoint(subPath, NULL, stem_x + kSTEM_WIDTH, stem_y);
    CGPathAddLineToPoint(subPath, NULL, stem_x, stem_y);
    CGPathCloseSubpath(subPath);

    CGPathAddPath(path, NULL, subPath);
    return path;
}

@end
