//
//  MNChordTestStruct.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/26/15.
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

#import "MNChordTestStruct.h"
#import "MNTableChords.h"
#import "MNChordBarStruct.h"
#import "OCTotallyLazy.h"

@implementation MNChordTestStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        // TODO: the following should bo covered by IAMOdelBase
        self.name = optionsDict[@"name"];
        self.chord = optionsDict[@"chord"];
        self.position = [optionsDict[@"position"] unsignedIntegerValue];
        self.positionText = optionsDict[@"position_text"] ? optionsDict[@"position_text"] : @"";
        self.bars = optionsDict[@"bars"];
    }
    return self;
}

- (instancetype)initWithKey:(NSString*)key string:(NSString*)string shape:(NSString*)shape
{
    self = [super initWithDictionary:@{}];
    if(self)
    {
        NSDictionary* optionsDict = MNTableChords.chordShapes[shape];
        self.name = [NSString stringWithFormat:@"%@%@", key, optionsDict[@"name"]];
        self.chord = optionsDict[@"chord"];
        self.position = [MNTableChords.positions[string][key] unsignedIntegerValue];
        NSArray* bars = optionsDict[@"bars"];
        self.bars = [bars oct_map:^MNChordBarStruct*(NSDictionary* d) {
          return [[MNChordBarStruct alloc] initWithDictionary:d];
        }];
    }
    return self;
}

@end