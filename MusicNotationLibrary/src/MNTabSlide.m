//
//  MNTabSlide.m
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

#import "MNTabSlide.h"
#import "MNLog.h"
#import "MNMacros.h"
#import "MNFont.h"
#import "MNColor.h"

@implementation MNTabSlide

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super init];
    if(self)
    {
        [self setupTabSlide];
    }
    return self;
}

/*!
 * Create a new tie from the specified notes. The notes must
 * be part of the same line, and have the same duration (in ticks).
 *  @param notes     <#notes description#>
 *  @param direction <#direction description#>
 *  @return <#return value description#>
 */
- (instancetype)initWithNoteTie:(MNNoteTie*)notes direction:(MNTabSlideType)direction
{
    self = [super initWithNotes:notes andText:@"sl."];
    if(self)
    {
        /*
        Vex.Flow.TabSlide.prototype.init = function(notes, direction) {

            Vex.Flow.TabSlide.superclass.init.call(this, notes, "sl.");
            if (!direction) {
                var first_fret = notes.first_note.getPositions()[0].fret;
                var last_fret = notes.last_note.getPositions()[0].fret;

                direction = ((parseInt(first_fret) > parseInt(last_fret)) ?
                             Vex.Flow.TabSlide.SLIDE_DOWN : Vex.Flow.TabSlide.SLIDE_UP);
            }
        }
         */
        self.slideDirection = direction;
        self.cp1 = 11;
        self.cp2 = 14;
        self.yShift = 0.5;

        self.font = [MNFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:10];

        self.notes = notes;
    }
    return self;
}

- (void)setupTabSlide
{
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
            [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"slide_direction" : @"slideDirection"}];
    return propertiesEntriesMapping;
}

+ (MNTabSlide*)createSlideUp:(MNNoteTie*)notes
{
    return [[MNTabSlide alloc] initWithNoteTie:notes direction:MNTabSlideSLIDE_UP];
}

+ (MNTabSlide*)createSlideDown:(MNNoteTie*)notes
{
    return [[MNTabSlide alloc] initWithNoteTie:notes direction:MNTabSlideSLIDE_DOWN];
}

- (void)renderTieWithContext:(CGContextRef)ctx
                     firstYs:(NSArray*)first_ys
                      lastYs:(NSArray*)last_ys
                     lastXpx:(float)last_x_px
                    firstXpx:(float)first_x_px
                   direction:(MNStemDirectionType)directionX   // not used
{
    //    float center_x = (first_x_px + last_x_px) / 2;

    MNTabSlideType direction = self.slideDirection;

    for(NSUInteger i = 0; i < self.firstIndices.count; ++i)
    {
        float slide_y = [first_ys[[self.firstIndices[i] unsignedIntegerValue]] floatValue] + self.yShift;

        if(isnan(slide_y))
        {
            MNLogError(@"BadArguments, Bad indices for slide rendering.");
        }

        float d = (float)direction;

        CGPoint pt1, pt2;
        pt1 = CGPointMake(first_x_px, slide_y + (3 * d));
        pt2 = CGPointMake(last_x_px, slide_y - (3 * d));

        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, [MNColor blackColor].CGColor);
        CGContextSetFillColorWithColor(ctx, [MNColor blackColor].CGColor);

        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, pt1.x, pt1.y);
        CGContextAddLineToPoint(ctx, pt2.x, pt2.y);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        //        CGContextFillPath(ctx);
        //        CGContextStrokePath(ctx);
    }
}

@end
