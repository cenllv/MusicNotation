//
//  MNDot.m
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
#import "MNDot.h"
#import "MNNote.h"
#import "MNStaff.h"
#import "MNStaffNote.h"
#import "MNTabNote.h"
#import "MNKeyProperty.h"
#import "MNMetrics.h"
#import "MNOptions.h"
#import "MNBezierPath.h"
#import "MNStemmableNote.h"
#import "MNModifierContext.h"
#import "MNTable.h"
#import "MNNoteHead.h"
#import "MNExtentStruct.h"
#import "MNGraceNote.h"

@interface DotStruct : NSObject
@property (strong, nonatomic) MNNote* note;
@property (assign, nonatomic) float line;
@property (assign, nonatomic) float shift;
@property (strong, nonatomic) MNDot* dot;
- (NSComparisonResult)compare:(DotStruct*)otherDot;
@end

@implementation DotStruct

- (instancetype)initWithLine:(float)line shift:(float)shift note:(MNNote*)note dot:(MNDot*)dot
{
    self = [super init];
    if(self)
    {
        self.line = line;
        self.shift = shift;
        self.note = note;
        self.dot = dot;
    }
    return self;
}

- (NSComparisonResult)compare:(DotStruct*)otherDot
{
    return self.line < otherDot.line;
}
@end

@interface MNDot ()
@property (strong, nonatomic) NSString* type;
@end

@implementation MNDot

+ (MNDot*)dotWithType:(NSString*)type
{
    MNDot* ret = [[MNDot alloc] init];
    ret.type = type;
    return ret;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        //        [self setupDot];
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupDot];
    }
    return self;
}

- (void)setupDot
{
    self.note = nil;
    //    self.index = -1;
    self.position = MNPositionRight;
    self.radius = 2;
    self.width = 5;
    self.dotShiftY = 0;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (id)setNote:(MNNote*)note
{
    _note = note;
    if([self.note.category isEqualToString:[MNGraceNote CATEGORY]])
    {
        self.radius *= 0.5;
        self.width = 3;
    }
    return self;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);   // return @"dots";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

// Arrange dots inside a ModifierContext.
+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray* dots = modifiers;
    float right_shift = state.right_shift;
    float dot_spacing = 1;

    if(dots == nil || dots.count == 0)
    {
        return NO;
    }

    MNDot* dot;
    MNNote* note;
    float shift = 0.0;
    DotStruct* dotStruct;

    NSMutableArray* dot_list = [NSMutableArray array];   // list of DotStruct

    for(int i = 0; i < dots.count; ++i)
    {
        MNDot* dot = [dots objectAtIndex:i];
        MNNote* note;
        if([dot.note isKindOfClass:[MNStaffNote class]])
        {
            note = (MNStaffNote*)dot.note;
        }
        else if([dot.note isKindOfClass:[MNTabNote class]])
        {
            // TODO: needs refactoring
             note = (MNTabNote*)dot.note;
        }
        else
        {
            MNLogError(@"dot note is not staff note");
            abort();
        }

        MNKeyProperty* prop;
        // Only StaffNote has .getKeyProps()
        if([note isKindOfClass:[MNStaffNote class]])
        {
            NSMutableArray* props;
            props = note.keyProps;
            prop = [props objectAtIndex:dot.index];
            shift = prop.displaced ? note.extraRightPx : 0;
        }
        else if([note isKindOfClass:[MNTabNote class]])
        {   // Else it's a TabNote
            prop = [[MNKeyProperty alloc] init];
            prop.line = 0.5;
            shift = 0;
        }

        dotStruct = [[DotStruct alloc] initWithLine:prop.line shift:shift note:note dot:dot];
        [dot_list addObject:dotStruct];
    }

    // Sort dots by line number.
    [dot_list sortUsingComparator:^NSComparisonResult(DotStruct* a, DotStruct* b) {
      //      return [obj1 compare:obj2];
      float al = a.line;
      float bl = b.line;
      if(al > bl)
      {
          return NSOrderedAscending;
      }
      else if(al < bl)
      {
          return NSOrderedDescending;
      }
      else
      {
          return NSOrderedSame;
      }

    }];

    float dot_shift = right_shift;
    float x_width = 0;
    float last_line = 0;
    MNNote* last_note;
    float prev_dotted_space = 0;
    float half_shiftY = 0;

    for(int i = 0; i < dot_list.count; ++i)
    {
        dotStruct = [dot_list objectAtIndex:i];
        dot = dotStruct.dot;
        note = dotStruct.note;
        shift = dotStruct.shift;
        float line = dotStruct.line;

        // Reset the position of the dot every line.
        if(line != last_line || note != last_note)
        {
            dot_shift = shift;
        }

        if(!note.isRest && line != last_line)
        {
            if(fabsf(fmodf(line, 1)) == 0.5)
            {
                // note is on a space, so no dot shift
                half_shiftY = 0;
            }
            else if(!note.isRest)
            {
                // note is on a line, so shift dot to space above the line
                half_shiftY = 0.5;
                if(last_note != nil && !last_note.isRest && last_line - line == 0.5)
                {
                    // previous note on a space, so shift dot to space below the line
                    half_shiftY = -0.5;
                }
                else if(line + half_shiftY == prev_dotted_space)
                {
                    // previous space is dotted, so shift dot to space below the line
                    half_shiftY = -0.5;
                }
            }
        }

        // convert half_shiftY to a multiplier for dots.draw()
        dot.dotShiftY += (-half_shiftY);
        prev_dotted_space = line + half_shiftY;

        dot.xShift = dot_shift;                 //.setX_shift(dot_shift);
        dot_shift += dot.width + dot_spacing;   // spacing
        x_width = (dot_shift > x_width) ? dot_shift : x_width;
        last_line = line;
        last_note = note;
    }

    // update state
    state.right_shift += x_width;

    return YES;
}

- (void)setDotShiftY:(float)dotShiftY
{
    _dotShiftY = dotShiftY;
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    if(self.note == nil || self.index == -1)
    {
        MNLogError(@"NoAttachedNote, Can't draw dot without a note and index.");
    }

    float line_space = self.note.staff.spacingBetweenLines;

    MNPoint* start = [self.note getModifierstartXYforPosition:self.position andIndex:self.index];

    if([self.note.category isEqualToString:[MNTabNote CATEGORY]])
    {
        start.y = ((MNStemmableNote*)self.note).stemExtents.baseY;
    }

    float dotX, dotY;

    //    float shift = [((MNNoteHead*)self.note.note_heads[0])headWidth] * 1.25;   // CHANGE

    dotX = (start.x + self.xShift) + self.width - self.radius;   // + shift;   // CHANGE
    dotY = start.y + self.yShift + (self.dotShiftY * line_space);

    //    MNBezierPath* bPath =  [MNBezierPath bezierPath];
    //    [bPath addArcWithCenter:CGPointMake(dot_x, dot_y) radius:self.radius startAngle:0 endAngle:kPI clockwise:NO];
    //    [bPath fill];

    CGContextSaveGState(ctx);
    //    CGContextSetFillColorWithColor(ctx, NSColor.blueColor.CGColor);
    CGContextMoveToPoint(ctx, dotX, dotY);
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, dotX, dotY, self.radius, 0, 2 * M_PI, NO);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextRestoreGState(ctx);
}
@end
