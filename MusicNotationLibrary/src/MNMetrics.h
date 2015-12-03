//
//  MNMetrics.h
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

@class MNFloatSize, MNColor;
@class MNPoint, MNBoundingBox, MNPadding;

/*!
 *  The `Metrics` class is a container for all the positioning, spacing,
 *  direction, scale, and every other possible number you can assign to a thing that is
 *  gonna be stored, compared, calculated and drawn for music notation.
 */
@interface MNMetrics : IAModelBase
{
   @private
    NSString* _code;
    NSString* _name;
}
#pragma mark - Properties
@property (assign, nonatomic) float xMin;
@property (assign, nonatomic) float xMax;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float scale;
@property (assign, nonatomic) float length;

@property (assign, nonatomic) float notePoints;

// parent parent properties
@property (weak, nonatomic) id parent;
@property (assign, nonatomic) NSUInteger line;
@property (assign, nonatomic) float minLine;
@property (assign, nonatomic) float maxLine;
@property (assign, nonatomic) float lineAbove;
@property (assign, nonatomic) float lineBelow;
@property (assign, nonatomic) float textLine;
@property (assign, nonatomic) float spacing;

@property (assign, nonatomic) BOOL cached;
@property (strong, nonatomic) NSString* code;   // name ~ code ~ key
//@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString* name;
//@property (strong, nonatomic) NSString* font;
@property (strong, nonatomic) NSArray* arrayOutline;
@property (strong, nonatomic) NSString* stringOutline;

@property (strong, nonatomic) MNPoint* point;
//@property (strong, nonatomic)  MNPoint* shift;
@property (strong, nonatomic) MNBoundingBox* bounds;

// used by  MNTickContext
//@property (strong, nonatomic)  MNPadding* padding;
//@property (strong, nonatomic)  MNPadding *extra;
//@property (strong, nonatomic)  MNPadding* mod;

//@property (strong, nonatomic) MNColor* strokeColor;
//@property (strong, nonatomic) MNColor* fillColor;

//@property (assign, nonatomic) CGContextRef graphicsContext;

//@property (weak, nonatomic) id<MNContextDelegate> context;

@property (strong, nonatomic) MNFloatSize* size;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMetrics:(MNMetrics*)other;
+ (MNMetrics*)standardMetrics;
+ (MNMetrics*)metricsZero;
/*!
 *  gets a short description of this object
 *  @return a string showing properties of this object
 */
- (NSString*)description;

@end
