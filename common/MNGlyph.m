//
//  MNGlyph.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
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

#import "MNGlyph.h"
#import "MNGlyphList.h"
#import "MNUtils.h"
#import "MNPoint.h"
#import "MNBezierPath.h"
#import "MNSize.h"
#import "MNBoundingBox.h"
#import "MNStaff.h"
#import "MNCarrierLayer.h"
#import "MNGlyphLayer.h"
#import "NSBezierPath+MNAdditions.h"
#import "MNConstants.h"
#import "MNGlyphMetrics.h"

@implementation MNGlyph

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        /*
         *
         * @constructor
         *
         Vex.Flow.Glyph = function(code, point, options) {
         self.code = code;
         self.point = point;
         self.context = nil;
         self.options = {
         cache: YES,
         font: Vex.Flow.Font
         };

         self.width = nil;
         _metrics = nil;
         self.x_shift = 0;
         self.y_shift = 0;

         if (options) self.setOptions(options); else self.reset();
         }
         */

        _headWidth = 0;
        self.metrics.width = 0;
        self.x_shift = 0;
        self.y_shift = 0;
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithCode:(NSString*)code withPointSize:(float)point
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.metrics.code = code;
        MNGlyphStruct* glyphStruct = [MNGlyphList sharedInstance].availableGlyphStructsDictionary[code];
        MNFloatSize* glyphStructSize = [[MNGlyphList sharedInstance] sizeForName:glyphStruct.name];
        self.metrics.width = glyphStructSize.width;
        ////do not do the following line! causes infinite loop
        // self.aOutline = [[MNGlyphList availableGlyphsDictionary] objectForKey:self.code];
        //        self.metrics.bounds.xPosition = point.x;
        self.metrics.bounds.width = self.metrics.width;
        self.metrics.scale = point;
        //        self.metrics.point.x = point.x;
        //        self.metrics.point.y = point.y;
    }
    return self;
}

- (instancetype)initWithCode:(NSString*)code withRect:(CGRect)rect
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        //        [self setupWithCode:code withRect:rect];
        self.metrics.code = code;
    }
    return self;
}

- (instancetype)initWithCode:(NSString*)code withScale:(float)scale
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.metrics.scale = scale;
        self.metrics.code = code;
        self.metrics.width = [[MNGlyphList sharedInstance] sizeForName:code].width;
    }
    return self;
}

+ (MNGlyph*)glyphWithCode:(NSString*)code withRect:(CGRect)rect
{
    return [[MNGlyph alloc] initWithCode:code withRect:rect];
}

+ (MNGlyph*)glyphWithCode:(NSString*)code withPointSize:(float)point
{
    return [[MNGlyph alloc] initWithCode:code withPointSize:point];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

- (NSDictionary*)dictionarySerialization
{
    //    return [NSMutableDictionary merge:[super dictionarySerialization]
    //                                 with:[self dictionaryWithValuesForKeyPaths:@[
    //                                     @"metrics",
    //                                 ]]];
    return [self dictionaryWithValuesForKeyPaths:@[
        @"x_shift",
        @"y_shift",
    ]];
}

- (MNGlyphMetrics*)metrics
{
    if(!_metrics)
    {
        _metrics = [[MNGlyphMetrics alloc] init];
    }
    return _metrics;
}

- (NSString*)code_head
{
    //    Metrics* metrics = (Metrics*)_metrics;
    return self.metrics.code;
}

/*
 Vex.Flow.Glyph.prototype.setStaff = function(Staff) {
 self.Staff = Staff; return self; }
 Vex.Flow.Glyph.prototype.setX_shift = function(x_shift) {
 self.x_shift = x_shift; return self; }
 Vex.Flow.Glyph.prototype.setYShift = function(y_shift) {
 self.y_shift = y_shift; return self; }
 Vex.Flow.Glyph.prototype.setContext = function(ctx) {
 self.context = context; return self; }
 Vex.Flow.Glyph.prototype.getContext = function(ctx) {
 return self.context; }
 */

- (NSString*)category
{
    return [MNGlyph CATEGORY];
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);   // return @"glyphs";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

static BOOL _debugMode = NO;
+ (void)setDebugMode:(BOOL)mode
{
    _debugMode = mode;
}

- (BOOL)hasStem
{
    MNMetrics* metrics = (MNMetrics*)_metrics;
    return [metrics.code isEqualToString:@"vb"];
}

- (BOOL)rest
{
    MNMetrics* metrics = (MNMetrics*)_metrics;
    return [metrics.code isEqualToString:@"vc"] || [metrics.code isEqualToString:@"v7c"];
}

- (BOOL)flag
{
    MNMetrics* metrics = (MNMetrics*)_metrics;
    return [metrics.code isEqualToString:@"vb"];
}

- (float)headWidth
{
    MNLogNotYetImlemented();
    abort();
    return 0;
}

#pragma mark - Methods
- (void)reset
{
    /*
     Vex.Flow.Glyph.prototype.reset = function() {
     _metrics = Vex.Flow.Glyph.loadMetrics(self.options.font, self.code,
     self.options.cache);
     self.scale = self.point * 72 / (self.options.font.resolution * 100);
     }
     */
    //    _metrics = [self loadMetricsWithFont:self.options.font withCode:self.code andCache:self.options.cache];
}

- (void)loadMetricsWithFont:(NSString*)font withCode:(NSString*)code andCache:(BOOL)cache
{
    /*
     Vex.Flow.Glyph.loadMetrics = function(font, code, cache) {
     var glyph = font.glyphs[code];
     if (!glyph) throw new Vex.RuntimeError("BadGlyph", "Glyph " + code +
     " does not exist in font.");

     var x_min = glyph["x_min"];
     var x_max = glyph["x_max"];

     var outline;

     if (glyph["o"]) {
     if (cache) {
     if (glyph.cached_outline) {
     outline = glyph.cached_outline;
     } else {
     outline = glyph["o"].split(' ');
     glyph.cached_outline = outline;
     }
     } else {
     if (glyph.cached_outline) delete glyph.cached_outline;
     outline = glyph["o"].split(' ');
     }

     return {
     x_min: x_min,
     x_max: x_max,
     outline: outline
     };
     } else {
     throw new Vex.RuntimeError("BadGlyph", "Glyph " + self.code +
     " has no outline defined.");
     }
     }
     */

    //     MNGlyph *glyph = [[MNGlyphList availableGlyphsDictionary] objectForKey:code];

    MNMetrics* metrics = nil;
    if(!_metrics)
    {
        _metrics = [MNMetrics metricsZero];
    }
    metrics = _metrics;
    //    metrics.font = font;
    metrics.code = code;
    //    _metrics.cache = cache;
}

#pragma mark - Render Methods
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Render Methods
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (void)renderWithCG:(CGContextRef)ctx
{
    MNMetrics* metrics = (MNMetrics*)_metrics;
    CGFloat x = metrics.point.x;
    CGFloat y = metrics.point.y;

    CGFloat scale = metrics.scale * kSCALE;
    NSArray* outline = metrics.arrayOutline;

    if(outline.count == 0)
    {
        MNLogInfo(@"EmptyOutlineException, outline for self symbol was not initialized.");
        MNLogInfo(@"Attempting to look up outline before rendering blockscope proceeds.");
        // attempt to lookup code
        if(metrics.code.length == 0)
        {
            MNLogError(@"SymbolCodeEmptyException, code for symbol is empty.");
        }
        metrics.arrayOutline = [[MNGlyphList sharedInstance].availableGlyphStructsDictionary objectForKey:metrics.code];
    }

    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x, y);
    for(int i = 0; i < outline.count;)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        NSString* action = (NSString*)[outline objectAtIndex:i++];
        if([action isEqual:@"m"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGContextMoveToPoint(ctx, pt.x, pt.y);
            CGContextAddLineToPoint(ctx, pt.x, pt.y);
        }
        else if([action isEqual:@"l"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGContextAddLineToPoint(ctx, pt.x, pt.y);
            CGContextMoveToPoint(ctx, pt.x, pt.y);
        }
        else if([action isEqual:@"q"])
        {
            int cpx = x + (int)[outline objectAtIndex:i++] * scale;
            int cpy = y + (int)[outline objectAtIndex:i++] * -scale;
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cpt = CGPointMake(cpx, cpy);
            CGContextAddQuadCurveToPoint(ctx, cpt.x, cpt.y, pt.x, pt.y);
            CGContextMoveToPoint(ctx, pt.x, pt.y);
        }
        else if([action isEqual:@"b"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cp1 = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                      y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cp2 = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                      y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGContextAddCurveToPoint(ctx, cp1.x, cp1.y, cp2.x, cp2.y, pt.x, pt.y);
        }
        else
        {
            //             MNLogError(@"something went wrong: (void)renderOutline:(CGContextRef)ctx"];
        }
#pragma clang diagnostic pop
    }
    //    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextClosePath(ctx);
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextDrawPath(ctx, kCGPathFill);
}

+ (MNCarrierLayer*)createCarrierLayerWithCode:(NSString*)code withScale:(CGFloat)scale hasCross:(BOOL)hasCross
{
    MNCarrierLayer* carrierLayer = [MNCarrierLayer layer];

    if(hasCross)
    {
        CAShapeLayer* crossLayer = [CAShapeLayer layer];
        CGPathRef immutablePath = NULL;
        CGMutablePathRef mutablePath = CGPathCreateMutable();
        CGPathMoveToPoint(mutablePath, NULL, -5, 0);
        CGPathAddLineToPoint(mutablePath, NULL, +5, 0);
        CGPathMoveToPoint(mutablePath, NULL, 0, -5);
        CGPathAddLineToPoint(mutablePath, NULL, 0, +5);
        CGPathCloseSubpath(mutablePath);
        immutablePath = CGPathCreateCopy(mutablePath);
        CGPathRelease(mutablePath);
        crossLayer.path = immutablePath;
        CGPathRelease(immutablePath);
        crossLayer.lineCap = kCALineCapRound;
        crossLayer.lineWidth = 1;
        crossLayer.strokeColor = MNColor.blackColor.CGColor;
        crossLayer.fillColor = MNColor.blackColor.CGColor;
        //    crossLayer.zPosition = +3;
        crossLayer.anchorPoint = CGPointMake(0.5, 0.5);
        crossLayer.position = CGPointZero;
        [carrierLayer addSublayer:crossLayer];
    }

    MNGlyphShapeLayer* glyphLayer = [MNGlyphShapeLayer layer];
    //    glyphLayer.borderWidth = 1.0;
    //    glyphLayer.borderColor = [NSColor orangeColor].CGColor;
    //    glyphLayer.backgroundColor = [NSColor lightGrayColor].CGColor;
    MNGlyphStruct* g = [[[MNGlyphList sharedInstance] availableGlyphStructsDictionary] objectForKey:code];
    CGSize size = CGScaleSize(g.size, scale);
    glyphLayer.frame = CGPointSizeCombine(CGPointZero, size);
    glyphLayer.anchorPoint = CGClampPoint(CGInvertPoint(g.anchorPoint.CGPoint), g.size);
    glyphLayer.fillColor = MNColor.blackColor.CGColor;
    CGPathRef cgpath = [MNGlyph createPathwithCode:g.name
                                         withScale:scale
                                           atPoint:CGScalePoint(CGInvertPoint(g.anchorPoint.CGPoint), scale)];
    glyphLayer.path = cgpath;
    glyphLayer.position = CGPointZero;
    [carrierLayer addSublayer:glyphLayer];

    return carrierLayer;
}

+ (CGPathRef)createPathwithCode:(NSString*)code withScale:(CGFloat)scale atPoint:(CGPoint)point;
// Withtransform:(CGAffineTransform*)transform
{
    MNBezierPath* bPath = [MNBezierPath bezierPath];
    scale = kSCALE * scale;
    CGFloat x = point.x, y = point.y;
    //    CGFloat x = 0, y = 0;
    //    [bPath moveToPoint:CGPointMake(x, y)];
    [bPath moveToPoint:point];

    NSArray* outline = [[MNGlyphList sharedInstance] getOutlineForName:code];

    for(int i = 0; i < outline.count;)
    {
        NSString* action = (NSString*)[outline objectAtIndex:i++];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        if([action isEqual:@"m"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            [bPath moveToPoint:pt];
        }
        else if([action isEqual:@"l"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            [bPath addLineToPoint:pt];
        }
        else if([action isEqual:@"q"])
        {
            int cpx = x + (int)[outline objectAtIndex:i++] * scale;
            int cpy = y + (int)[outline objectAtIndex:i++] * -scale;
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cpt = CGPointMake(cpx, cpy);
            [bPath addQuadCurveToPoint:pt controlPoint:cpt];
        }
        else if([action isEqual:@"b"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cp1 = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                      y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cp2 = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                      y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            [bPath addCurveToPoint:pt controlPoint1:cp1 controlPoint2:cp2];
        }
        else
        {
            //MNLogError(@"draw symbol error."];
        }
#pragma clang diagnostic pop
    }

    [bPath closePath];
    return ((MNBezierPath*)bPath).CGPath;
}

+ (void)renderIntoArray:(NSMutableArray*)paths
              transform:(CGAffineTransform*)transform
               withCode:(NSString*)code
              withScale:(float)scale
{
    scale *= kSCALE;

    [MNGlyph glyphWithCode:code withPointSize:1];

    if(!paths)
    {
        paths = [NSMutableArray array];
    }

    // FIXME: can't fetch the outline without going through  MNGlyphStruct?

    //    NSDictionary* dict =  [MNGlyphList sharedInstance].availableGlyphStructsDictionary;
    MNGlyphStruct* glyphStruct =
        (MNGlyphStruct*)[[MNGlyphList sharedInstance].availableGlyphStructsDictionary objectForKey:code];
    NSArray* outline = glyphStruct.arrayOutline;

    if(outline.count == 0)
    {
        MNLogError(@"EmptyArrayOutline, recheck the code.");
    }

    CGPoint prevPoint = CGPointApplyAffineTransform(CGPointZero, *transform);
    CGFloat x = 0.0, y = 0.0;
    for(int i = 0; i < outline.count;)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, transform, prevPoint.x, prevPoint.y);
        NSString* action = (NSString*)[outline objectAtIndex:i++];
        if([action isEqual:@"m"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPathMoveToPoint(path, transform, pt.x, pt.y);
            CGPathAddLineToPoint(path, transform, pt.x, pt.y);
            prevPoint = pt;
        }
        else if([action isEqual:@"l"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPathAddLineToPoint(path, transform, pt.x, pt.y);
            CGPathMoveToPoint(path, transform, pt.x, pt.y);
            prevPoint = pt;
        }
        else if([action isEqual:@"q"])
        {
            int cpx = x + (int)[outline objectAtIndex:i++] * scale;
            int cpy = y + (int)[outline objectAtIndex:i++] * -scale;
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cpt = CGPointMake(cpx, cpy);
            CGPathAddQuadCurveToPoint(path, transform, cpt.x, cpt.y, pt.x, pt.y);
            CGPathMoveToPoint(path, transform, pt.x, pt.y);
            prevPoint = pt;
        }
        else if([action isEqual:@"b"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cp1 = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                      y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cp2 = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                      y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPathAddCurveToPoint(path, transform, cp1.x, cp1.y, cp2.x, cp2.y, pt.x, pt.y);
            prevPoint = pt;
        }
        else
        {
            //             MNLogError(@"something went wrong: (void)renderOutline:(CGContextRef)ctx"];
        }
        CGPathCloseSubpath(path);
        [paths push:CFBridgingRelease(path)];
#pragma clang diagnostic pop
    }
}

- (void)renderWithMNKit
{
    MNMetrics* metrics = (MNMetrics*)_metrics;
    CGFloat x = metrics.point.x;
    CGFloat y = metrics.point.y;

    MNBezierPath* bPath = [MNBezierPath bezierPath];
    [bPath setLineWidth:1.0];
    //    [MNColor.blackColor setStroke];
    //    [MNColor.blackColor setFill];
    //    ctx.moveTo(x_pos, y_pos);
    [bPath moveToPoint:CGPointMake(x, y)];

    CGFloat scale = metrics.scale * kSCALE;
    NSArray* outline = metrics.arrayOutline;

    if(outline.count == 0)
    {
        MNLogInfo(@"EmptyOutlineException, outline for self symbol was not initialized.");
        MNLogInfo(@"Attempting to look up outline before rendering blockscope proceeds.");
        // attempt to lookup code
        if(metrics.code.length == 0)
        {
            MNLogError(@"SymbolCodeEmptyException, code for symbol is empty.");
        }
        metrics.arrayOutline = [[MNGlyphList sharedInstance].availableGlyphStructsDictionary objectForKey:metrics.code];
    }

    for(int i = 0; i < outline.count;)
    {
        NSString* action = (NSString*)[outline objectAtIndex:i++];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        if([action isEqual:@"m"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            [bPath moveToPoint:pt];
        }
        else if([action isEqual:@"l"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            [bPath addLineToPoint:pt];
        }
        else if([action isEqual:@"q"])
        {
            int cpx = x + (int)[outline objectAtIndex:i++] * scale;
            int cpy = y + (int)[outline objectAtIndex:i++] * -scale;
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cpt = CGPointMake(cpx, cpy);
            [bPath addQuadCurveToPoint:pt controlPoint:cpt];
        }
        else if([action isEqual:@"b"])
        {
            CGPoint pt = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                     y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cp1 = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                      y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            CGPoint cp2 = CGPointMake(x + [(NSNumber*)[outline objectAtIndex:i++] intValue] * scale,
                                      y + [(NSNumber*)[outline objectAtIndex:i++] intValue] * -scale);
            [bPath addCurveToPoint:pt controlPoint1:cp1 controlPoint2:cp2];
        }
        else
        {
            //MNLogError(@"draw symbol error."];
        }
#pragma clang diagnostic pop
    }

    [bPath closePath];
    bPath.miterLimit = -10;   // TODO: look into miterlimits more
    bPath.lineJoinStyle = kCGLineJoinRound;
    //        [bPath stroke];  //looks like crap
    [bPath fill];
}

- (void)renderWithContext:(CGContextRef)ctx
{
    if(self.isSpacer)
    {
        return;
    }
    BOOL useMNtoDraw = kDrawUsingMNKit;
    if(useMNtoDraw)
    {
        [self renderWithMNKit];
    }
    else
    {
        [self renderWithCG:ctx];
    }
}

+ (void)renderGlyph:(CGContextRef)ctx withMetrics:(MNMetrics*)metrics
{
}

+ (void)renderGlyph:(CGContextRef)ctx
                atX:(CGFloat)x
                atY:(CGFloat)y
          withScale:(CGFloat)scale
       forGlyphCode:(NSString*)gCode
{
    [MNGlyph renderGlyph:ctx atX:x atY:y withScale:scale forGlyphCode:gCode renderBoundingBox:NO];
}

+ (void)renderGlyph:(CGContextRef)ctx
                atX:(CGFloat)x
                atY:(CGFloat)y
          withScale:(CGFloat)scale
       forGlyphCode:(NSString*)gCode
  renderBoundingBox:(BOOL)renderBoundingBox
{
    MNGlyphStruct* glyphStruct =
        (MNGlyphStruct*)[[MNGlyphList sharedInstance].availableGlyphStructsDictionary objectForKey:gCode];

    MNGlyph* g = [[MNGlyph alloc] init];
    MNMetrics* metrics = g.metrics;   // (Metrics*)g->_metrics;
    metrics.point = MNPointMake(x, y);
    metrics.scale = scale;
    metrics.arrayOutline = glyphStruct.arrayOutline;
    metrics.stringOutline = glyphStruct.stringOutline;
    //    g.graphicsContext = ctx;
    g.renderBoundingBox = renderBoundingBox;
    if(_debugMode)
    {
        g.renderBoundingBox = YES;
    }
//    [metrics.point setX:x andY:y];

#if TARGET_OS_IPHONE
    //    NSGraphicsContext* nsgc = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO];
    //    [NSGraphicsContext saveGraphicsState];
    //    [NSGraphicsContext setCurrentContext:nsgc];
    CGContextSaveGState(ctx);
    [g renderWithMNKit];
    //        [g renderWithCG:ctx];  // NOTE: poor rendering
    CGContextRestoreGState(ctx);
//    [NSGraphicsContext restoreGraphicsState];
#elif TARGET_OS_MAC
    NSGraphicsContext* nsgc = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsgc];
    [g renderWithMNKit];
    [NSGraphicsContext restoreGraphicsState];
#endif

    if(g.renderBoundingBox)
    {
        MNFloatSize* size = [[MNGlyphList sharedInstance] sizeForName:glyphStruct.name];
        MNPoint* anchorPoint = glyphStruct.anchorPoint;
        metrics.bounds = [MNBoundingBox boundingBoxAtX:(x + anchorPoint.x * scale)
                                                   atY:(y + anchorPoint.y * scale)
                                             withWidth:size.width * scale
                                             andHeight:size.height * scale];

        [metrics.bounds draw:ctx];
    }
}

- (void)renderWithContext:(CGContextRef)ctx atX:(CGFloat)x atY:(CGFloat)y
{
    /*
     Vex.Flow.Glyph.prototype.render = function(ctx, x_pos, y_pos) {
     if (!_metrics) throw new Vex.RuntimeError("BadGlyph", "Glyph " +
     self.code + " is not initialized.");

     var outline = _metrics.outline;
     var scale = self.scale;
     var outlineLength = outline.count;

     Vex.Flow.Glyph.renderOutline(ctx, outline, scale, x_pos, y_pos);
     }
     */

    if(self.drawBlock)
    {
        self.drawBlock(ctx, nil, x, y);
    }
    else
    {
        [[self class] renderGlyph:ctx
                              atX:x   // + self.x_shift
                              atY:y   //+ self.y_shift   //+ self.metrics.point.y
                        withScale:self.metrics.scale
                     forGlyphCode:self.metrics.code
                renderBoundingBox:NO];
    }
}

- (void)renderWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff atX:(CGFloat)x
{
    /*
     Vex.Flow.Glyph.prototype.renderToStaff = function(x) {
     if (!_metrics) throw new Vex.RuntimeError("BadGlyph", "Glyph " +
     self.code + " is not initialized.");
     if (!self.Staff) throw new Vex.RuntimeError("GlyphError", "No valid Staff");
     if (!self.context) throw new Vex.RERR("GlyphError", "No valid context");

     var outline = _metrics.outline;
     var scale = self.scale;
     var outlineLength = outline.count;

     Vex.Flow.Glyph.renderOutline(self.context, outline, scale,
     x + self.x_shift, self.Staff.getYForGlyphs() + self.y_shift);
     }

     /// Static methods used to implement loading / unloading of glyphs
     */
    MNMetrics* metrics = (MNMetrics*)_metrics;
    if(!_metrics)
    {
        MNLogError(@"BadGlyph, Glyph %@ is not initialized.", metrics.code);
    }

    if(self.drawBlock)
    {
        self.drawBlock(ctx, staff, x + self.x_shift, [staff getYForGlyphs] + self.y_shift);
    }
    else
    {
        [self renderWithContext:ctx atX:(x + self.x_shift)atY:([staff getYForGlyphs] + self.y_shift)];
    }
}

@end
