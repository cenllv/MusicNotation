//
//  MNBoundingBox.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
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


#import "MNColor.h"
#import "MNBoundingBox.h"
#import "MNFont.h"
#import "MNStaff.h"
//#import "Typeset.h"

//@interface MNBoundingBox()
//@property (assign, nonatomic) CGRect rect;
//@end

@implementation MNBoundingBox

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setupBoudingBox];
    }
    return self;
}

- (instancetype)initWithRect:(CGRect)rect
{
    self = [super init];
    if(self)
    {
        [self setupBoudingBox];
        _r = rect;
        _x = CGRectGetMinX(self.rect);     // self.rect.origin.x;
        _y = CGRectGetMinY(self.rect);     // self.rect.origin.y;
        _w = CGRectGetWidth(self.rect);    // self.rect.size.width;
        _h = CGRectGetHeight(self.rect);   // self.rect.size.height;
    }
    return self;
}

- (instancetype)initAtX:(float)x atY:(float)y withWidth:(float)width andHeight:(float)height
{
    self = [self init];
    if(self)
    {
        [self setupBoudingBox];
        _r = CGRectMake(x, y, width, height);
        _x = x;
        _y = y;
        _w = width;
        _h = height;
    }
    return self;
}

- (void)setupBoudingBox
{
    _r = CGRectZero;
    _x = 0.0;
    _y = 0.0;
    _w = 0.0;
    _h = 0.0;
}

#pragma mark - Properties
@synthesize xPosition = _x;
@synthesize yPosition = _y;
@synthesize width = _w;
@synthesize height = _h;
@synthesize rect = _r;

- (void)setXPosition:(float)xPosition
{
    _x = xPosition;
    _r = CGRectMake(_x, _y, _w, _h);
}

- (void)setYPosition:(float)yPosition
{
    _y = yPosition;
    _r = CGRectMake(_x, _y, _w, _h);
}

- (void)setWidth:(float)width
{
    _w = width;
    _r = CGRectMake(_x, _y, _w, _h);
}

- (void)setHeight:(float)height
{
    _h = height;
    _r = CGRectMake(_x, _y, _w, _h);
}

- (void)setRect:(CGRect)rect
{
    _r = rect;
    _x = _r.origin.x;
    _y = _r.origin.y;
    _w = _r.size.width;
    _h = _r.size.height;
}

- (CGPoint)origin
{
    return CGPointMake(self.xPosition, self.yPosition);
}

- (float)xEnd
{
    return CGRectGetMaxX(self.rect);   // self.rect.origin.x + self.rect.size.width;
}

- (float)yEnd
{
    return CGRectGetMaxY(self.rect);   // self.rect.origin.y + self.rect.size.height;
}

#pragma mark - Methods
+ (MNBoundingBox*)boundingBoxAtX:(float)x atY:(float)y withWidth:(float)width andHeight:(float)height
{
    return [[MNBoundingBox alloc] initAtX:x atY:y withWidth:width andHeight:height];
}

+ (MNBoundingBox*)boundingBoxZero
{
    return [[MNBoundingBox alloc] init];
}

+ (MNBoundingBox*)boundingBoxWithRect:(CGRect)rect
{
    return [[MNBoundingBox alloc] initWithRect:rect];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"rect: (%f.01, %f.01, %f.01, %f.01)\n", self.xPosition, self.yPosition,
                                      self.width, self.height];
}

- (void)mergeWithBox:(MNBoundingBox*)box
{   // andDrawWthContext:(CGContextRef)ctx; {
    [self setRect:CGRectUnion(self.rect, box.rect)];

    //    if (context != nil)
    //        [self draw:context];
}

- (void)draw:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    [[MNColor blueColor] setStroke];
    CGContextSetFillColorWithColor(ctx, [MNColor blueColor].CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.rect);
    CGContextAddPath(ctx, path);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGPathRelease(path);
    CGContextRestoreGState(ctx);

    //    [[MNColor crayolaApricotColor] setStroke];
    MNFont* descriptionFont = [MNFont fontWithName:@"ArialMT" size:8];

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    NSAttributedString* description;

    float y_top_text_line = CGRectGetMinY(self.rect) - 30;
    y_top_text_line = y_top_text_line < 0 ? 0 : y_top_text_line;
    float y_bottom_text_line = CGRectGetMaxY(self.rect) + 5;

    description = [[NSAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"%.00f\n%.00f\n", self.xPosition, self.yPosition]
            attributes:@{
                NSParagraphStyleAttributeName : paragraphStyle,
                NSFontAttributeName : descriptionFont.font,
                NSForegroundColorAttributeName : [MNColor blueColor]
            }];
    float x = CGRectGetMinX(self.rect) - 15;
    float y = y_top_text_line;
    [description drawAtPoint:CGPointMake(x, y)];

    description = [[NSAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"%.00f\n%.00f\n", self.xPosition + self.width,
                                                  self.yPosition + self.height]
            attributes:@{
                NSParagraphStyleAttributeName : paragraphStyle,
                NSFontAttributeName : descriptionFont.font,
                NSForegroundColorAttributeName : [MNColor blueColor]
            }];
    x = CGRectGetMinX(self.rect) + 15;
    y = y_bottom_text_line;   // CGRectGetMinY(self.rect) + 30;
    [description drawAtPoint:CGPointMake(x, y)];

    // TODO: the following hack fixes a color issue where every draw after this is set to this color
    description = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" "]
                                                  attributes:@{NSForegroundColorAttributeName : MNColor.blackColor}];
    [description drawAtPoint:CGPointMake(0, 0)];
}
@end
