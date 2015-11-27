//
//  MNTuning.m
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

#import "MNTuning.h"
#import "MNLog.h"
#import "MNTuningNames.h"
#import "MNTable.h"
#import "MNKeyProperty.h"
#import "NSString+Ruby.h"

@interface MNTuning ()
@property (assign, nonatomic) NSUInteger numStrings;
@property (strong, nonatomic) NSString* tuningString;
@end

@implementation MNTuning

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupTuning];
    }
    return self;
}

- (void)setupTuning
{
    [self setTuning:@"E/5,B/4,G/4,D/4,A/3,E/3,B/2,E/2"];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

static NSDictionary* _tuningNames;
+ (NSDictionary*)tuningNames
{
    if(!_tuningNames)
    {
        //        _tuningNames = [[MNTuningNames alloc] initWithDictionary:@{
        _tuningNames = @{
            @"standard" : @[ @"E/5", @"B/4", @"G/4", @"D/4", @"A/3", @"E/3" ],
            @"dagdad" : @[ @"D/5", @"A/4", @"G/4", @"D/4", @"A/3", @"D/3" ],
            @"dropd" : @[ @"E/5", @"B/4", @"G/4", @"D/4", @"A/3", @"D/3" ],
            @"eb" : @[ @"Eb/5", @"Bb/4", @"Gb/4", @"Db/4", @"Ab/3", @"Db/3" ],
        };
        //];
    }
    return _tuningNames;
}

- (instancetype)initWithTuningString:(NSString*)tuningString
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        if(tuningString)
        {
            [self setTuning:tuningString];
        }
        else
        {
            // Default to standard tuning.
            [self setTuning:@"E/5,B/4,G/4,D/4,A/3,E/3"];
        }
    }
    return self;
}

- (NSMutableArray*)tuningValues
{
    if(!_tuningValues)
    {
        _tuningValues = [NSMutableArray array];
    }
    return _tuningValues;
}

#pragma mark - Methods

- (NSUInteger)noteToInteger:(NSString*)noteString
{
    MNKeyProperty* tmp = [MNTable keyPropertiesForKey:noteString];
    return [tmp intValue];
}

- (void)setTuning:(NSString*)noteString
{
    NSArray* keys = nil;
    if([[[self class] tuningNames] objectForKey:noteString])
    {
        keys = [[[self class] tuningNames] objectForKey:noteString];
    }
    else
    {
        self.tuningValues = [NSMutableArray array];
        self.numStrings = 0;

        keys = [noteString split:@","];   // @"/\\s*,\\s*/"];   // TODO: <- test this
    }
    if(keys.count == 0)
    {
        MNLogError("BadArguments, Invalid tuning string: %@", noteString);
    }

    self.tuningString = noteString;
    self.numStrings = keys.count;
    for(NSUInteger i = 0; i < self.numStrings; ++i)
    {
        self.tuningValues[i] = [NSNumber numberWithInteger:[self noteToInteger:keys[i]]];
    }
}

- (NSUInteger)getValueForString:(NSUInteger)stringNum
{
    //    NSInteger s = [stringNum integerValue];
    NSUInteger s = stringNum;
    if(s < 1 || s > self.numStrings)
    {
        MNLogError(@"BadArguments, String number must be between 1 and %lu : %lu", self.numStrings, stringNum);
    }

    return [self.tuningValues[s - 1] unsignedIntegerValue];
}

- (NSUInteger)getValueForFret:(NSInteger)fretNum andStringNum:(NSUInteger)stringNum
{
    NSUInteger stringValue = 0;

    NSInteger f = fretNum;

    if(f < 0)
    {
        MNLogError("BadArguments, Fret number must be 0 or higher: %lu", fretNum);
    }

    return stringValue + f;
}

- (NSString*)getNoteForFret:(NSInteger)fretNum andStringNum:(NSUInteger)stringNum
{
    float noteValue = (float)[self getValueForFret:fretNum andStringNum:stringNum];
    NSUInteger octave = floorf(fmodf(noteValue, 12));
    NSString* i = [[MNTable integerToNoteArray] objectAtIndex:octave];
    return [NSString stringWithFormat:@"%@/%lu", i, octave];
}

@end
