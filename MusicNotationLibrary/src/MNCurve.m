//
//  MNCurve.m
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

#import "MNCurve.h"
#import "MNLog.h"
#import "MNPoint.h"
#import "MNMacros.h"
#import "MNStaffNote.h"
#import "MNExtentStruct.h"

@implementation MNCurve

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        _spacing = 2;
        _thickness = 2;
        _xShift = 0;
        _yShift = 10;
        _position = MNCurveNearHead;
        _invert = NO;
        _cps = @[ MNPointMake(0, 10), MNPointMake(0, 10) ];   // control points
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

/*!
 *  generate a curve object
 *  @param fromNote start note
 *  @param toNote   end note
 *  @return a curve object
 */
+ (MNCurve*)curveFromNote:(MNNote*)fromNote toNote:(MNNote*)toNote
{
    MNCurve* ret = [[MNCurve alloc] initWithDictionary:@{@"fromNote" : fromNote, @"toNote" : toNote}];
    return ret;
}

+ (MNCurve*)curveFromNote:(MNNote*)fromNote toNote:(MNNote*)toNote withDictionary:(NSDictionary*)optionsDict
{
    MNCurve* ret = [[MNCurve alloc] initWithDictionary:@{@"fromNote" : fromNote, @"toNote" : toNote}];
    //    [ret setValuesForKeyPathsWithDictionary:optionsDict];
    return ret;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*!
 *  set the notes to render this curve
 *  @param fromNote start note
 *  @param toNote   end note
 *  @return this object
 */
- (id)setNotesFrom:(MNStaffNote*)fromNote toNote:(MNStaffNote*)toNote
{
    if(!fromNote && !toNote)
    {
        MNLogError(@"BadArguments, Curve needs to have either first_note or last_note set.");
    }
    self.fromNote = fromNote;
    self.toNote = toNote;
    return self;
}

/*!
 *  Returns YES if this is a partial bar.
 *  @return YES if this is a partial bar.
 */
- (BOOL)isPartial
{
    return (!self.fromNote || !self.toNote);
}

/*!
 *  actually renders the curve
 *  @param ctx            the graphics context
 *  @param firstPoint     the starting point
 *  @param lastPoint      the ending point
 *  @param curveDirection up or down
 */
- (void)renderCurve:(CGContextRef)ctx
     fromFirstPoint:(MNPoint*)firstPoint
        toLastPoint:(MNPoint*)lastPoint
          direction:(float)curveDirection

{
    float direction = curveDirection;

    NSArray* cps = self.cps;

    float x_shift = self.xShift;
    float y_shift = self.yShift * direction;

    float first_x = firstPoint.x + x_shift;
    float first_y = firstPoint.y + y_shift;
    float last_x = lastPoint.x - x_shift;
    float last_y = lastPoint.y + y_shift;
    float thickness = self.thickness;

    float cp_spacing = (last_x - first_x) / (cps.count + 2);

    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, first_x, first_y);
    MNPoint* cp0 = cps[0];
    MNPoint* cp1 = cps[1];
    CGContextAddCurveToPoint(ctx, first_x + cp_spacing + cp0.x, first_y + (cp0.y * direction),
                             last_x - cp_spacing + cp1.x, last_y + (cp1.y * direction), last_x, last_y);
    CGContextAddCurveToPoint(ctx, last_x - cp_spacing + cp1.x, last_y + ((cp1.y + thickness) * direction),
                             first_x + cp_spacing + cp0.x, first_y + ((cp0.y + thickness) * direction), first_x,
                             first_y);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextRestoreGState(ctx);
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];
    MNStaffNote* first_note = self.fromNote;
    MNStaffNote* last_note = self.toNote;
    float first_x, last_x, first_y, last_y;
    MNStemDirectionType stem_direction = 0;

    NSString* metric = @"baseY";
    NSString* end_metric = @"baseY";
    MNCurveType position = self.position;
    MNCurveType position_end = self.positionEnd;

    if(position == MNCurveNearTop)
    {
        metric = @"topY";
        end_metric = @"topY";
    }

    if(position_end == MNCurveNearHead)
    {
        end_metric = @"baseY";
    }
    else if(position_end == MNCurveNearTop)
    {
        end_metric = @"topY";
    }

    if(first_note)
    {
        first_x = first_note.tieRightX;
        stem_direction = first_note.stemDirection;
        first_y = [[first_note.stemExtents valueForKey:metric] floatValue];   // .getStemExtents()[metric];
    }
    else
    {
        first_x = last_note.staff.tieStartX;                                 // .getStave().getTieStartX();
        first_y = [[last_note.stemExtents valueForKey:metric] floatValue];   // getStemExtents()[metric];
    }

    if(last_note)
    {
        last_x = last_note.tieLeftX;                                            // getTieLeftX();
        stem_direction = last_note.stemDirection;                               // getStemDirection();
        last_y = [[last_note.stemExtents valueForKey:end_metric] floatValue];   // getStemExtents()[end_metric];
    }
    else
    {
        last_x = first_note.staff.tieEndX;                                       // getStave().getTieEndX();
        last_y = [[first_note.stemExtents valueForKey:end_metric] floatValue];   // getStemExtents()[end_metric];
    }
    float direction = stem_direction * (self.invert ? -1.f : 1.f);
    [self renderCurve:ctx
        fromFirstPoint:MNPointMake(first_x, first_y)
           toLastPoint:MNPointMake(last_x, last_y)
             direction:direction];
}

@end
