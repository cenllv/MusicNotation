//
//  MNClefNote.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Taehoon Moon 2014
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

#import "MNClefNote.h"
#import "MNUtils.h"
#import "MNGlyph.h"
#import "MNClef.h"
#import "MNStaff.h"
#import "MNClefAnnotation.h"
#import "MNGlyphMetrics.h"

@implementation MNClefNote

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        /*
        Vex.Flow.ClefNote = (function() {
            function ClefNote(clef, size, annotation) { self.init(clef, size, annotation); }

            Vex.Inherit(ClefNote, Vex.Flow.Note, {
            init: function(clef, size, annotation) {
                ClefNote.superclass.init.call(this, {duration: "b"});

                self.setClef(clef, size, annotation);

                // Note properties
                self.ignore_ticks = YES;
            },
         */

        [self setClefWithClefName:self.clefName size:self.clefSize annotationName:self.annotationName];

        [self setIgnoreTicks:YES];
    }
    return self;
}

+ (MNClefNote*)clefNoteWithClef:(NSString*)clef
{
    MNLogNotYetImlemented();
    abort();
    return nil;
}

+ (MNClefNote*)clefNoteWithClef:(NSString*)clef size:(NSString*)size
{
    return [[MNClefNote alloc] initWithDictionary:@{ @"clefName" : clef, @"clefSize" : size, @"duration" : @"b" }];
}

+ (MNClefNote*)clefNoteWithClef:(NSString*)clef size:(NSString*)size annotation:(NSString*)annotation
{
    MNClefNote* ret = [[MNClefNote alloc] initWithDictionary:@{
        @"clefName" : clef,
        @"clefSize" : size,
        @"annotationName" : annotation,
        @"duration" : @"b"
    }];

    return ret;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

/*
    setStave: function(stave) {
        var superclass = Vex.Flow.ClefNote.superclass;
        superclass.setStave.call(this, stave);
    },

    getBoundingBox: function() {
        return new Vex.Flow.BoundingBox(0, 0, 0, 0);
    },

    addToModifierContext: function() {
        // overridden to ignore
        return this;
    },

    getCategory: function() {
        return @"clefnote";
    },
*/

+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);   // return @"clefnote";
}
- (NSString*)category
{
    return NSStringFromClass([self class]);   // return @"clefnote";
}

- (id)setClefWithClefName:(NSString*)clefName size:(NSString*)size annotationName:(NSString*)annotationName
{
    /*

        setClef: function(clef, size, annotation) {
            self.clef_obj = new Vex.Flow.Clef(clef, size, annotation);
            self.clef = self.clef_obj.clef;
            self.glyph = new Vex.Flow.Glyph(self.clef.code, self.clef.point);
            self.setWidth(self.glyph.getMetrics().width);
            return this;
        },

        getClef: function() {
            return self.clef;
        },
    */

    self.clef = [MNClef clefWithName:clefName size:size annotationName:annotationName];
    // new Vex.Flow.Clef(clef, size, annotation);
    self.clefName = self.clef.clefName;
    self.clefType = self.clef.type;
    float pointSize = self.clef.scale;
    self.glyph = [MNGlyph glyphWithCode:self.clef.code withPointSize:pointSize];
    // new Vex.Flow.Glyph(self.clef.code, self.clef.point);
    self.width = self.glyph.metrics.width;

    return self;
}

#pragma mark - Methods
- (BOOL)preFormat
{
    BOOL ret = [super preFormat];
    self.preFormatted = YES;
    return ret;
}

/*
    preFormat: function() {
        self.setPreFormatted(YES);
        return this;
    },
*/

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];
    /*
        draw: function() {
            if (!self.stave) throw new Vex.RERR("NoStave", "Can't draw without a stave.");

            if (!self.glyph.getContext()) {
                self.glyph.setContext(self.context);
            }
            var abs_x = self.getAbsoluteX();

            self.glyph.setStave(self.stave);
            self.glyph.setYShift(
                                 self.stave.getYForLine(self.clef.line) - self.stave.getYForGlyphs());
            self.glyph.renderToStave(abs_x);

            // If the Vex.Flow.Clef has an annotation, such as 8va, draw it.
            if (self.clef_obj.annotation !== undefined) {
                var attachment = new Vex.Flow.Glyph(self.clef_obj.annotation.code, self.clef_obj.annotation.point);
                if (!attachment.getContext()) {
                    attachment.setContext(self.context);
                }
                attachment.setStave(self.stave);
                attachment.setYShift(
                                     self.stave.getYForLine(self.clef_obj.annotation.line) -
       self.stave.getYForGlyphs());
                attachment.setX_shift(self.clef_obj.annotation.x_shift);
                attachment.renderToStave(abs_x);
            }

        }

    */
    if(!self.staff)
    {
        MNLogError(@"NoStaff, Can't draw without a staff.");
    }

    float abs_x = self.absoluteX;

    self.glyph.y_shift = [self.staff getYForLine:self.clef.line] - [self.staff getYForGlyphs];
    [self.glyph renderWithContext:ctx toStaff:self.staff atX:abs_x];

    // If the Vex.Flow.Clef has an annotation, such as 8va, draw it.
    if(self.clef.hasAnnotation)
    {
        MNGlyph* attachment =
            [MNGlyph glyphWithCode:self.clef.annotation.code withPointSize:self.clef.annotation.point];
        attachment.y_shift = [self.staff getYForLine:self.clef.annotation.line] - [self.staff getYForGlyphs];
        attachment.x_shift = self.clef.annotation.xShift;
        [attachment renderWithContext:ctx toStaff:self.staff atX:abs_x];
    }
}

@end
