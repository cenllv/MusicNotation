//
//  MNTabStaff.m
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

#import "MNTabStaff.h"
#import "MNUtils.h"
#import "MNStaff.h"
#import "MNGlyph.h"

@implementation MNTabStaff

- (instancetype)initAtX:(float)x atY:(float)y width:(float)width height:(float)height
{
    self = [super initAtX:x atY:y width:width height:height optionsDict:@{}];
    if(self)
    {
        [self setupTabStaff];
    }
    return self;
}

+ (MNTabStaff*)staffWithRect:(CGRect)rect
{
    return [[MNTabStaff alloc] initAtX:CGRectGetMinX(rect)
                                   atY:CGRectGetMinY(rect)
                                 width:CGRectGetWidth(rect)
                                height:CGRectGetHeight(rect)];
}

+ (MNTabStaff*)staffAtX:(float)x atY:(float)y width:(float)width height:(float)height;
{
    return [[MNTabStaff alloc] initAtX:x atY:y width:width height:height];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

//- (instancetype)initAtX:(float)x
//         andY:(float)y
//    withWidth:(float)width
//   andOptions:(Options *)options {
//
//    /*
//     Vex.Flow.TabStaff.prototype.init = function(x, y, width, options) {
//     var superclass = Vex.Flow.TabStaff.superclass;
//
//
//     Vex.Merge(tab_options, options);
//     superclass.init.call(this, x, y, width, tab_options);
//     }
//     */
//
//    self = [super in initAtX:x atY:y withWidth:width andHeight:0];
//    if (self) {
//        [self setupTabStaff];
//
//        //TODO: do a merge here of options
//    }
//    return self;
//}
//
//- (instancetype)initWithBoundingBox:(MNBoundingBox *)frame {
//    self = [super initWithBoundingBox:frame];
//    if (self) {
//        [self setupTabStaff];
//    }
//    return self;
//}

- (void)setupTabStaff
{
    /*
     var tab_options = {
     spacing_between_lines_px: 13,
     num_lines: 6,
     top_text_position: 1,
     bottom_text_position: 7
     };
     */
    self.options.pointsBetweenLines = 13;
    self.options.numLines = 6;
    self.options.topTextPosition = 1;
    self.options.bottomTextPosition = 7;
}

- (void)setNumberOfLines:(float)numberOfLines
{
    self.options.numLines = numberOfLines;
}

- (float)getYForGlyphs
{
    return [self getYForLine:2.5];
}

- (id)addTabGlyph
{
    float glyphScale = 0;
    float glyphOffset = 0;

    switch(self.options.numLines)
    {
        case 8:
            glyphScale = 55;
            glyphOffset = 14;
            break;
        case 7:
            glyphScale = 47;
            glyphOffset = 8;
            break;
        case 6:
            glyphScale = 40;
            glyphOffset = 1;
            break;
        case 5:
            glyphScale = 30;
            glyphOffset = -6;
            break;
        case 4:
            glyphScale = 23;
            glyphOffset = -12;
            break;
    }

    MNGlyph* tabGlyph = [[MNGlyph alloc] initWithCode:@"v2f" withScale:1];   // glyphScale];
    tabGlyph.y_shift = glyphOffset;
    [self addGlyph:[self makeSpacer:5]];
    [self addGlyph:tabGlyph];
    [self addGlyph:[self makeSpacer:5]];
    return self;
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];
}

@end
