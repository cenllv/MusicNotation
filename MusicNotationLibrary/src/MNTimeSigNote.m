//
//  MNTimeSigNote.m
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

#import "MNTimeSigNote.h"
#import "MNUtils.h"
#import "MNBoundingBox.h"
#import "MNTimeSignature.h"

@interface MNTimeSigNote ()
@property (strong, nonatomic) MNTimeSignature* timeSignature;
@end

@implementation MNTimeSigNote

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self->_ignoreTicks = YES;
    }
    return self;
}

- (instancetype)initWithTimeSpec:(NSString*)timeSpec andCustomPadding:(float)customPadding
{
    self = [self initWithDictionary:@{ @"duration" : @"b" }];
    if(self)
    {
        self.padding = customPadding;
        self.timeSpec = timeSpec;
        /*


                var timeSignature = new Vex.Flow.TimeSignature(timeSpec, customPadding);
                self.timeSig = timeSignature.getTimeSig();
                self.setWidth(self.timeSig.glyph.getMetrics().width);

                // Note properties
                self.ignore_ticks = YES;
            },
                */
        self.timeSignature = [[MNTimeSignature alloc] initWithTimeSpec:timeSpec andPadding:customPadding];
        //        self.timeSignature get
        //        self->_ignoreTicks = YES;
    }
    return self;
}

+ (MNTimeSigNote*)timeSigNoteWithTimeType:(MNTimeType)timeType
{
    MNTimeSigNote* ret;
    ret = [[MNTimeSigNote alloc] initWithDictionary:nil];
    ret.timeSignature = [MNTimeSignature timeSignatureWithType:timeType];
    return ret;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (void)setStaff:(MNStaff*)staff
{
    [super setStaff:staff];
}

- (MNBoundingBox*)boundingBox
{
    return MNBoundingBoxMake(0, 0, 0, 0);
}

- (id)addToModifierContext:(MNModifierContext*)modifierContext
{
    // overridden to ignore
    return self;
}

- (BOOL)preFormat
{
    self.preFormatted = YES;
    return YES;
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];
    /*

    if (!self.timeSig.glyph.getContext()) {
        self.timeSig.glyph.setContext(self.context);
    }

    self.timeSig.glyph.setStave(self.stave);
    self.timeSig.glyph.setYShift(
                                 self.stave.getYForLine(self.timeSig.line) - self.stave.getYForGlyphs());
    self.timeSig.glyph.renderToStave(self.getAbsoluteX());

    */
    if(!self.staff)
    {
        MNLogError(@"NoStave, Can't draw without a stave.");
    }
}

@end
