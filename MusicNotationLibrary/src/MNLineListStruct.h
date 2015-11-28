//
//  MNLineListStruct.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/27/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "IAModelBase.h"

@interface MNLineListStruct : IAModelBase

@property (assign, nonatomic) float line;             //@"line" : acc[@"line"],
@property (assign, nonatomic) float flat_line;        //@"flat_line" : @YES,
@property (assign, nonatomic) float dbl_sharp_line;   //@"dbl_sharp_line" : @YES,
@property (assign, nonatomic) NSInteger num_acc;      //@"num_acc" : @0,
@property (assign, nonatomic) float width;            //@"width" : @0
@property (assign, nonatomic) NSInteger column;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

@end
