//
//  MNTabTie.m
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

#import "MNTabTie.h"
#import "MNStaffNote.h"

/*!
 *  `MNStaffTie` category provides protected methods to `MNTabTie` from superclass `MNStaffTie`
 */
@interface MNStaffTie (Protected)

- (void)setupStaffTie;
- (void)setupNotes:(MNNoteTie*)notes;

- (void)renderText:(CGContextRef)ctx first_x_px:(float)first_x_px last_x_px:(float)last_x_px;
- (void)renderTieWithContext:(CGContextRef)ctx
                     firstYs:(NSArray*)first_ys
                      lastYs:(NSArray*)last_ys
                     lastXpx:(float)last_x_px
                    firstXpx:(float)first_x_px
                   direction:(MNStemDirectionType)direction;

@end

@implementation MNTabTie

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

/*!
 *  Create a new tie from the specified notes. The notes must
 *   be part of the same line, and have the same duration (in ticks).
 *  @param notes <#notes description#>
 *  @param text  <#text description#>
 *  @return <#return value description#>
 */
- (instancetype)initWithNotes:(MNNoteTie*)notes andText:(NSString*)text
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        self.notes = notes;
        self.text = text;
        [self setupStaffTie];

        [self->_renderOptions setCp1:9];
        [self->_renderOptions setCp2:11];
        [self->_renderOptions setYShift:3];

        [self setupNotes:notes];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

+ (MNTabTie*)createHammeron:(MNNoteTie*)notes
{
    return [[MNTabTie alloc] initWithNotes:notes andText:@"H"];
}

+ (MNTabTie*)createPulloff:(MNNoteTie*)notes
{
    return [[MNTabTie alloc] initWithNotes:notes andText:@"P"];
}

- (void)draw:(CGContextRef)ctx
{
    float first_x_px, last_x_px;
    NSArray* first_ys;
    NSArray* last_ys;
    // MNStemDirectionType stem_direction = MNStemDirectionNone;

    if(self.firstNote)
    {
        first_x_px = self.firstNote.tieRightX + self.tie_spacing;
        // stem_direction = self.firstNote.stemDirection;
        first_ys = self.firstNote.ys;
    }
    else
    {
        first_x_px = self.lastNote.staff.tieStartX;
        first_ys = self.lastNote.ys;
        self.firstIndices = self.lastIndices;
    }

    if(self.lastNote)
    {
        last_x_px = self.lastNote.tieLeftX + [self->_renderOptions tie_spacing];
        // stem_direction = self.lastNote.stemDirection;
        last_ys = self.lastNote.ys;
    }
    else
    {
        last_x_px = self.firstNote.staff.tieEndX;
        last_ys = self.firstNote.ys;
        self.lastIndices = self.firstIndices;
    }

    [self renderTieWithContext:ctx
                       firstYs:first_ys
                        lastYs:last_ys
                       lastXpx:last_x_px
                      firstXpx:first_x_px
                     direction:-1];   // Tab tie's are always face up.

    [self renderText:ctx first_x_px:first_x_px last_x_px:last_x_px];
}

@end
