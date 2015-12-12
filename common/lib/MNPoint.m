//
//  MNPoint.m
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

#import "MNPoint.h"

@interface MNPoint ()
{
    float _x;
    float _y;
}
@end

@implementation MNPoint

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
        _x = 0;
        _y = 0;
    }
    return self;
}

- (instancetype)initWithX:(float)x andY:(float)y
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        _x = x;
        _y = y;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    return [MNPoint pointWithX:_x andY:_y];
}

+ (MNPoint*)pointWithX:(float)x andY:(float)y
{
    return [[MNPoint alloc] initWithX:x andY:y];
}

+ (MNPoint*)pointZero
{
    return [MNPoint pointWithX:0 andY:0];
}

- (NSString*)toString
{
    return [NSString stringWithFormat:@"(%f, %f)", _x, _y];
}

- (void)translateByX:(float)x andY:(float)y
{
    self.x += x;
    self.y += y;
}

- (void)setX:(float)x andY:(float)y
{
    _x = x;
    _y = y;
}

- (float)distance:(MNPoint*)otherPoint
{
    return sqrtf(powf(self.x - otherPoint.x, 2.0) + powf(self.y - otherPoint.y, 2.0));
}

- (CGPoint)CGPoint
{
    return CGPointMake(self.x, self.y);
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%f, %f", self.x, self.y];
}

@end
