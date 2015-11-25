//
//  MNTable.h
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

#import "MNMetrics.h"
#import "MNEnum.h"
#import "MNTableNoteValueStruct.h"
#import "MNTableNoteGlyphStruct.h"

@class MNGlyph, MNAccidental, MNNote, MNKeyProperty, MNRational, MNClef, MNKeySignature, MNStaffNote;
@class MNTableOrnamentCodes, MNTableAccidentalCodes, MNTableNoteInputData, MNTableGlyphStruct, MNTablesNoteStringData;
@class MNGlyphTabStruct;

/*!
    The `MNTables` class has lots data and formatting of music objects.
    It is a singleton but has a dealloc to free resources of C objects
 */
@interface MNTable : NSObject
{
   @private
}

#pragma mark - Class Collections

+ (NSDictionary*)accidentalColumnsTable;
+ (NSDictionary*)accidentalCodes;

+ (NSDictionary*)accidentalsDictionary;

+ (NSDictionary*)articulationsDictionary;

//+ (NSDictionary *)clefPropertiesDictionary;

+ (NSDictionary*)durationAliasesDictionary;

//+ (NSDictionary *)durationCodesDictionary;

/*! note that this is a dictionary of float values
 */
+ (NSDictionary*)durationToTicksDictionary;

/*! piano key frequencies LUT
    http://en.wikipedia.org/wiki/Piano_key_frequencies
 */
+ (float*)frequenciesArray;

/*! the labels on the piano keys LUT
 */
+ (NSArray*)pianoLabels;

+ (NSArray*)integerToNoteArray;

+ (NSDictionary*)integerToNoteDictionary;

//+ (NSDictionary*)keyNoteValuesDictionary;

+ (NSArray*)keyPropertiesArray;

+ (NSDictionary*)keySpecsDictionary;

+ (NSDictionary*)noteGlyphsDictionary;

+ (NSDictionary*)noteTypesDictionary;

//+ (NSDictionary *)pianoKeyForNoteDictionary;

#pragma mark - Class Methods
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Class Methods
 * ---------------------------------------------------------------------------------------------------------------------
 */

+ (NSArray*)accidentalListForAcc:(NSString*)accidental;

+ (void)configureStaffNoteForNote:(MNStaffNote*)note;

//+ (MNGlyph*)durationToGlyph:(NSString*)noteDurationString withNHMRSNoteType:(NSString*)noteTypeString;
//+ (MNGlyph*)durationToGlyph:(MNNoteDurationType)noteDurationType withNHMRSType:(MNNoteNHMRSType)noteNHMRSType;
+ (MNTableGlyphStruct*)durationToGlyphStruct:(NSString*)noteDurationString;
+ (MNTableGlyphStruct*)durationToGlyphStruct:(NSString*)noteDurationString
                         withNHMRSNoteString:(NSString*)noteNHSMSString;
+ (MNTableGlyphStruct*)durationToGlyphStruct:(MNNoteDurationType)noteDurationType
                               withNHMRSType:(MNNoteNHMRSType)noteNHMRSType;

+ (MNGlyphTabStruct*)glyphForTab:(NSString*)fret;

/*!  Take a note in the format "Key/Octave" (e.g., "C/5") and return properties.
 */
+ (MNKeyProperty*)keyPropertiesForKey:(NSString*)key andClef:(MNClefType)clefType andOptions:(NSDictionary*)params;

+ (MNKeySignature*)keySignatureWithString:(NSString*)key;

+ (NSMutableArray*)keySignatureForSpec:(NSString*)spec;

+ (MNTableAccidentalCodes*)objectForAccidental:(NSString*)accidental;

+ (MNMetrics*)metricForArticulation:(NSString*)articulation;

+ (MNNote*)noteForIndex:(NSUInteger)index;

//+ (MNNoteType)noteTypeForTypeString:(NSString *)type;

//+ (MNNote *)parseNoteDurationString:(NSString *)durationString;

//+ (NSString *)noteStringTypeForNoteType:(MNNoteType)noteType;

+ (MNTablesNoteStringData*)parseNoteData:(MNTableNoteInputData*)noteData;

//+ (MNTablesNoteStringData*)parseNoteDurationString:(NSString*)noteStringData;

+ (NSUInteger)textWidthForText:(NSString*)text;

/*! determines the Fraction object for the given duration
 */
+ (MNRational*)ticksForDuration:(NSString*)duration;

/*! determines the note type for the given duration
 */
+ (MNNoteDurationType)noteDurationTypeForDurationString:(NSString*)duration;

+ (BOOL)duration:(NSString*)a greaterThanDuration:(NSString*)b;

/*!
 *   Used to convert duration aliases to the number based duration.
 *    If the input isn't an alias, simply return the input.
 *    example: 'q' -> '4', '8' -> '8'
 *  @param duration note duration
 *  @return duration note duration
 */
+ (NSString*)sanitizeDuration:(NSString*)duration;
+ (NSNumber*)durationToNumber:(NSString*)duration;
+ (MNRational*)durationToFraction:(NSString*)duration;

+ (NSUInteger)durationToTicks:(NSString*)duration;

+ (NSDictionary*)ornamentCodes;

+ (NSString*)articulationCodeForType:(MNArticulationType)type;
//+ (NSDictionary *)articulationsDictionary;

@end
