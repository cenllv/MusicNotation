//
//  MNStaffTie.h
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
#import "MNNoteTie.h"

@class MNStaffNote;

/*! 
 *  The `MNStaffTie` class implements various types of ties between contiguous notes.
 *   Ties include reuglar ties, hammer ons, pull offs, and slides.
 */
@interface MNStaffTie : MNStaffModifier

#pragma mark - Properties
@property (assign, nonatomic, readonly) BOOL isPartial;
@property (strong, nonatomic) MNNoteTie* notes;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) MNStaffNote* firstNote;
@property (strong, nonatomic) NSArray* firstIndices;
@property (strong, nonatomic) NSArray* lastIndices;
@property (assign, nonatomic) NSUInteger firstIndex;
@property (strong, nonatomic) MNStaffNote* lastNote;
@property (assign, nonatomic) NSUInteger lastIndex;
@property (assign, nonatomic) float cp1;
@property (assign, nonatomic) float cp2;
@property (assign, nonatomic) float tie_spacing;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict andText:(NSString*)text;
- (instancetype)initWithNoteTie:(MNNoteTie*)noteTie andText:(NSString*)text;
- (instancetype)initWithNoteTie:(MNNoteTie*)noteTie;
- (instancetype)initWithLastNote:(MNNote*)lastNote
                       firstNote:(MNNote*)firstNote
                    firstIndices:(NSArray*)firstIndices
                     lastIndices:(NSArray*)lastIndices;

@end
