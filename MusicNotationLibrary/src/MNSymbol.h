//
//  MNSymbol.h
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

@class MNMetrics, MNOptions, MNPoint, MNFloatSize, MNPadding, MNBoundingBox, MNRenderOptions, MNGlyph, MNColor,
    MNShapeLayer;

/*! The `MNSymbol` class
 */
@interface MNSymbol : IAModelBase
{
   @protected
    id _renderOptions;
    id _metrics;
    BOOL _preFormatted;
    BOOL _postFormatted;
    //    CGContextRef _graphicsContext;

    float _rotationalSkewX, _rotationalSkewY;
    float _scaleX, _scaleY;
    float _vertexZ;
    float _skewX, _skewY;

    MNPoint* _point;
    MNPoint* _anchorPointInPoints;
    MNPoint* _anchorPoint;
    MNFloatSize* _contentSize;
    MNBoundingBox* _boundingBox;
    float _width;
    //    float          _absoluteX;

    CGAffineTransform _transform, _inverse;
    BOOL _isTransformDirty;
    BOOL _isInverseDirty;
    NSInteger _zOrder;

    __weak MNSymbol* _parent;
    NSMutableArray* _children;
    NSString* _name;
    // NSString        *_category;

    id _userObject;
    NSUInteger _orderOfArrival;
    BOOL _visible;
    BOOL _isReorderChildDirty;
    MNColor *_displayColor, *_color;
    BOOL _cascadeColorEnabled, _cascadeOpacityEnabled, _cascadeScaleEnabled;

    CALayer* _layer;
}

#pragma mark - Properties
@property (strong, nonatomic) id metrics;

@property (assign, nonatomic) BOOL preFormatted;
@property (assign, nonatomic) BOOL postFormatted;
//@property (assign, nonatomic) CGContextRef graphicsContext;

@property (assign, nonatomic) float rotationalSkewX;
@property (assign, nonatomic) float rotationalSkewY;
@property (assign, nonatomic) float scaleX;
@property (assign, nonatomic) float scaleY;
@property (assign, nonatomic) float vertexZ;
@property (assign, nonatomic) float skewX;
@property (assign, nonatomic) float skewY;

@property (strong, nonatomic) MNPoint* point;
@property (strong, nonatomic) MNPoint* anchorPointInPoints;
@property (strong, nonatomic) MNPoint* anchorPoint;
@property (strong, nonatomic) MNFloatSize* contentSize;
@property (strong, nonatomic, readonly) MNBoundingBox* boundingBox;
//@property (assign, nonatomic) float width;
- (id)setWidth:(float)width;
- (float)width;
@property (assign, nonatomic, readonly) float absoluteX;

// staff or note or other parent
@property (weak, nonatomic) MNSymbol* parent;
@property (strong, nonatomic) NSMutableArray* children;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic, readonly) NSString* category;

@property (strong, nonatomic) id userObject;
@property (assign, nonatomic) NSUInteger orderOfArrival;
@property (assign, nonatomic) BOOL visible;
@property (assign, nonatomic) BOOL isReorderChildDirty;
@property (strong, nonatomic) MNColor* displayColor;
@property (strong, nonatomic) MNColor* color;
@property (assign, nonatomic) BOOL cascadeColorEnabled;
@property (assign, nonatomic) BOOL cascadeOpacityEnabled;
@property (assign, nonatomic) BOOL cascadeScaleEnabled;

@property (strong, nonatomic) CALayer* layer;

@property (assign, nonatomic) NSUInteger index;

- (id)metrics;

//- (Metrics *)metrics;
//- (void)setMetrics;

#pragma mark - Methods
//`````````````````````
// initialize
+ (instancetype)node;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCode:(NSString*)code;
- (instancetype)initWithCode:(NSString*)code withPointSize:(float)pointSize;
//- (instancetype)initWithCode:(NSString *)code
//           atPoint:(MNPoint *)point;
//          withSize:(CGSize)size;

//+ (MNSymbol *)symbol;

//`````````````````````
// description

//- (NSString*)prolog;
//- (NSString*)epilog:(NSString*)desc;

+ (MNSymbol*)symbolWithCode:(NSString*)code withPointSize:(float)pointSize;

- (void)renderWithContext:(CGContextRef)ctx;
//- (void)renderWithCG:(CGContextRef)ctx;
//- (void)renderWithMNKit;

//`````````````````````
// setup

/*! loads the glyph outline from the code
 */
- (void)load;
- (void)reset;
- (BOOL)preFormat;
- (BOOL)postFormat;
- (void)draw:(CGContextRef)ctx;

//`````````````````````
// CALayer Methods

- (CGMutablePathRef)pathConvertPoint:(CGPoint)convertPoint;
- (CGRect)layerFrame;
- (MNShapeLayer*)shapeLayer;

@end
