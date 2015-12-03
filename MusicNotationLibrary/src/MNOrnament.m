//
//  MNOrnament.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Cyril Silverman
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

#import "MNOrnament.h"
#import "MNUtils.h"
#import "MNTable.h"
#import "MNAccidental.h"
#import "MNStaffNote.h"
#import "MNTabNote.h"
#import "MNExtentStruct.h"
#import "MNMath.h"
#import "MNTickContext.h"
#import "MNGlyph.h"
#import "MNTableOrnamentCodes.h"
#import "MNPoint.h"

//@implementation State
//@end

//@interface MNOrnament (private)
//@property (strong, nonatomic) State *state;
//@end

@implementation MNOrnament
{
    float _width;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        /*
         self.note = null;
         self.index = null;
         self.type = type;
         self.position = Modifier.Position.ABOVE;
         self.delayed = NO;

         self.accidental_upper = "";
         self.accidental_lower = "";

         self.render_options = {
         font_scale: 38
         };

         self.ornament = Vex.Flow.ornamentCodes(self.type);
         if (!self.ornament) throw new Vex.RERR("ArgumentError",
         "Ornament not found: '" + self.type + "'");

         // Default width comes from ornament table.
         self.setWidth(self.ornament.width);
         */
        // TODO: complete this
        //    _note = nil;
        //    _index = -1;
        //    _position =  MNPositionAbove;
        //    _delayed = NO;
        //
        //    _accidental_upper = @"";
        //    _accidental_lower = @"";
        //
        //    _font_scale = 38;
        //             [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

// Create a new ornament of type `type`, which is an entry in
// `Vex.Flow.ornamentCodes` in `tables.js`.
// TODO: replace type with an enum type derived from  MNTaables orngmanetCodes dictionary keys
- (instancetype)initWithType:(NSString*)type
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        _type = type;
        NSDictionary* dict = MNTable.ornamentCodes[type];
        _ornament = [[MNOrnamentData alloc] initWithDictionary:dict];
        if(!_ornament)
        {
            MNLogError(@"ArgumentError %@ %@", @"Ornament not found: '%@'", _type);
        }
        _width = _ornament.width;
    }
    return self;
}

+ (MNOrnament*)ornamentWithType:(NSString*)type
{
    return [[MNOrnament alloc] initWithType:type];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

//+ (BOOL)format:(NSMutableArray *)ornaments state:(MNModifierState *)state; {
//    //+ (void)formatOrnaments:(NSArray *)ornaments state:(State *)state {
//    //    /*
//    //    if (!ornaments || ornaments.count === 0) return NO;
//    //
//    //    var text_line = state.text_line;
//    //    var max_width = 0;
//    //
//    //    // Format Articulations
//    //    var width;
//    //    for (var i = 0; i < ornaments.count; ++i) {
//    //        var ornament = ornaments[i];
//    //        ornament.setTextLine(text_line);
//    //        width = ornament.getWidth() > max_width ?
//    //        ornament.getWidth() : max_width;
//    //
//    //        var type = Vex.Flow.ornamentCodes(ornament.type);
//    //        if(type.between_lines)
//    //        text_line += 1;
//    //        else
//    //        text_line += 1.5;
//    //    }
//    //
//    //    state.left_shift += width / 2;
//    //    state.right_shift += width / 2;
//    //    state.text_line = text_line;
//    //    return YES;
//    //    */
//    //
//    //
//    ////    float width;
//    //    // Default width comes from ornament table.
//    //
//    //    //TODO: fix self.code
//    //    //self.code = nil; //" : @"v1e",
//    ////    state.shiftRight = [[_ornament objectForKey:@"shift_right"] floatValue];
//    ////    state.shiftUp = [[_ornament objectForKey:@"shift_up"] floatValue];
//    ////    state.shiftDown = [[_ornament objectForKey:@"shift_down"] floatValue];
//    ////    state.width = [[_ornament objectForKey:@"width"] floatValue];
//    //}
//    return YES;
//}

- (id)setDelayed:(BOOL)delayed
{
    _delayed = delayed;
    return self;
}

- (BOOL)delayed
{
    return _delayed;
}

- (id)setUpperAccidental:(NSString*)accidental
{
    _accidental_upper = accidental;
    return self;
}

- (id)setLowerAccidental:(NSString*)accidental
{
    _accidental_lower = accidental;
    return self;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"ornaments";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

static NSDictionary* _acc_mods;

+ (NSDictionary*)acc_mods
{
    if(!_acc_mods)
    {
        _acc_mods = @{
            @"n" : @{@"shift_x" : @(1), @"shift_y_upper" : @(0), @"shift_y_lower" : @(0), @"height" : @(17)},
            @"#" : @{@"shift_x" : @(0), @"shift_y_upper" : @(-2), @"shift_y_lower" : @(-2), @"height" : @(20)},
            @"b" : @{@"shift_x" : @(1), @"shift_y_upper" : @(0), @"shift_y_lower" : @(3), @"height" : @(18)},
            @"##" : @{
                @"shift_x" : @(0),
                @"shift_y_upper" : @(0),
                @"shift_y_lower" : @(0),
                @"height" : @(12),
            },
            @"bb" : @{@"shift_x" : @(0), @"shift_y_upper" : @(0), @"shift_y_lower" : @(4), @"height" : @(17)},
            @"db" : @{@"shift_x" : @(-3), @"shift_y_upper" : @(0), @"shift_y_lower" : @(4), @"height" : @(17)},
            @"bbs" : @{@"shift_x" : @(0), @"shift_y_upper" : @(0), @"shift_y_lower" : @(4), @"height" : @(17)},
            @"d" : @{@"shift_x" : @(0), @"shift_y_upper" : @(0), @"shift_y_lower" : @(0), @"height" : @(17)},
            @"++" : @{@"shift_x" : @(-2), @"shift_y_upper" : @(-6), @"shift_y_lower" : @(-3), @"height" : @(22)},
            @"+" : @{@"shift_x" : @(1), @"shift_y_upper" : @(-4), @"shift_y_lower" : @(-2), @"height" : @(20)}
        };
    }
    return _acc_mods;
}

- (float)shiftRight
{
    return self.state.right_shift;
}

/*!
 *  Arrange ornaments within a `ModifierContext`
 *  @param modifiers collection of `Modifier`
 *  @param state     state of the `ModifierContext`
 *  @param context   the calling `ModifierContext`
 *  @return YES if succussful
 */
+ (BOOL)format:(NSMutableArray<MNModifier*>*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray<MNOrnament*>* ornaments = (NSMutableArray<MNOrnament*>*)modifiers;
    if(!ornaments || ornaments.count == 0)
    {
        return NO;
    }

    float text_line = state.text_line;
    float max_width = 0;

    // format articulations
    float width = 0;
    for(int i = 0; i < ornaments.count; ++i)
    {
        MNOrnament* ornament = (MNOrnament*)ornaments[i];
        //[ornament setTextLine:text_line];
        ornament.text_line = text_line;
        width = ornament.width > max_width ? ornament.width : max_width;

        MNOrnamentData* type = ornament.ornament;   // [MNTable.ornamentCodes valueForKey:ornament.type];
        if(type.between_lines)
        {
            text_line += 1;
        }
        else
        {
            text_line += 1.5;
        }
    }

    state.left_shift += width / 2;
    state.right_shift += width / 2;
    state.text_line = text_line;

    return YES;
}

// Render ornament in position next to note.
- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    void (^drawAccidental)(CGContextRef, NSString*, BOOL, MNPoint*);

    //    self.graphicsContext = ctx;
    if(!(self.note && (self.index != -1)))
    {
        MNLogError(@"NoAttachedNote, Can't draw Ornament without a note and index.");
    }

    MNNote* note = self.note;
    if(![note isKindOfClass:[MNStaffNote class]])
    {
        MNLogError(@"NoStaffNote, expected a staffnote.");
        abort();
    }
    MNStemDirectionType stem_direction = ((MNStaffNote*)note).stemDirection;
    MNStaff* staff = note.staff;

    // Get stem extents
    MNExtentStruct* stem_ext = ((MNStaffNote*)note).stemExtents;
    float top; // , bottom;
    if(stem_direction == MNStemDirectionDown)
    {
        top = stem_ext.baseY;
        // bottom = stem_ext.topY;
    }
    else
    {
        top = stem_ext.topY;
        // bottom = stem_ext.baseY;
    }

    // TabNotes don't have stems attached to them. Tab stems are rendered
    // outside the staff.
    BOOL is_tabnote = [note.category isEqualToString:[MNTabNote CATEGORY]];
    if(is_tabnote)
    {
        if(note.hasStem)
        {
            if(stem_direction == MNStemDirectionUp)
            {
                // bottom = [staff getYForBottomTextWithLine:self.text_line - 2];
            }
            else if(stem_direction == MNStrokeDirectionDown)
            {
                top = [staff getYForTopTextWithLine:(self.text_line - 1.5)];
            }
        }
        else
        {   // Without a stem
            top = [staff getYForTopTextWithLine:(self.text_line - 1)];
            // bottom = [staff getYForBottomTextWithLine:(self.text_line - 2)];
        }
    }

    BOOL is_on_head = stem_direction == MNStemDirectionDown;
    float spacing = staff.spacingBetweenLines;
    float line_spacing = 1;

    // Beamed stems are longer than quarter note stems, adjust accordingly
    if(!is_on_head && ((MNStaffNote*)note).beam)
    {
        line_spacing += 0.5;
    }

    float total_spacing = spacing * (self.text_line + line_spacing);
    float glyph_y_between_lines = (top - 7) - total_spacing;

    // Get initial coordinates for the modifier position
    MNPoint* start =
        [self.note getModifierstartXYforPosition:self.position andIndex:self.index];   // (self.position, self.index);
    float glyph_x = start.x + self.shiftRight;
    __block float glyph_y = MIN([staff getYForTopTextWithLine:(self.text_line) - 3], glyph_y_between_lines);
    glyph_y += self.shiftUp + self.shift_y;

    // Ajdust x position if ornament is delayed
    if(self.delayed)
    {
        glyph_x += self.width;
        MNTickContext* next_context = [MNTickContext getNextContext:note.tickContext];
        if(next_context != nil)
        {
            glyph_x += (next_context.x - glyph_x) * 0.5;
        }
        else
        {
            glyph_x += (staff.x + staff.width - glyph_x) * 0.5;
        }
    }

    //    MNOrnament* ornament = self;
    drawAccidental = ^(CGContextRef ctx, NSString* code, BOOL upper, MNPoint* point) {
      MNAccidental* accidental = [[MNTable accidentalsDictionary] objectForKey:code];

      float acc_x = point.x - 3;
      float acc_y = point.y + 2;

      // Fine tune position of accidental glyph
      NSDictionary* mods = _acc_mods[code];
      if(mods)
      {
          acc_x += [mods[@"shift_x"] floatValue];
          acc_y += upper ? [mods[@"shift_y_upper"] floatValue] : [mods[@"shift_y_lower"] floatValue];
      }

      // Special adjustments for trill glyph
      if(upper)
      {
          float ht = [_acc_mods[@"height"] floatValue];
          acc_y -= mods ? ht : 18;
          acc_y += [self.type isEqualToString:@"tr"] ? -8 : 0;
      }
      else
      {
          acc_y += [self.type isEqualToString:@"tr"] ? -6 : 0;
      }

      // Render the glyph
      //      float scale = ornament.font_scale / 1.3;   // .render_options.font_scale / 1.3;
      MNPoint* pt = [MNPoint pointWithX:acc_x andY:acc_y];
      [MNGlyph renderGlyph:ctx atX:pt.x atY:pt.y withScale:1. / 1.3 /*scale*/ forGlyphCode:accidental.code];
      // renderGlyphWithContext:ctx atPoint:pt withScale:scale forCode:accidental.code];

      // If rendered a bottom accidental, increase the y value by the
      // accidental height so that the ornament's glyph is shifted up
      if(!upper)
      {
          glyph_y -= mods ? [mods[@"height"] floatValue] : 18;
      }
    };

    // Draw lower accidental for ornament
    if(self.accidental_lower)
    {
        MNPoint* pt = [MNPoint pointWithX:glyph_x andY:glyph_y];
        drawAccidental(ctx, self.accidental_lower, NO, pt);
    }

    [MNLog
        logDebug:[NSString stringWithFormat:@"Rendering ornament: %@ point:(%f, %f)", self.ornament, glyph_x, glyph_y]];

    MNPoint* pt = [MNPoint pointWithX:glyph_x andY:glyph_y];
    [MNGlyph renderGlyph:ctx atX:pt.x atY:pt.y withScale:1 /*self.font_scale*/ forGlyphCode:self.ornament.code];
    //    [self renderGlyphWithContext:ctx atPoint:pt withScale:self.font_scale forCode:ornament_code];

    // Draw upper accidental for ornament
    if(self.accidental_upper)
    {
        MNPoint* pt = [MNPoint pointWithX:glyph_x andY:glyph_y];
        drawAccidental(ctx, self.accidental_upper, YES, pt);
    }
}
@end
