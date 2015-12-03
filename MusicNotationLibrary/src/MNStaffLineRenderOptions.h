//
//  StaffLineRenderOptions.h
//  MusicNotation
//
//  Created by Scott on 6/1/15.
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

#import "MNRenderOptions.h"
#import "MNEnum.h"
#import "MNColor.h"

/*!
 *  The `MNStaffLineRenderOptions` class
 */
@interface MNStaffLineRenderOptions : MNRenderOptions

@property (strong, nonatomic) NSArray* line_dash;
@property (strong, nonatomic) NSString* color;

@property (assign, nonatomic) BOOL lineDash;
@property (assign, nonatomic) float lineDashPhase;
@property (assign, nonatomic) NSArray* lineDashLengths;
@property (assign, nonatomic) NSUInteger lineDashCount;
@property (assign, nonatomic) float lineWidth;
@property (assign, nonatomic) CGLineCap lineCap;

@property (assign, nonatomic) float padding_left;
@property (assign, nonatomic) float padding_right;

@property (assign, nonatomic) BOOL draw_start_arrow;
@property (assign, nonatomic) BOOL draw_end_arrow;
@property (assign, nonatomic) float arrowhead_length;
@property (assign, nonatomic) float arrowhead_angle;
@property (assign, nonatomic) MNColor* fillColor;
@property (assign, nonatomic) MNColor* strokeColor;

@property (assign, nonatomic) MNStaffLineJustiticationType text_justification;
@property (assign, nonatomic) MNStaffLineVerticalJustifyType text_position_vertical;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end