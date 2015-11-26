//
//  MNTabNote.h
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

#import "MNStemmableNote.h"
//#import "MNOptions.h"
#import "MNTabNoteRenderOptions.h"
#import "MNTabNotePositionsStruct.h"

@class MNGhostNote, MNTabStaff, MNAnnotation;

/*! The `MNTabNote` implements notes for Tablature notation. This consists of one or
  more fret positions, and can either be drawn with or without stems.

 */
@interface MNTabNote : MNStemmableNote

#pragma mark - Properties
@property (strong, nonatomic) MNGhostNote* ghostNote;
@property (assign, nonatomic) BOOL ghost;
//@property (weak, nonatomic) MNStaff* staff;
@property (strong, nonatomic) NSArray* positionsCollection;   // positions for the notes in a chord
@property (strong, nonatomic) NSArray* positions;
@property (assign, nonatomic, getter=getStemY) float stemY;
@property (assign, nonatomic, getter=getStemX) float stemX;
@property (strong, nonatomic) NSArray* stem_extents;
//@property (strong, nonatomic) TabNoteOptions *renderOptions;
@property (strong, nonatomic) NSMutableArray* glyphs;   // array of  MNGlyphTabStruct
//@property (weak, nonatomic) MNTabStaff* staff; //FIXME:rename to tabStaff?
@property (weak, nonatomic) MNTabStaff* tabStaff;
//@property (strong, nonatomic)  MNTablesGlyphStruct* glyphStruct;
//@property (strong, nonatomic) MNFont* font;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

- (MNTabNoteRenderOptions*)renderOptions;

//- (void)setGhost:(MNGhostNote*)ghost;
//- (BOOL)hasStem;
//- (float)getStemExtension;
/*!
 *  Add a dot to the note
 *  @return this object
 */
- (id)addDot;
- (id)addAnnotation:(MNAnnotation*)annotation atIndex:(NSUInteger)index;
- (id)addStroke:(MNStroke*)stroke atIndex:(NSUInteger)index;

//- (void)updateWidth;
//- (void)setStaff:(MNStaff*)staff;
//- (NSArray*)getPositions;
//- (void)addToModifierContext:(MNModifierContext*)mc;
//- (float)getTieRightX;
//- (float)getTieLeftX;
- (float)tieRightX;
- (float)tieLeftX;

//- (MNPoint*)getModifierStartXY;
//- (BOOL)preFormat;
//- (float)getLineForRest;
//- (float)getStemX;
//- (float)getStemY;
//
//- (NSArray*)getStemExtents;
//- (void)drawFlag:(CGContextRef)ctx;
//- (void)drawModifiers:(CGContextRef)ctx;
//- (void)drawStemThrough:(CGContextRef)ctx;
//- (void)drawPositions:(CGContextRef)ctx;
//- (void)draw:(CGContextRef)ctx;

@end
