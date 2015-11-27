//
//  MNStaff.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Mohit Cheppudira 2010
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

#import <objc/runtime.h>
#import "MNStaff.h"
#import "MNColor.h"
#import "MNFont.h"
#import "MNBezierPath.h"
#import "MNUtils.h"
#import "MNMetrics.h"
#import "MNOptions.h"
#import "MNBoundingBox.h"
#import "MNEnum.h"
#import "MNGlyph.h"
#import "MNModifier.h"
#import "MNStaffModifier.h"
#import "MNKeySignature.h"
#import "MNClef.h"
#import "MNTimeSignature.h"
#import "MNStaffBarLine.h"
#import "OCTotallyLazy.h"
#import "NSString+Ruby.h"
#import "MNShift.h"
#import "MNStaffModifier.h"
#import "MNStaffSection.h"
#import "MNPadding.h"
#import "NSObject+MNAdditions.h"
#import "NSMutableArray+MNAdditions.h"
#import "MNPoint.h"
#import "MNTable.h"
#import "NSMutableArray+MNAdditions.h"
#import "MNStaffText.h"
#import "MNStaffTempo.h"
#import "MNStaffVolta.h"
#import "MNStaffRepetition.h"
#import "NSObject+AutoDescription.h"
#import "MNConstants.h"

@implementation StaffOptions
{
    NSUInteger _numLines;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        _verticalBarWidth = 10;   // Width around vertical bar end-marker
        _glyphSpacingPoints = 10;
        _numLines = 5;
        _pointsBetweenLines = 10;   // in points
        _spaceAboveStaffLine = 4;   // in staff lines
        _spaceBelowStaffLine = 4;   // in staff lines
        _topTextPosition = 1;       // in staff lines
        _bottomTextPosition = 6;
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

+ (StaffOptions*)staffOptions
{
    return [[StaffOptions alloc] initWithDictionary:nil];
}

- (NSMutableArray*)lineConfig
{
    if(!_lineConfig)
    {
        _lineConfig = [NSMutableArray arrayWithCapacity:_numLines];
        for(NSUInteger i = 0; i < _numLines; ++i)
        {
            [_lineConfig addObject:[NSMutableDictionary dictionaryWithDictionary:@{ @"visible" : @(YES) }]];
        }
    }
    return _lineConfig;
}

- (void)setNumLines:(NSUInteger)numLines
{
    _numLines = numLines;
    if(_numLines > self.lineConfig.count)
    {
        for(NSUInteger i = 0; i < (_numLines - self.lineConfig.count); ++i)
        {
            [_lineConfig addObject:[NSMutableDictionary dictionaryWithDictionary:@{ @"visible" : @(YES) }]];
        }
    }
}

@end

static MNStaff* _currentStaff;

@interface MNStaff (private)
@property (strong, nonatomic) StaffOptions* options;
@end

@implementation MNStaff

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        _postFormatted = NO;
        _thickNess = kTHICKNESS > 1 ? kTHICKNESS : 0;
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

+ (MNStaff*)currentStaff
{
    if(!_currentStaff)
    {
        MNLogError(@"StaffNotYetCreatedError, need to create a staff first.");
    }
    return _currentStaff;
}

- (instancetype)initAtX:(float)x
                    atY:(float)y
                  width:(float)width
                 height:(float)height
            optionsDict:(NSDictionary*)optionsDict
{
    self = [self initWithDictionary:optionsDict];
    if(self)
    {
        _x = x;
        _y = y;
        _width = width;

        _glyph_start_x = _x + 0;
        _glyph_end_x = _x + _width;
        _start_x = _glyph_start_x + 20;
        _end_x = _glyph_end_x;

        // TODO: move these to property methods
        _modifiers = [NSMutableArray array];   // non-glyph Staff items (barlines, coda, segno, etc.)
        _measure = 0;
        //        _clef =  [MNClef clefWithType:MNClefTreble];
        //        _font =  [MNFont fontWithName:@"sans-serif" size:8 weight:@""];

        _boundingBox = [MNBoundingBox boundingBoxAtX:x atY:y withWidth:width andHeight:height];
        if(_boundingBox.height == 0)
        {
            _boundingBox.height = _options.pointsBetweenLines * 4;
        }

        //        // reset lines
        //        for(NSUInteger line = 0; line < self.options.numLines; ++line)
        //        {
        //            self.options.lineConfig[line][@"visible"] = @(YES);   //  @{
        //                                                                  //                @"visible" : @(YES)
        //            //            };   // addObject:[NSMutableDictionary dictionaryWithDictionary:@{ @"visible" :
        //            @(YES) }]];
        //        }
        self.height = (_options.numLines + _options.spaceAboveStaffLine) * _options.pointsBetweenLines;
        self.options.bottomTextPosition = _options.numLines + 1;

        // beginning bar
        MNStaffBarLine* leftStaffBarLine = [MNStaffBarLine barLineWithType:MNBarLineSingle atX:self.x];
        leftStaffBarLine.staff = self;
        [self.modifiers push:leftStaffBarLine];

        // ending bar
        MNStaffBarLine* rightStaffBarLine = [MNStaffBarLine barLineWithType:MNBarLineSingle atX:self.x + self.width];
        rightStaffBarLine.staff = self;
        [self.modifiers push:rightStaffBarLine];

        _fillColor = MNColor.blackColor;
        _strokeColor = MNColor.blackColor;
        _preFormatted = NO;
        _currentStaff = self;

        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

+ (MNStaff*)staffWithBoundingBox:(MNBoundingBox*)frame
{
    return [MNStaff staffWithRect:frame.rect];
}

+ (MNStaff*)staffWithRect:(CGRect)rect
{
    return [MNStaff staffAtX:CGRectGetMinX(rect)
                         atY:CGRectGetMinY(rect)
                       width:CGRectGetWidth(rect)
                      height:CGRectGetHeight(rect)];
}

+ (MNStaff*)staffAtX:(float)x atY:(float)y width:(float)width height:(float)height
{
    return [[MNStaff alloc] initAtX:x atY:y width:width height:height optionsDict:nil];
}

+ (MNStaff*)staffWithRect:(CGRect)rect optionsDict:(NSDictionary*)optionsDict
{
    return [[MNStaff alloc] initAtX:CGRectGetMinX(rect)
                                atY:CGRectGetMinY(rect)
                              width:CGRectGetWidth(rect)
                             height:CGRectGetHeight(rect)
                        optionsDict:optionsDict];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Configuration
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Configuration
 * ---------------------------------------------------------------------------------------------------------------------
 */

/*!
 * Get the current configuration for the staff.
 * @return {Array} An array of NSDictionaries configuration objects.
 */
- (NSMutableArray*)getConfigForLines
{
    return self.options.lineConfig;
}

/*!
 *  Configure properties of the lines in the staff
 *  @param lineNumber The index of the line to configure.
 *  @param lineConfig An configuration object for the specified line.
 *  @return this object
 */
- (id)setConfigForLine:(NSInteger)lineNumber withConfig:(NSDictionary*)lineConfig
{
    // are there a valid number of lines
    if(lineNumber >= self.options.numLines || lineNumber < 0.0)
    {
        MNLogError(@"StaffConfigError, The line number must be within the range "
                   @"of the number of lines in the Staff.");
    }

    // is the 'visible' key stored in the line configuration dictionary passed in
    if(![lineConfig objectForKey:@"visible"])
    {
        MNLogError(@"StaffConfigError, The line configuration object is missing the 'visible' property.");
    }

    // is a boolean stored in the line configuration collection
    if(strcmp(@encode(BOOL), [[lineConfig objectForKey:@"visible"] objCType]))
    {
        MNLogError(@"StaffConfigError, The line configuration objects 'visible' property must be YES or NO.");
    }

    for(NSString* key in lineConfig.allKeys)
    {
        self.options.lineConfig[lineNumber][key] = lineConfig[key];
    }
    return self;
}

/*!
 *  Set the staff line configuration array for all of the lines at once.
 *  @param linesConfiguration An array of line configuration dictionaries.  These objects
 *   are of the same format as the single one passed in to setLineConfiguration().
 *   The caller can set null for any line config entry if it is desired that the default be used
 *  @return this object
 */
- (id)setConfigForLines:(NSArray*)linesConfiguration
{
    NSMutableArray* tmpLinesConfiguration = [NSMutableArray arrayWithCapacity:linesConfiguration.count];
    for(int i = 0; i < linesConfiguration.count; ++i)
    {
        tmpLinesConfiguration[i] = linesConfiguration[i];
    }

    if(linesConfiguration.count != self.options.numLines)
    {
        MNLogError(@"StaffConfigError, The length of the lines configuration "
                   @"array must match the number of lines in " @"the Staff");
    }

    // Make sure the defaults are present in case an incomplete set of
    //  configuration options were supplied.
    for(int i = 0; i < linesConfiguration.count; ++i)
    {
        // Allow 'nil' to be used if the caller just wants the default for a particular node.
        //        if(tmpLinesConfiguration[i] != nil)
        if(((NSDictionary*)tmpLinesConfiguration[i]).allKeys.count == 0)
        {
            tmpLinesConfiguration[i] = self.options.lineConfig[i];
        }
        //        self.options.lineConfig[i] = [NSMutableDictionary merge:self.options.lineConfig[i]
        //        with:tmpLinesConfiguration[i]];

        else
        {
            for(NSString* key in((NSDictionary*)tmpLinesConfiguration[i]).allKeys)
            {
                self.options.lineConfig[i][key] = tmpLinesConfiguration[i][key];
            }
        }
    }
    return self;
}

- (float)spacingBetweenLines
{
    return self.options.pointsBetweenLines;
}

#pragma mark - Properties

- (NSString*)description
{
    // TODO: figure this out
    return [self autoDescription];
}

//    NSString* ret = @"";
//    ret = [ret concat:[NSString stringWithFormat:@"KeySignature: %@", [self.keySignature description]]];
//    ret = [ret concat:[NSString stringWithFormat:@"TimeSignature: %@", [self.timeSignature description]]];
//    ret = [ret concat:[NSString stringWithFormat:@"Clef: %@", [self.clef description]]];
//    ret = [ret concat:[NSString stringWithFormat:@"BoundingBox: %@", [self.boundingBox description]]];
//    return ret;
//}

//- (NSString*)debugDescription;
//{
//    return self.description;
//}

//- (MNKeySignature*)keySignature
//{
//    if(!_keySignature)
//    {
//        _keySignature = [[MNTables keySpecsDictionary] objectForKey:@"C"];
//    }
//    return _keySignature;
//}

- (void)setKeySignature:(MNKeySignature*)keySignature
{
    if(_keySignature)
    {
        MNLogError(@"already added a keySignature.");
    }
    _keySignature = keySignature;
    [self addKeySignatureWithKeySignature:_keySignature];
}

- (MNTimeSignature*)timeSignature
{
    if(!_timeSignature)
    {
        _timeSignature = [MNTimeSignature timeSignatureWithType:MNTime4_4];
    }
    return _timeSignature;
}

- (StaffOptions*)options
{
    if(!_options)
    {
        _options = [StaffOptions staffOptions];
    }
    return _options;
}

- (NSMutableArray*)glyphs
{
    if(!_glyphs)
    {
        _glyphs = [[NSMutableArray alloc] init];
    }
    return _glyphs;
}

- (NSMutableArray*)endGlyphs
{
    if(!_endGlyphs)
    {
        _endGlyphs = [[NSMutableArray alloc] init];
    }
    return _endGlyphs;
}

- (NSMutableArray*)modifiers
{
    if(!_modifiers)
    {
        _modifiers = [[NSMutableArray alloc] init];
    }
    return _modifiers;
}

/*!
 *  reset the lines options
 */
- (void)resetLines
{
    self.options.lineConfig = nil;
    for(NSUInteger i = 0; i < self.options.numLines; ++i)
    {
        [self.options.lineConfig push:@{ @"visible" : @(YES) }];
    }
    self.height = (self.options.numLines + self.options.spaceAboveStaffLine) * self.spacingBetweenLines;
    self.options.bottomTextPosition = self.options.numLines + 1;
}

- (id)setNoteStartX:(float)x
{
    _start_x = x;
    return self;
}

- (float)noteStartX
{
    float start_x = _start_x;

    // Add additional space if left barline is REPEAT_BEGIN and there are other
    // start modifiers than barlines
    if(((MNStaffBarLine*)self.modifiers[0]).barLinetype == MNBarLineRepeatBegin && self.modifiers.count > 2)
    {
        start_x += 20;
    }

    return start_x;
}

- (float)getNoteEndX
{
    return self.end_x;   // self.start_x + self.width;
}

- (float)getTieStartX
{
    return _start_x;
}

- (float)getTieEndX
{
    return self.x + self.width;
}

- (NSUInteger)getNumLines
{
    return self.options.numLines;
}

/*!
 *  sets the total width of this staff
 *  @param width the new width
 *  @return this object
 */
- (id)setWidth:(float)width
{
    _width = width;
    _glyph_end_x = self.x + width;
    self.boundingBox.width = _glyph_end_x;

    // reset the x position of the end barline (TODO(0xfe): This makes no sense)
    // this.modifiers[1].setX(this.end_x);
    return self;
}

/*!
 *  sets the measure of this particular staff
 *  @param measure the number to display
 */
- (void)setMeasure:(NSUInteger)measure
{
    _measure = measure;
}

/*!
 *  Bar Line functions
 *  @param begBarType beginning bar type
 *  @return this object
 */
- (id)setBegBarType:(MNBarLineType)begBarType
{
    // only valid bar types at beginning of Staff is `none`, `single` or `begin repeat`
    if(begBarType == MNBarLineSingle || begBarType == MNBarLineRepeatBegin || begBarType == MNBarLineNone)
    {
        MNStaffBarLine* leftStaffBarLine = [MNStaffBarLine barLineWithType:begBarType atX:self.x];
        self.modifiers[0] = leftStaffBarLine;
        leftStaffBarLine.staff = self;
    }
    else
    {
        MNLogError(@"InvalidBegBarType, beginning bar type not set to: %li", begBarType);
    }
    return self;
}

/*!
 *  Bar Line functions
 *  @param endBarType ending bar type
 *  @return this object
 */
- (id)setEndBarType:(MNBarLineType)endBarType
{
    // repeat end not valid at end of staff
    if(endBarType != MNBarLineRepeatBegin)
    {
        MNStaffBarLine* rightStaffBarLine = [MNStaffBarLine barLineWithType:endBarType atX:self.endX];
        self.modifiers[1] = rightStaffBarLine;
        rightStaffBarLine.staff = self;
    }
    return self;
}

/*!
 *  Gets the pixels to shift from the beginning of the stave
 *  following the modifier at the provided index
 *  @return The amount of pixels shifted
 */
- (float)getModifierXShift
{
    return [self getModifierXShift:-1];   // -1 indicates nil
}

/*!
 *  Gets the pixels to shift from the beginning of the stave
 *  following the modifier at the provided index
 *  @param index The index from which to determine the shift
 *  @return The amount of pixels shifted
 */
- (float)getModifierXShift:(NSInteger)index
{
    if(index < 0)
    {
        index = self.glyphs.count - 1;
    }

    float x = self.glyph_start_x;
    float bar_x_shift = 0;

    for(NSUInteger i = 0; i < index + 1; ++i)
    {
        MNGlyph* glyph = self.glyphs[i];
        // TODO: memoize
        x += glyph.metrics.width;
        bar_x_shift += glyph.metrics.width;
    }

    // Add padding after clef, time sig, key sig
    if(bar_x_shift > 0)
    {
        bar_x_shift += self.options.verticalBarWidth + 10;
    }

    return bar_x_shift;
};

/*!
 *  Coda & Segno Symbol functions
 *  @param type repetition type
 *  @param y    y position relative to staff origin
 *  @return this object
 */
- (id)setRepetitionTypeLeft:(MNRepetitionType)type atY:(float)y
{
    [self.modifiers push:[[MNStaffRepetition alloc] initWithType:type x:self.x y_shift:y]];
    return self;
}

/*!
 *  Coda & Segno Symbol functions
 *  @param type repetition type
 *  @param y    y position relative to staff origin
 *  @return this object
 */
- (id)setRepetitionTypeRight:(MNRepetitionType)type atY:(float)y
{
    [self.modifiers push:[[MNStaffRepetition alloc] initWithType:type x:self.x y_shift:y]];
    return self;
}

/*!
 *  Volta functions
 *  @param type    volta type
 *  @param numberT number of 'times' to repeat displayed
 *  @param y       y position relative to staff origin
 *  @return this object
 */
- (id)setVoltaType:(MNVoltaType)type withNumber:(NSString*)numberT atY:(float)y
{
    [self.modifiers push:[[MNStaffVolta alloc] initWithType:type number:numberT atX:self.x yShift:y]];
    return self;
}

/*!
 *  Section functions
 *  @param section the section
 *  @param y       shift up from staff origin
 *  @return this object
 */
- (id)setSectionWithSection:(NSString*)section atY:(float)y
{
    [self.modifiers push:[MNStaffSection staffSectionWithSection:section withX:self.x yShift:y]];
    return self;
}

/*!
 *  sets the tempo label for the staff
 *  @param tempo options for the tempo:
 *                  `name`, `duration`, `dots`, `bpm`
 *  @param y     y position relative to staff origin
 *  @return this object
 */
- (id)setTempoWithTempo:(TempoOptionsStruct*)tempo atY:(float)y
{
    [self.modifiers push:[[MNStaffTempo alloc] initWithTempo:tempo atX:self.x withShiftY:y]];
    return self;
}

/*!
 *  Text functions
 *  @param text     text to add
 *  @param position position of the text relative to the staff origin
 *  @param options  the following options to set text position:
 *                      `shift_x`
 *                      `shift_y`
 *                      `justification`
 *  @return this object
 */
- (id)setTextWithText:(NSString*)text atPosition:(MNPositionType)position withOptions:(NSDictionary*)options
{
    [self.modifiers push:[[MNStaffText alloc] initWithText:text atPosition:position WithOptions:options]];
    return self;
}

/*!
 *  Text functions
 *  @param text     text to add
 *  @param position position of the text relative to the staff origin
 *  @param options  the following options to set text position:
 *  @return this object
 */
- (id)setTextWithText:(NSString*)text atPosition:(MNPositionType)position
{
    return [self setTextWithText:text atPosition:position withOptions:nil];
}

/*!
 *  returns bounding box around this staff
 *  @return a bounding box instance
 */
- (MNBoundingBox*)boundingBox
{
    if(!_boundingBox)
    {
        float y = [self getYForLine:self.options.numLines];
        float height = ABS(y - [self getYForLine:0]);
        _boundingBox = [MNBoundingBox boundingBoxAtX:self.x atY:y withWidth:self.width andHeight:height];
        _boundingBox.height = self.options.pointsBetweenLines * self.options.numLines;
    }
    return _boundingBox;
}

- (MNPoint*)point
{
    MNBoundingBox* bb = [self boundingBox];
    return MNPointMake(bb.xPosition, bb.yPosition);
}

//- (MNColor*)strokeColor
//{
//    if(!_strokeColor)
//    {
//        _strokeColor = MNColor.blackColor;
//    }
//    return _strokeColor;
//}
//
//- (void)setStrokeColor:(MNColor*)strokeColor
//{
//    _strokeColor = strokeColor;
//}
//
//- (MNColor*)fillColor
//{
//    if(!_fillColor)
//    {
//        _fillColor = MNColor.blackColor;
//    }
//    return _fillColor;
//}
//
//- (void)setFillColor:(MNColor*)fillColor
//{
//    _fillColor = fillColor;
//}

- (void)setXPosition:(float)xPosition
{
    //    _boundingBox.xPosition = xPosition;
    _x = xPosition;
}
//
//- (float)startXPosition {
//    return self.x;
//}

- (float)x
{
    //    return _boundingBox.xPosition;
    return _x;
}

- (float)y
{
    //    return _boundingBox.xPosition;
    return _y;
}

- (void)setYPosition:(float)yPosition
{
    _boundingBox.yPosition = yPosition;
}

- (float)yPosition
{
    return _boundingBox.yPosition;
}

// defined above
//- (void)setWidth:(float)width {
//    _boundingBox.width = width;
//}

- (float)width
{
    return _boundingBox.width;
}

- (void)setHeight:(float)height
{
    //    _boundingBox.height = height;
    // TODO: height is set in StaffOptions
}

- (float)height
{
    //    return self.boundingBox.height;
    float y = [self getYForLine:self.options.numLines];
    float height = ABS(y - [self getYForLine:0]);
    return height;
}

- (float)endX
{
    return self.x + self.width;
}

//- (MNKeySignatureFlavorType)getFlavorForLine:(NSInteger)line
//{
//    // staff.cleftype
//
//    //    NSArray *flatPositionsGClef = @[ @(3), @(4.5), @(2.5), @(4), @(2), @(3.5), @(1.5), ];
//    //
//    //    NSArray *sharpPositionsGClef = @[ @(5), @(3.5), @(5.5), @(4), @(2.5), @(4.5), @(3), ];
//    //
//
//    return  MNKeySignatureNone;
//}

//- (MNPoint *)startPosition {
//    if (!_start_x) {
//        _startPosition =  [MNPoint pointZero];
//    }
//    return [_startPosition copy];
//}

- (void)setClefName:(NSString*)clefName
{
    _clefName = clefName;
    NSString* lookup = [clefName lowercaseString];
    typedef void (^CaseBlock)();
    _clefType = 0;
    NSDictionary* d = @{
        @"treble" : ^{
          _clefType = MNClefTreble;
        },
        @"bass" : ^{
          _clefType = MNClefBass;
        },
        @"alto" : ^{
          _clefType = MNClefAlto;
        },
        @"tenor" : ^{
          _clefType = MNClefTenor;
        },
        @"percussion" : ^{
          _clefType = MNClefPercussion;
        },
        @"soprano" : ^{
          _clefType = MNClefSoprano;
        },
        @"mezzo-soprano" : ^{
          _clefType = MNClefMezzoSoprano;
        },
        @"baritone-c" : ^{
          _clefType = MNClefBaritoneC;
        },
        @"baritone-f" : ^{
          _clefType = MNClefBaritoneF;
        },
        @"subbass" : ^{
          _clefType = MNClefSubBass;
        },
        @"french" : ^{
          _clefType = MNClefFrench;
        },
        @"moveable-c" : ^{
          _clefType = MNClefMovableC;
        },
    };

    ((CaseBlock)d[lookup])();
    if(_clefType == 0)
    {
        MNLogError(@"BadArgument, unknown name passed as clef type: %@", clefName);
    }
}

- (void)setClefType:(MNClefType)clefType
{
    switch(clefType)
    {
        case MNClefAlto:
            _clefName = @"alto";
            break;
        case MNClefBass:
            _clefName = @"bass";
            break;
        case MNClefPercussion:
            _clefName = @"percussion";
            break;
        case MNClefTenor:
            _clefName = @"tenor";
            break;
        case MNClefTreble:
            _clefName = @"treble";
            break;
        case MNClefSoprano:
            _clefName = @"soprano";
            break;
        case MNClefMezzoSoprano:
            _clefName = @"mezzo-soprano";
            break;
        case MNClefBaritoneC:
            _clefName = @"baritone-c";
            break;
        case MNClefBaritoneF:
            _clefName = @"baritone-f";
            break;
        case MNClefSubBass:
            _clefName = @"subbass";
            break;
        case MNClefFrench:
            _clefName = @"french";
            break;
        case MNClefMovableC:
            _clefName = @"moveable-c";
            break;
        default:
            MNLogError(@"BadArgument, unknown clef type");
            break;
    }

    [self addClefWithName:_clefName];

    // TODO: using the following creates an infinite loop
    //    [self addClefWithType:clefType];
}

- (NSUInteger)numberOfLines
{
    return self.options.numLines;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines
{
    self.options.numLines = numberOfLines;
}

#pragma mark - Get y positions Methods
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Get y positions Methods
 * ---------------------------------------------------------------------------------------------------------------------
 *
 *   staff lines are arranged as follows
 *
 *
 *                FLIPPED
 *       ---        -1   6
 *                  -0.5 5.5
 *  +--------------  0   5
 *  |                0.5 4.5
 *  +--------------  1   4
 *  |                1.5 3.5
 *  +--------------  2   3
 *  |                2.5 2.5
 *  +--------------  3   2
 *  |                3.5 1.5
 *  +--------------  4   1
 *                   4.5 0.5
 *       ---         5   0
 */

/*!
 *  gets the bottom y coordinate in global space
 *  @return the bottom y coordinate
 */
- (float)getBottomY
{
    StaffOptions* options = self.options;
    float spacing = options.pointsBetweenLines;
    float score_bottom = [self getYForLine:options.numLines] + (options.spaceBelowStaffLine * spacing);
    return score_bottom;
}

- (float)translateLine:(float)line
{
    return -1 * line + 5;
}

/*!
 *  gets absolute y position for line
 *  @param line staff line
 *  @return y position
 */
- (float)getYForLine:(float)line
{
    //    line = [self translateLine:line];

    float spacing = self.options.pointsBetweenLines;
    float headroom = self.options.spaceAboveStaffLine;
    //    float y = self.yPosition + line * spacing + headroom;
    float y = self.yPosition + ((line * spacing) + (headroom * spacing)) - (kTHICKNESS / 2);
    return y;
}

/*!
 *  gets absolute y position for top text line
 *  @param line staff line
 *  @return y position
 */
- (float)getYForTopTextWithLine:(float)line
{
    return [self getYForLine:(-line - self.options.topTextPosition)];
}

/*!
 *  gets absolute y position for top text line
 *  @return y position
 */
- (float)getYForTopText
{
    return [self getYForTopTextWithLine:0];
}

/*!
 *  gets absolute y position for bottom text line
 *  @param line staff line
 *  @return y position
 */
- (float)getYForBottomTextWithLine:(float)line
{
    return [self getYForLine:(self.options.bottomTextPosition + line)];
}

/*!
 *  gets absolute y position for top text line
 *  @return y position
 */
- (float)getYForBottomText
{
    return [self getYForBottomTextWithLine:0];
}

/*!
 *  gets absolute y position for a note
 *  @param line staff line
 *  @return y position
 */
- (float)getYForNoteWithLine:(float)line
{
    StaffOptions* options = _options;
    float spacing = options.pointsBetweenLines;
    float headroom = options.spaceAboveStaffLine;
    float y = self.yPosition + ((headroom * spacing) + (5. * spacing) - (line * spacing));
    return y;
}

/*!
 *  gets absolute y position for glyphs
 *  @return y position
 */
- (float)getYForGlyphs
{
    return [self getYForLine:3];
}

#pragma mark - Add Methods
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Add Methods
 * ---------------------------------------------------------------------------------------------------------------------
 */

/*!
 *  adds a glyph
 *  @param glyph the glyph object
 *  @return this object
 */
- (id)addGlyph:(MNGlyph*)glyph
{
    if((!glyph.metrics.code || glyph.metrics.code.length == 0) && !glyph.drawBlock)
    {
        MNLogError(@"EmptyGlyphCodeException");
    }
    glyph.parent = self;
    [self.glyphs push:glyph];
    float glyphWidth = glyph.metrics.width;
    _start_x += glyphWidth;
    return self;
}

/*!
 *  adds a glyph to end
 *  @param glyph the glyph object
 *  @return this object
 */
- (id)addEndGlyph:(MNGlyph*)glyph
{
    glyph.parent = self;
    [self.endGlyphs push:glyph];
    float glyphWidth = glyph.metrics.width;
    //    self.endXPosition -= glyphWidth;
    _end_x -= glyphWidth;
    return self;
}

/*!
 *  creates a blank glyph that does not render anything except it takes up space
 *  @param padding amount of space the blank glyph occupies
 *  @return a blank glyph
 */
- (MNGlyph*)makeSpacer:(float)padding
{
    MNGlyph* ret = [[MNGlyph alloc] init];
    ret.metrics.width = padding;
    ret.drawBlock = ^(CGContextRef context, float x, float y) { /* do nothing */ };
    return ret;
}

/*!
 *  adds a modifier
 *  @param modifier a staff modifier
 *  @return this object
 */
- (id)addModifier:(MNStaffModifier*)modifier
{
    [self.modifiers push:modifier];
    modifier.staff = self;   // CHANGE
    [modifier addToStaff:self firstGlyph:(self.glyphs.count == 0)];
    return self;
}

/*!
 *  adds a modifier to end
 *  @param modifier a staff modifier
 *  @return this object
 */
- (id)addEndModifier:(MNStaffModifier*)modifier
{
    [self.modifiers push:modifier];
    modifier.staff = self;   // CHANGE
    [modifier addToStaffEnd:self firstGlyph:(self.glyphs.count == 0)];
    return self;
}

/*!
 *  adds a key signature to the start of this staff
 *  @param signature the specifier for the signature
 *  @return this object
 */
- (id)addKeySignature:(NSString*)signature
{
    [self addModifier:[MNKeySignature keySignatureWithKey:signature]];
    return self;
}

- (id)addKeySignatureWithKeySignature:(MNKeySignature*)keySignature
{
    [self addModifier:keySignature];
    return self;
}

/*!
 *  adds a key signature to the start of this staff
 *  @param keySpec. one of:
 *              'C', 'CN', 'C#', 'C##', 'CB', 'CBB', 'D', 'DN', 'D#',
 *              'D##', 'DB', 'DBB', 'E', 'EN', 'E#', 'E##', 'EB',
 *              'EBB', 'F', 'FN', 'F#', 'F##', 'FB', 'FBB', 'G', 'GN', 'G#',
 *              'G##', 'GB', 'GBB', 'A', 'AN', 'A#', 'A##',
 *              'AB', 'ABB', 'B', 'BN', 'B#', 'B##', 'BB', 'BBB', 'R', 'X'
 *  @return this object
 */
- (id)addKeySignatureWithSpec:(NSString*)keySpec
{
    // TODO: this is possibly broken
    [self addModifier:[MNTable keySignatureWithString:keySpec]];
    return self;
}

/*!
 *  adds a treble clef to the start of this staff
 *  @return this object
 */
- (id)addTrebleGlyph
{
    self.clefType = MNClefTreble;
    //     MNClef* clef =  [MNClef clefWithType:self.clefType];
    //    [self addModifier:clef];
    return self;
}

/*!
 *  adds a clef to the start of this staff
 *  @param clefType the clef type enum value
 *  @return this object
 */
- (id)addClefWithType:(MNClefType)clefType
{
    self.clefType = clefType;
    MNClef* clef = [MNClef clefWithType:clefType];
    [self addModifier:clef];
    return self;
}

/*!
 *  adds a clef to the start of this staff
 *  @param clefName name of the clef. one of
 *                      `treble`, `alto`, `baritone-c`, `baritone-f`, `bass`, `french`,
 *                      `soprano`, `moveable-c`, percussion, soprano,
 *                      `subbass`, `tenor`
 *  @return this object
 */
- (id)addClefWithName:(NSString*)clefName
{
    self.clefName = clefName;
    MNClef* clef = [MNClef clefWithName:clefName];
    self.clef = clef;
    [self addModifier:clef];
    return self;
}

/*!
 *  adds a clef to the end of this staff
 *  @param clefName name of the clef. one of
 *                      treble, alto, baritone-c, baritone-f, bass, french, soprano, moveable-c, percussion, soprano,
 *                      subbass, tenor
 *  @return this object
 */
- (id)addEndClefWithName:(NSString*)clefName
{
    self.clefName = clefName;
    MNClef* clef = [MNClef clefWithName:clefName];
    [self addEndModifier:clef];
    return self;
}

/*!
 *  adds a clef to the start of this staff
 *  @param clef the clef object
 *  @return thix object
 */
- (id)addClef:(MNClef*)clef
{
    self.clefName = clef.clefName;
    [self addModifier:clef];
    return self;
}

/*!
 *  adds a clef to the start of this staff
 *  @param clefName name of the clef. one of
 *                      treble, alto, baritone-c, baritone-f, bass, french, soprano, moveable-c, percussion, soprano,
 *                      subbass, tenor
 *  @param size     the size of the clef
 *  @return this object
 */
- (id)addClefWithName:(NSString*)clefName size:(NSString*)size
{
    self.clefName = clefName;
    MNClef* clef = [MNClef clefWithName:clefName size:size];
    [self addModifier:clef];
    return self;
}

/*!
 *  adds a clef to the start of this staff
 *  @param clefName   name of the clef. one of
 *                      treble, alto, baritone-c, baritone-f, bass, french, soprano, moveable-c, percussion, soprano,
 *                      subbass, tenor
 *  @param size       the size of the clef
 *  @param annotation a clef annotation
 *  @return this object
 */
- (id)addClefWithName:(NSString*)clefName size:(NSString*)size annotation:(NSString*)annotation
{
    self.clefName = clefName;
    MNClef* clef = [MNClef clefWithName:clefName size:size annotationName:annotation];
    [self addModifier:clef];
    return self;
}

/*!
 *  adds a clef to the end of this staff
 *  @param clefName name of the clef. one of
 *                      treble, alto, baritone-c, baritone-f, bass, french, soprano, moveable-c, percussion, soprano,
 *                      subbass, tenor
 *  @param size     the size of the clef
 *  @return this object
 */
- (id)addEndClefWithName:(NSString*)clefName size:(NSString*)size
{
    self.clefName = clefName;
    [self addEndModifier:[MNClef clefWithName:clefName size:size]];
    return self;
}

/*!
 *  adds a clef to the end of this staff
 *  @param clefName   the name of the clef, one of
 *                      treble, alto, baritone-c, baritone-f, bass, french, soprano, moveable-c, percussion, soprano,
 *                      subbass, tenor
 *  @param size       the size of the clef
 *  @param annotation an annotation
 *  @return this object
 */
- (id)addEndClefWithName:(NSString*)clefName size:(NSString*)size annotation:(NSString*)annotation
{
    self.clefName = clefName;
    [self addEndModifier:[MNClef clefWithName:clefName size:size annotationName:annotation]];
    return self;
}

/*!
 *  adds a time signature to the start
 *  @param signature time signature name
 *  @return this object
 */
- (id)addTimeSignatureWithName:(NSString*)signature
{
    //[self addModifier:[[MNTimeSignature alloc] initWithTimeSpec:signature andPadding:0]];

    float padding = 5;
    MNTimeSignature* timeSignature = [[MNTimeSignature alloc] initWithTimeSpec:signature andPadding:padding];
    [self addModifier:timeSignature];
    _glyph_start_x += timeSignature.width;
    return self;
}

/*!
 *  adds a time signature to the end
 *  @param signature time signature name
 *  @return this object
 */
- (id)addEndTimeSignatureWithName:(NSString*)signature
{
    float padding = 5;
    MNTimeSignature* timeSignature = [[MNTimeSignature alloc] initWithTimeSpec:signature andPadding:padding];
    [self addEndModifier:timeSignature];
    _glyph_end_x -= timeSignature.width;
    return self;
}

/*!
 *  adds a time signature to the start
 *  @param signature time signature name
 *  @param padding   amount of space between time siganture and next glyph
 *  @return this object
 */
- (id)addTimeSignatureWithName:(NSString*)signature padding:(float)padding
{
    MNTimeSignature* timeSignature = [[MNTimeSignature alloc] initWithTimeSpec:signature andPadding:padding];
    [self addModifier:timeSignature];
    _glyph_start_x += timeSignature.width;
    return self;
}

/*!
 *  adds a time signature to the start
 *  @param signature time signature object
 *  @param padding   amount of space between time siganture and next glyph
 *  @return this object
 */
- (id)addTimeSignature:(MNTimeSignature*)signature padding:(float)padding
{
    signature.padding = padding;
    [self addModifier:signature];
    _glyph_start_x += signature.width;
    return self;
}

/*!
 *  adds a time signature to the end
 *  @param signature     time signature object
 *  @return this object
 */
- (id)addEndTimeSignature:(MNTimeSignature*)signature
{
    [self addEndModifier:signature];
    return self;
}

#pragma mark Draw Methods
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Draw
 * ---------------------------------------------------------------------------------------------------------------------
 */

/*!
 *  draw line numbers for debugging
 */
- (void)drawLineNumbers
{
    float x = self.boundingBox.xPosition;
    float y;
    float w = self.width;   // self.boundingBox.width;

    for(NSUInteger line = 0; line < self.options.numLines; line++)
    {
        y = [self getYForLine:line];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = kCTTextAlignmentLeft;
        MNFont* font1 = [MNFont fontWithName:@"TimesNewRomanPS-BoldMT" size:8];
        NSString* text = [NSString stringWithFormat:@"%lu, %.01f", line, y];
        NSAttributedString* title = [[NSAttributedString alloc]
            initWithString:text
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];
        [title drawAtPoint:CGPointMake(x + w + 10, y - 5)];
    }

    NSArray* arr = @[ @(-1), @(5) ];
    for(NSNumber* n in arr)
    {
        NSInteger line = [n floatValue];
        float y = [self getYForLine:line];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = kCTTextAlignmentLeft;
        MNFont* font1 = [MNFont fontWithName:@"TimesNewRomanPS-BoldMT" size:8];
        NSString* text = [NSString stringWithFormat:@"%li, %.01f", line, y];
        NSAttributedString* title = [[NSAttributedString alloc]
            initWithString:text
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];
        [title drawAtPoint:CGPointMake(x + w + 10, y - 5)];
    }
}

/*!
 *  draw everything
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    [self.strokeColor setStroke];
    [self.fillColor setFill];
    //    [MNColor.blackColor setStroke];
    //    [MNColor.blackColor setFill];

    float x = self.boundingBox.xPosition;
    float y;
    float w = self.width;   // self.boundingBox.width;

    // draw horizontal lines
    MNBezierPath* path;
    for(NSUInteger line = 0; line < self.options.numLines; line++)
    {
        y = [self getYForLine:line];
        if([[(self.options.lineConfig[line])objectForKey:@"visible"] boolValue])
        {
            path = (MNBezierPath*)[MNBezierPath bezierPathWithRect:CGRectMake(x, y, w, kSTAFF_LINE_THICKNESS)];
            [path fill];
            //                        CGContextBeginPath(ctx);
            //                        CGContextMoveToPoint(ctx, x, y);
            //                        CGContextAddRect(ctx, CGRectMake(x, y, w, 1));
            //                        CGContextDrawPath(ctx, kCGPathFillStroke);
        }
    }

    //    [self drawLineNumbers];

    // Render glyphs
    x = self.glyph_start_x;
    for(NSUInteger i = 0; i < self.glyphs.count; ++i)
    {
        MNGlyph* glyph = self.glyphs[i];
        MNMetrics* metrics = glyph.metrics;
        //        [glyph renderWithContext:ctx atX:x atY:[self getYForGlyphs]];
        [glyph renderWithContext:ctx toStaff:self atX:x];
        x += metrics.width;
    }

    // Render end glyphs
    x = self.glyph_end_x;
    for(NSUInteger i = 0; i < self.endGlyphs.count; ++i)
    {
        MNGlyph* glyph = self.endGlyphs[i];
        MNMetrics* metrics = glyph.metrics;
        x -= metrics.width;
        //        [glyph renderWithContext:ctx atX:x atY:[self getYForGlyphs]];
        [glyph renderWithContext:ctx toStaff:self atX:x];
    }

    //    [[self.modifiers filter:^BOOL(MNModifier* modifier) {
    //      return [modifier isKindOfClass:[MNTimeSignature class]];
    //    }] foreach:^(MNTimeSignature* staffModifier, NSUInteger index, BOOL* stop) {
    //      [staffModifier drawWithContext:ctx toStaff:self withShiftX:[self getModifierXShift]];
    //    }];

    // Draw the modifiers (bar lines, coda, segno, repeat brackets, etc.)
    [[self.modifiers filter:^BOOL(MNModifier* modifier) {
      return YES;   //[modifier isKindOfClass:[MNStaffModifier class]];
    }] foreach:^(MNStaffModifier* staffModifier, NSUInteger index, BOOL* stop) {
      [staffModifier drawWithContext:ctx toStaff:self withShiftX:[self getModifierXShift]];
    }];

    [[self.modifiers filter:^BOOL(MNModifier* modifier) {
      return ([modifier isKindOfClass:[MNStaffText class]]);
    }] foreach:^(MNStaffText* staffText, NSUInteger index, BOOL* stop) {
      [staffText drawWithContext:ctx toStaff:self];
    }];

    // Render measure numbers
    if(self.measure > 0)
    {
        float y = [self getYForTopText];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = kCTTextAlignmentLeft;
        MNFont* font1 = [MNFont fontWithName:@"TimesNewRomanPS-BoldMT" size:10];
        NSString* text = [NSString stringWithFormat:@"%lu", self.measure];
        NSAttributedString* title = [[NSAttributedString alloc]
            initWithString:text
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1.font}];
        [title drawInRect:CGRectMake(self.x, y - 3, 50, 100)];
    }
}

- (void)drawVertical:(CGContextRef)ctx x:(float)x
{
    [self drawVertical:ctx x:x isDouble:NO];
}

- (void)drawVertical:(CGContextRef)ctx x:(float)x isDouble:(BOOL)isDouble
{
    [self drawVerticalFixed:ctx x:(self.x + x)isDouble:isDouble];
}

- (void)drawVerticalFixed:(CGContextRef)ctx x:(float)x isDouble:(BOOL)isDouble
{
    float top_line = [self getYForLine:0];
    float bottom_line = [self getYForLine:(self.options.numLines - 1)];
    if(isDouble)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rectangle = CGRectMake(x - 3, top_line, 1, bottom_line - top_line + 1);
        CGPathAddRect(path, NULL, rectangle);
        CGContextAddPath(ctx, path);
        [self.strokeColor setStroke];
        [self.fillColor setFill];
        CGContextSetLineWidth(ctx, 1.0f);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        CGPathRelease(path);
    }
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rectangle = CGRectMake(x, top_line, 1, bottom_line - top_line + 1);
    CGPathAddRect(path, NULL, rectangle);
    CGContextAddPath(ctx, path);
    [self.strokeColor setStroke];
    [self.fillColor setFill];
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGPathRelease(path);
}

- (void)drawVerticalBar:(CGContextRef)ctx x:(float)x
{
    [self drawVerticalBarFixed:ctx x:(self.x + x)];
}

- (void)drawVerticalBarFixed:(CGContextRef)ctx x:(float)x
{
    float top_line = [self getYForLine:0];
    float bottom_line = [self getYForLine:(self.options.numLines - 1)];
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rectangle = CGRectMake(x, top_line, 1, bottom_line - top_line + 1);
    CGPathAddRect(path, NULL, rectangle);
    CGContextAddPath(ctx, path);
    [self.strokeColor setStroke];
    [self.fillColor setFill];
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGPathRelease(path);
}

- (void)drawBoundingBox:(CGContextRef)ctx
{
    //    MNBoundingBox* box = [MNBoundingBox boundingBoxWithRect:_boundingBox.rect];
    //    box.yPosition = [self getYForLine:0] - 10;
    //    box.xPosition -= 10;
    //    box.height += 20;
    //    box.width += 20;
    float y = [self getYForLine:0] - 10;
    //    float height = ABS(y - [self getYForLine:self.options.numLines]);
    MNBoundingBox* box = [MNBoundingBox boundingBoxAtX:self.x - 10 atY:y withWidth:self.width + 20 andHeight:0];
    box.height = self.options.pointsBetweenLines * (1 + self.options.numLines);

    [box draw:ctx];
}

@end
