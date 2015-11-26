//
//  MNPedalMarking.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
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

#import "MNEnum.h"
#import "IAModelBase.h"

@class MNColor, MNFont;

/*! The `MNPedalMarking` class performs implements different types of pedal markings. These notation
      elements indicate to the performer when to depress and release the a pedal.

      In order to create "Sostenuto", and "una corda" markings, you must set
      custom text for the release/depress pedal markings.

 */
@interface MNPedalMarking : IAModelBase

#pragma mark - Properties
@property (strong, nonatomic) NSArray* notes;
@property (assign, nonatomic) MNPedalMarkingType style;
@property (assign, nonatomic) float line;
@property (strong, nonatomic) NSString* custom_depress_text;
@property (strong, nonatomic) NSString* custom_release_text;

@property (strong, nonatomic) NSString* fontFamily;
@property (assign, nonatomic) float fontSize;
@property (assign, nonatomic) BOOL fontBold;
@property (assign, nonatomic) BOOL fontItalic;
@property (strong, nonatomic) MNFont* font;

@property (assign, nonatomic) float bracket_height;
@property (assign, nonatomic) float text_margin_right;
@property (assign, nonatomic) float bracket_line_width;
@property (assign, nonatomic) float glyph_point_size;
@property (strong, nonatomic) MNColor* color;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNotes:(NSArray*)notes;
+ (MNPedalMarking*)pedalMarkingWithNotes:(NSArray*)notes;

+ (MNPedalMarking*)createUnaCorda:(NSArray*)notes;
+ (MNPedalMarking*)createSustain:(NSArray*)notes;
+ (MNPedalMarking*)createSostenuto:(NSArray*)notes;

- (void)setCustomText:(NSString*)text;
- (void)setCustomTextDepress:(NSString*)depressText release:(NSString*)releaseText;
- (void)setStyle:(MNPedalMarkingType)style;
- (void)setLine:(float)line;

- (void)drawBracketed:(CGContextRef)ctx;
- (void)drawText:(CGContextRef)ctx;

- (void)draw:(CGContextRef)ctx;

@end
