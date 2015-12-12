//
//  MNBeam.m
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

#import "MNBeam.h"
#import "MNTabNote.h"
#import "MNStem.h"
#import "MNRational.h"
#import "MNTable.h"
#import "MNKeyProperty.h"
#import "MNOptions.h"
#import "MNGlyph.h"
#import "MNVoice.h"
#import "MNTickable.h"
#import "MNExtentStruct.h"
#import "NSString+Ruby.h"
#import "MNTuplet.h"
#import "MNBeamConfig.h"
#import "MNConstants.h"
#import "MNMacros.h"
#import "MNStaffNote.h"
#import "NSString+MNAdditions.h"

@interface MNBeamLine : IAModelBase
// TODO: is this data type a float or nsuiniteger
@property (assign, nonatomic) float start;
@property (assign, nonatomic) float end;
+ (MNBeamLine*)lineWithStart:(float)start end:(float)end;
@end
@implementation MNBeamLine
+ (MNBeamLine*)lineWithStart:(float)start end:(float)end
{
    MNBeamLine* ret = [[MNBeamLine alloc] init];
    ret.start = start;
    ret.end = end;
    return ret;
}
@end

@interface MNBeamPartial : IAModelBase
@property (assign, nonatomic) BOOL left;
@property (assign, nonatomic) BOOL right;
+ (MNBeamPartial*)partialWithLeft:(BOOL)left right:(BOOL)right;
@end
@implementation MNBeamPartial
+ (MNBeamPartial*)partialWithLeft:(BOOL)left right:(BOOL)right
{
    MNBeamPartial* ret = [[MNBeamPartial alloc] init];
    ret.left = left;
    ret.right = right;
    return ret;
}
@end

#pragma mark -  MNBeam Implementation
/*!---------------------------------------------------------------------------------------------------------------------
 * @name  MNBeam Implementation
 * ---------------------------------------------------------------------------------------------------------------------
 */

@interface MNBeam ()
{
    //    BOOL _preFormatted;
    //    BOOL _postFormatted;

    // re-declare ivar from superclass MNSymbol
    MNBeamRenderOptions* _renderOptions;
}
@property (assign, nonatomic) float slope;
@property (strong, nonatomic) NSArray<NSNumber*>* break_on_indices;
@end

@implementation MNBeam

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        //        [self setupBeam];
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}
- (instancetype)initWithNotes:(NSArray<MNStemmableNote*>*)notes
{
    self = [self initWithNotes:notes autoStem:NO];
    if(self)
    {
        [self setupBeam];
    }
    return self;
}
- (instancetype)initWithNotes:(NSArray<MNStemmableNote*>*)notes autoStem:(BOOL)autoStem
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        _notes = notes;
        _autoStem = autoStem;
        [self setupBeam];
    }
    return self;
}

+ (MNBeam*)beamWithNotes:(NSArray<MNStemmableNote*>*)notes
{
    return [[MNBeam alloc] initWithNotes:notes autoStem:NO];
}

+ (MNBeam*)beamWithNotes:(NSArray<MNStemmableNote*>*)notes autoStem:(BOOL)autoStem
{
    return [[MNBeam alloc] initWithNotes:notes autoStem:autoStem];
}

- (void)setupBeam
{
    if(!_notes || _notes.count == 0)
    {
        MNLogError(@"BadArguments, No notes provided for beam.");
    }
    if(_notes.count == 1)
    {
        MNLogError(@"BadArguments, Too few notes for beam.");
    }
    // Validate beam line, direction and ticks.
    if(self.intrinsicTicks >= [MNTable durationToTicks:@"4"])
    {
        MNLogError(@"BadArguments , Beams can only be applied to notes shorter than a quarter note.");
    }

    _stemDirection = MNStemDirectionUp;

    for(MNStemmableNote* note in _notes)
    {
        if(note.hasStem)
        {
            _stemDirection = note.stemDirection;
            break;
        }
    }

    MNStemDirectionType stem_direction = _stemDirection;
    // Figure out optimal stem direction based on given notes
    if(_autoStem && [_notes[0] isKindOfClass:[MNStaffNote class]])
    {
        stem_direction = [MNBeam calculateStemDirection:_notes];
    }
    else if(_autoStem && [_notes[0] isKindOfClass:[MNTabNote class]])
    {
        // Auto Stem TabNotes
        //        float stem_weight = [[_notes oct_reduce:^NSNumber*(NSNumber* memo, MNStemmableNote* note) {
        //            if (!memo) {
        //                memo = @(0);
        //            }
        //          return [NSNumber numberWithFloat:([memo floatValue] + note.stemDirection)];
        //        }] floatValue];
        float stem_weight = 0;
        for(MNTabNote* note in _notes)
        {
            stem_weight += note.stemDirection;
        }
        stem_direction = stem_weight > -1 ? MNStemDirectionUp : MNStemDirectionDown;
    }

    // Apply stem directions and attach beam to notes
    for(MNStemmableNote* note in _notes)
    {
        if(_autoStem)
        {
            [note setStemDirection:stem_direction];
            _stemDirection = stem_direction;
        }
        note.beam = self;
    }
    _postFormatted = NO;
    //    _notes = notes; //already set in init
    _beamCount = [self getBeamCount];
    _break_on_indices = [NSMutableArray array];
    MNBeamRenderOptions* renderOptions = [[MNBeamRenderOptions alloc] initWithDictionary:@{}];
    renderOptions.beam_width = 5.0;   // 0.5;
    renderOptions.max_slope = 0.25;
    renderOptions.min_slope = -0.25;
    renderOptions.slope_iterations = 20;
    renderOptions.slope_cost = 100;
    renderOptions.show_stemlets = NO;
    renderOptions.stemlet_extension = 7;
    renderOptions.partial_beam_length = 10;
    self.renderOptions = renderOptions;

    _slope = 0;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"beam_width" : @"beamWidth",
        @"partial_beam_length" : @"partialBeamLength",

    }];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

/*!
 *  Get the max number of beams in the set of notes
 *  @return a count of possible beams
 */
- (NSUInteger)getBeamCount
{
    NSArray<NSNumber*>* beamCounts = [self.notes oct_map:^NSNumber*(MNNote* note) {
      return [NSNumber numberWithUnsignedInteger:note.glyphStruct.beamCount];
    }];
    NSUInteger maxBeamCount = [[beamCounts oct_reduce:^NSNumber*(NSNumber* max, NSNumber* beamCount) {
      return [beamCount unsignedIntegerValue] > [max unsignedIntegerValue] ? beamCount : max;
    }] unsignedIntegerValue];
    return maxBeamCount;
}

/*!
 *  Set which note `indices` to break the secondary beam at
 *  @param indices which beams brean on
 *  @return this object
 */
- (id)breakSecondaryAt:(NSArray*)indices
{
    self.break_on_indices = indices;
    return self;
}

/*!
 *  Return the y coordinate for linear function
 *  @param x          variable x coordinate
 *  @param first_x_px first x coordinade
 *  @param first_y_px first y coordinade
 *  @param slope      rise over run, slope m
 *  @return the y coordinate for the given x and other variables
 */
- (float)getSlopeYForX:(float)x first_x_px:(float)first_x_px first_y_px:(float)first_y_px slope:(float)slope
{
    return first_y_px + ((x - first_x_px) * slope);
}

/*!
 *  Calculate the best possible slope for the provided notes
 */
- (void)calculateSlope
{
    MNStemmableNote* first_note = self.notes[0];
    float first_y_px = first_note.stemExtents.topY;
    float first_x_px = first_note.stemX;

    float inc = (self.renderOptions.max_slope - self.renderOptions.min_slope) / self.renderOptions.slope_iterations;
    float min_cost = FLT_MAX;
    float best_slope = 0;
    float y_shift = 0;

    // iterate through slope values to find best weighted fit
    for(float slope = self.renderOptions.min_slope; slope <= self.renderOptions.max_slope; slope += inc)
    {
        float total_stem_extension = 0;
        float y_shift_tmp = 0;

        // iterate through notes, calculating y shift and stem extension
        for(NSUInteger i = 1; i < self.notes.count; ++i)
        {
            MNStemmableNote* note = self.notes[i];

            float x_px = note.stemX;
            float y_px = note.stemExtents.topY;
            float slope_y_px =
                [self getSlopeYForX:x_px first_x_px:first_x_px first_y_px:first_y_px slope:slope] + y_shift_tmp;

            // beam needs to be shifted up to accommodate note
            if(y_px * ((float)self.stemDirection) < slope_y_px * ((float)self.stemDirection))
            {
                float diff = fabsf(y_px - slope_y_px);
                if(self.stemDirection == MNStemDirectionNone)
                {
                    MNLogError(@"CalculateSlopeError, cannot calculate slope without stem direction");
                }
                float direction = ((float)self.stemDirection);   // ==  MNStemDirectionUp ? +1.f : -1.f;
                y_shift_tmp += diff * -direction;
                total_stem_extension += (diff * i);
            }
            else
            {   // beam overshoots note, account for the difference
                total_stem_extension += (y_px - slope_y_px) * ((float)self.stemDirection);
            }
        }

        MNStemmableNote* last_note = self.notes[self.notes.count - 1];
        float first_last_slope = ((last_note.stemExtents.topY - first_y_px) / (last_note.stemX - first_x_px));
        // most engraving books suggest aiming for a slope about half the angle of
        // the
        // difference between the first and last notes' stem length;
        float ideal_slope = first_last_slope / 2;
        float distance_from_ideal = fabsf(ideal_slope - slope);

        // This tries to align most beams to something closer to the ideal_slope,
        // but
        // doesn't go crazy. To disable, set self.render_options.slope_cost = 0
        float cost = self.renderOptions.slope_cost * distance_from_ideal + fabsf(total_stem_extension);

        // update state when a more ideal slope is found
        if(cost < min_cost)
        {
            min_cost = cost;
            best_slope = slope;
            y_shift = y_shift_tmp;
        }
    }
    if(y_shift > FLT_MAX)
    {
        MNLogError(@"self.y_shift is unreasonable: %f", y_shift);
    }

    self.slope = best_slope;
    self.yShift = y_shift;
}

/*!
 *   Create new stems for the notes in the beam, so that each stem
 *   extends into the beams.
 */
- (void)applyStemExtensions
{
    MNStemmableNote* first_note = self.notes[0];
    float first_y_px = first_note.stemExtents.topY;
    float first_x_px = first_note.stemX;

    for(uint i = 0; i < self.notes.count; ++i)
    {
        MNStemmableNote* note = self.notes[i];

        float x_px = note.stemX;
        MNExtentStruct* y_extents = note.stemExtents;
        float base_y_px = y_extents.baseY;
        float top_y_px = y_extents.topY;

        // For harmonic note heads, shorten stem length by 3 pixels
        base_y_px += ((float)self.stemDirection) * note.glyphStruct.stemOffset;

        // Don't go all the way to the top (for thicker stems)
        float y_displacement = kSTEM_WIDTH;

        if(!note.hasStem)
        {
            if(note.isRest && self.renderOptions.show_stemlets)
            {
                float centerGlyphX = note.centerGlyphX;

                float width = self.renderOptions.beam_width;
                float total_width = ((((float)self.beamCount) - 1) * width * 1.5) + width;

                float stemlet_height = (total_width - y_displacement + self.renderOptions.stemlet_extension);

                float beam_y =
                    [self getSlopeYForX:centerGlyphX first_x_px:first_x_px first_y_px:first_y_px slope:self.slope] +
                    self.yShift;
                float start_y = beam_y + (kSTEM_HEIGHT * ((float)self.stemDirection));
                float end_y = beam_y + (stemlet_height * ((float)self.stemDirection));

                // Draw Stemlet
                MNStem* stem = [[MNStem alloc] init];
                stem.x_begin = centerGlyphX;
                stem.x_end = centerGlyphX;
                stem.y_bottom = self.stemDirection == MNStemDirectionUp ? end_y : start_y;
                stem.y_top = self.stemDirection == MNStemDirectionUp ? start_y : end_y;
                stem.y_extend = y_displacement;
                stem.stem_extension = -1;   // To avoid protruding through the beam
                stem.stemDirection = self.stemDirection;
                note.stem = stem;
            }
            continue;
        }

        float slope_y =
            [self getSlopeYForX:x_px first_x_px:first_x_px first_y_px:first_y_px slope:self.slope] + self.yShift;

        MNStem* stem = [[MNStem alloc] init];
        stem.x_begin = x_px - (kSTEM_WIDTH / 2);
        stem.x_end = x_px;
        stem.y_top = self.stemDirection == MNStemDirectionUp ? top_y_px : base_y_px,
        stem.y_bottom = self.stemDirection == MNStemDirectionUp ? base_y_px : top_y_px, stem.y_extend = y_displacement;
        stem.y_extend = y_displacement;
        stem.stem_extension = ABS(top_y_px - slope_y) - kSTEM_HEIGHT - 1;
        stem.stemDirection = self.stemDirection;
        note.stem = stem;
    }
}

/*!
 *  Get the x coordinates for the beam lines of specific `duration`
 *  @param duration <#duration description#>
 *  @return an array of BeamLine objects
 */
- (NSArray<MNBeamLine*>*)getBeamLines:(NSString*)duration
{
    NSMutableArray* beam_lines = [NSMutableArray array];
    BOOL beam_started = NO;
    MNBeamLine* current_beam;
    float partial_beam_length = self.renderOptions.partial_beam_length;

    MNBeamPartial* (^determinePartialSide)(MNStemmableNote*, MNStemmableNote*);

    determinePartialSide = ^MNBeamPartial*(MNStemmableNote* prev_note, MNStemmableNote* next_note)
    {
        // Compare beam counts and store differences
        NSInteger unshared_beams = 0;
        if(next_note && prev_note)
        {
            unshared_beams = prev_note.beamCount - next_note.beamCount;
        }

        BOOL left_partial = [duration isNotEqualToString:@"8"] && unshared_beams > 0;
        BOOL right_partial = [duration isNotEqualToString:@"8"] && unshared_beams < 0;

        return [MNBeamPartial partialWithLeft:left_partial right:right_partial];
    };

    for(NSUInteger i = 0; i < self.notes.count; ++i)
    {
        MNStemmableNote* note = self.notes[i];
        MNStemmableNote* prev_note = i == 0 ? nil : self.notes[i - 1];
        MNStemmableNote* next_note = i == self.notes.count - 1 ? nil : self.notes[i + 1];
        NSUInteger ticks = note.intrinsicTicks;
        MNBeamPartial* partial = determinePartialSide(prev_note, next_note);
        float stem_x = note.isRest ? note.centerGlyphX : note.stemX;

        // Check whether to apply beam(s)
        if(ticks < [MNTable durationToTicks:duration])
        {
            if(!beam_started)
            {
                MNBeamLine* new_line = [MNBeamLine lineWithStart:stem_x end:0];
                if(partial.left)
                {
                    new_line.end = stem_x - partial_beam_length;
                }

                [beam_lines push:new_line];
                beam_started = YES;
            }
            else
            {
                current_beam = beam_lines.lastObject;
                current_beam.end = stem_x;

                // Should break secondary beams on note
                BOOL should_break = [self.break_on_indices containsObject:@(1)];
                // Shorter than or eq an 8th note duration
                BOOL can_break = duration.integerValue >= 8;
                if(should_break && can_break)
                {
                    beam_started = NO;
                }
            }
        }
        else
        {
            if(!beam_started)
            {
                // we don't care
            }
            else
            {
                current_beam = beam_lines.lastObject;
                if(current_beam.end == 0)
                {
                    // single note
                    current_beam.end = current_beam.start + partial_beam_length;
                }
                else
                {
                    // we don't care
                }
            }

            beam_started = NO;
        }
    }

    if(beam_started)
    {
        current_beam = beam_lines.lastObject;
        if(current_beam.end == 0)
        {
            // single note
            current_beam.end = current_beam.start - partial_beam_length;
        }
    }

    return beam_lines;
}

#pragma mark - Rendering Methods

/*!
 *  Render the stems for each notes
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)drawStems:(CGContextRef)ctx
{
    [self.notes oct_foreach:^(MNStemmableNote* note, NSUInteger index, BOOL* stop) {
      if(note.stem)
      {
          [note.stem draw:ctx];
      }
    }];
}

/*!
 *  Render the beam lines
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)drawBeamLines:(CGContextRef)ctx
{
    NSArray<NSString*>* valid_beam_durations = @[ @"4", @"8", @"16", @"32", @"64" ];

    MNStemmableNote* first_note = self.notes[0];
    MNStemmableNote* last_note = self.notes.lastObject;   //[self.notes.count - 1];

    float first_y_px = ([((MNStaffNote*)first_note)stemExtents]).topY;
    float last_y_px = ([((MNStaffNote*)last_note)stemExtents]).topY;

    float first_x_px = ((MNStaffNote*)first_note).stemX;

    float beam_width = self.renderOptions.beam_width * ((float)self.stemDirection);

    // Draw the beams.
    for(NSUInteger i = 0; i < valid_beam_durations.count; ++i)
    {
        NSString* duration = valid_beam_durations[i];
        NSArray<MNBeamLine*>* beam_lines = [self getBeamLines:duration];

        for(uint j = 0; j < beam_lines.count; ++j)
        {
            MNBeamLine* beam_line = beam_lines[j];
            float first_x =
                beam_line.start - (((float)self.stemDirection) == MNStemDirectionDown ? kSTEM_WIDTH / 2 : 0);
            float first_y = [self getSlopeYForX:first_x first_x_px:first_x_px first_y_px:first_y_px slope:self.slope];

            float last_x =
                beam_line.end + (self.stemDirection == MNStemDirectionUp ? (kSTEM_WIDTH / 3) : (-kSTEM_WIDTH / 3));
            float last_y = [self getSlopeYForX:last_x first_x_px:first_x_px first_y_px:first_y_px slope:self.slope];

            MNLogInfo(@"first:(%f, %f), last(%f, %f)", first_x, first_y, last_x, last_y);

            //            if(first_x > last_x)
            //            {
            //                NSLog(@"hi");
            //            }

            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, first_x, first_y + self.yShift);
            CGContextAddLineToPoint(ctx, first_x, first_y + beam_width + self.yShift);
            CGContextAddLineToPoint(ctx, last_x + 1, last_y + beam_width + self.yShift);
            CGContextAddLineToPoint(ctx, last_x + 1, last_y + self.yShift);
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
        }

        first_y_px += beam_width * 1.5;
        last_y_px += beam_width * 1.5;
    }
}

/*!
 *  Pre-format the beam
 *  @return YES if preFormatting was successful, NO otherwise
 */
- (BOOL)preFormat
{
    // do nothing

    return YES;
}

/*!
 *   Post-format the beam. This can only be called after
 *   the notes in the beam have both `x` and `y` values. ie: they've
 *   been formatted and have staves
 *  @return YES if preFormatting was successful, NO otherwise
 */
- (BOOL)postFormat
{
    if(_postFormatted)
    {
        MNLogInfo(@"postFormat: Already called");
        return YES;
    }
    [self calculateSlope];
    [self applyStemExtensions];
    _postFormatted = YES;

    return YES;
}

/*!
 *  Render the beam to the canvas context
 *
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    if(self.unbeamable)
    {
        return;
    }
    if(!_postFormatted)
    {
        [self postFormat];
    }
    [self drawStems:ctx];
    [self drawBeamLines:ctx];
}

/*!
 *  calculates the direction of the stems
 *  @param notes the notes used to determine the stem direction
 *  @return up or down
 */
+ (MNStemDirectionType)calculateStemDirection:(NSArray<MNStemmableNote*>*)notes
{
    __block float lineSum = 0.f;
    [notes oct_foreach:^(MNStaffNote* note, NSUInteger index, BOOL* stop) {
      if(note.keyProps)
      {
          [note.keyProps oct_foreach:^(MNKeyProperty* keyProp, NSUInteger index, BOOL* stop) {
            lineSum += (keyProp.line - 3.f);
          }];
      }
    }];
    if(lineSum >= 0.f)
    {
        return MNStemDirectionDown;
    }
    else
    {
        return MNStemDirectionUp;
    }
}

#pragma mark - Static Methods

/*!
 *  Gets the default beam groups for a provided time signature.
 *  Attempts to guess if the time signature is not found in table.
 *  Currently this is fairly naive.
 *  @param timeType <#timeType description#>
 *  @return <#return value description#>
 */
+ (NSArray*)getDefaultBeamGroupsForTimeSignatureType:(MNTimeType)timeType
{
    NSString* ret = [MNEnum simplNameForTimeType:timeType];
    return [self getDefaultBeamGroupsForTimeSignatureName:ret];
}

+ (NSArray*)getDefaultBeamGroupsForTimeSignatureName:(NSString*)timeType
{
    // TODO: does this belong in  MNTables?
    NSDictionary* defaults = @{
        @"1/2" : @[ @"1/2" ],
        @"2/2" : @[ @"1/2" ],
        @"3/2" : @[ @"1/2" ],
        @"4/2" : @[ @"1/2" ],

        @"1/4" : @[ @"1/4" ],
        @"2/4" : @[ @"1/4" ],
        @"3/4" : @[ @"1/4" ],
        @"4/4" : @[ @"1/4" ],

        @"1/8" : @[ @"1/8" ],
        @"2/8" : @[ @"2/8" ],
        @"3/8" : @[ @"3/8" ],
        @"4/8" : @[ @"2/8" ],

        @"1/16" : @[ @"1/16" ],
        @"2/16" : @[ @"2/16" ],
        @"3/16" : @[ @"3/16" ],
        @"4/16" : @[ @"2/16" ],
    };

    NSArray* groups = defaults[timeType];

    if(!groups)
    {
        // If no beam groups found, naively determine
        // the beam groupings from the time signature
        NSArray* timeSplit = [timeType split:@"/"];

        NSString* beatTotalString = timeSplit[0];
        NSNumber* number = [NSNumber numberWithLongLong:beatTotalString.longLongValue];
        NSUInteger beatTotal = number.unsignedIntegerValue;
        NSString* beatValueString = timeSplit[1];
        number = [NSNumber numberWithLongLong:beatValueString.longLongValue];
        NSUInteger beatValue = number.unsignedIntegerValue;

        NSUInteger tripleMeter = beatTotal % 3 == 0;

        if(tripleMeter)
        {
            return @[ Rational(3, beatValue) ];
        }
        else if(beatValue > 4)
        {
            return @[ Rational(2, beatValue) ];
        }
        else if(beatValue <= 4)
        {
            return @[ Rational(1, beatValue) ];
        }
    }
    else
    {
        return [groups oct_map:^MNRational*(NSString* group) {
          return [MNRational parse:group];
        }];
    }
    return nil;
}

/*!
 *  A helper function to automatically build basic beams for a voice. For more
 *  complex auto-beaming use `Beam.generateBeams()`.
 *  @param voice          The voice to generate the beams for
 *  @param stem_direction A stem direction to apply to the entire voice
 *  @param groups         An array of `MNRational` representing beat groupings for the beam
 *  @return an array of `MNBeam`
 */
+ (NSArray<MNBeam*>*)applyAndGetBeams:(MNVoice*)voice
                            direction:(MNStemDirectionType)stem_direction
                               groups:(NSArray*)groups
{
    return [[self class] generateBeams:voice.tickables
                                config:[[MNBeamConfig alloc] initWithDictionary:@{
                                    @"groups" : (groups ? groups : @[]),
                                    @"stem_direction" : @(stem_direction)
                                }]];
}

+ (NSArray<MNBeam*>*)applyAndGetBeams:(MNVoice*)voice groups:(NSArray<MNRational*>*)groups
{
    return
        [self generateBeams:voice.tickables config:[[MNBeamConfig alloc] initWithDictionary:@{
                                                @"groups" : groups
                                            }]];
}

+ (NSArray<MNBeam*>*)applyAndGetBeams:(MNVoice*)voice
{
    return [self generateBeams:voice.tickables config:nil];
}

/*!!
 *   A helper function to autimatically build beams for a voice with
 *    configuration options.
 *
 *    Example configuration object:
 *
 *    ```
 *    config = {
 *      groups: [new Vex.Flow.Fraction(2, 8)],
 *      stem_direction: -1,
 *      beam_rests: YES,
 *      beam_middle_only: YES,
 *      show_stemlets: NO
 *    };
 *    ```
 *    * `config` - The configuration object
 *       * `groups` - Array of `Rationals` that represent the beat structure to beam the notes
 *       * `stem_direction` - Set to apply the same direction to all notes
 *       * `beam_rests` - Set to `YES` to include rests in the beams
 *       * `beam_middle_only` - Set to `YES` to only beam rests in the middle of the beat
 *       * `show_stemlets` - Set to `YES` to draw stemlets for rests
 *       * `maintain_stem_directions` - Set to `YES` to not apply new stem directions
 *
 *  @param notes  An array of notes to create the beams for
 *  @param config The configuration object
 *
 *  @return generated beams
 */
+ (NSArray<MNBeam*>*)generateBeams:(NSArray<MNStemmableNote*>*)notes withDictionary:(NSDictionary*)config
{
    return [[self class] generateBeams:notes config:[[MNBeamConfig alloc] initWithDictionary:config]];
}

+ (NSArray<MNBeam*>*)generateBeams:(NSArray<MNStemmableNote*>*)notes config:(MNBeamConfig*)config
{
    if(!config)
    {
        config = [[MNBeamConfig alloc] initWithDictionary:nil];
    }

    if(!config.groups || config.groups.count == 0)
    {
        config.groups = [NSMutableArray arrayWithArray:@[ Rational(2, 8) ]];
    }

    // Convert beam groups to tick amounts
    NSMutableArray<MNRational*>* tickGroups = [config.groups oct_map:^MNRational*(MNRational* r) {
      if(![r isKindOfClass:[MNRational class]])
      {
          MNLogError(@"InvalidBeamGroups, The beam groups must be an array of Rationals");
      }
      return [[r clone] multiply:Rational(kRESOLUTION, 1)];
    }];

    NSArray<MNStemmableNote*>* unprocessedNotes = notes;
    __block NSUInteger currentTickGroup = 0;
    __block NSMutableArray<NSArray*>* noteGroups = [NSMutableArray array];
    __block NSMutableArray* currentGroup = [NSMutableArray array];

    // forward declarations of all blocks used in this method
    MNRational* (^getTotalTicks)(NSArray<MNStemmableNote*>*);
    void (^nextTickGroup)();
    void (^createGroups)();
    NSArray* (^getBeamGroups)();   // get groups able to have beams added
    void (^sanitizeGroups)();      // Splits up groups by Rest
    void (^formatStems)();
    __block MNStemmableNote* (^findFirstNote)(NSArray*);
    __block void (^applyStemDirection)(NSArray*, MNStemDirectionType);
    NSArray* (^getTupletGroups)();

    getTotalTicks = ^MNRational*(NSArray<MNStemmableNote*>* notes)
    {
        //        return [mn_notes reduce:^Rational*(Rational* memo, MNStemmableNote* note) {
        //          return [[note.ticks clone] add:memo];
        //        }];
        MNRational* ret = RationalZero();
        for(MNStemmableNote* note in notes)
        {
            [ret add:note.ticks];
        }
        return ret;
    };

    nextTickGroup = ^() {
      if(tickGroups.count - 1 > currentTickGroup)
      {
          currentTickGroup += 1;
      }
      else
      {
          currentTickGroup = 0;
      }
    };

    createGroups = ^() {
      //      NSMutableArray* nextGroup = [NSMutableArray array];
      [unprocessedNotes oct_foreach:^(MNStemmableNote* unprocessedNote, NSUInteger index, BOOL* stop) {
        NSMutableArray* nextGroup = [NSMutableArray array];
        if(unprocessedNote.shouldIgnoreTicks)
        {
            [noteGroups push:currentGroup];
            currentGroup = nextGroup;
            return;   // Ignore untickables (like bar notes)
        }

        [currentGroup push:unprocessedNote];
        MNRational* ticksPerGroup = [tickGroups[currentTickGroup] clone];
        MNRational* totalTicks = getTotalTicks(currentGroup);

        // Double the amount of ticks in a group, if it's an unbeamable tuplet
        NSUInteger val = [MNTable durationToNumber:unprocessedNote.durationString].unsignedIntegerValue;
        BOOL unbeamable = val < 8;
        if(unbeamable && unprocessedNote.tuplet)
        {
            [ticksPerGroup multiplyByValue:2];
        }

        // If the note that was just added overflows the group tick total
        if([totalTicks greaterThan:ticksPerGroup])
        {
            // If the overflow note can be beamed, start the next group
            // with it. Unbeamable notes leave the group overflowed.
            if(!unbeamable)
            {
                [nextGroup push:[currentGroup pop]];
            }
            [noteGroups push:currentGroup];
            currentGroup = nextGroup;
            nextTickGroup();
        }
        else if([totalTicks equals:ticksPerGroup])
        {
            [noteGroups push:currentGroup];
            currentGroup = nextGroup;
            nextTickGroup();
        }
      }];

      // Adds any remainder notes
      if(currentGroup.count > 0)
      {
          [noteGroups push:currentGroup];
      }
    };

    getBeamGroups = ^NSArray*()
    {
        return [noteGroups oct_filter:^BOOL(NSArray* group) {
          if(group.count > 1)
          {
              __block BOOL beamable = YES;
              [group oct_foreach:^(MNTickable* note, NSUInteger index, BOOL* stop) {
                if(note.intrinsicTicks >= [MNTable durationToTicks:@"4"])
                {
                    beamable = NO;
                }
              }];
              return beamable;
          }
          return NO;
        }];
    };

    // Splits up groups by Rest
    sanitizeGroups = ^() {
      NSMutableArray* sanitizedGroups = [NSMutableArray array];
      [noteGroups oct_foreach:^(NSArray* group, NSUInteger index, BOOL* stop) {
        __block NSMutableArray* tempGroup = [NSMutableArray array];
        [group oct_foreach:^(MNStemmableNote* note, NSUInteger index, BOOL* stop) {
          BOOL isFirstOrLast = index == 0 || index == group.count - 1;
          MNStemmableNote* prevNote = index > 0 ? group[index - 1] : nil;

          BOOL breaksOnEachRest = !config.beamRests && note.isRest;
          BOOL breaksOnFirstOrLastRest = (config.beamRests && config.beamMiddleOnly && note.isRest && isFirstOrLast);

          BOOL breakOnStemChange = NO;
          if(config.maintainStemDirections && prevNote && !note.isRest && !prevNote.isRest)
          {
              MNStemDirectionType prevDirection = prevNote.stemDirection;
              MNStemDirectionType currentDirection = note.stemDirection;
              breakOnStemChange = currentDirection != prevDirection;
          }

          BOOL isUnbeamableDuration = [note.durationString integerValue] < 8;

          // Determine if the group should be broken at this note
          BOOL shouldBreak = breaksOnEachRest || breaksOnFirstOrLastRest || breakOnStemChange || isUnbeamableDuration;

          if(shouldBreak)
          {
              // Add current group
              if(tempGroup.count > 0)
              {
                  [sanitizedGroups push:tempGroup];
              }

              // Start a new group. Include the current note if the group
              // was broken up by stem direction, as that note needs to start
              // the next group of notes
              tempGroup = [(breakOnStemChange ? @[ note ] : @[])mutableCopy];
          }
          else
          {
              // Add note to group
              [tempGroup push:note];
          }
        }];
        // If there is a remaining group, add it as well
        if(tempGroup.count > 0)
        {
            [sanitizedGroups push:tempGroup];
        }
      }];
      noteGroups = sanitizedGroups;
    };

    formatStems = ^() {
      [noteGroups oct_foreach:^(NSArray* group, NSUInteger index, BOOL* stop) {
        MNStemDirectionType stemDirection;
        if(config.maintainStemDirections)
        {
            MNStemmableNote* note = findFirstNote(group);
            stemDirection = note ? note.stemDirection : MNStemDirectionUp;
        }
        else
        {
            if(config.stemDirection)
            {
                stemDirection = config.stemDirection;
            }
            else
            {
                stemDirection = [MNBeam calculateStemDirection:group];
            }
        }
        applyStemDirection(group, stemDirection);
      }];
    };

    findFirstNote = ^MNStemmableNote*(NSArray* group)
    {   // group of notes
        for(MNStemmableNote* note in group)
        {
            if(!note.isRest)
            {
                return note;
            }
        }
        return nil;
    };

    applyStemDirection = ^(NSArray* group, MNStemDirectionType direction) {
      [group oct_foreach:^(MNStemmableNote* note, NSUInteger index, BOOL* stop) {
        note.stemDirection = direction;
      }];
    };

    getTupletGroups = ^NSArray*()
    {
        return [noteGroups oct_filter:^BOOL(NSArray* group) {   // group of notes
          if(group.firstObject)
          {
              if(((MNStemmableNote*)group.firstObject)
                     .tuplet)   // NOTE: this might break if tuplet is dynamically allocated
              {
                  return YES;
              }
          }
          return NO;
        }];
    };

    // Using closures to store the variables throughout the various functions
    // IMO Keeps it this process lot cleaner - but not super consistent with
    // the rest of the API's style - Silverwolf90 (Cyril)
    createGroups();
    sanitizeGroups();
    formatStems();

    // Get the notes to be beamed
    NSArray* beamedNoteGroups = getBeamGroups();

    // Get the tuplets in order to format them accurately
    NSArray* tupletGroups = getTupletGroups();

    __block NSMutableArray* beams = [NSMutableArray array];
    [beamedNoteGroups oct_foreach:^(NSArray* group, NSUInteger index, BOOL* stop) {   // group of notes
      MNBeam* beam = [[MNBeam alloc] initWithNotes:group];
      BOOL show_stemlets = config.showStemlets;
      if(show_stemlets)
      {
          beam.renderOptions.show_stemlets = YES;
      }
      [beams push:beam];
    }];

    // Reformat tuplets
    [tupletGroups oct_foreach:^(NSArray* group, NSUInteger index, BOOL* stop) {
      __block MNStemmableNote* firstNote = group.firstObject;
      [group oct_foreach:^(MNStemmableNote* note, NSUInteger index, BOOL* stop) {
        if(note.hasStem)
        {
            firstNote = note;
            *stop = YES;
        }
      }];

      MNTuplet* tuplet = firstNote.tuplet;

      if(firstNote.beam)
      {
          tuplet.bracketed = NO;
      }
      if(firstNote.stemDirection == MNStemDirectionDown)
      {
          tuplet.tupletLocation = MNTupletLocationBottom;
      }
    }];

    return beams;
}

@end
