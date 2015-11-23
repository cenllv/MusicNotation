//
//  MNMusic.h
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



#import "IAModelBase.h"

@class RootAccidentalTypeStruct, MNMusicScales, /*MNMusicRootIndices,*/ MNMusicDiatonicAccidentals;

/*! The `MNMusic` class implements some standard music theory routines.
 */
@interface MNMusic : NSObject
{
}

#pragma mark - Properties
//@property (strong, nonatomic) NSArray *roots;
//@property (strong, nonatomic) NSArray *rootValues;
//@property (strong, nonatomic) NSDictionary *rootIndices;
//@property (strong, nonatomic) NSArray *canonicalNotes;
//@property (strong, nonatomic) NSArray *diatonicIntervals;
//@property (strong, nonatomic) NSDictionary *diatonicAccidentals;
//@property (strong, nonatomic) NSDictionary *intervals;
//@property (strong, nonatomic) NSDictionary *scales;
//@property (strong, nonatomic) NSArray *accidentals;
//@property (strong, nonatomic) NSDictionary *noteValues;

#pragma mark - Methods
+ (id)sharedManager;

+ (NSArray*)roots;
+ (NSArray*)rootValues;
+ (NSDictionary*)rootIndices;
+ (NSArray*)canonicalNotes;
+ (NSArray*)diatonicIntervals;
+ (MNMusicDiatonicAccidentals*)diatonicAccidentalsObject;
+ (NSDictionary*)intervals;
+ (MNMusicScales*)scales;
+ (NSArray*)accidentals;
+ (NSDictionary*)noteValues;

+ (BOOL)isValidNoteValue:(NSInteger)note;
+ (BOOL)isValidIntervalValue:(NSInteger)interval;

+ (RootAccidentalTypeStruct*)getNoteParts:(NSString*)noteString;
+ (RootAccidentalTypeStruct*)getKeyParts:(NSString*)keyString;
+ (NSUInteger)getNoteValue:(NSString*)noteString;
+ (NSArray*)getIntervalValue:(NSString*)intervalString;

+ (NSString*)getCanonicalNoteName:(NSUInteger)noteValue;
+ (NSString*)getCanonicalIntervalName:(NSUInteger)intervalValue;
+ (NSUInteger)getRelativeNoteValueForNoteValue:(NSUInteger)noteValue
                              forIntervalValue:(NSUInteger)intervalValue
                                  andDirection:(NSInteger)direction;
+ (NSString*)getRelativeNoteNameForRoot:(NSString*)root andNoteValue:(NSUInteger)noteValue;
+ (NSArray*)getScaleTonesForKey:(NSUInteger)key andIntervals:(NSArray*)intervals;
+ (NSUInteger)getIntervalBetweenNote:(NSUInteger)note
                        andOtherNote:(NSUInteger)otherNote
                       withDirection:(NSInteger)direction;
+ (NSMutableDictionary*)createScaleMap:(NSString*)keySignature;

@end

@interface RootAccidentalTypeStruct : IAModelBase 
@property (strong, nonatomic) NSString* root;
@property (strong, nonatomic) NSString* accidental;
@property (strong, nonatomic) NSString* type;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end