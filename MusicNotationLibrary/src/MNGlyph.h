//
//  MNGlyph.h
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


#import "MNSymbol.h"
#import "MNMetrics.h"

@class MNStaff, MNPoint, MNCarrierLayer;

@interface GlyphMetrics : MNMetrics
@property (assign, nonatomic) float x_shift;
@property (assign, nonatomic) float y_shift;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (NSString*)description;
- (NSDictionary*)dictionarySerialization;
@end

typedef void (^DrawCustom)(CGContextRef context, float x, float y);

/*! The `MNGlyph` class is a static glyph renderer.

 */
@interface MNGlyph : MNSymbol
{
   @public

   @private
    float _headWidth;
}

#pragma mark - Properties

///*!
// */
@property (strong, nonatomic) NSString* position;
//
////@property (strong, nonatomic)  MNStaff *Staff;
//@property (strong, nonatomic) NSDictionary *glyphTypes;
//
//

//@property (assign, nonatomic) float dotShiftY;

@property (assign, nonatomic) NSUInteger beamCount;

@property (assign, nonatomic, getter=hasStem) BOOL stem;
@property (assign, nonatomic) BOOL flag;

@property (assign, nonatomic) BOOL rest;

/*!
 *  does not draw anything, only takes up space
 */
@property (assign, nonatomic) BOOL isSpacer;

@property (assign, nonatomic) BOOL cache;
@property (strong, nonatomic) NSString* codeFlagUpstem;
@property (strong, nonatomic) NSArray* aFlagUpstem;
@property (strong, nonatomic) NSString* codeFlagDownstem;
@property (strong, nonatomic) NSArray* aFlagDownstem;

//@property (strong, nonatomic) NSString *category;

//@property (strong, nonatomic) Metrics *metrics;

@property (strong, nonatomic) NSString* code_head;

@property (assign, nonatomic) float x_shift;
@property (assign, nonatomic) float y_shift;

@property (assign, nonatomic) BOOL renderBoundingBox;

@property (strong, nonatomic) DrawCustom drawBlock;

- (NSString*)category;
+ (NSString*)CATEGORY;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCode:(NSString*)code withRect:(CGRect)rect;   // cached:(BOOL)cache andFont:(NSString *)font;

- (instancetype)initWithCode:(NSString*)code withPointSize:(float)point;

- (instancetype)initWithCode:(NSString*)code withScale:(float)scale;

+ (MNGlyph*)glyphWithCode:(NSString*)code withRect:(CGRect)rect;
+ (MNGlyph*)glyphWithCode:(NSString*)code withPointSize:(float)point;

- (void)reset;
- (void)loadMetricsWithFont:(NSString*)font withCode:(NSString*)code andCache:(BOOL)cache;

- (GlyphMetrics*)metrics;

+ (void)setDebugMode:(BOOL)mode;

- (NSDictionary*)dictionarySerialization;

#pragma mark - Render Methods
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Render Methods
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (void)renderWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff atX:(CGFloat)x;
- (void)renderWithContext:(CGContextRef)ctx atX:(CGFloat)x atY:(CGFloat)y;

- (void)renderWithContext:(CGContextRef)ctx;

+ (void)renderIntoArray:(NSMutableArray*)paths
              transform:(CGAffineTransform*)transform
               withCode:(NSString*)code
              withScale:(float)scale;

+ (MNCarrierLayer*)createCarrierLayerWithCode:(NSString*)code withScale:(CGFloat)scale hasCross:(BOOL)hasCross;

+ (CGPathRef)createPathwithCode:(NSString*)code withScale:(CGFloat)scale atPoint:(CGPoint)point;

//- (void)renderOutline:(CGContextRef)ctx
//          withOutline:(NSArray*)outline
//             andScale:(CGFloat)scale
//                  atX:(CGFloat)x
//                  atY:(CGFloat)y;

+ (void)renderGlyph:(CGContextRef)ctx withMetrics:(MNMetrics*)metrics;

+ (void)renderGlyph:(CGContextRef)ctx
                atX:(CGFloat)x
                atY:(CGFloat)y
          withScale:(CGFloat)scale
       forGlyphCode:(NSString*)gCode;

+ (void)renderGlyph:(CGContextRef)ctx
                atX:(CGFloat)x
                atY:(CGFloat)y
          withScale:(CGFloat)scale
       forGlyphCode:(NSString*)gCode
  renderBoundingBox:(BOOL)renderBoundingBox;

@end
