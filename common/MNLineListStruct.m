//
//  MNLineListStruct.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/27/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "MNLineListStruct.h"
#import "NSString+Ruby.h"

@implementation MNLineListStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (NSString*)description
{
    NSString* info = [NSString stringWithFormat:@"\nline: %.2f", self.line];
    return [self.description concat:info];
}

@end
