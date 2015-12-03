//
//  MNTuplet.m
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

#import "MNTuplet.h"
#import "MNUtils.h"
#import "MNNote.h"
#import "MNStaffNote.h"
#import "MNPoint.h"
#import "MNFormatter.h"
#import "MNGlyph.h"
#import "MNBezierPath.h"
#import "MNExtentStruct.h"

@implementation MNTuplet

#pragma mark - Initialize

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithNotes:(NSArray*)notes
{
    self = [self initWithNotes:notes andOptionsDict:nil];
    if(self)
    {
        //        [self setupTuplet];
    }
    return self;
}

// Create a new tuplet from the specified notes. The notes must
// be part of the same line, and have the same duration (in ticks).
- (instancetype)initWithNotes:(NSArray*)notes andOptionsDict:(NSDictionary*)optionsDict
{
    self = [self initWithDictionary:optionsDict];
    if(self)
    {
        if(!notes || notes.count == 0)
        {
            [MNLog logError:@"BadArguments, No notes provided for tuplet."];
        }

        if(notes.count == 1)
        {
            [MNLog logError:@"BadArguments, Too few notes for tuplet."];
        }
        _notes = [notes mutableCopy];

        [self setupTuplet];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

// Set the notes to attach this tuplet to.
- (void)setupTuplet
{
    _beatsOccupied = _beatsOccupied > 0 ? _beatsOccupied : 2;
    _bracketed = ((MNStaffNote*)_notes[0]).beam == nil;
    _ratioed = NO;
    _points = 28;
    _position = [MNPoint pointWithX:100 andY:16];
    _width = 200;
    _tupletLocation = MNTupletLocationTop;

    [MNFormatter alignRestsToNotes:_notes withNoteAlignment:YES andTupletAlignment:YES];
    [self resolveGlyphs];
    [self attach];
}

#pragma mark - Properties

// Set whether or not the bracket is drawn.
- (id)setBracketed:(BOOL)bracketed
{
    _bracketed = bracketed;
    return self;
}

/*!
 *  Set whether or not the ratio is shown.
 *  @param ratioed <#ratioed description#>
 *  @return <#return value description#>
 */
- (id)setRatioed:(BOOL)ratioed
{
    _ratioed = ratioed;
    return self;
}

- (void)setTupletLocation:(MNTupletLocationType)tupletLocation
{
    if(tupletLocation == MNTupletLocationNone)
    {
        tupletLocation = MNTupletLocationTop;
    }
    switch(tupletLocation)
    {
        case MNTupletLocationBottom:
        case MNTupletLocationTop:
            _tupletLocation = tupletLocation;
            break;
        default:
            MNLogError(@"BadArgument, Invalid tuplet location: %lu", tupletLocation);
            break;
    }
}

- (NSMutableArray*)notes
{
    if(!_notes)
    {
        _notes = [NSMutableArray array];
    }
    return _notes;
}

- (NSUInteger)getNoteCount
{
    if(_notes)
    {
        return _notes.count;
    }
    else
        return 0;
}

- (NSUInteger)numNotes
{
    return self.noteCount;
}

- (void)setBeatsOccupied:(NSUInteger)beatsOccupied
{
    [self detach];

    _beatsOccupied = beatsOccupied;

    [self resolveGlyphs];

    [self attach];
}

- (NSMutableArray*)numeratorGlyphs
{
    if(!_numeratorGlyphs)
    {
        _numeratorGlyphs = [NSMutableArray array];
    }
    return _numeratorGlyphs;
}

- (NSMutableArray*)denominatorGlyphs
{
    if(!_denominatorGlyphs)
    {
        _denominatorGlyphs = [NSMutableArray array];
    }
    return _denominatorGlyphs;
}

//- (void)setPosition:(MNPoint*)pointPosn
//{
//    _position = pointPosn;
//}
//
//- (MNPoint*)pointPosition
//{
//    if(!_position)
//    {
//        _position = [MNPoint pointZero];
//    }
//    return _position;
//}

#pragma mark - Methods
- (void)attach
{
    for(NSUInteger i = 0; i < self.notes.count; ++i)
    {
        MNStaffNote* note = self.notes[i];
        note.tuplet = self;
    }
}

- (void)detach
{
    for(NSUInteger i = 0; i < self.notes.count; ++i)
    {
        MNStaffNote* note = self.notes[i];
        note.tuplet = nil;
    }
}

- (void)resolveGlyphs
{
    for(NSUInteger n = self.numNotes; n >= 1; n /= 10)
    {
        MNGlyph* glyph = [MNGlyph glyphWithCode:[NSString stringWithFormat:@"v%lu", (n % 10)] withPointSize:1];
        [self.numeratorGlyphs addObject:glyph];
    }
    for(NSUInteger n = self.beatsOccupied; n >= 1; n /= 10)
    {
        MNGlyph* glyph = [MNGlyph glyphWithCode:[NSString stringWithFormat:@"v%lu", (n % 10)] withPointSize:1];
        [self.denominatorGlyphs addObject:glyph];
    }
}

- (void)draw:(CGContextRef)ctx
{
    // determine x value of left bound of tuplet
    MNStaffNote* firstNote = [self.notes objectAtIndex:0];
    MNStaffNote* lastNote = [self.notes lastObject];

    if(!_bracketed)
    {
        self.position.x = firstNote.stemX;
        self.width = lastNote.stemX - self.position.x;
    }
    else
    {
        self.position.x = firstNote.tieLeftX - 5;
        self.width = lastNote.tieRightX - self.position.x + 5;
    }

    // determine y value for tuplet
    if(self.tupletLocation == MNTupletLocationTop)
    {
        self.position.y = [firstNote.staff getYForLine:0] - 15;
        for(MNStaffNote* note in self.notes)
        {
            float topY =
                note.stemDirection == MNStemDirectionUp ? note.stemExtents.topY - 5 : note.stemExtents.baseY - 10;
            if(topY < self.position.y)
            {
                self.position.y = topY;
            }
        }
    }
    else
    {
        self.position.y = [firstNote.staff getYForLine:4] + 30;
        for(MNStaffNote* note in self.notes)
        {
            float bottomY =
                note.stemDirection == MNStemDirectionUp ? note.stemExtents.baseY + 20 : note.stemExtents.topY + 10;
            if(bottomY > self.position.y)
            {
                self.position.y = bottomY;
            }
        }
    }

    // calculate total width of tuplet notation
    float width = 0;
    for(MNTableGlyphStruct* glyph in self.numeratorGlyphs)
    {
        width += glyph.metrics.width;
    }
    if(_ratioed)
    {
        for(MNTableGlyphStruct* glyph in self.denominatorGlyphs)
        {
            width += glyph.metrics.width;
        }
        width += self.points * 0.32;
    }
    float notationCenterX = self.position.x + self.width / 2;
    float notationStartX = notationCenterX - width / 2;

    // draw bracket if the tuplet is not beamed
    if(_bracketed)
    {
        float lineWidth = self.width / 2 - width / 2 - 5;

        // only draw the bracket if it has positive length
        if(lineWidth > 0)
        {
            float x = self.position.x;
            float y = self.position.y;

            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, x, y);
            CGContextAddRect(ctx, CGRectMake(x, y, lineWidth, 1));
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);

            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, x + self.width / 2 + width / 2 + 5, y);
            CGContextAddRect(ctx, CGRectMake(x + self.width / 2 + width / 2 + 5, y, lineWidth, 1));
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);

            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, x, y + (self.tupletLocation == MNTupletLocationBottom));
            CGContextAddRect(
                ctx, CGRectMake(x, y + (self.tupletLocation == MNTupletLocationBottom), 1, self.tupletLocation * 10));
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);

            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, x + self.width, y + (self.tupletLocation == MNTupletLocationBottom));
            CGContextAddRect(ctx, CGRectMake(x + self.width, y + (self.tupletLocation == MNTupletLocationBottom), 1,
                                             self.tupletLocation * 10));
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
        }
    }

    // draw numerator glyphs
    float xOffset = 0;
    float size = self.numeratorGlyphs.count;
    for(NSUInteger i = 0; i < self.numeratorGlyphs.count; ++i)
    {
        NSUInteger index = size - i - 1;
        MNTableGlyphStruct* glyph = self.numeratorGlyphs[index];
        CGFloat x, y;
        x = notationStartX + xOffset;
        y = self.position.y + (self.points / 3) - 2;
        [MNGlyph renderGlyph:ctx atX:x atY:y withScale:1 forGlyphCode:glyph.metrics.code];
        xOffset += ((MNTableGlyphStruct*)self.numeratorGlyphs[index]).metrics.width;
    }

    // display colon and denominator if the ratio is to be shown
    if(_ratioed)
    {
        /*

        this.context.beginPath();
        this.context.arc(colon_x, this.y_pos - this.point*0.08,
                         colon_radius, 0, Math.PI*2, true);
        this.context.closePath();
        this.context.fill();
        this.context.beginPath();
        this.context.arc(colon_x, this.y_pos + this.point*0.12,
                         colon_radius, 0, Math.PI*2, true);
        this.context.closePath();
        this.context.fill();
        x_offset += this.point*0.32;
        size = this.denom_glyphs.length;
        for (glyph in this.denom_glyphs) {
            this.denom_glyphs[size-glyph-1].render(
                                                   this.context, notation_start_x + x_offset,
                                                   this.y_pos + (this.point/3) - 2);
            x_offset += this.denom_glyphs[size-glyph-1].getMetrics().width;
        }
        */

        float colonX = notationStartX + xOffset + self.points * 0.16;
        float colonRadius = self.points * 0.06;
        MNBezierPath* path = (MNBezierPath*)[MNBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(colonX, self.position.y - self.points * 0.08)
                        radius:colonRadius
                    startAngle:0
                      endAngle:M_2_PI
                     clockwise:YES];
        [path closePath];
        [path stroke];
        [path fill];
        path = (MNBezierPath*)[MNBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(colonX, self.position.y + self.points * 0.12)
                        radius:colonRadius
                    startAngle:0
                      endAngle:M_2_PI
                     clockwise:YES];
        [path stroke];
        [path fill];
        xOffset += self.points * 0.32;
        size = self.denominatorGlyphs.count;
        for(NSUInteger i = 0; i < self.denominatorGlyphs.count; ++i)
        {
            NSUInteger index = size - i - 1;
            MNTableGlyphStruct* glyph = (MNTableGlyphStruct*)self.denominatorGlyphs[index];
            CGFloat x, y;
            x = notationStartX + xOffset;
            y = self.position.y + (self.points / 3) - 2;
            [MNGlyph renderGlyph:ctx atX:x atY:y withScale:1 forGlyphCode:glyph.metrics.code];
            xOffset += ((MNTableGlyphStruct*)self.denominatorGlyphs[index]).metrics.width;
        }
    }
}

@end
