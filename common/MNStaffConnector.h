//
//  MNStaffConnector.h
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
#import "MNStaffModifier.h"

@class MNStaff, MNGlyph, MNMetrics;

/*!
 *  The `MNStaffConnector` class implements the following as outlined at
 *
 *      https://en.wikipedia.org/wiki/Staff_(music)#Ensemble_staves
 *
 *  A single vertical line drawn to the left of multiple staves creates a system, indicating that the
 *  music on all the staves is to be played simultaneously. A bracket is an additional straight line
 *  joining staves, to show groupings of instruments that function as a unit, such as the string
 *  section of an orchestra. A brace is used to join multiple staves that represent a single instrument,
 *  such as a piano, organ, harp, or marimba.[2] Sometimes, a second bracket is used to show instruments
 *  grouped in pairs, such as the first and second oboes, or the first and second violins in an
 *  orchestra.[3] In some cases, a brace is used for this purpose instead of a bracket.[4][2]
 *  Four-part SATB vocal settings, especially in hymnals, use a divisi notation on a two-staff system
 *  with soprano and alto voices sharing the upper staff, and tenor and bass voices on the lower staff.
 *
 *  and,
 *
 *       https://en.wikipedia.org/wiki/Staff_(music)#Grand_staff
 *
 *  When music on two staves is joined by a brace, or is intended to be played at once by a single performer
 *  usually a keyboard instrument or the harp), a great stave (BrE) or grand staff (AmE) is created. Typically,
 *  the upper staff uses a treble clef and the lower staff has a bass clef. In this instance, middle C is
 *  centered between the two staves, and it can be written on the first ledger line below the upper staff or
 *  the first ledger line above the lower staff. When playing the piano or harp, the upper staff is normally
 *  played with the right hand and the lower staff with the left hand. In music intended for the organ, a grand
 *  staff comprises three staves, one for each hand on the manuals and one for the feet on the pedalboard.
 */
@interface MNStaffConnector : MNStaffModifier

#pragma mark - Properties

/*! parent staves
 */
@property (weak, nonatomic) MNStaff* topStaff;
@property (weak, nonatomic) MNStaff* bottomStaff;

/*!
 */
//@property (strong, nonatomic) Metrics* metrics;

//@property (strong, nonatomic) NSString* category;

//@property (assign, nonatomic) float width;
@property (assign, nonatomic) MNStaffConnectorType connectorType;
//@property (assign, nonatomic) BOOL preFormatted;

//@property (strong, nonatomic)  MNGlyph* glyph;

@property (assign, nonatomic) MNStaffConnectorType type;

@property (assign, nonatomic) float shift_x;
@property (assign, nonatomic) float shift_y;

@property (strong, nonatomic) NSString* text;
//@property (assign, nonatomic) CGContextRef graphicsContext;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithTopStaff:(MNStaff*)topStaff andBottomStaff:(MNStaff*)bottomStaff;
+ (MNStaffConnector*)staffConnectorWithTopStaff:(MNStaff*)topStaff andBottomStaff:(MNStaff*)bottomStaff;

//- (BOOL)preFormat;
//- (void)load;
//- (BOOL)postFormat;
- (void)renderWithContext:(CGContextRef)ctx;

- (void)draw:(CGContextRef)ctx;

- (void)drawBoldDoublLine:(CGContextRef)ctx
                 withType:(MNStaffConnectorType)type
                     topX:(float)topX
                     topY:(float)topY
                  bottomY:(float)botY;

+ (void)setDebugMode:(BOOL)mode;

@end
