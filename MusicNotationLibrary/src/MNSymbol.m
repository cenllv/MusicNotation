//
//  MNSymbol.m
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


#import "MNColor.h"
#import "MNBezierPath.h"
#import "MNSymbol.h"
#import "MNUtils.h"
#import "MNPoint.h"
#import "MNGlyphList.h"
//#import "MNCore.h"
#import "MNRenderOptions.h"
#import <objc/runtime.h>
#import "MNGlyphList.h"
#import "NSString+Ruby.h"
#import "MNMetrics.h"
#import "MNBoundingBox.h"
#import "MNShapeLayer.h"

@interface MNSymbol ()   //<CALayerDelegate> // <-- informal protocol

@end

@implementation MNSymbol
#pragma mark - Initialization

+ (instancetype)node
{
    return [[MNSymbol alloc] initWithDictionary:nil];
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        //[NSException raise:NSStringFromClass([self class])
        //          format:@"Attempting to instantiate an abstract class. Use a concrete subclass instead."];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setupSymbol];
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)initWithCode:(NSString*)code
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.symbolMetrics.code = code;
        [self setupSymbol];
        //        [self load];
    }
    return self;
}

- (instancetype)initWithCode:(NSString*)code withPointSize:(float)pointSize
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.symbolMetrics.code = code;
        //        self.symbolMetrics.point = point;
        [self setupSymbol];
        //        [self load];
    }
    return self;
}

//- (instancetype)initWithCode:(NSString *)code
//           atPoint:(MNPoint *)point {
////          withSize:(CGSize)size{
//    self = [super init];
//    if (self) {
//        [self setup];
//        self.metrics.code = code;
//        self.metrics.point = point;
////        self.metrics.bounds
//    }
//    return self;
//}

+ (MNSymbol*)symbol
{
    return [[MNSymbol alloc] init];
}

+ (MNSymbol*)symbolWithCode:(NSString*)code withPointSize:(float)pointSize
{
    return [[MNSymbol alloc] initWithCode:code withPointSize:pointSize];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (void)setupSymbol
{
    //    if (self.metrics.code) {
    //        self.category =  [MNGlyphList nameForCode:self.metrics.code];
    //    }
    _preFormatted = NO;
    _postFormatted = NO;

    _skewX = _skewY = 0.0f;
    _rotationalSkewX = _rotationalSkewY = 0.0f;
    _scaleX = _scaleY = 1.0f;

    _isTransformDirty = _isInverseDirty = YES;

    _vertexZ = 0;

    _visible = YES;

    _zOrder = 0;

    // children (lazy allocs)
    _children = nil;

    // userObject is always inited as nil
    _userObject = nil;

    // initialize parent to nil
    _parent = nil;

    _orderOfArrival = 0;

    _cascadeOpacityEnabled = NO;
    _cascadeColorEnabled = NO;
}

#pragma mark - Properties

/*!---------------------------------------------------------------------------------------------------------------------
 * @name Properties
 * ---------------------------------------------------------------------------------------------------------------------Ø
 */
//- (NSString*)description
//{
//    //    NSString *ret = [self prolog];
//    //
//    //    ret = [ret concat:[NSString stringWithFormat:@"Category: %@\n", self.category]];
//    //    ret = [ret concat:[self.metrics prettyPrint]];
//
//    return [NSString stringWithFormat:@"<%@ = %p | Name = %@>", [self class], self, _name];
//
//    //    return  [MNLog FormatObject:[self epilog:ret]];
//}
//- (NSString*)prolog
//{
//    //    static int depth = 0;
//    //    int i = depth++;
//    //    id a = self;
//    //    while (i > 0) {
//    //        a = class_getSuperclass([a class]);
//    //        --i;
//    //    }
//    //
//    //    const char *str = class_getName([a class]);
//
//    //    NSString *desc = [desc concat:[NSString stringWithFormat:@"%s <%p> : { \n", str, self]];
//
//    NSString* desc = [NSString stringWithFormat:@"%@ { \n", @""];
//
//    //    NSString *desc = [NSString stringWithFormat:@"%@ { \n", @"super : "];
//
//    //    NSString *desc = [NSString stringWithCString:str encoding:NSASCIIStringEncoding];
//    //*!*
//    //    desc = [desc concat:[NSString stringWithFormat:@"%s { \n", str]];
//    return desc;
//}
//
//- (NSString*)epilog:(NSString*)desc
//{
//    desc = [desc concat:@"}\n"];
//    return desc;
//}

/*!
 *  hhelps create a debug description from the specified string to properties dictionary
 *  @return a dictionary of property names
 */
- (NSDictionary*)dictionarySerialization;
{
    //    return [self dictionaryWithValuesForKeyPaths:@[]];
    return [self dictionaryWithValuesForKeyPaths:@[]];
}

- (MNRenderOptions*)renderOptions
{
    if(!_renderOptions)
    {
        _renderOptions = [[MNRenderOptions alloc] init];
    }
    return _renderOptions;
}

- (MNMetrics*)symbolMetrics
{
    if(!_metrics)
    {
        _metrics = [MNMetrics metricsZero];
    }
    return _metrics;
}

- (void)setMetrics:(MNMetrics*)metrics
{
    _metrics = metrics;
}

- (void)setPoint:(MNPoint*)point
{
    self.symbolMetrics.point = point;
}

- (MNPoint*)point
{
    return self.symbolMetrics.point;
}

- (float)width
{
    return self.symbolMetrics.width;
}

- (id)setWidth:(float)width
{
    self.symbolMetrics.width = width;
    return self;
}

//- (CGContextRef)graphicsContext
//{
//    //    return self.metrics.graphicsContext;
//    return _graphicsContext;
//}

//- (void)setGraphicsContext:(CGContextRef)graphicsContext
//{
//    _graphicsContext = graphicsContext;
//}

- (MNBoundingBox*)getBoundingBox
{
    //    return _metrics.bounds;
    return _boundingBox;
}

- (NSString*)getCode
{
    return self.symbolMetrics.code;
}

- (float)absoluteX;
{
    MNMetrics* metrics = _metrics;
    return metrics.point.x;
    //    return _boundingBox.xPosition;
}

- (CALayer*)layer
{
    if(!_layer)
    {
        _layer = [CALayer layer];
        _layer.delegate = self;
        [_layer setNeedsDisplay];
    }
    return _layer;
}

#pragma mark - Methods
- (void)reset;
{
    _preFormatted = NO;
    _postFormatted = NO;
}

- (BOOL)preFormat;
{
    if(!_preFormatted)
    {
        [self load];
        _preFormatted = YES;
    }
    return YES;
}

- (void)load;
{
    //    if([self.symbolMetrics.code isEqualToString:@""])
    //    {
    //        //         [MNLog LogError:;
    //        //         [MNLog LogVexDump:[NSString stringWithFormat:@"CodeExceptionOnLoading : %@",
    //        self.description]];
    //        //         [MNLog LogInfo:[NSString stringWithFormat:@"Attempting to load empty nsstring code: -
    //        (void)load
    //        :
    //        //        %@", self.description]];
    //    }

    // self.category =  [MNGlyphList nameForCode:self.metrics.code];
    if(self.symbolMetrics.arrayOutline)
    {
        MNLogError(@"SymbolMetricsCodeError, code not set for symbol Metrics object");
        self.symbolMetrics.arrayOutline = [[MNGlyphList sharedInstance] getOutlineForName:self.symbolMetrics.code];
    }
}

- (BOOL)postFormat;
{
    return YES;
}

- (void)draw:(CGContextRef)ctx;
{
    if(!ctx)
    {
        MNLogError(@"NoCanvasContext, Can't draw without a canvas context.");
    }
    //    if (!self.metrics.graphicsContext) {
    //         [MNLog LogError:@"NoCanvasContext: Can't draw without a canvas context."];
    //        return;
    //    }
    //    [self renderWithContext:self.metrics.context];
}

- (void)renderWithContext:(CGContextRef)ctx
{
    [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
    abort();
}

/*! to allow for variable position and scale glyphs
 */
- (void)renderWithContext:(CGContextRef)ctx atPoint:(CGPoint)point withScale:(float)scale forCode:(NSString*)code
{
    //    NSArray *aOutline = [[MNGlyphList availableGlyphsDictionary] objectForKey:code];
}

#pragma mark - CALayer Methods
/*!---------------------------------------------------------------------------------------------------------------------
 * @name CALayer Methods
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (CGMutablePathRef)pathConvertPoint:(CGPoint)convertPoint
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0 + convertPoint.x, 0 + convertPoint.y);
    return path;
}

- (CGRect)layerFrame
{
    //    return CGRectMake(self.point.x, self.point.y, 0, 0);
    return [[self boundingBox] rect];
}

- (MNShapeLayer*)shapeLayer
{
    MNShapeLayer* ret = [MNShapeLayer layer];

    ret.path = [self pathConvertPoint:self.point.CGPoint];

    return ret;
}

- (void)displayLayer:(CALayer*)layer
{
    layer.frame = self.boundingBox.rect;
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
#if TARGET_OS_IPHONE
    layer.backgroundColor = [[UIColor redColor] CGColor];
#elif TARGET_OS_MAC
    layer.backgroundColor = [[NSColor redColor] CGColor];
#endif
    layer.opacity = 0.5;

    [self draw:ctx];
}

@end
