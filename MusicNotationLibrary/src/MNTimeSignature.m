
//  MNTimeSignature.m
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

#import "MNTimeSignature.h"
#import "MNUtils.h"
#import "MNGlyph.h"
#import "MNPoint.h"
#import "MNStaff.h"
#import "MNTimeSignatureGlyphMetrics.h"
#import "MNTimeSigStruct.h"
#import "MNGlyphMetrics.h"

@interface MNTimeSignature ()

@property (assign, nonatomic) float topLine;
@property (assign, nonatomic) float bottomLine;
@property (strong, nonatomic) NSMutableArray* topGlyphs;
@property (strong, nonatomic) NSMutableArray* botGlyphs;
@property (assign, nonatomic) BOOL num;
@property (assign, nonatomic) float line;
@property (strong, nonatomic) NSArray* topNumbers;
@property (strong, nonatomic) NSArray* bottomNumbers;

@end

@implementation MNTimeSignature
//@dynamic glyph;

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.num = NO;
        if(self.padding == 0)
        {
            self.padding = 15;
        }
        [self setPadding:15];
        self.topLine = 2;
        self.bottomLine = 4;
        self.point.x = 40;
        BOOL haveGlyph = [self parseTimeSpec:self.timeSpec];

        self.timeSig.num = haveGlyph;
        if(!haveGlyph)
        {
            self.glyph =
                [self makeTimeSignatureGlyphWithTopNumbers:self.topNumbers andBottomNumbers:self.bottomNumbers];
            self.timeSig.glyph = self.glyph;
        }
    }
    return self;
}

- (instancetype)initWithTimeSpec:(NSString*)timeSpec andPadding:(float)padding
{
    self = [self initWithDictionary:@{ @"timeSpec" : timeSpec }];
    if(self)
    {
        //        _timeSpec = timeSpec;
        self.padding = padding;
    }
    return self;
}

- (instancetype)initWithTimeType:(MNTimeType)type
{
    self = [self initWithDictionary:@{ @"timeSpec" : [MNEnum simplNameForTimeType:type] }];
    if(self)
    {
        _timeType = type;
        // TODO: implement this method
    }
    return self;
}

+ (MNTimeSignature*)standard_4_4_TimeSignature
{
    return [[MNTimeSignature alloc] initWithTimeType:MNTime4_4];
}

+ (MNTimeSignature*)timeSignatureWithType:(MNTimeType)type
{
    return [[MNTimeSignature alloc] initWithTimeType:type];
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
    return NSStringFromClass([self class]);   // return @"timesignature";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

#pragma mark - Properties

- (NSString*)timeSpec
{
    if(!_timeSpec)
    {
        _timeSpec = [[NSString alloc] init];
    }
    return _timeSpec;
}

- (MNTimeSigStruct*)timeSig
{
    if(!_timeSig)
    {
        _timeSig = [[MNTimeSigStruct alloc] init];
    }
    return _timeSig;
}

#pragma mark - LU Tables
/*!---------------------------------------------------------------------------------------------------------------------
 * @name LU Tables
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (void)setCodeAndName
{
    switch(self.timeType)
    {
        case MNTime4_4:
            self.name = @"4_4";
            self.timeSpec = [NSString stringWithFormat:@"4/4"];
            break;
        case MNTime3_4:
            self.name = @"3_4";
            self.timeSpec = [NSString stringWithFormat:@"3/4"];
            break;
        case MNTime2_4:
            self.name = @"2_4";
            self.timeSpec = @"2/4";
            break;
        case MNTime4_2:
            self.name = @"4_2";
            self.timeSpec = @"4/2";
            break;
        case MNTime2_2:
            self.name = @"2_2";
            self.timeSpec = @"2/2";
            break;
        case MNTime3_8:
            self.name = @"3_8";
            self.timeSpec = @"3/8";
            break;
        case MNTime6_8:
            self.name = @"6_8";
            self.timeSpec = @"6/8";
            break;
        case MNTime9_8:
            self.name = @"9_8";
            self.timeSpec = @"9/8";
            break;
        case MNTime12_8:
            self.name = @"12_8";
            self.timeSpec = @"12/8";
            break;
        default:
            [MNLog logError:@"bad choice of timeType enum"];
            break;
    }
    [((MNMetrics*)self->_metrics)setName:self.name];
}

static NSDictionary* _standardTimeSignatures;
+ (NSDictionary*)standardTimeSignatures
{
    if(!_standardTimeSignatures)
    {
        _standardTimeSignatures = @{
            @"C" : @{@"code" : @"v41", @"point" : @40, @"line" : @2},
            @"C|" : @{@"code" : @"vb6", @"point" : @40, @"line" : @2},
        };
    }
    return _standardTimeSignatures;
}

#pragma mark - Methods

/*!
 *  Parses a time signature string
 *  @param timeSpec time signature string in the form: [0-9]+/[0-9]+
 *  @return YES if successful, NO otherwise
 */
- (BOOL)parseTimeSpec:(NSString*)timeSpec
{
    if(!timeSpec)
    {
        MNLogError(@"MissingTimeSpecTimeSignatureException, Try adding a time spec to this time signature.");
    }

    if([timeSpec isEqualToString:@"C"] || [timeSpec isEqualToString:@"C|"])
    {
        self.num = NO;
        NSDictionary* sig = [self class].standardTimeSignatures[timeSpec];
        self.line = [sig[@"line"] floatValue];
        self.glyph = [[MNGlyph alloc] initWithCode:sig[@"code"] withPointSize:[sig[@"point"] floatValue]];
        return YES;
    }

    // ensure that this timeSpec is of the correct format
    //  using a regex
    NSString* timeSpecRegexString = @"^[0-9]+/[0-9]+$";

    NSString* timeSpecErrMsg =
        [NSString stringWithFormat:@"TimeSignatureFormatException, must be of form: @%@", timeSpecRegexString];
    NSError* ts_error = nil;
    NSRegularExpression* timeSpecRegex =
        [NSRegularExpression regularExpressionWithPattern:timeSpecRegexString
                                                  options:NSRegularExpressionIgnoreMetacharacters
                                                    error:&ts_error];
    NSString* timeSpecMatch = [timeSpecRegexString
        substringWithRange:[timeSpecRegex rangeOfFirstMatchInString:timeSpecRegexString
                                                            options:NSMatchingReportCompletion
                                                              range:NSMakeRange(0, timeSpecRegexString.length)]];
    if(!timeSpecMatch)
    {
        MNLogError(@"%@", timeSpecErrMsg);
        return NO;
    }

    // split the timeSpec string
    NSArray* specComponents = [timeSpec componentsSeparatedByString:@"/"];

    // time signatures are composed of only two digits
    if(specComponents.count != 2)
    {
        MNLogError(@"%@", timeSpecErrMsg);
        MNLogError(@"invalid values: received values=[%@]", specComponents);
        return NO;
    }

    // get a formatter to convert from a string to an actual number
    NSNumberFormatter* f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];

    NSArray* (^split)(NSString*) = ^NSArray*(NSString* inputString)
    {
        NSMutableArray* chars = [[NSMutableArray alloc] initWithCapacity:inputString.length];
        for(NSUInteger i = 0; i < inputString.length; ++i)
        {
            [chars addObject:[NSString stringWithFormat:@"%C", [inputString characterAtIndex:i]]];
        }
        return chars;
    };

    NSArray* topNumbers = split(specComponents[0]);
    topNumbers = [topNumbers oct_map:^NSNumber*(NSString* element) {
      return [NSNumber numberWithInteger:[element integerValue]];
    }];
    self.topNumbers = topNumbers;

    NSArray* bottomNumbers = split(specComponents[1]);
    bottomNumbers = [bottomNumbers oct_map:^NSNumber*(NSString* element) {
      return [NSNumber numberWithInteger:[element integerValue]];
    }];
    self.bottomNumbers = bottomNumbers;

    self.num = YES;
    return NO;
}

/*!
 *  makes a custom glyph for as the time signature
 *  @return a custom glyph with a custom draw method
 */
- (MNGlyph*)makeTimeSignatureGlyphWithTopNumbers:(NSArray*)topNums andBottomNumbers:(NSArray*)botNums
{
    MNGlyph* glyph = [[MNGlyph alloc] initWithCode:@"v0" withPointSize:1];
    //    glyph.metrics = [[TimeSignatureGlyphMetrics alloc] init];

    NSMutableArray* topGlyphs = [NSMutableArray arrayWithCapacity:topNums.count];
    NSMutableArray* botGlyphs = [NSMutableArray arrayWithCapacity:botNums.count];

    float topWidth = 0;
    NSUInteger num;
    for(NSUInteger i = 0; i < topNums.count; ++i)
    {
        num = [topNums[i] unsignedIntegerValue];
        MNGlyph* topGlyph = [[MNGlyph alloc] initWithCode:[NSString stringWithFormat:@"v%tu", num] withPointSize:1];

        [topGlyphs push:topGlyph];
        topWidth += topGlyph.metrics.width;
    }
    self.topGlyphs = topGlyphs;

    float botWidth = 0;
    for(NSUInteger i = 0; i < botNums.count; ++i)
    {
        num = [botNums[i] unsignedIntegerValue];
        MNGlyph* botGlyph = [[MNGlyph alloc] initWithCode:[NSString stringWithFormat:@"v%tu", num] withPointSize:1];

        [botGlyphs push:botGlyph];
        botWidth += botGlyph.metrics.width;
    }
    self.botGlyphs = botGlyphs;

    float width = (topWidth > botWidth ? topWidth : botWidth);
    glyph.width = width;

    //    float xMin = ((TimeSignatureGlyphMetrics*)glyph.metrics).x_min;
    //    ((TimeSignatureGlyphMetrics*)glyph.metrics).x_min = xMin;
    //    ((TimeSignatureGlyphMetrics*)glyph.metrics).x_max = xMin + width;
    //    ((TimeSignatureGlyphMetrics*)glyph.metrics).width = width;

    //    [self.botGlyphs foreach:^(MNGlyph* element, NSUInteger index, BOOL* stop) {
    //        element.width = width;
    //    }];
    //    [self.topGlyphs foreach:^(MNGlyph* element, NSUInteger index, BOOL* stop) {
    //        element.width = width;
    //    }];

    __block float topStartX = (width - topWidth) / 2.0;
    __block float botStartX = (width - botWidth) / 2.0;

    __block typeof(self) this = self;
    glyph.drawBlock = ^(CGContextRef ctx, MNStaff* staff, float x, float y) {

      float start_x = x + topStartX;
      MNGlyph* g;
      float _y = 0;
      if(!this.staff)
      {
          //          _y = y;
          _y = [staff getYForLine:this.topLine] + 1;
      }
      else
      {
          _y = [this.staff getYForLine:this.topLine] + 1;
      }
      for(NSUInteger i = 0; i < this.topGlyphs.count; ++i)
      {
          g = this.topGlyphs[i];
          [MNGlyph renderGlyph:ctx
                           atX:start_x + g.x_shift
                           atY:_y
                     withScale:1 /*g.scale*/
                  forGlyphCode:g.metrics.code];
          start_x += g.metrics.width;
      }

      start_x = x + botStartX;
      if(!this.staff)
      {
          //          _y = y;
          _y = [staff getYForLine:this.bottomLine] + 1;
      }
      else
      {
          _y = [this.staff getYForLine:this.bottomLine] + 1;
      }
      for(NSUInteger i = 0; i < this.botGlyphs.count; ++i)
      {
          g = this.botGlyphs[i];
          //          [this placeGlyphOnLine(g, this.stave, g.line);
          //          [this placeGlyphOnLine:glyph forStaff:this.staff onLine:g.line];
          [MNGlyph renderGlyph:ctx
                           atX:start_x + g.x_shift
                           atY:_y   //[this.staff getYForLine:this.bottomLine] + 1 + y
                     withScale:1    /*g.scale*/
                  forGlyphCode:g.metrics.code];
          start_x += g.metrics.width;
      }

    };

    return glyph;
}

/*!
 *  Add the key signature to the `MNStaff`. You probably want to use the
 *  helper method `.addToStaff()` instead
 *  @param staff the staff to add the modifier to
 */
- (void)addModifierToStaff:(MNStaff*)staff
{
    //    [staff addGlyph:self.glyph];
    //
    [staff addGlyph:[staff makeSpacer:self.padding]];

    if(!self.num)
    {
        [self placeGlyphOnLine:self.glyph forStaff:staff onLine:self.line];
    }
    [staff addGlyph:self.glyph];
    [staff addGlyph:[staff makeSpacer:10]];   // CHANGE
}

/*!
 *  Add the key signature to the `MNStaff`. You probably want to use the
 *  helper method `.addToStaff()` instead
 *  @param modifier the staff to add the modifier to
 */
- (void)addEndModifierToStaff:(MNStaff*)staff
{
    [staff addEndGlyph:[staff makeSpacer:self.padding]];

    if(!self.num)
    {
        [self placeGlyphOnLine:self.glyph forStaff:staff onLine:self.line];
    }
    [staff addEndGlyph:self.glyph];
}

@end
