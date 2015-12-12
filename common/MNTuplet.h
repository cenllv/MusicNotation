//
//  MNTuplet.h
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

#import "MNEnum.h"
#import "MNDelegates.h"
#import "MNModifier.h"

@class MNPoint;

/*! The `Tuplet` class configures tuplets.
 *
 *  http://piano.about.com/od/musicaltermsa1/g/GL_tuplet.htm
 *
 *  A tuplet is note-grouping that is played inside the length of another note-value; a division
 *  of musical time that allows for irrational rhythm.
 *  A tuplet is grouped together by a beam, slur, or bracket, and is marked with a small number or
 *  ratio. Tuplets may contain an even or uneven number of notes:
 *
 *  Duplet (2 notes): An eighth-note duplet spans the length of three normal eighth notes.
 *
 *  Triplet (3): An eighth-note triplet spans one quarter-note.
 *
 *  Quadruplet (4): An eighth-note quadruplet spans three or six eighth-notes.
 *
 *  Quintuplet (5): Commonly played in the length of four of its note-type.
 *
 *  Sextuplet (6): Six notes in place of four. In some rhythmic patterns, sextuplets may be
 *  indistinguishable from triplets, leaving it disputed among theorists. The exact placement of the
 *  downbeat(s) inside a sextuplet can be modified using horizontal brackets.
 *
 *  Septuplet (7): Seven notes played in the time of four, six, or eight; specified by a ratio (7:6, 7:8,
 *  respectively. 7:4 is implied in common time).
 *
 *  https://en.wikipedia.org/wiki/Tuplet
 *
 */
@interface MNTuplet : MNModifier
{
   @private
    BOOL _bracketed;
    BOOL _ratioed;
    NSUInteger _numNotes;
}

#pragma mark - Properties

@property (assign, nonatomic) NSUInteger beatsOccupied;
@property (assign, nonatomic) MNTupletLocationType tupletLocation;
@property (strong, nonatomic) NSMutableArray* notes;
@property (assign, nonatomic) float points;
@property (strong, nonatomic) MNPoint* position;   // TODO: refactor maybe? redefinition from Modifier.position
@property (strong, nonatomic) NSMutableArray* numeratorGlyphs;
@property (strong, nonatomic) NSMutableArray* denominatorGlyphs;
@property (assign, nonatomic, readonly, getter=getNoteCount) NSUInteger noteCount;
- (NSUInteger)getNoteCount;
- (id)setBracketed:(BOOL)bracketed;
- (id)setRatioed:(BOOL)ratioed;

#pragma mark - Methods

/*!
 *  Create a new tuplet from the specified notes. The notes must
 *  be part of the same line, and have the same duration (in ticks).
 */
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNotes:(NSArray*)notes;
- (instancetype)initWithNotes:(NSArray*)notes andOptionsDict:(NSDictionary*)optionsDict;

@end
