//
//  MNPadding.h
//  MusicNotation
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

#import "IAModelBase.h"

@class MNPoint;

/*!
 *  The `MNPadding` class is a container for padding {left, right up, down} points
 */
@interface MNPadding : IAModelBase

#pragma mark - Properties

/*! coordinate of this padding
 */
@property (strong, nonatomic) MNPoint* point;

/*! amount of padding to other elements
 */
@property (assign, nonatomic) float xRightPadding;
@property (assign, nonatomic) float xLeftPadding;
@property (assign, nonatomic) float yUpPadding;
@property (assign, nonatomic) float yDownPadding;

@property (assign, nonatomic, readonly) float width;
@property (assign, nonatomic, readonly) float height;

#pragma mark - Methods

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithXRightPadding:(float)xRight
                      andXLeftPadding:(float)xLeft
                        andYUpPadding:(float)yUp
                      andYDownPadding:(float)yDown;

- (instancetype)initWithXRightPadding:(float)xRight andXLeftPadding:(float)xLeft;

- (instancetype)initWithX:(float)x andY:(float)y;

+ (MNPadding*)paddingWithX:(float)x andY:(float)y;

+ (MNPadding*)paddingWithRightPadding:(float)xRight
                      andXLeftPadding:(float)xLeft
                        andYUpPadding:(float)yUp
                      andYDownPadding:(float)yDown;

+ (MNPadding*)paddingWith:(float)padding;

+ (MNPadding*)paddingZero;

- (void)addPaddingToAllSidesWith:(float)padding;
- (void)padAllSidesBy:(float)padding;

@end
