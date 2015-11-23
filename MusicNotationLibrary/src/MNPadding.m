//
//  MNPadding.m
//  MNCore
//
//  Created by Scott Riccardelli on 1/1/15.
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

#import "MNPadding.h"
#import "MNPoint.h"

@implementation MNPadding

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
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
        [self setupPadding];
    }
    return self;
}

- (instancetype)initWithXRightPadding:(float)xRight
                      andXLeftPadding:(float)xLeft
                        andYUpPadding:(float)yUp
                      andYDownPadding:(float)yDown
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupPadding];
        _xRightPadding = xRight;
        _xLeftPadding = xLeft;
        _yUpPadding = yUp;
        _yDownPadding = yDown;
    }
    return self;
}

- (instancetype)initWithXRightPadding:(float)xRight andXLeftPadding:(float)xLeft
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupPadding];
        _xRightPadding = xRight;
        _xLeftPadding = xLeft;
    }
    return self;
}

- (instancetype)initWithX:(float)x andY:(float)y
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupPadding];
        _point = [MNPoint pointWithX:x andY:y];
    }
    return self;
}

- (void)setupPadding
{
    _point = [MNPoint pointZero];
    _xRightPadding = 0;
    _xLeftPadding = 0;
    _yUpPadding = 0;
    _yDownPadding = 0;
}

#pragma mark - Properties

- (float)width
{
    return self.xLeftPadding + self.xRightPadding;
}

- (float)height
{
    return self.yDownPadding + self.yUpPadding;
}

#pragma mark - Methods
+ (MNPadding*)paddingWithX:(float)x andY:(float)y
{
    return [[MNPadding alloc] initWithX:x andY:y];
}

+ (MNPadding*)paddingWithRightPadding:(float)xRight
                      andXLeftPadding:(float)xLeft
                        andYUpPadding:(float)yUp
                      andYDownPadding:(float)yDown
{
    return
        [[MNPadding alloc] initWithXRightPadding:xRight andXLeftPadding:xLeft andYUpPadding:yUp andYDownPadding:yDown];
}

+ (MNPadding*)paddingWith:(float)padding
{
    return [MNPadding paddingWithRightPadding:padding
                              andXLeftPadding:padding
                                andYUpPadding:padding
                              andYDownPadding:padding];
}

+ (MNPadding*)paddingZero
{
    return [[MNPadding alloc] initWithXRightPadding:0 andXLeftPadding:0 andYUpPadding:0 andYDownPadding:0];
}

- (void)addPaddingToAllSidesWith:(float)padding
{
    _xRightPadding += padding;
    _xLeftPadding += padding;
    _yUpPadding += padding;
    _yDownPadding += padding;
}

- (void)padAllSidesBy:(float)padding
{
    _xRightPadding = padding;
    _xLeftPadding = padding;
    _yUpPadding = padding;
    _yDownPadding = padding;
}

@end
