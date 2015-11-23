//
//  MNFretHandFinger.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Larry Kuhns 2013
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

#import "MNFretHandFinger.h"
#import "MNFont.h"
#import "MNLog.h"
#import "MNStaffNote.h"
#import "MNText.h"
#import "NSMutableArray+MNAdditions.h"
#import "MNStaffNote.h"
#import "MNKeyProperty.h"
#import "MNFretHandFingerNumStruct.h"

@implementation MNFretHandFinger

- (instancetype)initWithFingerNumber:(NSString*)fingerNumber
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.finger = fingerNumber;
        [self setupFretHandFinger];
    }
    return self;
}

- (instancetype)initWithFingerNumber:(NSString*)fingerNumber andPosition:(MNPositionType)position
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.finger = fingerNumber;
        self.position = position;
        [self setupFretHandFinger];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupFretHandFinger];
    }
    return self;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return @"frethandfingers";
}

- (void)setupFretHandFinger
{
    self->_note = nil;
    self.index = -1;
    self.width = 7;
    self.position = MNPositionLeft;   // Default position above stem or note head
    self.xShift = 0;
    self.yShift = 0;
    _x_offset = 0;   // Horizontal offset from default
    _y_offset = 0;   // Vertical offset from default
    self.font = [MNFont fontWithName:@"sans-serif" size:9 weight:@"bold"];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context;
{
    NSMutableArray* nums = modifiers;
    float left_shift = state.left_shift;
    float right_shift = state.right_shift;
    NSUInteger num_spacing = 1;

    if(!nums || nums.count == 0)
    {
        return NO;
    }

    NSMutableArray* nums_list = [NSMutableArray array];
    MNStaffNote* prev_note = nil;
    float shift_left = 0;
    float shift_right = 0;

    MNFretHandFinger* num;
    MNStaffNote* note;
    MNPositionType pos;
    MNKeyProperty* props_tmp;
    MNKeyProperty* props;
    for(NSUInteger i = 0; i < nums.count; ++i)
    {
        num = nums[i];
        note = (MNStaffNote*)num.note;
        pos = num.position;
        props = note.keyProps[num.index];
        if(note != prev_note)
        {
            for(NSUInteger n = 0; n < note.keyStrings.count; ++n)
            {
                props_tmp = note.keyProps[n];
                if(left_shift == 0)
                    shift_left = (props_tmp.displaced ? note.extraLeftPx : shift_left);
                if(right_shift == 0)
                    shift_right = (props_tmp.displaced ? note.extraRightPx : shift_right);
            }
            prev_note = note;
        }

        [nums_list push:[[MNFretHandFingerNumStruct alloc] initWithDictionary:@{
                       @"line" : @(props.line),
                       @"pos" : @(pos),
                       @"shiftL" : @(shift_left),
                       @"shiftR" : @(shift_right),
                       @"note" : note,
                       @"num" : num
                   }]];
    }

    [nums_list sortUsingComparator:^NSComparisonResult(MNFretHandFingerNumStruct* _Nonnull obj1,
                                                       MNFretHandFingerNumStruct* _Nonnull obj2) {
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
    float last_line = NSUIntegerMax;
    MNStaffNote* last_note = nil;

    for(NSUInteger i = 0; i < nums_list.count; ++i)
    {
        float num_shift = 0;
        MNFretHandFingerNumStruct* num_i = nums_list[i];
        MNStaffNote* note = num_i.note;
        MNPositionType pos = num_i.pos;
        MNFretHandFinger* num = num_i.num;
        float line = num_i.line;
        float shiftL = num_i.shiftL;
        float shiftR = num_i.shiftR;

        // Reset the position of the string number every line.
        if(line != last_line || note != last_note)
        {
            num_shiftL = left_shift + shiftL;
            num_shiftR = right_shift + shiftR;
        }

        float num_width = num.width + num_spacing;
        if(pos == MNPositionLeft)
        {
            [num setXShift:(left_shift + num_shiftL)];
            num_shift = left_shift + num_width;   // spacing
            x_widthL = (num_shift > x_widthL) ? num_shift : x_widthL;
        }
        else if(pos == MNPositionRight)
        {
            [num setXShift:num_shiftR];
            num_shift = shift_right + num_width;   // spacing
            x_widthR = (num_shift > x_widthR) ? num_shift : x_widthR;
        }
        last_line = line;
        last_note = note;
    }

    state.left_shift += x_widthL;
    state.right_shift += x_widthR;

    return YES;
}

/*

    getNote: function() { return self.note; },
    setNote: function(note) { self.note = note; return this; },
    getIndex: function() { return self.index; },
    setIndex: function(index) { self.index = index; return this; },
    getPosition: function() { return self.position; },
    setPosition: function(position) {
        if (position >= Modifier.Position.LEFT &&
            position <= Modifier.Position.BELOW)
        self.position = position;
        return this;
    },
    setFretHandFinger: function(number) { self.finger = number; return this; },
    setOffsetX: function(x) { self.x_offset = x; return this; },
    setOffsetY: function(y) { self.y_offset = y; return this; },
 */

- (id)setOffsetY:(float)y
{
    _y_offset = y;
    return self;
}

- (id)setPosition:(MNPositionType)position
{
    if(position >= MNPositionLeft && position <= MNPositionBelow)
    {
        super.position = position;
    }
    return self;
}

- (void)draw:(CGContextRef)ctx;
{
    [super draw:ctx];

    if(!(self->_note && (self.index != -1)))
    {
        MNLogError(@"NoAttachedNote, Can't draw string number without a note and index.");
    }

    MNPoint* start = [self->_note getModifierstartXYforPosition:self.position andIndex:self.index];
    float dot_x = (start.x + self.xShift + _x_offset);
    float dot_y = start.y + self.yShift + _y_offset + 5;

    MNPositionType position = self.position;
    switch(position)
    {
        case MNPositionAbove:
            dot_x -= 4;
            dot_y -= 12;
            break;
        case MNPositionBelow:
            dot_x -= 2;
            dot_y += 10;
            break;
        case MNPositionLeft:
            dot_x -= self.width;
            break;
        case MNPositionRight:
            dot_x += 1;
            break;
        case MNPositionCenter:
        default:
            break;
    }

    MNFont* descriptionFont = [MNFont fontWithName:@"ArialMT" size:12];

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    NSAttributedString* description;

    description = [[NSAttributedString alloc] initWithString:self.finger
                                                  attributes:@{
                                                      NSParagraphStyleAttributeName : paragraphStyle,
                                                      NSFontAttributeName : descriptionFont,
                                                      NSForegroundColorAttributeName : MNColor.blackColor
                                                  }];
    [description drawAtPoint:CGPointMake(dot_x, dot_y)];
}

@end
