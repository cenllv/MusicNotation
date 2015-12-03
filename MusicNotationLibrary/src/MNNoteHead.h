//
//  MNNoteHead.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
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


#import "MNNote.h"
#import "MNOptions.h"
#import "MNRenderOptions.h"
#import "MNEnum.h"
#import "MNPoint.h"

@class MNBoundingBox, MNColor, MNStaffNote, MNStaff;
@class MNNoteHeadRenderOptions, MNTableGlyphStruct;

/*! The `MNNoteHead` implements `NoteHeads`. `NoteHeads` are typically not manipulated
  directly, but used internally in `MNStaffNote`.
 */
@interface MNNoteHead : MNNote
{
   @private
    //    __weak MNStaff* _staff;
    //    float _x;
    //    float _y;
}
#pragma mark - Properties

// Determine if the notehead is displaced
//@property (assign, nonatomic) BOOL displaced;

// Get/set the notehead's style
@property (assign, nonatomic) BOOL shadowBlur;
@property (strong, nonatomic) MNColor* shadowColor;
@property (strong, nonatomic) MNColor* fillColor;
@property (strong, nonatomic) MNColor* strokeColor;

// Set the X coordinate
@property (assign, nonatomic) float x;

// get/set the Y coordinate
@property (assign, nonatomic) float y;

// Get/set the stave line the notehead is placed on
//@property (assign, nonatomic) float line;

@property (assign, nonatomic) BOOL useCustomGlyph;
@property (strong, nonatomic) NSString* customGlyphCode;

//@property (assign, nonatomic) float extraLeftPx;
//@property (assign, nonatomic) float extraRightPx;

// Get/set the notehead's style
//
// `style` is an `object` with the following properties: `shadowColor`,
// `shadowBlur`, `fillStyle`, `strokeStyle`
@property (strong, nonatomic) NSDictionary* style;

@property (assign, nonatomic) MNStemDirectionType stemDirection;

// TODO: make sure style applied when drawn
@property (nonatomic, copy) StyleBlock styleBlock;

//@property (weak, nonatomic) MNStaff* staff;

//@property (strong, nonatomic) NoteHeadOptions *headRenderOptions;
@property (strong, nonatomic) NSString* noteTypeString;
//@property (assign, nonatomic)  MNNoteNHMRSType noteNHMRSType;
@property (strong, nonatomic) NSString* noteName;
//@property (assign, nonatomic) MNNoteDurationType noteDurationType;
//@property (strong, nonatomic) NSString* duration;
@property (strong, nonatomic) NSString* glyph_code;

//@property (assign, nonatomic) NSInteger index;
//@property (assign, nonatomic) MNNoteType note_type;
@property (assign, nonatomic) BOOL slashed;
//@property (assign, nonatomic) BOOL displaced;
@property (assign, nonatomic) MNStemDirectionType stem_direction;
@property (assign, nonatomic) BOOL custom_glyph;
//@property (assign, nonatomic, setter=setGlyphFontScale:) float glyphFontScale;
//@property (strong, nonatomic)  MNTablesGlyphStruct* glyphStruct;

@property (assign, nonatomic) float headWidth;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

+ (MNNoteHead*)noteHeadWithOptionsDict:(NSDictionary*)optionsDict;

@end
