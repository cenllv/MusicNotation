//
//  MNRect.h
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

#import "IAModelBase.h"

/*!
 *  The `MNRect` class is a container for four points
 */
@interface MNRect : IAModelBase
@property (assign, nonatomic, readonly) CGRect rect;
@property (assign, nonatomic) float xPosition;
@property (assign, nonatomic) float yPosition;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;
@property (readonly, nonatomic) CGPoint origin;
@property (readonly, nonatomic) float xEnd;
@property (readonly, nonatomic) float yEnd;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithRect:(CGRect)rect;
- (instancetype)initAtX:(float)x atY:(float)y withWidth:(float)width andHeight:(float)height;

+ (MNRect*)boundingBoxAtX:(float)x atY:(float)y withWidth:(float)width andHeight:(float)height;
+ (MNRect*)boundingBoxZero;
+ (MNRect*)boundingBoxWithRect:(CGRect)rect;

- (NSString*)description;

- (void)mergeWithBox:(MNRect*)box;   // andDrawWthContext:(CGContextRef)ctx;

@end
