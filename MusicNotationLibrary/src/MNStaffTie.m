//
//  MNStaffTie.m
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

#import "MNStaffTie.h"
#import "MNUtils.h"
#import "MNNoteTie.h"
#import "MNStaffNote.h"
#import "MNText.h"
#import "MNFont.h"

@interface MNStaffTie ()
//@property (assign, nonatomic) float cp1;
//@property (assign, nonatomic) float cp2;
@property (assign, nonatomic) float text_shift_x;
@property (assign, nonatomic) float first_x_shift;
@property (assign, nonatomic) float last_x_shift;
//@property (assign, nonatomic) float y_shift;

@property (strong, nonatomic) NSString* font_family;
@property (assign, nonatomic) float font_size;
@property (strong, nonatomic) NSString* font_style;
@end

@implementation MNStaffTie

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        //         [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
        [self setupStaffTie];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict andText:(NSString*)text
{
    self = [self initWithDictionary:optionsDict];
    if(self)
    {
        //         [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
        [self setupStaffTie];
    }
    return self;
}

- (instancetype)initWithNoteTie:(MNNoteTie*)noteTie
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.notes = noteTie;
        [self setupStaffTie];
        [self setupNotes:noteTie];
    }
    return self;
}

- (instancetype)initWithNoteTie:(MNNoteTie*)noteTie andText:(NSString*)text
{
    self = [self initWithNoteTie:noteTie];
    if(self)
    {
        self.text = text;
    }
    return self;
}

- (instancetype)initWithNotes:(MNNoteTie*)notes andText:(NSString*)text
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.notes = notes;
        self.text = text;
        [self setupStaffTie];

        [self setupNotes:notes];
    }
    return self;
}

/*!
 *  init
 *  @param last_note     <#last_note description#>
 *  @param first_note    <#first_note description#>
 *  @param first_indices <#first_indices description#>
 *  @param last_indices  <#last_indices description#>
 *  @return <#return value description#>
 */
- (instancetype)initWithLastNote:(MNNote*)last_note
                       firstNote:(MNNote*)first_note
                    firstIndices:(NSArray*)first_indices
                     lastIndices:(NSArray*)last_indices
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
        [self setupStaffTie];
    }
    return self;
}

- (void)setupStaffTie
{
    self.cp1 = 8;
    self.cp2 = 15;
    self.text_shift_x = 0;
    self.first_x_shift = 0;
    self.last_x_shift = 0;
    self.yShift = 7;
    self.tie_spacing = 0;
    self.font_family = @"Arial";
    self.font_size = 10;
    self.font_style = @"";
    self.font = [MNFont fontWithName:@"Arial" size:10];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
    //        @"first_note" : @"firstNote",
    //        @"first_indices" : @"firstIndices",
    //        @"last_note" : @"lastNote",
    //        @"first_note" : @"firstNote",
    //    }];
    return propertiesEntriesMapping;
}

// Set the notes to attach this tie to.
- (void)setupNotes:(MNNoteTie*)notes
{
    if(notes.firstNote == nil && notes.lastNote == nil)
    {
        [MNLog logError:@"BadArguments, Tie needs to have either first_note or last_note set."];
    }
    //    if(notes.firstIndices == nil || [notes.firstIndices isKindOfClass:[NSNull class]])
    //        notes.firstIndices = @[];
    //    if(notes.lastIndices == nil || [notes.lastIndices isKindOfClass:[NSNull class]])
    //        notes.lastIndices = @[];

    if(notes.firstIndices.count != notes.lastIndices.count)
    {
        [MNLog logError:@"BadArguments, Tied notes must have similarindex sizes"];
    }

    // Success. Lets grab 'em notes.
    self.firstNote = (MNStaffNote*)notes.firstNote;
    self.firstIndices = notes.firstIndices;
    self.lastNote = (MNStaffNote*)notes.lastNote;
    self.lastIndices = notes.lastIndices;
}

// Returns YES if this is a partial bar.
- (BOOL)isPartial
{
    return (self.firstNote == nil || self.lastNote == nil);
}

- (void)renderTieWithContext:(CGContextRef)ctx
                     firstYs:(NSArray*)first_ys
                      lastYs:(NSArray*)last_ys
                     lastXpx:(float)last_x_px
                    firstXpx:(float)first_x_px
                   direction:(MNStemDirectionType)direction
{
    float cp1, cp2;
    cp1 = self.cp1;
    cp2 = self.cp2;

    if(fabs(last_x_px - first_x_px) < 10)
    {
        cp1 = 2;
        cp2 = 8;
    }

    float first_x_shift = self.first_x_shift;
    float last_x_shift = self.last_x_shift;
    float y_shift = self.yShift * direction;

    for(int i = 0; i < self.firstIndices.count; ++i)
    {
        float cp_x = ((last_x_px + last_x_shift) + (first_x_px + first_x_shift)) / 2;
        NSUInteger index = [self.firstIndices[i] integerValue];
        float first_y_px = [first_ys[index] floatValue] + y_shift;
        index = [self.lastIndices[i] integerValue];
        float last_y_px = [last_ys[index] floatValue] + y_shift;

        //        var first_y_px = params.first_ys[this.first_indices[i]] + y_shift;
        //        var last_y_px = params.last_ys[this.last_indices[i]] + y_shift;

        if(isnan(first_y_px) || isnan(last_y_px))
        {
            [MNLog logError:@"BadArguments, Bad indices for tie rendering."];
        }

        float top_cp_y = ((first_y_px + last_y_px) / 2) + (cp1 * direction);
        float bottom_cp_y = ((first_y_px + last_y_px) / 2) + (cp2 * direction);

        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, first_x_px + first_x_shift, first_y_px);
        CGContextAddQuadCurveToPoint(ctx, cp_x, top_cp_y, last_x_px + last_x_shift, last_y_px);
        CGContextAddQuadCurveToPoint(ctx, cp_x, bottom_cp_y, first_x_px + first_x_shift, first_y_px);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
    }
}

- (void)renderText:(CGContextRef)ctx first_x_px:(float)first_x_px last_x_px:(float)last_x_px
{
    if(self.text == nil)
    {
        return;
    }
    float center_x = (first_x_px + last_x_px) / 2;
    center_x -= [MNText measureText:self.text withFont:self.font].width / 2;

    MNStaff* staff = (self.firstNote.staff != nil ? self.firstNote.staff : self.lastNote.staff);

    MNPoint* point = MNPointMake(center_x + self.text_shift_x, [staff getYForTopText] - 1);

    //     [MNText setFont:[MNFont fontWithName:self.font_family size:self.font_size]];
    //     [MNText setBold:YES];
    //     [MNText drawText:ctx atPoint:point withText:self.text];

    self.font = [MNFont fontWithName:self.font_family size:self.font_size];

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;   // kCTTextAlignmentLeft;

    //    if (!self.font) {
    //        self.font =[MNFont fontWithName:@"Helvetica" size:12];
    //    }

    NSAttributedString* title = [[NSAttributedString alloc]
        initWithString:self.text
            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : self.font}];

    // FIXME: kCTTextAlignmentCenter does nothing
    [title drawAtPoint:CGPointMake(point.x - title.size.width / 2, point.y - title.size.height / 2)];
}

- (void)draw:(CGContextRef)ctx
{
    //    [super draw:ctx];
    //    if(!ctx)
    //    {
    //        MNLogError(@"NoCanvasContext, Can't draw without a canvas context.");
    //    }

    float first_x_px, last_x_px;
    NSArray* first_ys;
    NSArray* last_ys;
    MNStemDirectionType stem_direction = MNStemDirectionNone;

    if(self.firstNote)
    {
        first_x_px = self.firstNote.tieRightX + self.tie_spacing;
        stem_direction = self.firstNote.stemDirection;
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
        stem_direction = self.lastNote.stemDirection;
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
                     direction:stem_direction];
}

@end
