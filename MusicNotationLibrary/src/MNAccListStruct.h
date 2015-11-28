//
//  MNAccListStruct.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/27/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "IAModelBase.h"

@class MNAccidental;

@interface MNAccListStruct : IAModelBase

@property (assign, nonatomic) float y;
@property (assign, nonatomic) float line;          // line: acc_line,
@property (assign, nonatomic) float shift;         // shift: shiftL,
@property (strong, nonatomic) MNAccidental* acc;   // acc: acc,
@property (assign, nonatomic) float lineSpace;     // lineSpace: line_space

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

@end
