//
//  MNTuningNames.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/22/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "IAModelBase.h"

@interface MNTuningNames : IAModelBase
{
    NSArray* _standard;
    NSArray* _dagdad;
    NSArray* _dropd;
    NSArray* _eb;
}
@property (strong, nonatomic) NSArray* standard;
@property (strong, nonatomic) NSArray* dagdad;
@property (strong, nonatomic) NSArray* dropd;
@property (strong, nonatomic) NSArray* eb;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

@end
