//
//  MNAccidental.h
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

#import "MNStaffModifier.h"
#import "MNOptions.h"

@class MNKeySignature, MNStaffNote;

/*!
 *  The `MNAccidental` class inherits from `Modifier`, and is formatted within a
     `MNModifierContext`.
     
     In music, an accidental is a note whose pitch (or pitch class) is not a member of a scale
     or mode indicated by the most recently applied key signature. In musical notation, the
     sharp (♯), flat (♭), and natural (♮) symbols are used to mark such notes, and those
     symbols may themselves be called accidentals. In the measure (bar) in which it appears,
     an accidental sign raises or lowers the following notes from their normal pitch,
     overriding sharps or flats (or their absence) in the key signature. A note is usually
     raised or lowered by a semitone, although microtonal music may use "fractional" accidental
     signs. One occasionally sees double sharps or flats, which raise or lower the indicated
     note by a whole tone. Accidentals apply within the measure and octave in which they
     appear, unless canceled by another accidental sign, or tied into a following measure.
     
     ...the first seven letters of the alphabet represent the basic diatonic pitches, with
     additional symbols called accidentals. In addition to the sharp (♯) and flat (♭) used
     in Europe to indicate the displacement of a scale degree by a semitone up or down,
     respectively, Arabic theorists have added accidentals representing a lowering of a
     pitch by a quarter-tone () and raising it by a quarter-tone sharp (). (Iranians use
     different symbols.)
     —Alves (2008)[1]
     
     The modern accidental signs derive from the round and square small letter b used in
     Gregorian chant manuscripts to signify the two pitches of B, the only note that could
     be altered. The round b became the flat sign, while the square b diverged into the sharp
     and natural signs.
     Sometimes the black keys on a musical keyboard are called accidentals or sharps, and the
     white keys are called naturals.[2]
 */
@interface MNAccidental : MNStaffModifier
{
   @private
    BOOL _cautionary;
}
#pragma mark - Properties
@property (assign, nonatomic) float line;
@property (assign, nonatomic) float flat_line;
@property (assign, nonatomic) float dbl_sharp_line;
@property (assign, nonatomic) NSUInteger num_acc;
@property (assign, nonatomic) NSUInteger column;
@property (strong, nonatomic) NSDictionary* accidentalDict;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSMutableDictionary* accidentalCodes;
/*!
 *  If called, draws parenthesis around accidental.
 *  @return this object
 */
- (id)setAsCautionary;
- (id)setAsCautionary:(BOOL)cautionary;
@property (assign, nonatomic) NSDictionary* paren_left;
@property (assign, nonatomic) NSDictionary* paren_right;
@property (assign, nonatomic) float shift;
@property (assign, nonatomic) float shiftRight;
@property (assign, nonatomic) float shiftDown;
@property (assign, nonatomic) float gracenoteWidth;
#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

/*!
 *  gets an accidental for attaching to a note
 *  @param type the type of accidental specified by one of the following:
 *    #
 *    ##
 *    b
 *    b
 *    n
 *    {
 *    }
 *    db
 *    d
 *    bb
 *    ++
 *    +
 *  @return an accidental object
 */
+ (MNAccidental*)accidentalWithType:(NSString*)type;

/*!
 *  sets the staffnote for this accidental
 *  @param note parent note of accidental
 *  @return this object
 */
- (id)setNote:(MNStaffNote*)note;

/*!
 *  Use this method to automatically apply accidentals to a set of `voices`.
 *  The accidentals will be remembered between all the voices provided.
 *  Optionally, you can also provide an initial `keySignature`.
 *  @param voices       a collection of voices
 *  @param keySignature the key signature
 */
+ (void)applyAccidentals:(NSArray*)voices withKeySignature:(NSString*)keySignature;

@end
