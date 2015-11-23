//
//  MNStaffHairpin.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Raffaele Viglianti, 2012 http://itisnotsound.wordpress.com/
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

#import "MNStaffHairpin.h"
#import "MNUtils.h"
#import "MNRenderOptions.h"
#import "MNFormatter.h"
#import "MNStaffNote.h"
#import "MNPoint.h"

@implementation MNStaffHairpin

/*
 **
 * Notes is a struct that has:
 *
 *  {
 *    first_note: Note,
 *    last_note: Note,
 *  }
 */

/*!
 * Create a new hairpin from the specified notes.
 *
 * @constructor
 * @param {!Object} notes The notes to tie up.
 * @param {!Object} type The type of hairpin
 */
- (instancetype)initWithNotes:(NSArray*)notes
                    withStaff:(MNStaff*)staff
                      andType:(MNStaffHairpinType)type
                      options:(NSDictionary*)optionsDict;
{
    self = [self initWithDictionary:optionsDict];
    if(self)
    {
        _staff = staff;
        _notes = notes;
        _hairpin = type;

        [self setupStaffHairpin];
        [self setNotes:_notes];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setupStaffHairpin];
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (void)setupStaffHairpin
{
    self.position = MNPositionBelow;
    //    self.graphicsContext = nil;
    self.height = 10;
    self.yShift = 0;
    self.left_shift_px = 0;
    self.right_shift_px = 0;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionary:@{
        @"height" : @"height",
        @"y_shift" : @"yShift",
        @"left_shift_px" : @"left_shift_px",
        @"right_shift_px" : @"right_shift_px",
        @"vo" : @"vo",
        @"left_ho" : @"left_ho",
        @"right_ho" : @"right_ho",
    }];
    return propertiesEntriesMapping;
}

/*! Helper function to convert ticks into pixels.
 * Requires a Formatter with voices joined and formatted (to
 * get pixels per tick)
 *
 * options is struct that has:
 *
 *  {
 *   height: px,
 *   y_shift: px, //vertical offset
 *   left_shift_ticks: 0, //left horizontal offset expressed in ticks
 *   right_shift_ticks: 0 // right horizontal offset expressed in ticks
 *  }
 *
 **/
+ (void)formatByTicksAndDraw:(CGContextRef)ctx
               withFormatter:(MNFormatter*)formatter
                    andNotes:(NSArray*)notes
                   withStaff:(MNStaff*)staff
                    withType:(MNStaffHairpinType)type
                   leftShift:(float)leftShiftTicks
                 righttShift:(float)righttShiftTicks
                      height:(float)height
                      yShift:(float)yShift;
{
    float ppt = formatter.pixelsPerTick;

    if(ppt == -1)
    {
        [MNLog logError:@"BadArguments, A valid Formatter must be provide to draw offsets by ticks."];
    }

    float l_shift_px = ppt * leftShiftTicks;
    float r_shift_px = ppt * righttShiftTicks;

    MNStaffHairpin* staffHairPin =
        [[MNStaffHairpin alloc] initWithNotes:notes withStaff:staff andType:type options:nil];
    [staffHairPin setRenderOptionsWithHeight:height yShift:yShift leftShift:l_shift_px rightShift:r_shift_px];
    //    [staffHairPin setPosition:position];
    [staffHairPin draw:ctx];
}

//- (void)setContext:(CGContextRef)ctx
//{
//    self.graphicsContext = ctx;
//}

- (void)setPosition:(MNPositionType)position
{
    if(position == MNPositionAbove || position == MNPositionBelow)
    {
        _position = position;
    }
}

- (void)setRenderOptions:(NSDictionary*)renderOptions;
{
    if(renderOptions[@"height"])
    {
        self.height = [renderOptions[@"height"] floatValue];
    }
    if(renderOptions[@"y_shift"])
    {
        self.yShift = [renderOptions[@"y_shift"] floatValue];
    }
    if(renderOptions[@"left_shift_px"])
    {
        self.left_shift_px = [renderOptions[@"left_shift_px"] floatValue];
    }
    if(renderOptions[@"right_shift_px"])
    {
        self.right_shift_px = [renderOptions[@"right_shift_px"] floatValue];
    }
}

- (void)setRenderOptionsWithHeight:(float)height
                            yShift:(float)y_shift
                         leftShift:(float)left_shift_px
                        rightShift:(float)right_shift_px
{
    self.height = height;
    self.yShift = y_shift;
    self.left_shift_px = left_shift_px;
    self.right_shift_px = right_shift_px;

    // NOTE: this function broke RenderOptions out put directly into class
}

/*
 * Set the notes to attach this hairpin to.
 *
 * @param {!Object} notes The start and end notes.
 *
 */
- (void)setNotes:(NSArray*)notes
{
    if([notes firstObject] == nil && [notes lastObject] == nil)
    {
        [MNLog logError:@"BadArguments, Hairpin needs to have either first_note or last_note set."];
    }

    // Success. Lets grab 'em notes.
    self.first_note = [notes firstObject];
    self.last_note = [notes lastObject];
}

- (void)renderHairpin:(CGContextRef)ctx
               firstX:(float)first_x
                lastX:(float)last_x
               firstY:(float)first_y
                lastY:(float)last_y
          staffHeight:(float)staff_height
{
    float dis = self.yShift + 50;
    float y_shift = first_y;

    if(self.position == MNPositionAbove)
    {
        dis = -dis + 60;
        y_shift = first_y - staff_height;
    }

    float l_shift = self.left_shift_px;
    float r_shift = self.right_shift_px;

    switch(self.hairpin)
    {
        case MNStaffHairpinCres:
        {
            CGContextMoveToPoint(ctx, last_x + r_shift, y_shift + dis);
            CGContextAddLineToPoint(ctx, first_x + l_shift, y_shift + self.height / 2 + dis);
            CGContextAddLineToPoint(ctx, last_x + r_shift, y_shift + self.height + dis);
        }
        break;
        case MNStaffHairpinDescres:
        {
            CGContextMoveToPoint(ctx, first_x + l_shift, y_shift + dis);
            CGContextAddLineToPoint(ctx, last_x + r_shift, y_shift + self.height / 2 + dis);
            CGContextAddLineToPoint(ctx, first_x + l_shift, y_shift + self.height + dis);
        }
        break;

        default:
            // Default is NONE, so nothing to draw
            break;
    }
    CGContextStrokePath(ctx);
}

- (void)draw:(CGContextRef)ctx;
{
    [super draw:ctx];

    MNStaffNote* first_note = self.first_note;
    MNStaffNote* last_note = self.last_note;

    MNPoint* start = [first_note getModifierstartXYforPosition:self.position andIndex:0];
    MNPoint* end = [last_note getModifierstartXYforPosition:self.position andIndex:0];

    float staff_height = self.staff.height;
    float first_x = start.x;
    float last_x = end.x;
    float first_y = first_note.staff.y + first_note.staff.height;
    float last_y = last_note.staff.y + last_note.staff.height;

    [self renderHairpin:ctx firstX:first_x lastX:last_x firstY:first_y lastY:last_y staffHeight:staff_height];
}

@end
