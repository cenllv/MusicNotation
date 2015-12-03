//
//  MNTabStaff.h
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

#import "MNStaff.h"

/*!
 *  The `MNTabStaff` class is an implementation of the  MNStaff but for guitar tabs
 */
@interface MNTabStaff : MNStaff

#pragma mark - Properties

// defined in superclass
//@property (assign, nonatomic) float x;
//@property (assign, nonatomic) float y;
//@property (assign, nonatomic) float width;

#pragma mark - Methods//

//- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

+ (MNTabStaff*)staffWithRect:(CGRect)rect;
//+ (MNTabStaff*)tabStaffWithBoundingBox:(MNBoundingBox*)boundingBox;

//`````````````````````
// configuration

/*! set the number of lines (property setter)
 *  Note: might not be necessary to explicit declare, but useful for end-user
 *        TODO: read up on objective-c polymorphism
 */
- (void)setNumberOfLines:(float)numberOfLines;

/*! gets vertical points position for particular line
 */
- (float)getYForGlyphs;

/*! adds "TAB" vertical phrase to the Staff
 */
- (id)addTabGlyph;
@end
