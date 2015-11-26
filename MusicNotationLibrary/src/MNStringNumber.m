//
//  MNStringNumber.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Larry Kuhns
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

#import "MNStringNumber.h"
#import "MNUtils.h"
#import "MNNote.h"
#import "MNStemmableNote.h"
#import "MNStem.h"
#import "MNStaffNote.h"
#import "MNStaff.h"
#import "MNPoint.h"
#import "MNExtentStruct.h"
#import "MNKeyProperty.h"
#import "MNStringNumberFormatStruct.h"

@implementation MNStringNumber

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.note = nil;
        self.lastNote = nil;
        self.index = NSIntegerMax;         // indicates unset
        self.width = 20;                   // TODO: is this necessary
        self.position = MNPositionAbove;   // Default position above stem or note head
        self.xShift = 0;
        self.yShift = 0;
        self.xOffset = 0;   // Horizontal offset from default
        self.yOffset = 0;   // Vertical offset from default
        self.dashed = YES;
        self.leg = MNLineEndTypeNONE;
        self.radius = 8;
        //        self.font = [[MNFont fontWithName:@"sans-serif" size:10 weight:@"bold"];
    }
    return self;
}

- (instancetype)initWithNums:(NSArray*)nums
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        _nums = nums;
        [self setupStringNumber];
    }
    return self;
}

- (instancetype)initWithString:(NSString*)num
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.stringNumber = num;
    }
    return self;
}

- (void)setupStringNumber
{
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"stringnumber";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

/*
getNote: function() { return self.note; },
setNote: function(note) { self.note = note; return this; },
getIndex: function() { return self.index; },
setIndex: function(index) { self.index = index; return this; },
setLineEndType: function(leg) {
    if (leg >= Vex.Flow.Renderer.LineEndType.NONE &&
        leg <= Vex.Flow.Renderer.LineEndType.DOWN)
    self.leg = leg;
    return this;
},
getPosition: function() { return self.position; },
setPosition: function(position) {
    if (position >= Modifier.Position.LEFT &&
    position <= Modifier.Position.BELOW)
        self.position = position;
    return this;
},
setStringNumber: function(number) { self.string_number = number; return this; },
setOffsetX: function(x) { self.x_offset = x; return this; },
setOffsetY: function(y) { self.y_offset = y; return this; },
*/

- (id)setPosition:(MNPositionType)position
{
    if(position >= MNPositionLeft && position <= MNPositionBelow)
    {
        super.position = position;
    }
    return self;
}

- (id)setLineEndType:(MNLineEndType)leg
{
    if(leg >= MNLineEndTypeNONE && leg <= MNLineEndTypeDOWN)
    {
        _leg = leg;
    }
    return self;
}

- (MNStringNumber*)setOffsetX:(NSUInteger)x
{
    _x_offset = x;
    return self;
}

- (MNStringNumber*)setOffsetY:(NSUInteger)y
{
    _y_offset = y;
    return self;
}

- (id)setLastNote:(MNStaffNote*)lastNote
{
    _lastNote = lastNote;
    return self;
}

- (id)setDashed:(BOOL)dashed
{
    _dashed = dashed;
    return self;
}

#pragma mark - Methods

/*!
 *  Arrange string numbers inside a `ModifierContext`
 *  @param modifiers string modifiers
 *  @param state     modifier state
 *  @param context   modifier context
 *  @return success
 */
+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray* nums = modifiers;
    float left_shift = state.left_shift;
    float right_shift = state.right_shift;
    float num_spacing = 1;

    if(!nums || nums.count == 0)
        return YES;   // self;

    NSMutableArray* nums_list = [NSMutableArray array];
    MNStaffNote* prev_note = nil;
    float shift_left = 0;
    float shift_right = 0;

    MNStringNumber* num;
    MNStaffNote* note;
    MNPositionType pos;
    MNKeyProperty* props_tmp;
    for(NSUInteger i = 0; i < nums.count; ++i)
    {
        num = nums[i];
        if([num.note isKindOfClass:[MNStaffNote class]])
        {
            note = (MNStaffNote*)num.note;
        }

        for(NSUInteger j = 0; j < nums.count; ++j)
        {
            num = nums[j];

            num = nums[i];
            if([num.note isKindOfClass:[MNStaffNote class]])
            {
                note = (MNStaffNote*)num.note;
            }
            pos = num.position;
            //            NSArray* props = note.keyProps[num.index];
            if(note != prev_note)
            {
                for(NSUInteger n = 0; n < note.keyStrings.count; ++n)
                {
                    num = nums[i];
                    if([num.note isKindOfClass:[MNStaffNote class]])
                    {
                        note = (MNStaffNote*)num.note;
                    }
                    pos = num.position;
                    MNKeyProperty* props = note.keyProps[num.index];

                    if(note != prev_note)
                    {
                        for(NSUInteger m = 0; m < note.keyStrings.count; ++m)
                        {
                            props_tmp = note.keyProps[n];

                            if(left_shift == 0)
                                shift_left = (props_tmp.displaced ? note.extraLeftPx : shift_left);
                            if(right_shift == 0)
                                shift_right = (props_tmp.displaced ? note.extraRightPx : shift_right);
                        }
                        prev_note = note;
                    }
                    [nums_list push:[[MNStringNumberFormatStruct alloc] initWithDictionary:@{
                                   @"line" : @(props.line),
                                   @"pos" : @(pos),
                                   @"shiftL" : @(shift_left),
                                   @"shiftR" : @(shift_right),
                                   @"note" : note,
                                   @"num" : num,
                               }]];
                }
            }
        }
    }

    // Sort string numbers by line number.
    [nums_list sortedArrayUsingComparator:^NSComparisonResult(MNStringNumberFormatStruct* _Nonnull obj1,
                                                              MNStringNumberFormatStruct* _Nonnull obj2) {
      NSUInteger a = obj1.line;
      NSUInteger b = obj2.line;
      if(a < b)
      {
          return NSOrderedAscending;
      }
      else if(a > b)
      {
          return NSOrderedDescending;
      }
      else
      {
          return NSOrderedSame;
      }

    }];

    float num_shiftL = 0;
    float num_shiftR = 0;
    float x_widthL = 0;
    float x_widthR = 0;
    float last_line = NSIntegerMax;
    MNStaffNote* last_note = nil;

    for(NSUInteger i = 0; i < nums_list.count; ++i)
    {
        float num_shift = 0;
        MNStringNumberFormatStruct* snfStruct = nums_list[i];
        MNStaffNote* note = snfStruct.note;
        pos = snfStruct.pos;
        num = snfStruct.num;
        float line = snfStruct.line;
        float shiftL = snfStruct.shiftL;
        float shiftR = snfStruct.shiftR;

        // Reset the position of the string number every line.
        if(line != last_line || note != last_note)
        {
            num_shiftL = left_shift + shiftL;
            num_shiftR = right_shift + shiftR;
        }

        float num_width = num.width + num_spacing;

        if(pos == MNPositionLeft)
        {
            [num setXShift:left_shift];
            num_shift = shift_left + num_width;   // spacing
            x_widthL = (num_shift > x_widthL) ? num_shift : x_widthL;
        }
        else if(pos == MNPositionRight)
        {
            [num setXShift:num_shiftR];
            num_shift += num_width;   // spacing
            x_widthR = (num_shift > x_widthR) ? num_shift : x_widthR;
        }
        last_line = line;
        last_note = note;
    }

    state.left_shift += x_widthL;
    state.right_shift += x_widthR;

    return YES;
}

- (void)draw:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);

    [super draw:ctx];

    if(!(self.note && (!self.index)))
    {
        MNLogError(@"NoAttachedNote, Can't draw string number without a note and index.");
    }

    float line_space = self.note.staff.spacingBetweenLines;
    MNPoint* start = [self.note getModifierstartXYforPosition:self.position andIndex:self.index];
    float dot_x = (start.x + self.xShift + self.xOffset);
    float dot_y = start.y + self.yShift + self.yOffset;

    switch(self.position)
    {
        case MNPositionAbove:
        case MNPositionBelow:
        {
            MNExtentStruct* stem_ext = ((MNStemmableNote*)self.note).stemExtents;
            float top = stem_ext.topY;
            float bottom = stem_ext.baseY + 2;

            if(((MNStemmableNote*)self.note).stemDirection == MNStemDirectionDown)
            {
                top = stem_ext.baseY;
                bottom = stem_ext.topY - 2;
            }

            if(self.position == MNPositionAbove)
            {
                dot_y =
                    ((MNStemmableNote*)self.note).hasStem ? top - (line_space * 1.75) : start.y - (line_space * 1.75);
            }
            else
            {
                dot_y =
                    ((MNStemmableNote*)self.note).hasStem ? bottom + (line_space * 1.5) : start.y + (line_space * 1.75);
            }

            dot_y += self.yShift + self.yOffset;
        }
        break;
        case MNPositionLeft:
        {
            dot_x -= (self.radius / 2) + 5;
        }
        break;
        case MNPositionRight:
        {
            dot_x += (self.radius / 2) + 6;
        }
        break;
        case MNPositionCenter:
            MNLogError(@"Unhandled position exception");
            break;
    }

    /*
    ctx.arc(dot_x, dot_y, self.radius, 0, Math.PI * 2, false);
    ctx.lineWidth = 1.5;
    ctx.stroke();
     */
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, dot_x, dot_y, self.radius, 0, M_PI * 2, NO);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);

    /*
    ctx.setFont(self.font.family, self.font.size, self.font.weight);
    var x = dot_x - ctx.measureText(self.string_number).width / 2;
    ctx.fillText("" + self.string_number, x, dot_y + 4.5);
     */
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
    MNFont* font1 = [MNFont fontWithName:@"times" /*self.fontFamily*/ size:14];
    NSAttributedString* title = [[NSAttributedString alloc]
        initWithString:self.stringNumber
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];
    float x = dot_x - title.size.width / 2;
    [title drawAtPoint:CGPointMake(x, dot_y + 4.5 - title.size.height / 1.2)];

    if(_lastNote)
    {
        float end = _lastNote.stem.x - ((MNStemmableNote*)self.note).stem.x + 5;

        /*
        ctx.strokeStyle="#000000";
        ctx.lineCap = "round";
        ctx.lineWidth = 0.6;
        if (this.dashed)
          Vex.Flow.Renderer.drawDashedLine(ctx, dot_x + 10, dot_y, dot_x + end, dot_y, [3,3]);
        else
          Vex.Flow.Renderer.drawDashedLine(ctx, dot_x + 10, dot_y, dot_x + end, dot_y, [3,0]);
         */

        float len;
        CGFloat pattern[2];

        // TODO: this switch needs refactoring
        switch(self.leg)
        {
            case MNLineEndTypeUP:
            {
                len = -10;
                if(_dashed)
                {
                    pattern[0] = 3.f;
                    pattern[1] = 3.f;
                }
                else
                {
                    pattern[0] = 3.f;
                    pattern[1] = 0.f;
                }
                CGContextSetLineDash(ctx, 0, pattern, 1);
                CGContextBeginPath(ctx);
                CGContextMoveToPoint(ctx, dot_x + end, dot_y);
                CGContextAddLineToPoint(ctx, dot_x + end, dot_y + len);
                CGContextStrokePath(ctx);
            }
            break;
            case MNLineEndTypeDOWN:
            {
                len = 10;
                if(_dashed)
                {
                    pattern[0] = 3.f;
                    pattern[1] = 3.f;
                }
                else
                {
                    pattern[0] = 3.f;
                    pattern[1] = 0.f;
                }
                CGContextSetLineDash(ctx, 0, pattern, 1);
                CGContextBeginPath(ctx);
                CGContextMoveToPoint(ctx, dot_x + end, dot_y);
                CGContextAddLineToPoint(ctx, dot_x + end, dot_y + len);
                CGContextStrokePath(ctx);
            }
            break;
            case MNLineEndTypeNONE:
            default:
                MNLogError(@"Unexpected line end type");
                break;
        }
    }

    CGContextRestoreGState(ctx);
}

@end
