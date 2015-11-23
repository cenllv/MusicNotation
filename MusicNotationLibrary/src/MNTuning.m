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
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*
Vex.Flow.Tuning.names = {
    "standard": "E/5,B/4,G/4,D/4,A/3,E/3",
    "dagdad": "D/5,A/4,G/4,D/4,A/3,D/3",
    "dropd": "E/5,B/4,G/4,D/4,A/3,D/3",
    "eb": "Eb/5,Bb/4,Gb/4,Db/4,Ab/3,Db/3"
}
 */

static MNTuningNames* _tuningNames;
+ (MNTuningNames*)tuningNames
{
    if(!_tuningNames)
    {
        _tuningNames = [[MNTuningNames alloc] initWithDictionary:@{
            @"standard" : @[ @"E/5", @"B/4", @"G/4", @"D/4", @"A/3", @"E/3" ],
            @"dagdad" : @[ @"D/5", @"A/4", @"G/4", @"D/4", @"A/3", @"D/3" ],
            @"dropd" : @[ @"E/5", @"B/4", @"G/4", @"D/4", @"A/3", @"D/3" ],
            @"eb" : @[ @"Eb/5", @"Bb/4", @"Gb/4", @"Db/4", @"Ab/3", @"Db/3" ],
        }];
    }
    return _tuningNames;
}

/*
Vex.Flow.Tuning.prototype.init = function(tuningString) {
    // Default to standard tuning.
    self.setTuning(tuningString || "E/5,B/4,G/4,D/4,A/3,E/3");
}
 */
- (instancetype)initWithTuningString:(NSString*)tuningString
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
        abort();
    }
    return self;
}

/*
Vex.Flow.Tuning.prototype.noteToInteger = function(noteString) {
    return Vex.Flow.keyProperties(noteString).int_value;
}
 */

/*
Vex.Flow.Tuning.prototype.setTuning = function(noteString) {
    if (Vex.Flow.Tuning.names[noteString])
        noteString = Vex.Flow.Tuning.names[noteString];
    
    self.tuningString = noteString;
    self.tuningValues = [];
    self.numStrings = 0;
//    
// *    var keys = noteString.split(/\s*,\s*/   //);*/
//    if (keys.count == 0)
//        throw new Vex.RERR("BadArguments", "Invalid tuning string: " + noteString);
//
//    self.numStrings = keys.count;
//    for (var i = 0; i < self.numStrings; ++i) {
//        self.tuningValues[i] = self.noteToInteger(keys[i]);
//    }
//}
//*/
- (void)setTuning:(NSString*)noteString
{
    [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
    abort();
}

/*
//Vex.Flow.Tuning.prototype.getValueForString = function(stringNum) {
//    var s = parseInt(stringNum);
//    if (s < 1 || s > self.numStrings)
//        throw new Vex.RERR("BadArguments", "String number must be between 1 and " +
//                           self.numStrings + ": " + stringNum);
//
//    return self.tuningValues[s - 1];
//}
 //*/
- (NSUInteger)getValueForString:(NSUInteger)stringNum
{
    [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
    abort();
    return 0;
}

/*
//Vex.Flow.Tuning.prototype.getValueForFret = function(fretNum, stringNum) {
//    var stringValue = self.getValueForString(stringNum);
//    var f = parseInt(fretNum);
//
//    if (f < 0) {
//        throw new Vex.RERR("BadArguments", "Fret number must be 0 or higher: " +
//                           fretNum);
//    }
//
//    return stringValue + f;
//}
 //*/

/*
//Vex.Flow.Tuning.prototype.getNoteForFret = function(fretNum, stringNum) {
//    var noteValue = self.getValueForFret(fretNum, stringNum);
//
//    var octave = Math.floor(noteValue / 12);
//    var value = noteValue % 12;
//
//    return Vex.Flow.integerToNote(value) + "/" + octave;
//}
//
// */
- (NSString*)getNoteForFret:(NSUInteger)fretNum andStringNum:(NSUInteger)stringNum
{
    [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
    abort();
    return @"";
}

@end
