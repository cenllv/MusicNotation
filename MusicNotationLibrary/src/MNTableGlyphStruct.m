//
//  MNTableDurationCodes.m
//  MusicNotation
//
//  Created by Scott on 3/27/15.
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

#import "MNTableGlyphStruct.h"

@implementation MNTableGlyphStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionary:@{
        @"head_width" : @"headWidth",
        @"stem_offset" : @"stemOffset",
        @"code_flag_upstem" : @"codeFlagUpstem",
        @"code_flag_downstem" : @"codeFlagDownstem",
        @"stem_up_extension" : @"stemUpExtension",
        @"stem_down_extension" : @"stemDownExtension",
        @"gracenote_stem_up_extension" : @"gracenoteStemUpExtension",
        @"gracenote_stem_down_extension" : @"gracenoteStemDownExtension",
        @"tabnote_stem_up_extension" : @"tabnoteStemUpExtension",
        @"tabnote_stem_down_extension" : @"tabnoteStemDownExtension",
        @"dot_shiftY" : @"dotShiftY",
        @"line_above" : @"lineAbove",
        @"line_below" : @"lineBelow",
        @"code_head" : @"codeHead",
    }];
    return propertiesEntriesMapping;
}

@end
