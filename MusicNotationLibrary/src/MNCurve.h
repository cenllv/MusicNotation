//
//  MNCurve.h
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

/*! The `MNCurve` class implements curves (for slurs)
 
 */
@interface MNCurve : MNModifier
#pragma mark - Properties

@property (assign, nonatomic) float spacing;
@property (assign, nonatomic) float thickness;
//@property (assign, nonatomic) float x_shift;
//@property (assign, nonatomic) float y_shift;
@property (strong, nonatomic) MNStaffNote* fromNote;
@property (strong, nonatomic) MNStaffNote* toNote;
@property (assign, nonatomic) MNCurveType position;
@property (assign, nonatomic) MNCurveType positionEnd;
@property (assign, nonatomic) BOOL invert;
@property (assign, nonatomic, readonly) BOOL isPartial;
@property (strong, nonatomic) NSArray* cps;   // array of mnpoint

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

/*!
 *  generate a curve object
 *  @param fromNote start note
 *  @param toNote   end note
 *  @return a curve object
 */
+ (MNCurve*)curveFromNote:(MNNote*)fromNote toNote:(MNNote*)toNote;

+ (MNCurve*)curveFromNote:(MNNote*)fromNote toNote:(MNNote*)toNote withDictionary:(NSDictionary*)optionsDict;

/*!
 *  set the notes to render this curve
 *  @param fromNote start note
 *  @param toNote   end note
 *  @return this object
 */
- (id)setNotesFrom:(MNStaffNote*)fromNote toNote:(MNStaffNote*)toNote;

@end
