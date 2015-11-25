//
//  MNRect.m
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

#import "MNRect.h"

@interface MNRect ()
@property (assign, nonatomic) CGRect rect;
@end

@implementation MNRect

#pragma mark - Initialization

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
        [self setupRect];
    }
    return self;
}

- (instancetype)initWithRect:(CGRect)rect
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupRect];
        _r = rect;
        _x = self.rect.origin.x;
        _y = self.rect.origin.y;
        _w = self.rect.size.width;
        _h = self.rect.size.height;
    }
    return self;
}

- (instancetype)initAtX:(float)x atY:(float)y withWidth:(float)width andHeight:(float)height
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupRect];
        _r = CGRectMake(x, y, width, height);
        _x = x;
        _y = y;
        _w = width;
        _h = height;
    }
    return self;
}

- (void)setupRect
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

- (void)setX:(float)x
{
    _x = x;
    _r = CGRectMake(_x, _y, _w, _h);
}

- (void)setY:(float)y
{
    _y = y;
    _r = CGRectMake(_x, _y, _w, _h);
}

- (void)setW:(float)w
{
    _w = w;
    _r = CGRectMake(_x, _y, _w, _h);
}

- (void)setH:(float)h
{
    _h = h;
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
    return self.rect.origin.x + self.rect.size.width;
}

- (float)yEnd
{
    return self.rect.origin.y + self.rect.size.height;
}

#pragma mark - Methods
+ (MNRect*)boundingBoxAtX:(float)x atY:(float)y withWidth:(float)width andHeight:(float)height
{
    return [[MNRect alloc] initAtX:x atY:y withWidth:width andHeight:height];
}

+ (MNRect*)boundingBoxZero
{
    return [[MNRect alloc] init];
}

+ (MNRect*)boundingBoxWithRect:(CGRect)rect
{
    return [[MNRect alloc] initWithRect:rect];
}

- (NSString*)description
{
    return [NSString
        stringWithFormat:@"rect: (%f, %f, %f, %f)\n", self.xPosition, self.yPosition, self.width, self.height];
}

- (void)mergeWithBox:(MNRect*)box
{   // andDrawWthContext:(CGContextRef)ctx; {
    [self setRect:CGRectUnion(self.rect, box.rect)];

    //    if (context != nil)
    //        [self draw:context];
}

@end
