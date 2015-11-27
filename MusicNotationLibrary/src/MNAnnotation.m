//
//  MNAnnotation.m
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

#import "MNAnnotation.h"
#import "MNFont.h"
#import "MNText.h"
#import "MNUtils.h"
#import "MNStem.h"
#import "MNExtentStruct.h"
#import "MNStaffNote.h"

@implementation MNAnnotation

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

+ (MNAnnotation*)annotationWithText:(NSString*)text
{
    return [[MNAnnotation alloc] initWithText:text];
}

- (instancetype)initWithText:(NSString*)text
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.text = text;
        [self setupAnnotation];
    }
    return self;
}

- (void)setupAnnotation
{
    self.text_line = 0;

    _justification = MNJustifyCENTER;
    _verticalJustification = MNVerticalJustifyTOP;
    //    self.font = [MNFont fontWithName:@"Arial" size:10];

    // The default width is calculated from the text.
    self.width = [MNText measureText:self.text withFont:self.font].width;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"annotations";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

- (MNFont*)font
{
    if(!_font)
    {
        _font = [MNFont fontWithName:@"Arial" size:10];
    }
    return _font;
}

- (void)setFont:(MNFont*)font
{
    _font = font;
}

- (id)setFontName:(NSString*)fontName withSize:(NSUInteger)size
{
    [self.font setFamily:fontName];
    [self.font setSize:size];
    return self;
}

- (id)setFontName:(NSString*)fontName withSize:(NSUInteger)size withStyle:(NSString*)style
{
    //    [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
    //    abort();
    [self.font setFamily:fontName];
    [self.font setSize:size];
    if([style isEqualToString:@"italic"])
    {
        [self.font setItalic:YES];
    }
    else if([style isEqualToString:@"bold"])
    {
        [self.font setBold:YES];
    }
    return self;
}

- (id)setJustification:(MNJustiticationType)justification
{
    _justification = justification;
    return self;
}

- (id)setVerticalJustification:(MNVerticalJustifyType)verticalJustification
{
    _verticalJustification = verticalJustification;
    return self;
}

- (MNJustiticationType)justification
{
    return _justification;
}

- (MNVerticalJustifyType)vert_justification
{
    return _verticalJustification;
}

- (void)setText:(NSString*)text
{
    _text = text;
}

- (NSString*)text
{
    if(!_text)
    {
        _text = @"failed to initiailize text";
    }
    return _text;
}

// Arrange annotations within a `ModifierContext`
+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray* annotations = modifiers;
    if(!annotations || annotations.count == 0)
    {
        return NO;
    }

    float text_line = state.text_line;
    float max_width = 0;

    // Format Annotations
    float width = 0;
    for(NSUInteger i = 0; i < annotations.count; ++i)
    {
        MNAnnotation* annotation = annotations[i];
        [annotation setText_line:text_line];
        width = annotation.width > max_width ? annotation.width : max_width;
        text_line++;
    }

    state.left_shift += width / 2;
    state.right_shift += width / 2;

    return YES;
}

// Render text beside the note.
- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    if(!self.note)
    {
        MNLogError(@"NoNoteForAnnotation, Can't draw text annotation without an attached note.");
    }

    MNPoint* start = [self.note getModifierstartXYforPosition:MNPositionAbove andIndex:self.index];

    CGContextSaveGState(ctx);

    //    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.alignment = kCTTextAlignmentLeft;
    NSAttributedString* title =
        [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName : self.font.font}];
    
    CGSize size = [MNText measureText:title withFont:self.font];

    float text_width = size.width;
    float text_height = size.height;
    float x, y;

    if(self.justification == MNJustifyLEFT)
    {
        x = start.x;
    }
    else if(self.justification == MNJustifyRIGHT)
    {
        x = start.x - text_width;
    }
    else if(self.justification == MNJustifyCENTER)
    {
        x = start.x - text_width / 2;
    }
    else /*  MNJustifyCENTER_STEM */
    {
        if([self.note isKindOfClass:[MNStemmableNote class]])
        {
            x = ((MNStemmableNote*)self.note).stemX - text_width / 2;
        }
    }

    MNExtentStruct* stem_ext;
    float spacing = 0;
    BOOL has_stem = self.note.hasStem;
    MNStaff* staff = self.note.staff;

    // The position of the text varies based on whether or not the note
    // has a stem.
    if(has_stem)
    {
        if([self.note isKindOfClass:[MNStemmableNote class]])
        {
            stem_ext = ((MNStemmableNote*)self.note).stem.extents;
        }
        spacing = staff.spacingBetweenLines;
    }

    if(self.vert_justification == MNVerticalJustifyBOTTOM)
    {
        y = [staff getYForBottomTextWithLine:self.text_line];
        if(has_stem)
        {
            if([self.note isKindOfClass:[MNStemmableNote class]])
            {
                float stem_base =
                    (((MNStemmableNote*)self.note).stemDirection == MNStemDirectionUp ? stem_ext.baseY : stem_ext.topY);
                y = MAX(y, stem_base + (spacing * (self.text_line + 2)));
            }
        }
    }
    else if(self.vert_justification == MNVerticalJustifyCENTER)
    {
        if([self.note isKindOfClass:[MNStemmableNote class]])
        {
            float yt = [((MNStaffNote*)self.note)getYForTopText:self.text_line] - 1;
            float yb = [staff getYForBottomTextWithLine:self.text_line];
            y = yt + (yb - yt) / 2 + text_height / 2;
        }
    }
    else if(self.vert_justification == MNVerticalJustifyTOP)
    {
        y = MIN([staff getYForTopTextWithLine:self.text_line], [self.note.ys[0] floatValue] - 10);
        if(has_stem)
        {
            y = MIN(y, (stem_ext.topY - 5) - (spacing * self.text_line));
        }
    }
    else /* CENTER_STEM */
    {
        if([self.note isKindOfClass:[MNStemmableNote class]])
        {
            MNExtentStruct* extents = ((MNStemmableNote*)self.note).stemExtents;

            y = extents.topY + (extents.baseY - extents.topY) / 2;   // + text_height / 2;
        }
    }

    //    [title drawInRect:CGRectMake(self.x, y - 3, 50, 100)];
    //    [title drawAtPoint:CGPointMake(x, y - text_height)];
//    [MNText showBoundingBox:YES];
//    [MNText drawText:ctx
//             atPoint:MNPointMake(x, YES)
//          withBounds:CGRectMake(self.x, y - 3, 50, 100)
//            withText:title.string];
    
    [MNText drawText:ctx withFont:self.font atPoint:MNPointMake(x, y - 3) withText:title];
    
    
//    [MNText showBoundingBox:NO];

    self.width = size.width;
    self.point = MNPointMake(x, y);

    //    // uncomment to display boundind box
    //    MNBoundingBox* bb = [MNBoundingBox boundingBoxAtX:x atY:y withWidth:title.size.width
    //    andHeight:title.size.height];
    //    [bb draw:ctx];

    MNLogInfo(@"Rendering annotation: %@ %f %f", self.text, x, y);
    CGContextRestoreGState(ctx);
}

@end
