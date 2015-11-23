//
//  MNStaffModifier.h
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
#import "MNSymbol.h"
#import "MNNote.h"
#import "MNRenderOptions.h"

@class MNMetrics, MNOptions, MNStaff, MNGlyph, MNColor;

/*! The `MNStaffModifier` class
 */
@interface MNStaffModifier : MNModifier
{
   @public
    //    NSMutableArray* _list;
    //    NSMutableDictionary* _map;
    //    NSInteger _resolutionMultiplier;
    //    float _width;
    //    id<MNModifierContextDelegate> _modifierContext;
    //    __weak MNStaff* _staff;
}

#pragma mark - Properties

@property (strong, nonatomic) MNRational* measure;
@property (strong, nonatomic) MNRational* beat;

@property (strong, nonatomic) MNColor* strokeColor;
@property (strong, nonatomic) MNColor* fillColor;

@property (strong, nonatomic) NSMutableArray* subModifiers;

@property (assign, nonatomic) float padding;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

/*!
 *  creates a blank glyph that does not render anything except it takes up space
 *  @param padding amount of space the blank glyph occupies
 *  @return a blank glyph
 */
- (MNGlyph*)makeSpacer:(float)padding;

/*!
 *  places a glyph on the staff at the given line
 *  @param glyph the glyph to add to the staff
 *  @param staff the staff to add the glyph to
 *  @param line  the line on the staff to place the glyph on
 */
- (void)placeGlyphOnLine:(MNGlyph*)glyph forStaff:(MNStaff*)staff onLine:(float)line;

/*!
 *  sets the overall padding for all staff modifiers
 *  @param padding the amount of padding
 */
- (void)setPadding:(float)padding;

/*!
 *  add this modifier to the given staff
 *  @param staff the staff to add this modifier to
 */
- (void)addToStaff:(MNStaff*)staff;

/*!
 *  add this modifier to the given staff
 *  @param staff      the staff to add this modifier to
 *  @param firstGlyph if this is the first glyph
 *  @return this object
 */
- (id)addToStaff:(MNStaff*)staff firstGlyph:(BOOL)firstGlyph;

/*!
 *  add this modifier to the end of the given staff
 *  @param staff      the staff to add this modifier to
 *  @param firstGlyph if this is the first glyph
 */
- (void)addToStaffEnd:(MNStaff*)staff firstGlyph:(BOOL)firstGlyph;

/*!
 *  abstract method for allowing a staffmodifier subclass to add glyphs to start of a staff
 *  @param staff a staff object
 */
- (void)addModifierToStaff:(MNStaff*)staff;

/*!
 *  abstract method for allowing a staffmodifier subclass to add glyphs to end of a staff
 *  @param staff a staff object
 */
- (void)addEndModifierToStaff:(MNStaff*)staff;

/*!
 *  draw this modifier
 *  @param ctx   graphics context
 *  @param staff the staff to draw to
 */
- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff withShiftX:(float)shiftX;

- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff;

@end
