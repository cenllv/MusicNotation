//
//  MNText.h
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

#import "MNPoint.h"
#import "IAModelBase.h"

@class MNFont, MNColor, MNBoundingBox;

typedef NS_ENUM(NSUInteger, MNTextAlignment)
{
    MNTextAlignmentLeft = NSTextAlignmentLeft,
#if TARGET_OS_IPHONE
    MNTextAlignmentCenter = 1,
    MNTextAlignmentRight = 2,
#else
    MNTextAlignmentRight = NSTextAlignmentRight,
    MNTextAlignmentCenter = NSCenterTextAlignment,
#endif
    MNTextAlignmentJustified =
        NSTextAlignmentJustified,
    MNTextAlignmentNatural = NSTextAlignmentNatural,  
};

typedef NS_ENUM(NSUInteger, MNTextVerticalAlignment)
{
    MNTextAlignmentTop = 1,
    MNTextAlignmentMiddle = 2,
    MNTextAlignmentBottom = 3,
};

/*! The `MNText` draws text
 */
@interface MNText : NSObject

#pragma mark - Properties
+ (void)setAlignment:(MNTextAlignment)alignment;
+ (void)setVerticalAlignment:(MNTextVerticalAlignment)alignment;
+ (void)setFont:(MNFont*)font;
+ (void)setBold:(BOOL)bold;
+ (void)setItalic:(BOOL)italic;
+ (void)setColor:(MNColor*)color;
+ (void)showBoundingBox:(BOOL)showBoundingBox;

#pragma mark - Methods

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

//+ (void)drawText:(CGContextRef)ctx atPoint:(CGPoint)point withHeight:(float)h withText:(NSString *)text;
+ (void)drawText:(CGContextRef)ctx atPoint:(MNPoint*)point withBounds:(CGRect)bounds withText:(NSString*)text;

+ (void)drawText:(CGContextRef)ctx withFont:(MNFont*)font atPoint:(MNPoint*)point withText:(NSString*)text;
+ (void)drawText:(CGContextRef)ctx withFont:(MNFont*)font atRect:(CGRect)rect withText:(NSString*)text;

+ (void)drawText:(CGContextRef)ctx atPoint:(MNPoint*)point withText:(NSString*)text;
+ (void)drawText:(CGContextRef)ctx atPoint:(MNPoint*)point withHeight:(float)h withText:(NSString*)text;

+ (void)drawTextWithContext:(CGContextRef)ctx
                    atPoint:(MNPoint*)point
                 withBounds:(MNBoundingBox*)bounds
                   withText:(NSString*)text
               withFontName:(NSString*)fontName
                   fontSize:(NSUInteger)fontSize;

+ (CGSize)measureText:(NSString*)text;
+ (CGSize)measureText:(NSString*)text withFont:(MNFont*)font;

@end

@interface LoremIpsum : NSObject
- (NSString*)words:(NSUInteger)count;
- (NSString*)sentences:(NSUInteger)count;
- (NSString*)randomWord;
@end

@interface NSString (Size)
- (CGSize)attributedSizeWithFont:(MNFont*)font;
- (CGSize)attributedSizeWithFont:(MNFont*)font maxWidth:(CGFloat)width;
@end