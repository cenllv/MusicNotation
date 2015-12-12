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
#import "MNTimeSigStruct.h"
#import "MNGlyph.h"
#import "MNStaff.h"

@interface MNTimeSigNote ()
@property (strong, nonatomic) MNTimeSignature* timeSignature;
@property (strong, nonatomic) MNTimeSigStruct* timeSig;
@end

@implementation MNTimeSigNote

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    //    NSMutableDictionary* tmp_dict = [NSMutableDictionary dictionary];
    //    [tmp_dict addEntriesFromDictionary:optionsDict];
    //    tmp_dict[@"duration"] = @"8";
    //    self = [super initWithDictionary:tmp_dict];
    self = [super initWithDictionary:@{ @"duration" : @"b", @"ignore_ticks" : @(0) }];
    if(self)
    {
        //        self->_ignoreTicks =YES;
        //        self.ignoreTicks = YES;
        //        self.durationString = @"b";
    }
    return self;
}

- (instancetype)initWithTimeSpec:(NSString*)timeSpec andCustomPadding:(float)customPadding
{
    self = [self initWithDictionary:@{ @"duration" : @"8" }];
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
        self.timeSig = self.timeSignature.timeSig;
        [self setWidth:self.timeSig.glyph.width];
    }
    return self;
}

+ (MNTimeSigNote*)timeSigNoteWithTimeType:(MNTimeType)timeType
{
    MNTimeSigNote* ret;
    ret = [[MNTimeSigNote alloc] initWithDictionary:nil];
    ret.timeSignature = [MNTimeSignature timeSignatureWithType:timeType];
    ret.timeSig = ret.timeSignature.timeSig;
    if(ret.timeSignature.glyph)
    {
        ret.timeSig.glyph = ret.timeSignature.glyph;
    }
    [ret setWidth:ret.timeSig.glyph.width];
    return ret;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

//- (id)setStaff:(MNStaff*)staff
//{
//    return [super setStaff:staff];
//}

- (MNBoundingBox*)boundingBox
{
    return MNBoundingBoxMake(0, 0, 0, 0);
}

- (id)addToModifierContext:(MNModifierContext*)modifierContext
{
    // overridden to ignore
    return [super addToModifierContext:modifierContext];
}

- (BOOL)preFormat
{
    self.preFormatted = YES;
    return YES;
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];
    if(!self.staff)
    {
        MNLogError(@"NoStave, Can't draw without a stave.");
    }
    /*

    self.timeSig.glyph.setStave(self.stave);
    self.timeSig.glyph.setYShift(
                                 self.stave.getYForLine(self.timeSig.line) - self.stave.getYForGlyphs());
    self.timeSig.glyph.renderToStave(self.getAbsoluteX());

    */
    //    self.timeSig.staff = self.staff;
    //    float y_shift = [self.staff getYForLine:self.timeSig.line] - [self.staff getYForGlyphs];
    //    [self.timeSig.glyph setY_shift:y_shift];
    [self.timeSig.glyph renderWithContext:ctx toStaff:self.staff atX:self.absoluteX];
    //    [self.timeSig.glyph renderWithContext:ctx atX:self.absoluteX atY:100];
}

@end
