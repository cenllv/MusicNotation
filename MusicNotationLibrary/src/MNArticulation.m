//
//  MNArticulation.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Larry Kuhns.
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

#import "MNArticulation.h"
#import "MNUtils.h"
#import "MNNote.h"
#import "MNStaffNote.h"
#import "MNStem.h"
#import "MNExtentStruct.h"
#import "MNGlyph.h"
#import "MNTable.h"
#import "MNPoint.h"

@implementation MNArticulation

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupArticulation];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        //        _index = nil;
        [self setupArticulation];
    }
    return self;
}

- (instancetype)initWithType:(MNArticulationType)articulationType
{
    self =
        [self initWithDictionary:MNTable.articulationsDictionary[[MNTable articulationCodeForType:articulationType]]];
    if(self)
    {
        _articulationType = articulationType;
        //        _articulationCode = [MNTables articulationCodeForType:articulationType];
        //        [self setupArticulation];
    }
    return self;
}

- (instancetype)initWithCode:(NSString*)code
{
    self = [self initWithDictionary:MNTable.articulationsDictionary[code]];
    if(self)
    {
        //        [self setupArticulation];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"shift_right" : @"shiftRight",
        @"shift_up" : @"shiftUp",
        @"shift_down" : @"shiftDown",
        @"between_lines" : @"betweenLines",
    }];
    return propertiesEntriesMapping;
}

- (void)setupArticulation
{
    /*
    Vex.Inherit(Articulation, Modifier, {

    init: function(type) {
        Articulation.superclass.init.call(self);

        self.note = null;
        self.index = null;
        self.type = type;
        self.position = Modifier.Position.BELOW;

        self.render_options = {
        font_scale: 38
        };

        self.articulation = Vex.Flow.articulationCodes(self.type);
        if (!self.articulation) throw new Vex.RERR("ArgumentError",
                                                   "Articulation not found: '" + self.type + "'");

        // Default width comes from articulation table.
        self.setWidth(self.articulation.width);
    },*/

    //    self.note = nil;
    ////    _index = NULL;
    //    _position =  MNPositionBelow;
    //    self.renderOptions.fontScale = 38;
    //    _articulationCode = [self class]articulationCodeForType:<#(MNArticulationType)#>
    _positionType = MNPositionBelow;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);   // @"articulations";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

+ (MNArticulation*)articulationWithOptionsDict:(NSDictionary*)optionsDict
{
    MNArticulation* ret = [[MNArticulation alloc] initWithDictionary:optionsDict];
    return ret;
}

// Create a new articulation of type `type`, which is an entry in
// `Vex.Flow.articulationCodes` in `tables.js`.
+ (MNArticulation*)articulationForType:(MNArticulationType)type
{
    MNArticulation* ret = [[MNArticulation alloc] initWithType:type];
    return ret;
}

- (NSString*)getArticulationCode
{
    return [[self class] articulationCodeForType:_articulationType];
}

- (void)setArticulationType:(MNArticulationType)articulationType
{
    _articulationType = articulationType;
}

- (id)setPosition:(MNPositionType)positionType
{
    _positionType = positionType;
    return self;
}

/*!
 *  Arrange articulations inside `ModifierContext`
 *  @param modifiers collection of `Modifier`
 *  @param state     state of the `ModifierContext`
 *  @param context   the calling `ModifierContext`
 *  @return YES if succussful
 */
+ (BOOL)format:(NSMutableArray<MNModifier*>*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray<MNArticulation*>* articulations = (NSMutableArray<MNArticulation*>*)modifiers;
    if(!articulations || articulations.count == 0)
    {
        return NO;
    }

    float text_line = state.text_line;
    float max_width = 0;

    // Format Articulations
    float width = 0;
    for(uint i = 0; i < articulations.count; ++i)
    {
        MNArticulation* articulation = articulations[i];
        [articulation setText_line:text_line];
        width = articulation.width > max_width ? articulation.width : max_width;

        NSDictionary* type = MNTable.articulationsDictionary[articulation.articulationCode];
        if([type[@"between_lines"] boolValue])
            text_line += 1;
        else
            text_line += 1.5;
    }

    state.left_shift += width / 2;
    state.right_shift += width / 2;
    state.text_line = text_line;

    return YES;
}

- (void)draw:(CGContextRef)ctx withStaff:(MNStaff*)staff withShiftX:(float)shiftX
{
    [super draw:ctx withStaff:staff withShiftX:shiftX];
}

/*!
 *  Render articulation in position next to note.
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    if(!self.note && (self.index == -1))
    {
        MNLogError(@"NoAttachedNote, Can't draw Articulation without a note and index.");
    }

    MNStemDirectionType stem_direction = [((MNStemmableNote*)self.note)stemDirection];
    MNStaff* staff = [self.note staff];

    BOOL is_on_head = ((self.position == MNPositionAbove && stem_direction == MNStemDirectionDown) ||
                       (self.position == MNPositionBelow && stem_direction == MNStemDirectionUp));

    BOOL (^needsLineAdjustment)(MNArticulation*, NSUInteger, float) =
        ^BOOL(MNArticulation* articulation, NSUInteger note_line, float line_spacing) {
          NSInteger offset_direction = (articulation.position == MNPositionAbove) ? 1 : -1;
          NSString* duration = ((MNStaffNote*)articulation.note).durationString;
          if(!is_on_head && [[MNTable durationToNumber:duration] floatValue] <= 1)
          {
              // Add stem length, unless it's on a whole note.
              note_line += offset_direction * 3.5;
          }

          NSUInteger articulation_line = note_line + (offset_direction * line_spacing);

          if(articulation_line >= 1 && articulation_line <= 5 && articulation_line % 1 == 0)
          {
              return YES;
          }

          return NO;
        };

    // Articulations are centered over/under the note head.
    MNPoint* start = [self.note getModifierstartXYforPosition:self.position andIndex:self.index];
    float glyph_y;   // = start.y;
    float shiftY = 0;
    float line_spacing = 1;
    float spacing = staff.spacingBetweenLines;
    BOOL is_tabnote = [[self.note category] isEqualToString:@"tabnotes"];
    MNExtentStruct* stem_ext = [[(MNStemmableNote*)self.note stem] extents];

    float top = stem_ext.topY;
    float bottom = stem_ext.baseY;

    if(stem_direction == MNStemDirectionDown)
    {
        top = stem_ext.baseY;
        bottom = stem_ext.topY;
    }

    // TabNotes don't have stems attached to them. Tab stems are rendered
    // outside the staff.
    if(is_tabnote)
    {
        if([self.note hasStem])
        {
            if(stem_direction == MNStemDirectionUp)
            {
                bottom = [staff getYForBottomTextWithLine:(self.text_line - 2)];
            }
            else if(stem_direction == MNStemDirectionDown)
            {
                top = [staff getYForTopTextWithLine:(self.text_line - 1.5)];
            }
        }
        else
        {   // Without a stem
            top = [staff getYForTopTextWithLine:(self.text_line - 1)];
            bottom = [staff getYForBottomTextWithLine:(self.text_line - 2)];
        }
    }

    BOOL is_above = (self.position == MNPositionAbove) ? YES : NO;
    float note_line = 0;
    if([self.note isKindOfClass:[MNStaffNote class]])
    {
        note_line = [(MNStaffNote*)self.note getLineNumber:is_above];
    }
    else
    {
        note_line = [self.note getLineNumber];
    }

    // Beamed stems are longer than quarter note stems.
    if(!is_on_head && [((MNStemmableNote*)self.note)beam])
        line_spacing += 0.5;

    // If articulation will overlap a line, reposition it.
    if(needsLineAdjustment(self, note_line, line_spacing))
        line_spacing += 0.5;

    float glyph_y_between_lines;
    if(self.position == MNPositionAbove)
    {
        shiftY = self.shiftUp;
        glyph_y_between_lines = (top - 7) - (spacing * (self.text_line + line_spacing));

        if(self.betweenLines)
            glyph_y = glyph_y_between_lines;
        else
            glyph_y = MIN([staff getYForTopTextWithLine:(self.text_line)] - 3, glyph_y_between_lines);
    }
    else
    {
        shiftY = self.shiftDown - 10;

        glyph_y_between_lines = bottom + 10 + spacing * (self.text_line + line_spacing);
        if(self.betweenLines)
            glyph_y = glyph_y_between_lines;
        else
            glyph_y = MAX([staff getYForBottomTextWithLine:(self.text_line)], glyph_y_between_lines);
    }

    float glyph_x = start.x + self.shiftRight;
    glyph_y += shiftY + self.yShift;

    [MNLog logInfo:[NSString
                       stringWithFormat:@"Rendering articulation: %tu %f %f", self.articulationType, glyph_x, glyph_y]];
    [MNGlyph renderGlyph:ctx
                     atX:glyph_x
                     atY:glyph_y
               withScale:1   //[self->_renderOptions glyphFontScale]
            forGlyphCode:self.code];
}

@end
