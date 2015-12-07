//
//  MNFont.m
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

#import "MNFont.h"
#import "MNUtils.h"
#import "OCTotallyLazy.h"
#import "MNColor.h"

@implementation MNFont

static NSArray<NSString*>* _availableFonts;

+ (NSArray<NSString*>*)availableFonts
{
    if(!_availableFonts)
    {
#if TARGET_OS_IPHONE
        NSMutableArray* arr = [NSMutableArray array];
        for(NSString* familyName in [UIFont familyNames])
        {
            //        NSLog(@"Family name: %@", familyName);
            for(NSString* fontName in [UIFont fontNamesForFamilyName:familyName])
            {
                //            NSLog(@"--Font name: %@", fontName);
                [arr addObject:fontName];
            }
        }
        _availableFonts = arr;
#elif TARGET_OS_MAC
        _availableFonts = [[NSFontManager sharedFontManager] availableFonts];
// availableFontFamilies];
#endif
    }
    return _availableFonts;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _fontSize = 12;
#if TARGET_OS_IPHONE
        _font = [UIFont systemFontOfSize:_fontSize];
#elif TARGET_OS_MAC
        _font = [NSFont systemFontOfSize:_fontSize];
#endif
        _bold = NO;
        _italic = NO;
        _family = _font.familyName;
    }
    return self;
}

/*
#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC

#endif
 */

+ (MNFont*)systemFontWithSize:(CGFloat)fontSize
{
    MNFont* ret = [(MNFont*)[MNFont alloc] init];
    //    ret.family = fontName;
#if TARGET_OS_IPHONE
    ret.font = [UIFont systemFontOfSize:fontSize];
#elif TARGET_OS_MAC
    ret.font = [NSFont systemFontOfSize:fontSize];
#endif
    ret.size = fontSize;
    return ret;
}

+ (MNFont*)fontWithName:(NSString*)fontName size:(CGFloat)fontSize
{
    MNFont* ret = [(MNFont*)[MNFont alloc] init];
//    ret.family = fontName;
#if TARGET_OS_IPHONE
    ret.font = [UIFont fontWithName:fontName size:fontSize];
#elif TARGET_OS_MAC
    ret.font = [NSFont fontWithName:fontName size:fontSize];
#endif
    ret.size = fontSize;
    return ret;
}

+ (MNFont*)fontWithName:(NSString*)fontName size:(CGFloat)fontSize weight:(NSString*)weight
{
    //    return (MNFont*)[UIFont fontWithName:fontName size:fontSize];   // TODO: not using weight
    MNFont* ret = [(MNFont*)[MNFont alloc] init];
//    ret.family = fontName;
#if TARGET_OS_IPHONE
    ret.font = [UIFont fontWithName:fontName size:fontSize];
#elif TARGET_OS_MAC
    ret.font = [NSFont fontWithName:fontName size:fontSize];
#endif
    ret.size = fontSize;
    return ret;
}

+ (MNFont*)fontWithName:(NSString*)fontName size:(CGFloat)fontSize bold:(BOOL)bold italic:(BOOL)italic
{
    MNFont* ret = [MNFont fontWithName:fontName size:fontSize];
    if(bold)
    {
        [ret setBold:YES];
    }
    if(italic)
    {
        [ret setItalic:YES];
    }
    return ret;
}

#pragma mark - Properties

- (MNColor*)fillColor
{
    if(!_fillColor)
    {
        _fillColor = MNColor.blackColor;
    }
    return _fillColor;
}

- (void)setFillColor:(MNColor*)fillColor
{
    _fillColor = fillColor;
}

- (MNColor*)strokeColor
{
    //    if(!_strokeColor)
    //    {
    //        _strokeColor = MNColor.blackColor;
    //    }
    return _strokeColor;
}

- (void)setStrokeColor:(MNColor*)strokeColor
{
    _strokeColor = strokeColor;
}

- (MNColor*)backColor
{
    return _backColor;
}

- (void)setBackColor:(MNColor*)backColor
{
    _backColor = backColor;
}

- (BOOL)bold
{
    return _bold;
}

- (void)setBold:(BOOL)bold
{
    _bold = bold;
#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC
    [[NSFontManager sharedFontManager] convertWeight:YES ofFont:_font];
#endif
}

- (BOOL)italic
{
    return _italic;
}

- (void)setItalic:(BOOL)italic
{
    if(italic != _italic)
    {
#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC
        if(italic)
        {
            _font = [[NSFontManager sharedFontManager] convertFont:_font toHaveTrait:NSFontItalicTrait];
        }
        else
        {
            _font = [[NSFontManager sharedFontManager] convertFont:_font toNotHaveTrait:NSFontItalicTrait];
        }
#endif
    }
    _italic = italic;
}

- (void)setSize:(float)size
{
    if(size != _fontSize)
    {
#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC
        _font = [[NSFontManager sharedFontManager] convertFont:_font toSize:size];
#endif
        _fontSize = size;
    }
}

- (float)size
{
    return _fontSize;
}

- (NSString*)family
{
    return _family;
}

- (void)setFamily:(NSString*)family
{
    if([[[self class] availableFonts] containsObject:family])
    {
        _family = family;
        //        _font = [[NSFontManager sharedFontManager] convertFont:_font toFamily:_family];
        _font = [[MNFont fontWithName:family size:self.size bold:self.bold italic:self.italic] font];
    }
    else
    {
        MNLogError(@"Unknown fontFamily: %@", family);
    }
}

static NSArray<NSString*>* _fontNames;
+ (NSArray<NSString*>*)fontNames
{
    if(!_fontNames)
    {
        _fontNames = @[
            @"AcademyEngravedLetPlain",
            @"AlNile-Bold",
            @"AlNile",
            @"AmericanTypewriter",
            @"AmericanTypewriter-Bold",
            @"AmericanTypewriter-Condensed",
            @"AmericanTypewriter-CondensedBold",
            @"AmericanTypewriter-CondensedLight",
            @"AmericanTypewriter-Light",
            @"AppleColorEmoji",
            @"AppleSDGothicNeo-Thin",
            @"AppleSDGothicNeo-Light",
            @"AppleSDGothicNeo-Regular",
            @"AppleSDGothicNeo-Medium",
            @"AppleSDGothicNeo-SemiBold",
            @"AppleSDGothicNeo-Bold",
            @"AppleSDGothicNeo-Medium",
            @"ArialMT",
            @"Arial-BoldItalicMT",
            @"Arial-BoldMT",
            @"Arial-ItalicMT",
            @"ArialHebrew",
            @"ArialHebrew-Bold",
            @"ArialHebrew-Light",
            @"ArialRoundedMTBold",
            @"Avenir-Black",
            @"Avenir-BlackOblique",
            @"Avenir-Book",
            @"Avenir-BookOblique",
            @"Avenir-Heavy",
            @"Avenir-HeavyOblique",
            @"Avenir-Light",
            @"Avenir-LightOblique",
            @"Avenir-Medium",
            @"Avenir-MediumOblique",
            @"Avenir-Oblique",
            @"Avenir-Roman",
            @"AvenirNext-Bold",
            @"AvenirNext-BoldItalic",
            @"AvenirNext-DemiBold",
            @"AvenirNext-DemiBoldItalic",
            @"AvenirNext-Heavy",
            @"AvenirNext-HeavyItalic",
            @"AvenirNext-Italic",
            @"AvenirNext-Medium",
            @"AvenirNext-MediumItalic",
            @"AvenirNext-Regular",
            @"AvenirNext-UltraLight",
            @"AvenirNext-UltraLightItalic",
            @"AvenirNextCondensed-Bold",
            @"AvenirNextCondensed-BoldItalic",
            @"AvenirNextCondensed-DemiBold",
            @"AvenirNextCondensed-DemiBoldItalic",
            @"AvenirNextCondensed-Heavy",
            @"AvenirNextCondensed-HeavyItalic",
            @"AvenirNextCondensed-Italic",
            @"AvenirNextCondensed-Medium",
            @"AvenirNextCondensed-MediumItalic",
            @"AvenirNextCondensed-Regular",
            @"AvenirNextCondensed-UltraLight",
            @"AvenirNextCondensed-UltraLightItalic",
            @"BanglaSangamMN",
            @"BanglaSangamMN-Bold",
            @"Baskerville",
            @"Baskerville-Bold",
            @"Baskerville-BoldItalic",
            @"Baskerville-Italic",
            @"Baskerville-SemiBold",
            @"Baskerville-SemiBoldItalic",
            @"BodoniOrnamentsITCTT",
            @"BodoniSvtyTwoITCTT-Bold",
            @"BodoniSvtyTwoITCTT-Book",
            @"BodoniSvtyTwoITCTT-BookIta",
            @"BodoniSvtyTwoOSITCTT-Bold",
            @"BodoniSvtyTwoOSITCTT-Book",
            @"BodoniSvtyTwoOSITCTT-BookIt",
            @"BodoniSvtyTwoSCITCTT-Book",
            @"BradleyHandITCTT-Bold",
            @"ChalkboardSE-Bold",
            @"ChalkboardSE-Light",
            @"ChalkboardSE-Regular",
            @"Chalkduster",
            @"Cochin",
            @"Cochin-Bold",
            @"Cochin-BoldItalic",
            @"Cochin-Italic",
            @"Copperplate",
            @"Copperplate-Bold",
            @"Copperplate-Light",
            @"Courier",
            @"Courier-Bold",
            @"Courier-BoldOblique",
            @"Courier-Oblique",
            @"CourierNewPS-BoldItalicMT",
            @"CourierNewPS-BoldMT",
            @"CourierNewPS-ItalicMT",
            @"CourierNewPSMT",
            //            @"DBLCDTempBlack",
            @"DINAlternate-Bold",
            @"DINCondensed-Bold",
            @"DamascusBold",
            @"Damascus",
            @"DamascusLight",
            @"DamascusMedium",
            @"DamascusSemiBold",
            @"DevanagariSangamMN",
            @"DevanagariSangamMN-Bold",
            @"Didot",
            @"Didot-Bold",
            @"Didot-Italic",
            @"DiwanMishafi",
            @"EuphemiaUCAS",
            @"EuphemiaUCAS-Bold",
            @"EuphemiaUCAS-Italic",
            @"Farah",
            @"Futura-CondensedExtraBold",
            @"Futura-CondensedMedium",
            @"Futura-Medium",
            @"Futura-MediumItalic",
            @"GeezaPro",
            @"GeezaPro-Bold",
            @"Georgia",
            @"Georgia-Bold",
            @"Georgia-BoldItalic",
            @"Georgia-Italic",
            @"GillSans",
            @"GillSans-Bold",
            @"GillSans-BoldItalic",
            @"GillSans-Italic",
            @"GillSans-Light",
            @"GillSans-LightItalic",
            @"GujaratiSangamMN",
            @"GujaratiSangamMN-Bold",
            @"GurmukhiMN",
            @"GurmukhiMN-Bold",
            @"STHeitiSC-Light",
            @"STHeitiSC-Medium",
            @"STHeitiTC-Light",
            @"STHeitiTC-Medium",
            @"Helvetica",
            @"Helvetica-Bold",
            @"Helvetica-BoldOblique",
            @"Helvetica-Light",
            @"Helvetica-LightOblique",
            @"Helvetica-Oblique",
            @"HelveticaNeue",
            @"HelveticaNeue-Bold",
            @"HelveticaNeue-BoldItalic",
            @"HelveticaNeue-CondensedBlack",
            @"HelveticaNeue-CondensedBold",
            @"HelveticaNeue-Italic",
            @"HelveticaNeue-Light",
            @"HelveticaNeue-LightItalic",
            @"HelveticaNeue-Medium",
            @"HelveticaNeue-MediumItalic",
            @"HelveticaNeue-UltraLight",
            @"HelveticaNeue-UltraLightItalic",
            @"HelveticaNeue-Thin",
            @"HelveticaNeue-ThinItalic",
            //            @"HiraKakuProN-W",
            //            @"HiraKakuProN-W",
            //            @"HiraMinProN-W",
            //            @"HiraMinProN-W",
            @"HoeflerText-Black",
            @"HoeflerText-BlackItalic",
            @"HoeflerText-Italic",
            @"HoeflerText-Regular",
            @"IowanOldStyle-Bold",
            @"IowanOldStyle-BoldItalic",
            @"IowanOldStyle-Italic",
            @"IowanOldStyle-Roman",
            @"Kailasa",
            //            @"Kailasa-Bold",
            @"KannadaSangamMN",
            @"KannadaSangamMN-Bold",
            @"KhmerSangamMN",
            @"KohinoorDevanagari-Book",
            @"KohinoorDevanagari-Light",
            @"KohinoorDevanagari-Medium",
            @"LaoSangamMN",
            @"MalayalamSangamMN",
            @"MalayalamSangamMN-Bold",
            @"Marion-Bold",
            @"Marion-Italic",
            @"Marion-Regular",
            @"Menlo-BoldItalic",
            @"Menlo-Regular",
            @"Menlo-Bold",
            @"Menlo-Italic",
            @"MarkerFelt-Thin",
            @"MarkerFelt-Wide",
            @"Noteworthy-Bold",
            @"Noteworthy-Light",
            @"Optima-Bold",
            @"Optima-BoldItalic",
            @"Optima-ExtraBlack",
            @"Optima-Italic",
            @"Optima-Regular",
            @"OriyaSangamMN",
            @"OriyaSangamMN-Bold",
            @"Palatino-Bold",
            @"Palatino-BoldItalic",
            @"Palatino-Italic",
            @"Palatino-Roman",
            @"Papyrus",
            @"Papyrus-Condensed",
            @"PartyLetPlain",
            //            @"SanFranciscoDisplay-Black",
            //            @"SanFranciscoDisplay-Bold",
            //            @"SanFranciscoDisplay-Heavy",
            //            @"SanFranciscoDisplay-Light",
            //            @"SanFranciscoDisplay-Medium",
            //            @"SanFranciscoDisplay-Regular",
            //            @"SanFranciscoDisplay-Semibold",
            //            @"SanFranciscoDisplay-Thin",
            //            @"SanFranciscoDisplay-Ultralight",
            //            @"SanFranciscoRounded-Black",
            //            @"SanFranciscoRounded-Bold",
            //            @"SanFranciscoRounded-Heavy",
            //            @"SanFranciscoRounded-Light",
            //            @"SanFranciscoRounded-Medium",
            //            @"SanFranciscoRounded-Regular",
            //            @"SanFranciscoRounded-Semibold",
            //            @"SanFranciscoRounded-Thin",
            //            @"SanFranciscoRounded-Ultralight",
            //            @"SanFranciscoText-Bold",
            //            @"SanFranciscoText-BoldG",
            //            @"SanFranciscoText-BoldG",
            //            @"SanFranciscoText-BoldG",
            //            @"SanFranciscoText-BoldItalic",
            //            @"SanFranciscoText-BoldItalicG",
            //            @"SanFranciscoText-BoldItalicG",
            //            @"SanFranciscoText-BoldItalicG",
            //            @"SanFranciscoText-Heavy",
            //            @"SanFranciscoText-HeavyItalic",
            //            @"SanFranciscoText-Light",
            //            @"SanFranciscoText-LightItalic",
            //            @"SanFranciscoText-Medium",
            //            @"SanFranciscoText-MediumItalic",
            //            @"SanFranciscoText-Regular",
            //            @"SanFranciscoText-RegularG",
            //            @"SanFranciscoText-RegularG",
            //            @"SanFranciscoText-RegularG",
            //            @"SanFranciscoText-RegularItalic",
            //            @"SanFranciscoText-RegularItalicG",
            //            @"SanFranciscoText-RegularItalicG",
            //            @"SanFranciscoText-RegularItalicG",
            //            @"SanFranciscoText-Semibold",
            //            @"SanFranciscoText-SemiboldItalic",
            //            @"SanFranciscoText-Thin",
            //            @"SanFranciscoText-ThinItalic",
            @"SavoyeLetPlain",
            @"SinhalaSangamMN",
            @"SinhalaSangamMN-Bold",
            @"SnellRoundhand",
            @"SnellRoundhand-Black",
            @"SnellRoundhand-Bold",
            @"Superclarendon-Regular",
            @"Superclarendon-BoldItalic",
            @"Superclarendon-Light",
            @"Superclarendon-BlackItalic",
            @"Superclarendon-Italic",
            @"Superclarendon-LightItalic",
            @"Superclarendon-Bold",
            @"Superclarendon-Black",
            @"Symbol",
            @"TamilSangamMN",
            @"TamilSangamMN-Bold",
            @"TeluguSangamMN",
            @"TeluguSangamMN-Bold",
            @"Thonburi",
            @"Thonburi-Bold",
            @"Thonburi-Light",
            @"TimesNewRomanPS-BoldItalicMT",
            @"TimesNewRomanPS-BoldMT",
            @"TimesNewRomanPS-ItalicMT",
            @"TimesNewRomanPSMT",
            @"Trebuchet-BoldItalic",
            @"TrebuchetMS",
            @"TrebuchetMS-Bold",
            @"TrebuchetMS-Italic",
            @"Verdana",
            @"Verdana-Bold",
            @"Verdana-BoldItalic",
            @"Verdana-Italic",
            @"ZapfDingbatsITC",
            //            @"Zap",
        ];
    }
    return _fontNames;
}

@end