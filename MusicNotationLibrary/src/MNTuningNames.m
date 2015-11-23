//
//  MNTuningNames.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/22/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "MNTuningNames.h"

@implementation MNTuningNames

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

@end