//
//  MNBeam.h
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

#import "MNModifier.h"
#import "MNStaffNote.h"

@class MNModifierContext, MNVoice, MNRational, MNBeamConfig;

/*! The `MNBeam` class
 *  creates a new beam from the specified notes. The notes must
 *  be part of the same line, and have the same duration (in ticks).
 */
@interface MNBeam : MNModifier
{
   @private
    NSArray* _notes;
    BOOL _unbeamable;
    BOOL _autoStem;
    MNStemDirectionType _stemDirection;
    NSUInteger _beamCount;
    float _beamWidth;
    float _partialBeamLength;
}

#pragma mark - Properties
@property (strong, nonatomic) NSArray* notes;
@property (assign, nonatomic) BOOL unbeamable;
@property (assign, nonatomic) BOOL autoStem;
@property (assign, nonatomic) MNStemDirectionType stemDirection;
@property (assign, nonatomic, getter=getBeamCount) NSUInteger beamCount;
@property (assign, nonatomic) float beamWidth;
@property (assign, nonatomic) float partialBeamLength;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNotes:(NSArray*)notes;
- (instancetype)initWithNotes:(NSArray*)notes autoStem:(BOOL)autoStem;

+ (MNBeam*)beamWithNotes:(NSArray*)notes;
+ (MNBeam*)beamWithNotes:(NSArray*)notes autoStem:(BOOL)autoStem;
- (id)breakSecondaryAt:(NSArray*)indices;

+ (NSArray*)getDefaultBeamGroupsForTimeSignatureType:(MNTimeType)timeType;
//+ (NSArray*)getDefaultBeamGroupsForTimeSignatureName:(NSString*)timeType;

+ (NSArray<MNBeam*>*)applyAndGetBeams:(MNVoice*)voice;
+ (NSArray<MNBeam*>*)applyAndGetBeams:(MNVoice*)voice groups:(NSArray*)groups;
+ (NSArray<MNBeam*>*)applyAndGetBeams:(MNVoice*)voice
                            direction:(MNStemDirectionType)stem_direction
                               groups:(NSArray*)groups;
+ (NSArray<MNBeam*>*)generateBeams:(NSArray*)notes withDictionary:(NSDictionary*)config;

@end
