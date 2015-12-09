//
//  MNStaffModifier.m
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

#import "MNUtils.h"
#import "MNStaffModifier.h"
#import "MNStaff.h"
#import "MNGlyph.h"
#import "MNGlyphMetrics.h"

@implementation MNStaffModifier

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        //        [((MNPadding*)[((Metrics*)self->_metrics)padding])padAllSidesBy:10];
        //        [((Metrics*)self->_metrics)setPoint:[MNPoint pointWithX:0 andY:0]];
        _padding = 5;   //
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"staffmodifier";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

- (NSMutableArray*)subModifiers
{
    if(!_subModifiers)
    {
        _subModifiers = [@[] mutableCopy];
    }
    return _subModifiers;
}

//- (id<MNModifierContextDelegate>) modifierContext {
//    return _modifierContext;
//
//}

#pragma mark - Configure
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Configuration
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (BOOL)preFormat
{
    return [super preFormat];
}

- (BOOL)postFormat
{
    BOOL ret = [super postFormat];
    //    for(MNSymbol* symbol in self.subModifiers)
    //    {
    //        ((Metrics*)symbol->_metrics).point.x += ((Metrics*)self->_metrics).point.x;
    //    }
    return ret;
}

#pragma mark - Methods
///*!
// *  creates a blank glyph that does not render anything except it takes up space
// *  @param padding amount of space the blank glyph occupies
// *  @return a blank glyph
// */
//- (MNGlyph*)makeSpacer:(float)padding
//{
//     MNGlyph* ret = [[MNGlyph alloc] init];
//    ret.metrics.width = padding;
////    ret.metrics.bounds =
////        [MNBoundingBox boundingBoxAtX:0
////                                  atY:0
////                            withWidth:padding
////                            andHeight:50];   //  NOTE: the height is arbitrary, perhaps there's a better way
//    return ret;
//}

/*!
 *  places a glyph on the staff at the given line
 *  @param glyph the glyph to add to the staff
 *  @param staff the staff to add the glyph to
 *  @param line  the line on the staff to place the glyph on
 */
- (void)placeGlyphOnLine:(MNGlyph*)glyph forStaff:(MNStaff*)staff onLine:(float)line
{
    glyph.y_shift = [staff getYForLine:line] - [staff getYForGlyphs];
}

/*!
 *  sets the overall padding for all staff modifiers
 *  @param padding the amount of padding
 */
- (void)setPadding:(float)padding
{
    _padding = padding;
}

/*!
 *  add this modifier to the given staff
 *  @param staff the staff to add this modifier to
 */
- (void)addToStaff:(MNStaff*)staff
{
    [self addToStaff:staff firstGlyph:NO];
}

/*!
 *  add this modifier to the given staff
 *  @param staff      the staff to add this modifier to
 *  @param firstGlyph if this is the first glyph
 *  @return this object
 */
- (id)addToStaff:(MNStaff*)staff firstGlyph:(BOOL)firstGlyph
{
    if(firstGlyph)
    {
        [staff addGlyph:[self makeSpacer:self.padding]];
    }
    [self addModifierToStaff:staff];
    return self;
}

/*!
 *  add this modifier to the end of the given staff
 *  @param staff      the staff to add this modifier to
 *  @param firstGlyph if this is the first glyph
 */
- (void)addToStaffEnd:(MNStaff*)staff firstGlyph:(BOOL)firstGlyph
{
    if(firstGlyph)
    {
        [staff addEndGlyph:[self makeSpacer:self.padding]];
    }
    //    else
    //    {
    //        [staff addEndGlyph:[self makeSpacer:2]];
    //    }
    [self addEndModifierToStaff:staff];
}

/*!
 *  creates a blank glyph that does not render anything except it takes up space
 *  @param padding amount of space the blank glyph occupies
 *  @return a blank glyph
 */
- (MNGlyph*)makeSpacer:(float)padding
{
    MNGlyph* ret = [[MNGlyph alloc] init];
    ret.metrics.width = padding;
    //    ret.metrics.bounds =
    //        [MNBoundingBox boundingBoxAtX:0
    //                                  atY:0
    //                            withWidth:padding
    //                            andHeight:50];
    //  NOTE: the height is arbitrary, perhaps there's a better way
    ret.drawBlock = ^(CGContextRef context, MNStaff* staff, float x, float y) {
    };
    return ret;
}

/*!
 *  abstract method for allowing a staffmodifier subclass to add glyphs to start of a staff
 *  @param staff a staff object
 */
- (void)addModifierToStaff:(MNStaff*)staff
{
    MNLogError(@"MethodNotImplemented, addModifier() not implemented for this stave modifier.");
}

/*!
 *  abstract method for allowing a staffmodifier subclass to add glyphs to end of a staff
 *  @param staff a staff object
 */
- (void)addEndModifierToStaff:(MNStaff*)staff
{
    MNLogError(@"MethodNotImplemented, addModifier() not implemented for this stave modifier.");
}

/*!
 *  draw this modifier
 *  @param ctx   the core graphics opaque type drawing environment
 *  @param staff the staff to draw to
 */
- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff withShiftX:(float)shiftX
{
    [super draw:ctx];
}

- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff
{
    [super draw:ctx];
}

@end
