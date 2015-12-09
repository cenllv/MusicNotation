//
//  MNBend.m
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

#import "MNBend.h"
#import "MNStaffNote.h"
#import "MNText.h"
#import "MNBendRenderOptions.h"
#import "MNBendStruct.h"

@implementation MNBend

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        _draw_width = 1;
    }
    return self;
}

- (instancetype)initWithText:(NSString*)text
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupBendWith:text release:NO phrase:nil];
    }
    return self;
}

- (instancetype)initWithPhrase:(NSArray*)phrase
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupBendWith:nil release:NO phrase:phrase];
    }
    return self;
}

- (instancetype)initWithText:(NSString*)text release:(BOOL)release phrase:(NSArray*)phrase
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupBendWith:text release:release phrase:phrase];
    }
    return self;
}

+ (MNBend*)bendWithText:(NSString*)text
{
    return [[MNBend alloc] initWithText:text release:NO phrase:nil];
}

- (void)setupBendWith:(NSString*)text release:(BOOL)release phrase:(NSArray*)phrase
{
    self.text = text;
    self.xShift = 0;
    self.release_ = release;
    self.fontName = @"10pt Arial";

    self->_renderOptions = [[MNBendRenderOptions alloc] initWithDictionary:nil];
    [self->_renderOptions setLine_width:1.5];
    [self->_renderOptions setLine_style:@"#777777"];
    [self->_renderOptions setBend_width:8];
    [self->_renderOptions setRelease_width:8];

    if(phrase)
    {
        self.phrase = [phrase oct_map:^MNBendStruct*(NSDictionary* bendDict) {
          MNBendStruct* ret = [[MNBendStruct alloc] initWithDictionary:bendDict];
          return ret;
        }];
    }
    else
    {
        // Backward compatibility
        self.phrase = [@[ [MNBendStruct bendStructWithType:MNBendUP andText:self.text] ] mutableCopy];
        if(self.release_)
        {
            [self.phrase
                push:[MNBendStruct bendStructWithType:MNBendDOWN andText:@""]];   //@{ @"type" : @(MNBendDOWN), @"text"
            //                                                               : @""
        }

        //        self.bendDirectionType = MNBendUP;
        //        if(release)
        //        {
        //            self.bendDirectionType = MNBendDOWN;
        //        }
    }

    [self updateWidth];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{ @"type" : @"bendDirectionType" }];
    return propertiesEntriesMapping;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);   // return @"bends";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

/*!
 *  Arrange bends in `ModifierContext`
 *  @param modifiers collection of `Modifier`
 *  @param state     state of the `ModifierContext`
 *  @param context   the calling `ModifierContext`
 *  @return YES if succussful
 */
+ (BOOL)format:(NSMutableArray<MNModifier*>*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray<MNBend*>* bends = (NSMutableArray<MNBend*>*)modifiers;
    if(!bends || bends.count == 0)
    {
        return NO;
    }

    float last_width = 0;
    float text_line = state.text_line;

    // Format Bends
    for(MNBend* bend in bends)
    {
        bend.xShift = last_width;
        last_width = bend.width;
        bend.text_line = text_line;
    }

    // FIXME: these two lines are CHANGE:'d
    //    state.right_shift += last_width;
    //    state.text_line += 1;

    return YES;
}

- (id)setXShift:(float)x_shift
{
    // NOTE: this method overrides supclass method entirely
    // // // //  [super setXShift:x_shift];
    _xShift = x_shift;
    return [self updateWidth];
}

/*
    setFont: function(font) { self.font = font; return this; },

    getText: function() { return self.text; },
*/

- (id)updateWidth
{
    float (^measure_text)(NSString*) = ^float(NSString* text) {
      float text_width;
      //      CTTextAlignment justification = kCTTextAlignmentLeft;
      NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
      MNFont* font1 = [MNFont fontWithName:@"times" /*self.fontFamily*/ size:12];
      NSAttributedString* title = [[NSAttributedString alloc]
          initWithString:text
              attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1.font}];
      text_width = title.size.width;
      return text_width;
    };

    float total_width = 0;
    for(uint i = 0; i < self.phrase.count; ++i)
    {
        MNBendStruct* bend = self.phrase[i];
        if(bend.width != 0)
        {
            total_width += bend.width;
        }
        else
        {
            MNBendRenderOptions* renderOptions = self->_renderOptions;
            float additional_width = (bend.type == MNBendUP) ? renderOptions.bend_width : renderOptions.release_width;

            bend.width = MAX(additional_width, measure_text(bend.text)) + 3;
            bend.draw_width = bend.width / 2;
            total_width += bend.width;
        }
    }

    [self setWidth:(total_width + self.xShift)];
    return self;
}

- (void)draw:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    [super draw:ctx];

    //    CGContextSetLineWidth(ctx, self.draw_width);
    //    CGContextSetStrokeColorWithColor(ctx, MNColor.blackColor.CGColor);

    MNNote* note = (MNNote*)self.note;
    MNPoint* start = [note getModifierstartXYforPosition:MNPositionRight andIndex:self.index];

    start.x += 3;
    start.y += 0.5;
    float x_shift = self.xShift;

    float bend_height = [note.staff getYForTopTextWithLine:self.text_line] + 3;
    float annotation_y = [note.staff getYForTopTextWithLine:self.text_line] - 1;
    __block MNBend* that = self;

    void (^setStrokeStyle)(MNBendRenderOptions*);
    void (^renderBend)(float, float, float, float);
    void (^renderRelease)(float, float, float, float);
    void (^renderArrowHead)(float, float, MNBendDirectionType);
    void (^renderText)(float, NSString*);

    setStrokeStyle = ^void(MNBendRenderOptions* renderOptions) {
      if(renderOptions.components)
      {
          CGFloat* components = malloc(sizeof(CGFloat) * renderOptions.components.count);
          NSUInteger i = 0;
          for(NSNumber* component in renderOptions.components)
          {
              components[i++] = component.floatValue;
          }
          CGContextSetStrokePattern(ctx, renderOptions.pattern, components);
          CGContextSetFillPattern(ctx, renderOptions.pattern, components);
          free(components);
      }
    };

    renderBend = ^void(float x, float y, float width, float height) {
      float cp_x = x + width;
      float cp_y = y;
      CGContextSaveGState(ctx);
      CGContextBeginPath(ctx);
      CGContextSetLineWidth(ctx, [that->_renderOptions line_width]);
      //        CGContextSetStrokeColorWithColor(ctx, <#CGColorRef color#>)

      CGContextMoveToPoint(ctx, x, y);
      CGContextAddQuadCurveToPoint(ctx, cp_x, cp_y, x + width, height);
      //        CGContextClosePath(ctx);
      //      CGContextStrokePath(ctx);
      CGContextDrawPath(ctx, kCGPathStroke);
      CGContextRestoreGState(ctx);

    };

    renderRelease = ^void(float x, float y, float width, float height) {
      CGContextSaveGState(ctx);
      CGContextBeginPath(ctx);
      MNBendRenderOptions* renderOptions = that->_renderOptions;
      CGContextSetLineWidth(ctx, [that->_renderOptions line_width]);
      setStrokeStyle(renderOptions);
      CGContextMoveToPoint(ctx, x, height);
      CGContextAddQuadCurveToPoint(ctx, x + width, height, x + width, y);
      CGContextDrawPath(ctx, kCGPathStroke);
      CGContextRestoreGState(ctx);
    };

    renderArrowHead = ^void(float x, float y, MNBendDirectionType direction) {
      CGContextSaveGState(ctx);
      float width = 4;
      float dir = 1.f;
      switch(direction)
      {
          case MNBendDOWN:
              dir = -1.f;
              break;
          case MNBendUP:
              dir = 1.f;
              break;
          case MNBendNONE:
          default:
              dir = 1.f;
              break;
      }
      CGContextBeginPath(ctx);
      CGContextMoveToPoint(ctx, x, y);
      CGContextAddLineToPoint(ctx, x - width, y + width * dir);
      CGContextAddLineToPoint(ctx, x + width, y + width * dir);
      CGContextClosePath(ctx);
      CGContextDrawPath(ctx, kCGPathFill);
      CGContextRestoreGState(ctx);
    };

    renderText = ^void(float x, NSString* text) {
      CGContextSaveGState(ctx);

      float render_x = x - ([MNText measureText:text withFont:self.font].width / 2);
      //       [MNText drawText:ctx atPoint:MNPointMake(render_x, annotation_y) withText:text];

      MNPoint* point = MNPointMake(render_x, annotation_y);

      //      CTTextAlignment justification = kCTTextAlignmentLeft;
      NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.alignment = NSTextAlignmentLeft;   // justification;
      MNFont* font1 = [MNFont fontWithName:@"times" /*self.fontFamily*/ size:12];
      NSAttributedString* title = [[NSAttributedString alloc]
          initWithString:text
              attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1.font}];
      CGSize size = [MNText measureText:title withFont:font1];
      float h = size.height;
      //      float w = title.size.width;
      [title drawAtPoint:CGPointMake(point.x, point.y - h)];

      CGContextRestoreGState(ctx);
    };

    __block MNBendStruct* last_bend = nil;
    __block float last_drawn_width = 0;
    [self.phrase enumerateObjectsUsingBlock:^(MNBendStruct* bend, NSUInteger i, BOOL* stop) {
      if(bend.type == MNBendNONE)
      {
          MNLogError(@"Bend needs a direction.");
      }

      if(i == 0)
      {
          bend.draw_width += x_shift;
      }
      last_drawn_width = bend.draw_width + (last_bend ? last_bend.draw_width : 0) - (i == 1 ? x_shift : 0);
      if(bend.type == MNBendUP)
      {
          if(last_bend && last_bend.type == MNBendUP)
          {
              renderArrowHead(start.x, bend_height, 0);
          }

          renderBend(start.x, start.y, last_drawn_width, bend_height);
      }

      if(bend.type == MNBendDOWN)
      {
          if(last_bend && last_bend.type == MNBendUP)
          {
              renderRelease(start.x, start.y, last_drawn_width, bend_height);
          }

          if(last_bend && last_bend.type == MNBendDOWN)
          {
              renderArrowHead(start.x, start.y, -1);
              renderRelease(start.x, start.y, last_drawn_width, bend_height);
          }

          if(last_bend == nil)
          {
              last_drawn_width = bend.draw_width;
              renderRelease(start.x, start.y, last_drawn_width, bend_height);
          }
      }

      renderText(start.x + last_drawn_width, bend.text);
      last_bend = bend;
      last_bend.x = start.x;

      start.x += last_drawn_width;

    }];

    // Final arrowhead and text
    if(last_bend.type == MNBendUP)
    {
        renderArrowHead(last_bend.x + last_drawn_width, bend_height, MNBendUP);
    }
    else if(last_bend.type == MNBendDOWN)
    {
        renderArrowHead(last_bend.x + last_drawn_width, start.y, MNBendDOWN);
    }
    CGContextRestoreGState(ctx);
}
@end
