//
//  MNModifier.h
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

#import "MNDelegates.h"
#import "MNEnum.h"
#import "MNSymbol.h"
#import "MNModifierContext.h"

@class MNModifierContext, MNNote, MNTableGlyphStruct, MNStaffNote;
@class ShiftState, MNMetrics, MNModifierState, MNFont;

/*!
 *  The `MNModifier` class modifies a Staffmodifier. What this means more specifically is that it
 *  can render items to the staff defined by a code, a position and a scale.
 */
@interface MNModifier : MNSymbol <MNTickableDelegate>
{
   @public
    __weak MNNote* _note;
    MNPositionType _positionType;

   @protected
    NSUInteger _intrinsicTicks;
    MNRational* _tickMultiplier;
    MNRational* _ticks;
    //    __weak MNVoice* _voice; // NOTE: weak braeks graceNoteGroups
    MNVoice* _voice;

    MNTuplet* _tuplet;

    //    float _extraLeftPx;    // Extra room on left for offset note head
    //    float _extraRightPx;   // Extra room on right for offset note head

    NSUInteger _index;

    float _absoluteX;
    MNTableGlyphStruct* _glyphStruct;
    id _glyph;

    MNTickContext* _tickContext;

    float _yShift;
    float _xShift;
    BOOL _centerAlign;
    float _center_x_shift;

    MNFont* _font;

    __weak MNStaff* _staff;
}

#pragma mark - Properties
@property (weak, nonatomic) MNStaff* staff;
//@property (weak, nonatomic) MNNote* note;
- (MNNote*)note;
- (id)setNote:(MNNote*)note;

@property (assign, nonatomic) NSUInteger intrinsicTicks;
@property (strong, nonatomic) MNRational* tickMultiplier;
@property (strong, nonatomic) MNRational* ticks;

@property (strong, nonatomic) MNVoice* voice;
//@property (weak, nonatomic) MNVoice* voice; // NOTE: weak breaks graceNoteGroups

@property (strong, nonatomic) NSMutableArray* modifiers;

//@property (strong, nonatomic) MNTuplet* tuplet;
- (MNTuplet*)tuplet;
- (id)setTuplet:(MNTuplet*)tuplet;

// Get and set attached note (`MNStaffNote`, `MNTabNote`, etc.)
//@property (weak, nonatomic)  MNNote *note;
@property (strong, nonatomic, readonly) NSString* category;

// Every modifier must be part of a `ModifierContext`.
@property (strong, nonatomic) MNModifierContext* modifierContext;

// Set the `text_line` for the modifier.
@property (assign, nonatomic) float text_line;

// Shift modifier down `y` pixels. Negative values shift up.
@property (assign, nonatomic) float yShift;
//@property (assign, nonatomic) float xShift;
- (id)setXShift:(float)xShift;
- (float)xShift;

@property (assign, nonatomic) BOOL centerAlign;

@property (assign, nonatomic) float center_x_shift;

//// Get and set articulation position.
//@property (assign, nonatomic) MNPositionType position;

// Get and set note index, which is a specific note in a chord.
@property (assign, nonatomic) NSUInteger index;

@property (strong, nonatomic) MNModifierState* state;

@property (strong, nonatomic) MNFont* font;

@property (strong, nonatomic) MNTickContext* tickContext;

@property (assign, nonatomic) BOOL ignore_ticks;

@property (assign, nonatomic) float extraLeftPx;
@property (assign, nonatomic) float extraRightPx;

@property (strong, nonatomic) MNTableGlyphStruct* glyphStruct;
@property (strong, nonatomic) MNGlyph* glyph;

@property (strong, nonatomic) NSString* code;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (NSString*)CATEGORY;
//- (NSString*)description;
//- (NSString*)prolog;
//- (NSString*)epilog:(NSString*)desc;

+ (BOOL)format:(NSMutableArray<MNModifier*>*)modifiers
         state:(MNModifierState*)state
       context:(MNModifierContext*)context;

- (id)metrics;

- (id)setPosition:(MNPositionType)position;
- (MNPositionType)position;

- (BOOL)preFormat;
- (BOOL)postFormat;
- (BOOL)postFormatWith:(NSArray*)notes;

//- (void)setX_shift:(float)x_shift;

- (void)draw:(CGContextRef)ctx withStaff:(MNStaff*)staff withShiftX:(float)shiftX;

@end
