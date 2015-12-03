//
//  MNKeySignature.h
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

@class MNClef, MNStaff, MNAccidental;

/*!
 *  The `MNKeySignature` class implements key signatures.
 *
 *  In musical notation, a key signature is a set of sharp or flat symbols placed together on the staff.
 *  Key signatures are generally written immediately after the clef at the beginning of a line of
 *  musical notation, although they can appear in other parts of a score, notably after a double
 *  barline.
 *
 *  A key signature designates notes that are to be played higher or lower than the corresponding natural
 *  notes and applies through to the end of the piece or up to the next key signature. A sharp symbol on
 *  a line or space in the key signature raises the notes on that line or space one semitone above the
 *  natural, and a flat lowers such notes one semitone. Further, a symbol in the key signature affects
 *  all the notes of one letter: for instance, a sharp on the top line of the treble staff applies to
 *  F's not only on that line, but also to F's in the bottom space of the staff, and to any other F's.
 *
 *  An accidental is an exception to the key signature, applying only in the measure in which it appears,
 *  and the choice of key signature can increase or decrease the need for accidentals.
 *
 *  Although a key signature may be written using any combination of sharp and flat symbols, about a dozen
 *  diatonic key signatures are by far the most common, and their use is assumed in much of this
 *  article. A piece scored using a single diatonic key signature and no accidentals contains notes of
 *  at most seven of the twelve pitch classes, which seven being determined by the particular key
 *  signature.
 *
 *  Each major and minor key has an associated key signature that sharpens or flattens the notes which are
 *  used in its scale. However, it is not uncommon for a piece to be written with a key signature that
 *  does not match its key, for example, in some Baroque pieces,[1] or in transcriptions of traditional
 *  modal folk tunes.[2]
 *
 *  http://en.wikipedia.org/wiki/Key_signature
 */
@interface MNKeySignature : MNStaffModifier
{
   @private
    //    NSString* _code;
}

#pragma mark - Properties
@property (assign, nonatomic) float glyphFontScale;

/*! flat or sharp key signature flavor
 */
@property (assign, nonatomic) MNKeySignatureNoteType keyAccType;

/*!
 */
@property (assign, nonatomic) NSUInteger num;

/*! key signature
 * one of:
 * 'C', 'CN', 'C#', 'C##', 'CB', 'CBB', 'D', 'DN', 'D#', 'D##', 'DB', 'DBB', 'E', 'EN', 'E#', 'E##', 'EB',
 * 'EBB', 'F', 'FN', 'F#', 'F##', 'FB', 'FBB', 'G', 'GN', 'G#', 'G##', 'GB', 'GBB', 'A', 'AN', 'A#', 'A##', 'AB', 'ABB',
 * 'B', 'BN', 'B#', 'B##', 'BB', 'BBB', 'R', 'X'
 */
@property (strong, nonatomic) NSString* key;

/*! accidental
 */
@property (strong, nonatomic) NSString* acc;

/*! points between sharps or flats symbols
 */
@property (assign, nonatomic) float spacerPoints;

/*! padding between sharps or flats symbols
 */
@property (strong, nonatomic) MNPadding* spacerPadding;

/*! accidental list
 */
@property (strong, nonatomic) NSMutableArray* accList;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithAcc:(NSString*)acc andNumber:(NSUInteger)num;
- (instancetype)initWithKeySpecifier:(NSArray*)keySpecifier;

/*!
 *  gets a key signature for the specified key
 *  @param key the key
 *  @return a key signature object
 */
+ (MNKeySignature*)keySignatureWithKey:(NSString*)key;

/*!
 *  Add an accidental glyph to the `MNStaff`. `acc` is the data of the
 *  accidental to add. If the `next` accidental is also provided, extra
 *  width will be added to the initial accidental for optimal spacing.
 *  @param staff   staff
 *  @param acc     accidental to add
 *  @param nextAcc the optional next accidenal to add
 */
- (void)addAccToStaff:(MNStaff*)staff acc:(MNAccidental*)acc nextAcc:(MNAccidental*)nextAcc;

/*!
 *  Cancel out a key signature provided in the `spec` parameter. This will
 *  place appropriate natural accidentals before the key signature.
 *  @param spec the key specifier
 *  @return this object
 */
- (id)cancelKey:(NSString*)spec;

/*!
 *  Add the key signature to the `MNStaff`. You probably want to use the
 *  helper method `.addToStave()` instead
 *  @param staff the staff to add the modifier to
 */
- (void)addModifierToStaff:(MNStaff*)staff;

/*!
 *  Add the key signature to the `MNStaff`, if it's the not the `firstGlyph`
 *  a spacer will be added as well.
 *  @param staff      the staff
 *  @param firstGlyph if this is the first glyph
 *  @return this object
 */
- (id)addToStaff:(MNStaff*)staff firstGlyph:(BOOL)firstGlyph;

/*!
 *  Apply the accidental staff line placement based on the `clef` and
 *  the  accidental `type` for the key signature ('# or 'b').
 *  @param clef the clef of the staff
 *  @param type the type of the accidental for the clef
 */
- (void)convertAccLinesWithClef:(MNClef*)clef andType:(NSString*)type;

@end
