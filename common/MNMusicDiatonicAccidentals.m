//
//  MNMusicDiatonicAccidentals.m
//  MusicNotation
//
//  Created by Scott on 3/21/15.
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

#import "MNMusicDiatonicAccidentals.h"

@implementation MNMusicDiatonicAccidentals

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (NSDictionary*)propertiesToDictionaryEntriesMapping
{
    return [NSDictionary
        dictionaryWithObjectsAndKeys:@"obj_unison", @"unison",   // correct name of the property, name in dictionary
                                     @"obj_m2", @"m2", @"obj_M2", @"M2", @"obj_m3", @"m3", @"obj_M3", @"M3", @"obj_p4",
                                     @"p4", @"obj_dim5", @"dim5", @"obj_p5", @"p5", @"obj_m6", @"m6", @"obj_M6", @"M6",
                                     @"obj_b7", @"b7", @"obj_M7", @"M7", @"obj_octave", @"octave", nil];
}

@end