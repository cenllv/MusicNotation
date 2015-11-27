//
//  MNChordTestStruct.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/26/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "IAModelBase.h"

@interface MNChordTestStruct : IAModelBase

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray* chord;
@property (assign, nonatomic) NSUInteger position;
@property (strong, nonatomic) NSString* positionText;
@property (strong, nonatomic) NSArray* bars;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict;
- (instancetype)initWithKey:(NSString*)key string:(NSString*)string shape:(NSString*)shape;

@end