//
//  MNStaffBarLine.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Larry Kuhns 2011
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

#import "MNBezierPath.h"
#import "MNStaffBarLine.h"
#import "MNStaffModifier.h"
#import "MNUtils.h"
#import "MNStaff.h"
#import "MNPoint.h"
#import "MNPadding.h"
#import "MNStaffLineRenderOptions.h"
#import "MNTable.h"
#import "MNConstants.h"

@interface MNStaffBarLine ()
{
    MNBarNoteType _type;
    BOOL _doubleBar;
}
@property (assign, nonatomic) BOOL doubleBar;
@property (assign, nonatomic) float thickness;
@end

@implementation MNStaffBarLine

#pragma mark - Initialize

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        //        [self setupStaffBarLine];
    }
    return self;
}

- (instancetype)initWithType:(MNBarLineType)type AtX:(float)x
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        //        [self setupStaffBarLine];
        _barLinetype = type;
        //        [self point];
        //        _point =  [MNPoint pointZero];
        self.point.x = x;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setupStaffBarLine];
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (void)setupStaffBarLine
{
    _doubleBar = NO;
    self.preFormatted = YES;
    //    [((Metrics*)self->_metrics)setPadding:[MNPadding paddingZero]];
    self->_renderOptions = [[MNStaffLineRenderOptions alloc] init];
    self.thickness = kSTAFF_LINE_THICKNESS;
}

+ (MNStaffBarLine*)barLineWithType:(MNBarLineType)type atX:(float)x
{
    return [[MNStaffBarLine alloc] initWithType:type AtX:x];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Methods

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"barlines";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

- (void)setX:(float)x
{
    self.point.x = x;
}

//@synthesize staff = _staff;
//- (void)setStaff:(MNStaff*)staff {
//    _staff = staff;
//}

#pragma mark - Draw
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Draw
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (void)draw:(CGContextRef)ctx
{
    MNLogError(@"StaffBarLineError, do not call draw.");
}

/*!
 *  draw this modifier
 *  @param ctx   the core graphics opaque type drawing environment
 *  @param staff the staff to draw to
 */
- (void)drawWithContext:(CGContextRef)ctx toStaff:(MNStaff*)staff withShiftX:(float)shiftX
{
    [super drawWithContext:ctx toStaff:staff withShiftX:(float)shiftX];

    if(!self.staff)
    {
        // unlikely to ever not have a context.
        MNLogError(@"NoStaffError, Can't draw bar line without a staff.");
    }

    // draw barlines
    switch(self.barLinetype)
    {
        case MNBarLineSingle:
            _doubleBar = NO;
            [self drawVerticalBar:ctx withShiftX:self.point.x];
            break;
        case MNBarLineDouble:
            _doubleBar = YES;
            [self drawVerticalBar:ctx withShiftX:self.point.x];
            break;
        case MNBarLineEnd:
            [self drawVertialEndBar:ctx withShiftX:self.point.x];
            break;
        case MNBarLineRepeatBegin:
            if(shiftX > 0)
            {
                [self drawVerticalBar:ctx withShiftX:self.point.x];
            }
            [self drawRepeatBar:ctx withShiftX:self.point.x + shiftX begin:YES];
            break;
        case MNBarLineRepeatEnd:
            [self drawRepeatBar:ctx withShiftX:self.point.x begin:NO];
            break;
        case MNBarLineRepeatBoth:
            [self drawRepeatBar:ctx withShiftX:self.point.x begin:NO];
            [self drawRepeatBar:ctx withShiftX:self.point.x begin:YES];
            break;
        case MNBarLineNone:
            break;
        default:
            MNLogError(@"DrawBarLineWarning, tried to draw a bar line with unknown value: %li", self.barLinetype);
            break;
    }
}

- (void)drawVerticalBar:(CGContextRef)ctx withShiftX:(float)x
{
    //    float x = self.point.x;
    float topLine = [self.staff getYForLine:0];
    float bottomLine = [self.staff getYForLine:self.staff.options.numLines - 1] + self.thickness;
    MNBezierPath* path;
    if(self.doubleBar)
    {
        path = (MNBezierPath*)[MNBezierPath bezierPathWithRect:CGRectMake(x - 3, topLine, 1, bottomLine - topLine + 1)];
        //[path stroke];
        [path fill];
    }
    path = (MNBezierPath*)[MNBezierPath bezierPathWithRect:CGRectMake(x, topLine, 1, bottomLine - topLine + 1)];
    //[path stroke];
    [path fill];
}

- (void)drawVertialEndBar:(CGContextRef)ctx withShiftX:(float)x
{
    float topLine = [self.staff getYForLine:0];
    float bottomLine = [self.staff getYForLine:self.staff.options.numLines - 1] + self.thickness;
    MNBezierPath* path =
        (MNBezierPath*)[MNBezierPath bezierPathWithRect:CGRectMake(x - 5, topLine, 1, bottomLine - topLine + 1)];
    //    [path stroke];
    [path fill];
    path = (MNBezierPath*)[MNBezierPath bezierPathWithRect:CGRectMake(x - 2, topLine, 3, bottomLine - topLine + 1)];
    //    [path stroke];
    [path fill];
}

- (void)drawRepeatBar:(CGContextRef)ctx withShiftX:(float)x begin:(BOOL)begin
{
    float xShift = 3;
    float topY = [self.staff getYForLine:0];
    float botY = [self.staff getYForLine:self.staff.options.numLines - 1] + self.thickness;

    if(!begin)
    {
        xShift = -5;
    }

    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextAddRect(ctx, CGRectMake(x + xShift, topY, 1, botY - topY));
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
    CGContextBeginPath(ctx);
    CGContextAddRect(ctx, CGRectMake(x - 2, topY, 3, botY - topY));
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
    CGContextRestoreGState(ctx);

    float dotRadius = 2;

    // shift dots left or right
    if(begin)
    {
        xShift += 4;
    }
    else
    {
        xShift -= 5;   // CHANGE 4 -> 5
    }

    float dotX = (x + xShift) + (dotRadius / 2);

    // calculate the y offset based on number of staff lines
    float yOffset = (self.staff.options.numLines - 1) * self.staff.options.pointsBetweenLines;
    yOffset = (yOffset / 2) - (self.staff.options.pointsBetweenLines / 2);

    //    float dotY = topY - yOffset + (dotRadius / 2);
    float dotY = [self.staff getYForLine:1.5];

    // draw the top repeat dot
    CGContextSaveGState(ctx);
    CGContextMoveToPoint(ctx, dotX, dotY);
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, dotX, dotY, dotRadius, 0, 2 * M_PI, NO);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFill);

    dotY = [self.staff getYForLine:2.5];

    // draw the bottom repeat dot
    CGContextMoveToPoint(ctx, dotX, dotY);
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, dotX, dotY, dotRadius, 0, 2 * M_PI, NO);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
    CGContextRestoreGState(ctx);
}

@end
