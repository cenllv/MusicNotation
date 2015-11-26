//
//  MNVibrato.m
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

#import "MNVibrato.h"
#import "MNModifierContext.h"
#import "MNBend.h"
#import "MNLog.h"
#import "MNStaffNote.h"
#import "MNPoint.h"

@implementation MNVibrato

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        //        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupVibrato];
    }
    return self;
}

- (void)setupVibrato
{
    _harsh = NO;
    self.position = MNPositionRight;
    self->_renderOptions = [[MNVibratoRenderOptions alloc] init];
    [self->_renderOptions setVibrato_width:20];
    [self->_renderOptions setWave_height:6];
    [self->_renderOptions setWave_width:4];
    [self->_renderOptions setWave_girth:2];

    [self setVibratoWidth:[self->_renderOptions vibrato_width]];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"vibratos";
}

// Arrange vibratos inside a `ModifierContext`.
// TODO: this prototype differs from the other  MNModifiers
+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray* vibratos = modifiers;
    if(!vibratos || vibratos.count == 0)
    {
        return NO;
    }

    float text_line = (float)state.text_line;
    float width = 0;
    float shift = state.right_shift - 7;

    // If there's a bend, drop the text line
    NSArray* bends = [context getModifiersForType:[MNBend CATEGORY]];
    if(bends && bends.count > 0)
    {
        text_line--;
    }

    // Format Vibratos
    for(MNVibrato* vibrato in vibratos)
    {
        vibrato.xShift = shift;
        vibrato.text_line = text_line;
        width += vibrato.width;
        shift += width;
    }

    state.right_shift += width;
    state.text_line += 1;
    return YES;
}

- (id)setVibratoWidth:(float)width
{
    _vibrato_width = width;
    //    _width = width;
    return self;
}

- (id)setHarsh:(BOOL)harsh
{
    _harsh = harsh;
    return self;
}
- (BOOL)harsh
{
    return _harsh;
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    if(!self->_note)
    {
        [MNLog logError:[NSString
                            stringWithFormat:@"NoNoteForVibrato %@", @"Can't draw vibrato without an attached note."]];
    }

    MNPoint* start = [((MNStaffNote*)self.note)getModifierstartXYforPosition:MNPositionRight andIndex:self.index];

    MNVibrato* that = self;
    float vibrato_width = self.vibrato_width;

    void (^renderVibrato)(float, float) = ^void(float x, float y) {
      float wave_width = [that->_renderOptions wave_width];
      float wave_girth = [that->_renderOptions wave_girth];
      float wave_height = [that->_renderOptions wave_height];
      float num_waves = vibrato_width / wave_width;

      CGContextBeginPath(ctx);

      NSUInteger i;
      if(that.harsh)
      {
          CGContextMoveToPoint(ctx, x, y + wave_girth + 1);
          for(i = 0; i < num_waves / 2; ++i)
          {
              CGContextAddLineToPoint(ctx, x + wave_width, y - (wave_height / 2));
              x += wave_width;
              CGContextAddLineToPoint(ctx, x + wave_width, y + (wave_height / 2));
              x += wave_width;
          }
          for(i = 0; i < num_waves / 2; ++i)
          {
              CGContextAddLineToPoint(ctx, x - wave_width, (y - (wave_height / 2)) + wave_girth + 1);
              x -= wave_width;
              CGContextAddLineToPoint(ctx, x - wave_width, (y + (wave_height / 2)) + wave_girth + 1);
              x -= wave_width;
          }
          // ctx.fill();
          CGContextFillPath(ctx);
      }
      else
      {
          CGContextMoveToPoint(ctx, x, y + wave_girth);
          for(i = 0; i < num_waves / 2; ++i)
          {
              CGContextAddQuadCurveToPoint(ctx, x + (wave_width / 2), y - (wave_height / 2), x + wave_width, y);
              x += wave_width;
              CGContextAddQuadCurveToPoint(ctx, x + (wave_width / 2), y + (wave_height / 2), x + wave_width, y);
              x += wave_width;
          }

          for(i = 0; i < num_waves / 2; ++i)
          {
              CGContextAddQuadCurveToPoint(ctx, x - (wave_width / 2), (y + (wave_height / 2)) + wave_girth,
                                           x - wave_width, y + wave_girth);

              x -= wave_width;
              CGContextAddQuadCurveToPoint(ctx, x - (wave_width / 2), (y - (wave_height / 2)) + wave_girth,
                                           x - wave_width, y + wave_girth);
              x -= wave_width;
          }
          CGContextFillPath(ctx);
      }
    };

    float vx = start.x + self.xShift;
    float vy = [((MNStemmableNote*)self.note)getYForTopText:self.text_line];   // + 2; // CHANGE:

    renderVibrato(vx, vy);
}

@end
