//
//  MNTableOrnamentCodes.h
//  MusicNotation
//
//  Created by Scott on 3/21/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "IAModelBase.h"

@class MNOrnamentData;

/*!
 *  The `MNTableOrnamentCodes` class
 */
@interface MNTableOrnamentCodes : IAModelBase
@property (strong, nonatomic) MNOrnamentData* mordent;
@property (strong, nonatomic) MNOrnamentData* mordent_inverted;
@property (strong, nonatomic) MNOrnamentData* turn;
@property (strong, nonatomic) MNOrnamentData* turn_inverted;
@property (strong, nonatomic) MNOrnamentData* tr;
@property (strong, nonatomic) MNOrnamentData* upprall;
@property (strong, nonatomic) MNOrnamentData* downprall;
@property (strong, nonatomic) MNOrnamentData* prallup;
@property (strong, nonatomic) MNOrnamentData* pralldown;
@property (strong, nonatomic) MNOrnamentData* upmordent;
@property (strong, nonatomic) MNOrnamentData* downmordent;
@property (strong, nonatomic) MNOrnamentData* lineprall;
@property (strong, nonatomic) MNOrnamentData* prallprall;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end

@interface MNOrnamentData : IAModelBase
@property (strong, nonatomic) NSString* code;
@property (assign, nonatomic) NSInteger shift_right;
@property (assign, nonatomic) NSInteger shift_up;
@property (assign, nonatomic) NSInteger shift_down;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) BOOL between_lines;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end
