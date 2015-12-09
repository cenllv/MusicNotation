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
 *  The `MNTables` class has lots of data and formatting tables for `"MN"-Classes`.
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
+ (NSDictionary*)keySpecsDictionary;
+ (NSDictionary*)ornamentCodes;
//+ (NSDictionary*)textNoteGlyphs;
+ (NSDictionary*)unicode;
+ (NSArray*)integerToNoteArray;

#pragma mark - Class Methods

+ (MNTableGlyphStruct*)durationToGlyphStruct:(NSString*)noteDurationString;
+ (MNTableGlyphStruct*)durationToGlyphStruct:(NSString*)noteDurationString
                         withNHMRSNoteString:(NSString*)noteNHSMSString;
+ (MNTableGlyphStruct*)durationToGlyphStruct:(MNNoteDurationType)noteDurationType
                               withNHMRSType:(MNNoteNHMRSType)noteNHMRSType;
+ (MNGlyphTabStruct*)glyphForTab:(NSString*)fret;
+ (MNKeyProperty*)keyPropertiesForKey:(NSString*)key;
+ (MNKeyProperty*)keyPropertiesForKey:(NSString*)key andClef:(MNClefType)clefType andOptions:(NSDictionary*)params;
//+ (MNKeySignature*)keySignatureWithString:(NSString*)key;
+ (NSMutableArray*)keySignatureForSpec:(NSString*)spec;
+ (MNTablesNoteStringData*)parseNoteData:(MNTableNoteInputData*)noteData;
+ (NSNumber*)durationToNumber:(NSString*)duration;
+ (MNRational*)durationToFraction:(NSString*)duration;
+ (NSUInteger)durationToTicks:(NSString*)duration;
+ (NSString*)articulationCodeForType:(MNArticulationType)type;

@end
