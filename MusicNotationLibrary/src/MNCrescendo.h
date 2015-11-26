//
//  MNCrescendo.h
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



#import "MNNote.h"

/*! The `MNCrescendo` implements the `Crescendo` object which draws crescendos and
      decrescendo dynamics markings. A `Crescendo` is initialized with a
      duration and formatted as part of a `Voice` like any other `MNNote`
      type. This object would most likely be formatted in a Voice
      with `TextNotes` - which are used to represent other dynamics markings.
 */
@interface MNCrescendo : MNNote

#pragma mark - Properties
@property (assign, nonatomic) BOOL decrescendo;
@property (assign, nonatomic) float height;

// Extensions to the length of the crescendo on either side
//@property (assign, nonatomic) float extend_left;
//@property (assign, nonatomic) float extend_right;
// Vertical shift
//@property (assign, nonatomic) float y_shift;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
//- (instancetype)init;
- (instancetype)initWithNote:(MNNote*)note;

- (void)setHeight:(float)height;

- (void)setDescrescendo:(BOOL)decres;

//- (void)preFormat;

- (void)draw:(CGContextRef)ctx;

@end
