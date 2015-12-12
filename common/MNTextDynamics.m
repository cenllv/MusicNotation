//
//  MNTextDynamics.m
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

#import "MNTextDynamics.h"
#import "MNStaff.h"
#import "NSString+Ruby.h"
#import "MNGlyph.h"

@interface MNTextDynamicsGlyphStruct : IAModelBase
@property (strong, nonatomic) NSString* code;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float size;
@end

@implementation MNTextDynamicsGlyphStruct
@end

@interface MNTextDynamics ()

@property (strong, nonatomic) NSMutableArray* glyphs;

@end

@implementation MNTextDynamics

/*!
 *  A `TextDynamics` object inherits from `MNNote` so that it can be formatted
 *  within a `Voice`.
 *  Create the dynamics marking. `text_struct` is an object
 *  that contains a `duration` property and a `sequence` of
 *  letters that represents the letters to render
 *  @param optionsDict text dynamics struct data
 *  @return a new text dynamics object
 */
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.renderOptions.glyphFontScale = 40;
        _sequence = _text.lowercaseString;
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

static NSDictionary* _textDynamicsGlyphs;

/*!
 *  The glyph data for each dynamics letter
 *  @return a dictionary of the glyph data
 */
+ (NSDictionary*)textDynamicsGlyphs
{
    if(!_textDynamicsGlyphs)
    {
        _textDynamicsGlyphs = @{
            @"f" : @{@"code" : @"vba", @"width" : @12},
            @"p" : @{@"code" : @"vbf", @"width" : @14},
            @"m" : @{@"code" : @"v62", @"width" : @17},
            @"s" : @{@"code" : @"v4a", @"width" : @10},
            @"z" : @{@"code" : @"v80", @"width" : @12},
            @"r" : @{@"code" : @"vb1", @"width" : @12}
        };
    }

    return _textDynamicsGlyphs;
}

- (NSMutableArray*)glyphs
{
    if(!_glyphs)
    {
        _glyphs = [NSMutableArray array];
    }
    return _glyphs;
}

/*!
 *  <#Description#>
 *  @param text <#text description#>
 *  @return <#return value description#>
 */
- (id)setText:(NSString*)text
{
    _text = text;
    self.sequence = _text.lowercaseString;
    self.preFormatted = NO;
    return self;
}

///*!
// *  Set the staff line on which the note should be placed
// *  @param line the line on the staff
// *  @return this object
// */
//- (id)setLine:(float)line
//{
//    [super setLine:line];
//    return self;
//}

//
/*!
 *  Preformat the dynamics text
 *  @return if successful
 */
- (BOOL)preFormat
{
    __block BOOL success = [super preFormat];
    __block float total_width = 0;
    [[self.sequence split:@""] oct_foreach:^(NSString* letter, NSUInteger i, BOOL* stop) {
      NSDictionary* glyphDict = [[[self class] textDynamicsGlyphs] objectForKey:letter.lowercaseString];
      if(!glyphDict)
      {
          MNLogError(@"Invalid dynamics character: %@", letter);
          success = NO;
      }
      float size = self.renderOptions.glyphFontScale;
      MNTextDynamicsGlyphStruct* glyph = [[MNTextDynamicsGlyphStruct alloc] initWithDictionary:glyphDict];
      glyph.size = size;
      [self.glyphs push:glyph];
      total_width += glyph.width;
    }];

    // Store the width of the text
    [self setWidth:total_width];
    self.preFormatted = YES;

    return success;
}

/*!
 *  Draw the dynamics text on the rendering context
 *  @param ctx the core graphics opaque type drawing environment
 */
- (void)draw:(CGContextRef)ctx
{
    float x, y;
    x = self.absoluteX;
    y = [self.staff getYForLine:self.line + (-3)];

    MNLogDebug(@"Rendering Dynamics: %@", self.sequence);

    __block float letter_x = x;
    [self.glyphs oct_foreach:^(MNTextDynamicsGlyphStruct* glyph, NSUInteger i, BOOL* stop) {
      //      NSString* current_letter = [self.sequence substringWithRange:NSMakeRange(i, 1)];
      [MNGlyph renderGlyph:ctx atX:letter_x atY:y withScale:1 forGlyphCode:glyph.code];
      letter_x += glyph.width;   //[[[[[self class] textDynamicsGlyphs] objectForKey:current_letter]
      // objectForKey:@"width"] floatValue];
    }];
}

@end
