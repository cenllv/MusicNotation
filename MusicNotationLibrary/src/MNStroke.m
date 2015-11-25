//
//  MNStrokes.m
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

#import "MNStroke.h"
#import "MNUtils.h"
#import "MNFont.h"
#import "MNEnum.h"
#import "MNStaffNote.h"
#import "MNModifierContext.h"
#import "MNGlyph.h"
#import "MNKeyProperty.h"
#import "MNPoint.h"

@implementation MNStroke

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setValuesForKeyPathsWithDictionary:optionsDict];
        [self setupStrokesithDictionary:optionsDict];
    }
    return self;
}

+ (MNStroke*)strokeWithType:(MNStrokeType)type
{
    MNStroke* ret = [[MNStroke alloc] initWithDictionary:nil];
    ret.type = type;
    return ret;
}

+ (MNStroke*)strokeWithType:(MNStrokeType)type allVoices:(BOOL)allVoices
{
    MNStroke* ret = [[MNStroke alloc] initWithDictionary:nil];
    ret.type = type;
    ret.allVoices = allVoices;
    return ret;
}

- (void)setupStrokesithDictionary:(NSDictionary*)optionsDict
{
    /*
     // ## Prototype Methods
     Vex.Inherit(Stroke, Modifier, {
         init: function(type, options) {
         Stroke.superclass.init.call(this);

         self.note = nil;
         self.options = Vex.Merge({}, options);

         // multi voice - span stroke across all voices if YES
         self.all_voices = 'all_voices' in self.options ?
         self.options.all_voices : YES;

         // multi voice - end note of stroke, set in draw()
         self.note_end = nil;
         self.index = nil;
         self.type = type;
         self.position = Modifier.Position.LEFT;

         self.render_options = {
         font_scale: 38,
         stroke_px: 3,
         stroke_spacing: 10
         };

         self.font = {
         family: "serif",
         size: 10,
         weight: "bold italic"
         };

         self.setX_shift(0);
         self.setWidth(10);
     },
     */
    self.note = nil;
    //    self.options = Vex.Merge({}, options);

    // multi voice - span stroke across all voices if YES
    self.allVoices = [optionsDict.allKeys containsObject:@"all_voices"] ? [optionsDict[@"all_voices"] boolValue] : YES;

    // multi voice - end note of stroke, set in draw()
    self.noteEnd = nil;
    self.index = -999;   // nil;
                         //    self.type = type;
    self.position = MNPositionLeft;

    [self->_renderOptions setFontSize:38];   // = {font_scale : 38, stroke_px : 3, stroke_spacing : 10};

    //    self.font =  [MNFont fontWithName:@"serif" size:10 weight:@"bold italic"];

    self.xShift = 0;   // self.setX_shift(0);
    self.width = 10;   // self.setWidth(10);
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return @"strokes";
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"note_end" : @"noteEnd"}];
    return propertiesEntriesMapping;
}

/*!
 *  Arrange strokes inside `ModifierContext`
 *  @param modifiers <#modifiers description#>
 *  @param state     <#state description#>
 *  @param context   <#context description#>
 *  @return <#return value description#>
 */
+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray* strokes = modifiers;

    float left_shift = state.left_shift;
    float stroke_spacing = 0;

    if(!strokes || strokes.count == 0)
    {
        return YES;
    }

    NSMutableArray* str_list = [NSMutableArray array];
    NSUInteger i = 0;
    MNStroke* str = nil;
    float shift = 0;
    for(i = 0; i < strokes.count; ++i)
    {
        str = strokes[i];
        MNNote* note = str.note;
        MNKeyProperty* props;
        if([note isKindOfClass:[MNStaffNote class]])
        {
            props = note.keyProps[str.index];
            shift = (props.displaced ? note.extraLeftPx : 0);
            [str_list push:@{@"line" : @(props.line), @"shift" : @(shift), @"str" : str}];
        }
        else
        {
            // TODO: finish for tabnote
            //            props = note.getPositions()[str.getIndex()];
            //            [str_list push:@{@"line" : @(props.str), @"shift" : @(0), @"str" : str}];
        }
    }

    float str_shift = left_shift;
    float x_shift = 0.f;

    // There can only be one stroke .. if more than one, they overlay each other
    for(i = 0; i < str_list.count; ++i)
    {
        str = str_list[i][@"str"];
        shift = [str_list[i][@"shift"] floatValue];

        str.xShift = (str_shift + shift);
        x_shift = MAX(str.width + stroke_spacing, x_shift);
    }

    state.left_shift += x_shift;

    return YES;
}

/*
getPosition: function() { return self.position; },
addEndNote: function(note) { self.note_end = note; return this; },
 */

- (id)addEndNote:(MNNote*)note
{
    self.noteEnd = note;
    return self;
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    if(!(self.note && (self.index != -999)))
    {
        MNLogError("NoAttachedNote, Can't draw stroke without a note and index.");
    }
    if(![self.note isKindOfClass:[MNStaffNote class]])
    {
        MNLogError(@"StrokeNoteError, not yet ready for tabnotes.");
    }
    MNStaffNote* note = note;
    MNPoint* start = [self.note getModifierstartXYforPosition:self.position andIndex:self.index];
    NSArray* ys = self.note.ys;
    float topY = start.y;
    float botY = start.y;
    float x = start.x - 5.f;
    float line_space = self.note.staff.spacingBetweenLines;

    NSArray* notes = [self.modifierContext getModifiersForType:self.note.category];
    NSUInteger i;
    for(i = 0; i < notes.count; ++i)
    {
        ys = [notes[i] ys];
        for(NSUInteger n = 0; n < ys.count; ++n)
        {
            if(self.note == notes[i] || self.allVoices)
            {
                topY = MIN(topY, [ys[n] floatValue]);
                botY = MAX(botY, [ys[n] floatValue]);
            }
        }
    }

    NSString* arrow;
    float arrow_shift_x = 0;
    float arrow_y = 0;
    float text_shift_x = 0;
    float text_y = 0;
    switch(self.type)
    {
        case MNStrokeBrushDown:
        {
            arrow = @"vc3";
            arrow_shift_x = -3;
            arrow_y = topY - (line_space / 2) + 10;
            botY += (line_space / 2);
            break;
        }
        case MNStrokeBrushUp:
        {
            arrow = @"v11";
            arrow_shift_x = 0.5;
            arrow_y = botY + (line_space / 2);
            topY -= (line_space / 2);
            break;
        }
        case MNStrokeRollDown:
        case MNStrokeRasquedoDown:
        {
            arrow = @"vc3";
            arrow_shift_x = -3;
            text_shift_x = self.xShift + arrow_shift_x - 2;
            if([self.note isKindOfClass:[MNStaffNote class]])
            {
                topY += 1.5 * line_space;
                if(fmodf((botY - topY), 2) != 0.f)
                {
                    botY += 0.5 * line_space;
                }
                else
                {
                    botY += line_space;
                }
                arrow_y = topY - line_space;
                text_y = botY + line_space + 2;
            }
            else /* tabnote */
            {
                topY += 1.5 * line_space;
                botY += line_space;
                arrow_y = topY - 0.75 * line_space;
                text_y = botY + 0.25 * line_space;
            }
            break;
        }
        case MNStrokeRollUp:
        case MNStrokeRasquedoUp:
        {
            arrow = @"v52";
            arrow_shift_x = -4;
            text_shift_x = self.xShift + arrow_shift_x - 1;
            if([self.note isKindOfClass:[MNStaffNote class]])
            {
                arrow_y = line_space / 2;
                topY += 0.5 * line_space;
                if(fmodf((botY - topY), 2) == 0.f)
                {
                    botY += line_space / 2;
                }
                arrow_y = botY + 0.5 * line_space;
                text_y = topY - 1.25 * line_space;
            }
            else /* tabnote */
            {
                topY += 0.25 * line_space;
                botY += 0.5 * line_space;
                arrow_y = botY + 0.25 * line_space;
                text_y = topY - line_space;
            }
            break;
        }
    }

    // Draw the stroke
    if(self.type == MNStrokeBrushDown || self.type == MNStrokeBrushUp)
    {
        CGContextFillRect(ctx, CGRectMake(x + self.xShift, topY, 1, botY - topY));
    }
    else
    {
        if([self.note isKindOfClass:[MNStaffNote class]])
        {
            for(i = topY; i <= botY; i += line_space)
            {
                [MNGlyph renderGlyph:ctx
                                 atX:x + self.xShift - 4
                                 atY:i
                           withScale:1 /* self.render_options.font_scale */
                        forGlyphCode:@"va3"];
            }
        }
        else
        {
            for(i = topY; i <= botY; i += 10)
            {
                [MNGlyph renderGlyph:ctx
                                 atX:x + self.xShift - 4
                                 atY:i
                           withScale:1 /* self.render_options.font_scale */
                        forGlyphCode:@"va3"];
            }
            if(self.type == MNStrokeRasquedoDown)
                text_y = i + 0.25 * line_space;
        }
    }

    // Draw the arrow head
    [MNGlyph renderGlyph:ctx
                     atX:x + self.xShift + arrow_shift_x
                     atY:arrow_y
               withScale:1 /* self.render_options.font_scale */
            forGlyphCode:arrow];

    // Draw the rasquedo "R"
    if(self.type == MNStrokeRasquedoDown || self.type == MNStrokeRasquedoDown)
    {
        // TODO:  update the font    self.context.setFont(self.font.family, self.font.size, self.font.weight);
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = kCTTextAlignmentCenter;
        MNFont* font1 = [MNFont fontWithName:@"Helvetica" size:12];
        NSAttributedString* r = [[NSAttributedString alloc]
            initWithString:@"R"
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];
        [r drawAtPoint:CGPointMake(x + text_shift_x, text_y - r.size.height / 1.2)];
        MNLogInfo(@"Rendering stroke: %@ %f %f", @"R", x + text_shift_x, text_y);
    }
}
@end
