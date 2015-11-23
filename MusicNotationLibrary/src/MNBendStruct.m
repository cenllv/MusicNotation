//
//  MNBendStruct.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/22/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "MNBendStruct.h"

@implementation MNBendStruct

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

+ (MNBendStruct*)bendStructWithType:(MNBendDirectionType)type andText:(NSString*)text;
{
    MNBendStruct* ret = [[MNBendStruct alloc] initWithDictionary:nil];
    ret.type = type;
    ret.text = text;
    ret.x = 0;
    ret.width = 0;
    return ret;
}

@end
