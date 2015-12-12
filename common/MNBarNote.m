//
//  MNBarNote.m
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

#import "MNBarNote.h"
#import "MNUtils.h"

@implementation MNBarNote

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupBarNote];
    }
    return self;
}

- (void)setupBarNote
{
    /*
    Vex.Flow.BarNote.prototype.init = function() {
        var superclass = Vex.Flow.BarNote.superclass;
        superclass.init.call(this, {duration: "b"});

        var TYPE = Vex.Flow.Barline.type;
        self.metrics = {
        widths: {}
        }

        self.metrics.widths[TYPE.SINGLE] = 8;
        self.metrics.widths[TYPE.DOUBLE] = 12;
        self.metrics.widths[TYPE.END] = 15;
        self.metrics.widths[TYPE.REPEAT_BEGIN] = 14;
        self.metrics.widths[TYPE.REPEAT_END] = 14;
        self.metrics.widths[TYPE.REPEAT_BOTH] = 18;
        self.metrics.widths[TYPE.NONE] = 0;

        // Note properties
        self.ignore_ticks = YES;
        self.type = TYPE.SINGLE;
        self.setWidth(self.metrics.widths[self.type]);
     }*/
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (void)setType:(MNBarNoteType)type
{
    /*

    Vex.Flow.BarNote.prototype.setType = function(type) {
        self.type = type;
        self.setWidth(self.metrics.widths[self.type]);
        return this;
    }
     */
}

- (MNBarNoteType)type
{
    /*
    Vex.Flow.BarNote.prototype.getType = function() {
        return self.type;
    }
     */
    return 0;
}

- (id)setStaff:(MNStaff*)Staff
{
    /*
    Vex.Flow.BarNote.prototype.setStaff = function(Staff) {
        var superclass = Vex.Flow.BarNote.superclass;
        superclass.setStaff.call(this, Staff);
    }
     */
    return self;
}

- (MNStaff*)staff
{
    return nil;
}

- (CGRect)bounds
{
    /*
    Vex.Flow.BarNote.prototype.getBoundingBox = function() {
        return new Vex.Flow.BoundingBox(0, 0, 0, 0);
    }
     */
    return CGRectZero;
}

/*
Vex.Flow.BarNote.prototype.addToModifierContext = function(mc) {
    return this;
}
 */

- (void)setPreFormatted:(BOOL)preFormatted
{
    /*
    Vex.Flow.BarNote.prototype.preFormat = function() {
        self.setPreFormatted(YES);
        return this;
    }
     */
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    /*
    Vex.Flow.BarNote.prototype.draw = function() {
        if (!self.Staff) throw new Vex.RERR("NoStaff", "Can't draw without a Staff.");
    //
    //    *
    //     var x = self.getAbsoluteX() + self.x_shift;
    //     if (self.type == Vex.Flow.BarNote.TYPE.SINGLE) {
    //     self.Staff.drawVerticalBarFixed(x);
    //     } else if (self.type == Vex.Flow.BarNote.TYPE.DOUBLE) {
    //     self.Staff.drawVerticalBarFixed(x);
    //     self.Staff.drawVerticalBarFixed(x + self.metrics.double_x_shift);
    //     }
    //     *
        var barline = new Vex.Flow.Barline(self.type, self.getAbsoluteX());
        barline.draw(self.Staff, self.getAbsoluteX());
    }

    */
}
@end
