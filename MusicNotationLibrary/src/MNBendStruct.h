//
//  MNBendStruct.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/22/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "IAModelBase.h"
#import "MNEnum.h"

@interface MNBendStruct : IAModelBase

@property (assign, nonatomic) MNBendDirectionType type;
@property (strong, nonatomic) NSString* text;
@property (assign, nonatomic) float x;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float draw_width;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

+ (MNBendStruct*)bendStructWithType:(MNBendDirectionType)type andText:(NSString*)text;

@end
