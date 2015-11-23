//
//  MNStem.h
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
#import "MNModifier.h"

@class MNBoundingBox, MNExtentStruct, MNRect;

typedef void (^DrawStyle)(CGContextRef);
typedef void (^StyleBlock)(CGContextRef);

/*! The `MNStem` gnerally is handled by its parent `StemmableNote`.

 */
@interface MNStem : MNModifier

#pragma mark - Properties
@property (assign, nonatomic) MNStemDirectionType stemDirection;
@property (assign, nonatomic) float extension;

@property (strong, nonatomic) DrawStyle drawStyle;

@property (assign, nonatomic) float x_begin;
@property (assign, nonatomic) float x_end;
@property (assign, nonatomic) float y_top;
@property (assign, nonatomic) float y_bottom;
@property (assign, nonatomic) float y_extend;
@property (assign, nonatomic) float stem_extension;

//@property (assign, nonatomic) MNStemDirectionType stem_direction;

@property (assign, nonatomic) BOOL hide;

@property (strong, nonatomic, readonly) MNExtentStruct* extents;

@property (assign, readonly, nonatomic) float height;

// TODO: make sure style applied when drawn
@property (nonatomic, copy) StyleBlock styleBlock;

#pragma mark - Methods
//- (instancetype)initWithRect:(MNRect*)rect
//                 withYExtend:(float)yExtend
//           withStemExtension:(float)stemExtension
//            andStemDirection:(MNStemDirectionType)stemDirection;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

- (void)applyStyle:(DrawStyle)drawStyle;

- (void)setNoteHeadXBoundsBegin:(float)x_begin andEnd:(float)x_end;
- (void)setYBoundsTop:(float)y_top andBottom:(float)y_bottom;
- (void)draw:(CGContextRef)ctx;

@end
