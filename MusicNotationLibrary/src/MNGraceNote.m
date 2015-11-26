//
//  MNGraceNote.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
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

#import "MNGraceNote.h"
#import "MNUtils.h"
#import "MNStaffNote.h"
#import "MNBezierPath.h"
#import "MNTableTypes.h"
#import "MNRenderOptions.h"

@implementation GraceNoteOptions
@end

@implementation MNGraceNote

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        // TODO: slash slur properties need work
        if(optionsDict[@"isSlash"])
        {
            self.isSlash = [optionsDict[@"isSlash"] boolValue];
        }
        [self setupGraceNote];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

- (void)setupGraceNote
{
    self->_renderOptions = [[GraceNoteOptions alloc] initWithDictionary:nil];

    GraceNoteOptions* renderOptions = self->_renderOptions;
    [renderOptions setGlyphFontScale:22];
    [renderOptions setStemHeight:20];
    [renderOptions setStrokePoints:2];
    //    self.stemHeight = 20;
    //    _stroke_px = 2;
    self.glyphStruct.headWidth = 6;
    self.isSlur = YES;
    //    [self buildNodeHeads];
    self.width = 3;
}

- (float)getStemExtension
{
    if(self.stem_extension_override != -1)
    {
        return self.stem_extension_override;
    }

    if(self.glyphStruct != nil)
    {
        return self.stemDirection == 1 ? self.glyphStruct.gracenoteStemUpExtension
                                       : self.glyphStruct.gracenoteStemDownExtension;
    }

    return 0;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"gracenotes";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    CGFloat x = self.absoluteX;
    CGFloat y = [[self.ys objectAtIndex:0] floatValue];

    if(self.isSlash)
    {
        MNBezierPath* bPath = [MNBezierPath bezierPath];
        [bPath setLineWidth:1.0];
        [MNColor.blackColor setStroke];
        [MNColor.blackColor setFill];
        if(self.stemDirection == MNStemDirectionUp)
        {
            x += 1;
            [bPath moveToPoint:CGPointMake(x, y)];
            [bPath addLineToPoint:CGPointMake(x + 13, y - 9)];
        }
        else if(self.stemDirection == MNStemDirectionDown)
        {
            x -= 4;
            y += 1;
            [bPath moveToPoint:CGPointMake(x, y)];
            [bPath addLineToPoint:CGPointMake(x + 13, y + 9)];
        }
        [bPath closePath];
        [bPath fill];
    }
}
@end
