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
// #import "MNLog.h"
#import "MNPoint.h"
#import "MNStaffNote.h"
#import "MNExtentStruct.h"
#import "NSMutableDictionary+MNAdditions.h"

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
        _cps = @[ MNPointMake(0, 10), MNPointMake(0, 10) ];
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

/*!
 *  generate a curve object
 *  @param fromNote start note
 *  @param toNote   end note
 *  @return a curve object
 */
+ (nonnull MNCurve*)curveFromNote:(nonnull MNNote*)fromNote toNote:(nonnull MNNote*)toNote
{
    MNCurve* ret = [[MNCurve alloc] initWithDictionary:@{ @"fromNote" : fromNote, @"toNote" : toNote }];
    return ret;
}

+ (MNCurve*)curveFromNote:(nonnull MNNote*)fromNote
                   toNote:(nonnull MNNote*)toNote
           withDictionary:(NSDictionary*)optionsDict
{
    if(!fromNote || !toNote)
    {
        MNLogError(@"NilNotesException, need a valid fromNote and a valid toNote");
        abort();
    }
    NSDictionary* tmp_dict = @{ @"fromNote" : fromNote, @"toNote" : toNote };

    MNCurve* ret = [[MNCurve alloc] initWithDictionary:[NSMutableDictionary merge:tmp_dict with:optionsDict]];
    return ret;
}

#pragma marke - IAModelBase

- (NSMutableDictionary*)classesForArrayEntries
{
    NSMutableDictionary* classesForArrayEntries = [super classesForArrayEntries];
    [classesForArrayEntries addEntriesFromDictionaryWithoutReplacing:@{ @"cps" : NSStringFromClass([MNPoint class]) }];
    return classesForArrayEntries;
}

- (void)setValuesForKeyPathsWithDictionary:(NSDictionary*)keyedValues
{
    for(NSString* key_keyPath in keyedValues.allKeys)
    {
        id object = [keyedValues objectForKey:key_keyPath];
        if([key_keyPath isEqualToString:@"fromNote"])
        {
            self.fromNote = object;
            continue;
        }
        if([key_keyPath isEqualToString:@"toNote"])
        {
            self.toNote = object;
            continue;
        }
        [self setValue:object forKeyPath:key_keyPath];
    }
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"x_shift" : @"xShift",
        @"y_shift" : @"yShift",
        @"position_end" : @"positionEnd",
    }];
    return propertiesEntriesMapping;
}

/*!
 *  set the notes to render this curve
 *  @param fromNote start note
 *  @param toNote   end note
 *  @return this object
 */
- (id)setNotesFrom:(MNNote*)fromNote toNote:(MNNote*)toNote
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
 *  is a partial bar?
 *  @return YES if this is a partial bar.
 */
- (BOOL)isPartial
{
    return (!self.fromNote || !self.toNote);
}

/*!
 *  actually renders the curve
 *  @param ctx            the core graphics opaque type drawing environment
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

    MNPoint* cp0 = cps[0];
    MNPoint* cp1 = cps[1];

    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, first_x, first_y);

    CGContextAddCurveToPoint(ctx, first_x + cp_spacing + cp0.x, first_y + (cp0.y * direction),
                             last_x - cp_spacing + cp1.x, last_y + (cp1.y * direction), last_x, last_y);
    CGContextAddCurveToPoint(ctx, last_x - cp_spacing + cp1.x, last_y + ((cp1.y + thickness) * direction),
                             first_x + cp_spacing + cp0.x, first_y + ((cp0.y + thickness) * direction), first_x,
                             first_y);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);

    CGContextAddArc(ctx, first_x, first_y, 10, 0, 2 * M_PI, YES);
    CGContextAddArc(ctx, last_x, last_y, 10, 0, 2 * M_PI, YES);

    CGContextRestoreGState(ctx);

    // [self bezierRenderDebug:ctx points:@[ firstPoint, self.cps[0], self.cps[1], lastPoint]];
    if(_debugMode)
    {
        [self bezierRenderDebug:ctx
                         points:@[
                             firstPoint,
                             MNPointMake(first_x + cp_spacing + cp0.x, first_y + (cp0.y * direction)),
                             MNPointMake(last_x - cp_spacing + cp1.x, last_y + (cp1.y * direction)),
                             lastPoint
                         ]];
    }
}

static BOOL _debugMode = NO;

/*!
 *  Draw debug control points
 *  @param mode YES for debuge or NO for release
 */
+ (void)setDebug:(BOOL)mode
{
    _debugMode = mode;
}

/*!
 *  Render debug points and lines
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)bezierRenderDebug:(CGContextRef)ctx points:(NSArray<MNPoint*>*)points
{
    float radius = 6;
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, MNColor.redColor.CGColor);
    CGContextBeginPath(ctx);
    for(MNPoint* pt in @[
            points[0],
            points[3],
        ])
    {
        CGContextAddArc(ctx, pt.x, pt.y, radius, 0, 2 * M_PI, YES);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }

    //    NSArray<MNPoint*>* pts2 = self.cps;
    CGContextSetFillColorWithColor(ctx, MNColor.blueColor.CGColor);
    CGContextBeginPath(ctx);
    for(MNPoint* pt in @[
            points[1],
            points[2],
        ])
    {
        CGContextAddArc(ctx, pt.x, pt.y, radius, 0, 2 * M_PI, YES);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }

    //    NSArray<MNPoint*>* pts3 = points;
    CGContextMoveToPoint(ctx, points[0].x, points[0].y);
    CGContextSetLineWidth(ctx, 2);
    for(MNPoint* pt in points)
    {
        CGContextAddLineToPoint(ctx, pt.x, pt.y);
    }
    //    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);

    CGContextRestoreGState(ctx);
}

/*!
 *  Draw the curve
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    if(![self.fromNote isKindOfClass:[MNStaffNote class]] || ![self.toNote isKindOfClass:[MNStaffNote class]])
    {
        MNLogError(@"MNCurve prepared only for `MNStaffNote`s");
    }

    MNStaffNote* first_note = (MNStaffNote*)self.fromNote;
    MNStaffNote* last_note = (MNStaffNote*)self.toNote;

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
        first_y = [[first_note.stemExtents valueForKey:metric] floatValue];
    }
    else
    {
        first_x = last_note.staff.tieStartX;
        first_y = [[last_note.stemExtents valueForKey:metric] floatValue];
    }

    if(last_note)
    {
        last_x = last_note.tieLeftX;
        stem_direction = last_note.stemDirection;
        last_y = [[last_note.stemExtents valueForKey:end_metric] floatValue];
    }
    else
    {
        last_x = first_note.staff.tieEndX;
        last_y = [[first_note.stemExtents valueForKey:end_metric] floatValue];
    }
    float direction = ((float)stem_direction) * (self.invert ? -1.f : 1.f);
    [self renderCurve:ctx
        fromFirstPoint:MNPointMake(first_x, first_y)
           toLastPoint:MNPointMake(last_x, last_y)
             direction:direction];
}

@end
