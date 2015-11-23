//
//  MNDot.h
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

@class MNStaffNote, MNModifierState;

/*! The `MNDot` class implements dot modifiers for notes.

 In Western musical notation, a dotted note is a note with a small dot written after it.
 In modern practice the first dot increases the duration of the basic note by half of its
 original value. A dotted note is equivalent to writing the basic note tied to a note of
 half the value; or with more than one dots, tied to notes of progressively halved value.[1]
 The length of any given note a with n dots is therefore given by the geometric series
 a_n=a\left(1+\tfrac 12+\tfrac 14+ \cdots + \tfrac 1{2^n}\right)=a(2-\frac 1{2^n}).
 More than three dots are highly uncommon but theoretically possible;[2] only quadruple
 dots have been attested.[3]

 A rhythm using longer notes alternating with shorter notes (whether notated with dots or not)
 is sometimes called a dotted rhythm. Historical examples of music performance styles using
 dotted rhythm include notes inégales and swing. The precise performance of dotted rhythms
 can be a complex issue. Even in notation that includes dots, their performed values may be
 longer than the dot mathematically indicates, a practice known as over-dotting.[4]

 */
@interface MNDot : MNModifier
{
}

#pragma mark - Properties

//@property (weak, nonatomic) MNStaffNote* note;
@property (assign, nonatomic) float dotShiftY;
@property (assign, nonatomic) float lineSpace;
@property (assign, nonatomic) float radius;
@property (strong, nonatomic, readonly) NSString* type;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNDot*)dotWithType:(NSString*)type;
//- (void)setNote:(MNNote *)note;
//+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state;
- (void)setDotShiftY:(float)dotShiftY;

- (void)draw:(CGContextRef)ctx;

@end
