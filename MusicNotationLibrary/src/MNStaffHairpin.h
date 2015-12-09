//
//  MNStaffHairpin.h
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
#import "MNEnum.h"

@class MNFormatter, MNStaffNote;

/*!
 *  The `MNStaffHairpin` class implements hairpins between notes.
 *  Hairpins can be either Crescendo or Descrescendo.
 */
@interface MNStaffHairpin : MNModifier
{
   @private
    MNPositionType _position;
}

#pragma mark - Properties
@property (strong, nonatomic) NSArray* notes;
//@property (weak, nonatomic) MNStaff* staff;
@property (strong, nonatomic) MNStaffNote* first_note;
@property (strong, nonatomic) MNStaffNote* last_note;
@property (assign, nonatomic) MNStaffHairpinType hairpin;
@property (assign, nonatomic) MNPositionType position;

// render options
@property (assign, nonatomic) float height;
//@property (assign, nonatomic) float yShift;           // vertical offset
@property (assign, nonatomic) float left_shift_px;    // left horizontal offset
@property (assign, nonatomic) float right_shift_px;   // right horizontal offset
@property (assign, nonatomic) float vo;               // vertical offset
@property (assign, nonatomic) float left_ho;          // left horizontal offset
@property (assign, nonatomic) float right_ho;         // right horizontal offset

#pragma mark - Methods
- (instancetype)initWithNotes:(NSArray*)notes
                    withStaff:(MNStaff*)staff
                      andType:(MNStaffHairpinType)type
                      options:(NSDictionary*)optionsDict;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

+ (void)formatByTicksAndDraw:(CGContextRef)ctx
               withFormatter:(MNFormatter*)formatter
                    andNotes:(NSArray*)notes
                   withStaff:(MNStaff*)staff
                    withType:(MNStaffHairpinType)type
                   leftShift:(float)leftShiftTicks
                 righttShift:(float)righttShiftTicks
                      height:(float)height
                      yShift:(float)yShift;

//- (void)setPosition:(MNPositionType)position;

- (void)setRenderOptions:(NSDictionary*)renderOptions;

- (void)setRenderOptionsWithHeight:(float)height
                            yShift:(float)y_shift
                         leftShift:(float)left_shift_px
                        rightShift:(float)right_shift_px;
- (void)setNotes:(NSArray*)notes;

- (void)draw:(CGContextRef)ctx;

@end
