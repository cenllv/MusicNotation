//
//  MNStaffSection.h
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

#import "MNModifier.h"
#import "MNFont.h"

@class MNStaff;

/*! 
 *  The `MNStaffSection` class draws separation vertical lines between measures on the staff
 *  and also draws text.
 */
@interface MNStaffSection : MNModifier

#pragma mark - Properties
//@property (assign, nonatomic) NSUInteger width;
//@property (assign, nonatomic) float x;
@property (strong, nonatomic) NSString* section;
//@property (strong, nonatomic)  MNFont* font;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNStaffSection*)staffSectionWithSection:(NSString*)section withX:(float)x yShift:(float)yShift;
//- (instancetype)initWithSection:(NSString *)section withX:(NSUInteger)x yShift:(NSUInteger)yShift;

//- (void)draw:(CGContextRef)ctx withStaff:(MNStaff*)staff withShiftX:(float)shiftX;

@end
