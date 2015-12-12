//
//  MNFormatter.h
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

#import "MNUtils.h"
#import "IAModelBase.h"

@class MNRational, MNStaff, MNTabStaff, MNBoundingBox, MNFormatterContext, MNVoice;

/*!
 *  The `MNFormatter` class implements the formatting and layout algorithms that are used
 *  to position notes in a voice. The algorithm can align multiple voices both
 *  within a stave, and across multiple staves.
 *
 *  To do this, the formatter breaks up voices into a grid of rational-valued
 *  `ticks`, to which each note is assigned. Then, minimum widths are assigned
 *  to each tick based on the widths of the notes and modifiers in that tick. This
 *  establishes the smallest amount of space required for each tick.
 *
 *  Finally, the formatter distributes the left over space proportionally to
 *  all the ticks, setting the `x` values of the notes in each tick.
 */
@interface MNFormatter : IAModelBase

#pragma mark - Properties

@property (assign, nonatomic) float minTotalWidth;
@property (assign, nonatomic) BOOL hasMinTotalWidth;

/*! points occupied per tick per measure
 */
@property (assign, nonatomic) float pixelsPerTick;
@property (strong, nonatomic) MNRational* totalTicks;
@property (assign, nonatomic) float perTickableWidth;

/*! maximal extra width that a tickable may occupy
 */
@property (assign, nonatomic) float maxExtraWidthPerTickable;

@property (assign, nonatomic) BOOL autoBeam;
@property (assign, nonatomic) BOOL alignRests;

@property (strong, nonatomic) MNFormatterContext* tContexts;
@property (strong, nonatomic) MNFormatterContext* mContexts;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNFormatter*)formatter;

+ (MNBoundingBox*)formatAndDrawWithContext:(CGContextRef)ctx
                                 dirtyRect:(CGRect)dirtyRect
                                   toStaff:(MNStaff*)staff
                                 withNotes:(NSArray*)notes;

+ (MNBoundingBox*)formatAndDrawWithContext:(CGContextRef)ctx
                                 dirtyRect:(CGRect)dirtyRect
                                   toStaff:(MNStaff*)staff
                                 withNotes:(NSArray*)notes
                                withParams:(NSDictionary*)params;

+ (MNBoundingBox*)formatAndDrawWithContext:(CGContextRef)ctx
                                 dirtyRect:(CGRect)dirtyRect
                                   toStaff:(MNStaff*)staff
                                 withNotes:(NSArray*)notes
                          withJustifyWidth:(float)justifyWidth;

+ (BOOL)formatAndDrawTabWithContext:(CGContextRef)ctx
                          dirtyRect:(CGRect)dirtyRect
                       withTabStaff:(MNTabStaff*)staff
                       withTabStaff:(MNTabStaff*)tabStaff
                        andTabNotes:(NSArray*)tabNotes
                           andNotes:(NSArray*)notes
                            andBeam:(BOOL)autobeam
                         withParams:(NSDictionary*)params;

+ (void)alignRestsToNotes:(NSArray*)notes withNoteAlignment:(BOOL)alignAllNotes andTupletAlignment:(BOOL)alignTuplets;

+ (void)alignRests:(NSArray<MNVoice*>*)voices alignAllNotes:(BOOL)alignAllNotes;

- (float)preCalculateMinTotalWidth:(NSArray<MNVoice*>*)voices;

- (float)getMinTotalWidth;

- (MNFormatterContext*)createModifierContexts:(NSArray<MNVoice*>*)voices;
- (MNFormatterContext*)createTickContexts:(NSArray<MNVoice*>*)voices;

- (BOOL)preFormatWithContext:(CGContextRef)ctx voices:(NSArray<MNVoice*>*)voices staff:(MNStaff*)staff;

- (BOOL)preFormat;

//- (BOOL)preFormatWith:(float)justifyWidth andContext:(CGContextRef)ctx voices:(NSArray<MNVoice*>*)voices
//staff:(MNStaff*)staff;

- (BOOL)postFormat;

- (id)joinVoices:(NSArray<MNVoice*>*)voices;

- (id)formatWith:(NSArray<MNVoice*>*)voices;
- (id)formatWith:(NSArray<MNVoice*>*)voices withJustifyWidth:(float)justifyWidth;
- (id)formatWith:(NSArray<MNVoice*>*)voices withJustifyWidth:(float)justifyWidth andOptions:(NSDictionary*)options;

- (id)formatToStaff:(NSArray<MNVoice*>*)voices staff:(MNStaff*)staff;
- (id)formatToStaff:(NSArray<MNVoice*>*)voices staff:(MNStaff*)staff options:(NSDictionary*)options;

- (void)draw:(CGContextRef)ctx;

@end
