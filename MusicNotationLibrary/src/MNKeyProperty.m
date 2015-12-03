//
//  MNKeyProperties.m
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

#import "MNKeyProperty.h"
#import "MNTable.h"
#import "MNAccidental.h"
#import "MNUtils.h"
#import "MNStaff.h"

#pragma mark -  MNKeyProperties Implementation
/*!---------------------------------------------------------------------------------------------------------------------
 * @name  MNKeyProperties Implementation
 * ---------------------------------------------------------------------------------------------------------------------
 */
@implementation MNKeyProperty

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)initWithKey:(NSString*)key andClefType:(MNClefType)clefType andOptionsDict:(NSDictionary*)optionsDict
{
    self = [self initWithDictionary:optionsDict];
    if(self)
    {
        [self setupKeyProperty];
        _clefType = clefType;
        _key = key;
    }
    return self;
}

- (instancetype)initWithKey:(NSString*)key andClefType:(MNClefType)clefType
{
    self = [self initWithKey:key andClefType:clefType andOptionsDict:@{}];
    if(self)
    {
    }
    return self;
}

- (void)setupKeyProperty
{
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

- (NSString*)key
{
    if(!_key)
    {
        _key = @"";
    }
    return _key;
}

- (NSString*)glyphCode
{
    if(!_glyphCode)
    {
        _glyphCode = @"";
    }
    return _glyphCode;
}

//- (MNAccidental*)accidental
//{
//    if(!_accidental)
//    {
//        _accidental = [[MNAccidental alloc] init];
//    }
//    return _accidental;
//}

#pragma mark - Methods
//- (NSString*)description
//{
//    NSString* ret = @"";

//    return ret;
//}

- (NSDictionary*)dictionarySerialization
{
    return [self dictionaryWithValuesForKeyPaths:@[
        @"key",
        @"glyphCode",
        @"clefType",
        @"octave",
        @"displaced",
        @"ticks",
    ]];
}

- (MNClefType)clefType
{
    if(_clefType == 0)
    {
        _clefType = [[MNStaff currentStaff] clefType];
    }
    return _clefType;
}

@end
