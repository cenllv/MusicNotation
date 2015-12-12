//
//  MNFont.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
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

@class MNColor;

/*!
 *  The `MNFont` class
 */
@interface MNFont : NSObject
{
   @private
#if TARGET_OS_IPHONE
    UIFont* _font;
#elif TARGET_OS_MAC
    NSFont* _font;
#endif
    BOOL _bold;
    BOOL _italic;
    float _fontSize;
    NSString* _family;
    MNColor* _strokeColor;
    MNColor* _fillColor;
    MNColor* _backColor;
}
#pragma mark - Properties
#if TARGET_OS_IPHONE
@property (strong, atomic) UIFont* font;
#elif TARGET_OS_MAC
@property (strong, atomic) NSFont* font;
#endif
@property (assign, atomic) BOOL bold;
@property (assign, atomic) BOOL italic;
@property (assign, atomic) float size;
@property (strong, atomic) NSString* family;
@property (strong, atomic) MNColor* strokeColor;
@property (strong, atomic) MNColor* fillColor;
@property (strong, atomic) MNColor* backColor;

#pragma mark - Methods

+ (MNFont*)systemFontWithSize:(CGFloat)fontSize;
+ (MNFont*)fontWithName:(NSString*)fontName size:(CGFloat)fontSize;
+ (MNFont*)fontWithName:(NSString*)fontName size:(CGFloat)fontSize bold:(BOOL)bold italic:(BOOL)italic;

+ (NSArray<NSString*>*)fontNames;
+ (BOOL)fontAvailable:(NSString*)fontName;
+ (NSArray<NSString*>*)availableFonts;

@end
