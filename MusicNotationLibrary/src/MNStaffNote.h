//
//  MNStaffNote.h
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
#import "MNModifier.h"
#import "MNStaff.h"
#import "MNDelegates.h"
#import "MNTableGlyphStruct.h"

@class MNAccidental, MNArticulation, MNPoint;
@class MNAnnotation, MNModifierContext, MNTuplet, MNTableGlyphStruct;
@class MNNoteHeadBounds, MNStaffNoteRenderOptions;

/*! The `MNStaffNote` class calculates the position and renders a note to a staff.

 In music, the term note has two primary meanings:
 A sign used in musical notation to represent the relative duration and pitch of a sound;
 A pitched sound itself.

 Notes are the "atoms" of much Western music: discretizations of musical phenomena that
    facilitate performance, comprehension, and analysis.[1]

 The term note can be used in both generic and specific senses: one might say either "the
    piece 'Happy Birthday to You' begins with two notes having the same pitch," or "the
    piece begins with two repetitions of the same note." In the former case, one uses note
    to refer to a specific musical event; in the latter, one uses the term to refer to a
    class of events sharing the same pitch.

 */
@interface MNStaffNote : MNStemmableNote
{
//    __weak MNStaff* _staff;

    NSString* _category;
    NSString* _positionString;
    NSString* _codeHead;

    NSMutableArray* _accidentals;
    //    NSMutableArray* _dots;
    //    __weak  MNStaff *_staff;

    BOOL _rest;
    BOOL _renderStem;
    float _stemLengthHeight;
    BOOL _use_default_head_x;

    //     MNTuplet* _tuplet;
}

#pragma mark - Properties

//@property (assign, nonatomic)  MNStaff *staff;
- (id)setStaff:(MNStaff*)staff;
- (MNStaff*)staff;

/*! the type of note as a string to access in the tables dictionary
 */
//@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString* position;

/*! spacing between different modifiers and annotations of this note
 */
//@property (strong, nonatomic) StaffNoteOptions *renderOptions;
@property (strong, nonatomic) NSMutableArray* accidentals;
@property (strong, nonatomic) NSMutableArray* note_heads;

//@property (strong, nonatomic) NSArray *notes;

//`````````````````````
// property primitives

@property (assign, nonatomic) BOOL renderStem;

///*! is this note object a rest? YES/NO
// */
//@property (assign, nonatomic, getter = isRest) BOOL rest;

/*! displace note to right? YES/NO
 */
@property (assign, nonatomic, getter=isDisplaced) BOOL notesDisplaced;

/*! the height of the stem
 */
@property (assign, nonatomic) float stemHeight;

/*! allow to manually set note stem length, the length of the stem
    same as the height of the stem
 */
//@property (assign, nonatomic) float stemLength;

/*! height above this note that the dot belongs (this might better
    belong in renderOptions
 */
@property (assign, nonatomic) float dotShiftY;

//@property (assign, nonatomic) NSUInteger numDots;

/*! the width of the note head
 */
@property (assign, nonatomic) float headWidth;

/*! the x-direction offset from the oval that the stem is drawn from the head
 */
@property (assign, nonatomic) float stemOffset;

/*! the stem maximum length
 */
@property (assign, nonatomic) float stemMaxLength;

/*! the stem minimum length
 */
//@property (assign, nonatomic) float stemMinLength;

@property (assign, nonatomic) float yForTopText;

@property (assign, nonatomic) float yForBottomText;

@property (strong, nonatomic) MNNoteHeadBounds* noteHeadBounds;

/*! the staff parent that this note object is drawn to
 *  @note when the staff is set the ys array for the notes is configured
        using the key properties, ie. this is important
 */

///*!  minimum length of stem
// */
//@property (assign, nonatomic) float stemMinumumLength;

/*! the x-position on the staff that the stem occupies
 */
//@property (assign, nonatomic) float stemX;

/*! left-most x-position of note tie
 */
@property (assign, nonatomic) float tieLeftX;

/*! right-most x-position of note tie
 */
@property (assign, nonatomic) float tieRightX;

/*! the line on the staff that this rest object occupies
 */
@property (assign, nonatomic) NSUInteger getLineForRest;

/*!
 */
//@property (assign, nonatomic) float voiceShiftWidth;

//@property (assign, nonatomic) BOOL preFormatted;

@property (assign, nonatomic) BOOL flag;

@property (assign, nonatomic) NSUInteger beamCount;

@property (strong, nonatomic) NSString* codeFlagUpstem;

@property (strong, nonatomic) NSString* codeFlagDownstem;

@property (assign, nonatomic) BOOL isSlash;
@property (assign, nonatomic) BOOL isSlur;
@property (assign, nonatomic) BOOL use_default_head_x;

@property (nonatomic, copy) StyleBlock styleBlock;

//@property (strong, nonatomic) NSMutableArray* keyProps;   // the properties for all the keys in the note

@property (assign, nonatomic) float octaveShift;
@property (strong, nonatomic) NSString* clefName;

#pragma mark - Methods
//- (instancetype)initWithNote:(MNNote *)note;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

//+ (MNStaffNote *)noteWithDict:(NSDictionary *)dict;
//+ (MNStaffNote *)noteWithNote:(MNNote *)note;
+ (MNStaffNote*)noteWithKeys:(NSArray*)keys andDuration:(NSString*)duration;
+ (MNStaffNote*)noteWithKeys:(NSArray*)keys andDuration:(NSString*)duration autoStem:(BOOL)autoStem;
+ (MNStaffNote*)noteWithKeys:(NSArray*)keys andDuration:(NSString*)duration andClef:(NSString*)clef;
+ (MNStaffNote*)noteWithKeys:(NSArray*)keys
                 andDuration:(NSString*)duration
                     andClef:(NSString*)clef
                 octaveShift:(float)octaveShift;
//+ (MNStaffNote *)noteWithKeys:(NSArray*)keys andDuration:(NSString *)duration autoStem:(BOOL)autoStem;
+ (MNStaffNote*)noteWithKeys:(NSArray*)keys andDuration:(NSString*)duration dots:(NSUInteger)dots;
+ (MNStaffNote*)noteWithKeys:(NSArray*)keys andDuration:(NSString*)duration type:(NSString*)type;
+ (MNStaffNote*)noteWithKeys:(NSArray*)keys andDuration:(NSString*)duration dots:(NSUInteger)dots type:(NSString*)type;

//+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state;

- (float)getYForTopText:(float)textLine;
- (float)getYForBottomText:(float)textLine;
- (MNPoint*)getModifierstartXYforPosition:(MNPositionType)position andIndex:(NSUInteger)index;

- (void)setKeyLine:(NSUInteger)index withLine:(NSUInteger)line;
- (float)getLineNumber:(BOOL)is_top_note;

- (float)tieRightX;
- (float)tieLeftX;

- (MNStaffNote*)addAccidental:(MNAccidental*)accidental atIndex:(NSUInteger)index;
- (id)addArticulation:(MNArticulation*)articulation;
- (id)addArticulation:(MNArticulation*)articulation atIndex:(NSUInteger)index;

- (id)addAnnotation:(MNAnnotation*)annotation atIndex:(NSUInteger)index;
- (id)addDotAtIndex:(NSUInteger)index;

- (MNStaffNote*)addDotToAll;

+ (BOOL)formatByY:(NSMutableArray*)notes state:(MNModifierState*)state;
//- (BOOL)preFormat;
//- (BOOL)postFormat:(NSArray*)notes;
+ (BOOL)postFormat:(NSMutableArray*)modifiers;

- (NSArray*)getDots;

//- (void)drawStem:(CGContextRef)ctx withStem:(MNStem*)stemStruct;

+ (MNStaffNote*)showNoteWithDictionary:(NSDictionary*)noteStruct
                           withContext:(CGContextRef)ctx
                               onStaff:(MNStaff*)staff
                                   atX:(float)x;
// CALayer Methods
//- (CGMutablePathRef)path;
- (CAShapeLayer*)shapeLayer;

#if TARGET_OS_IPHONE
+ (UIImage*)imageForNoteWithDictionary:(NSDictionary*)noteStruct rect:(CGRect)rect;
+ (UIImage*)imageForNote:(MNStaffNote*)note rect:(CGRect)rect;
#endif

@end
