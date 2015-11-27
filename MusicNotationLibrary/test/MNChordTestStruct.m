//
//  MNChordTestStruct.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/26/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
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