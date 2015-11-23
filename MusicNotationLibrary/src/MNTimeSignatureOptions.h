//
//  MNTimeSignatureOptions.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/22/15.
//  Copyright © 2015 feedbacksoftware.com. All rights reserved.
//

#import "IAModelBase.h"
#import "MNOptions.h"

@interface MNTimeSignatureOptions : MNOptions

@property (assign, nonatomic) float topGlyphCollectionWidth;
@property (assign, nonatomic) float bottomGlyphCollectionWidth;

@end
