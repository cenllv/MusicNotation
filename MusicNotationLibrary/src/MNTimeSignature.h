//
//  MNTimeSignature.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
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

#import "MNStaffModifier.h"
#import "MNEnum.h"
#import "MNOptions.h"
#import "MNTimeSignatureOptions.h"

@class MNTimeSigStruct;

/*!
 *  The `MNTimeSignature` class performs
 *  Implements time signatures glyphs for staffs
 *  See tables.js for the internal time signatures
 *  representation
 */
@interface MNTimeSignature : MNStaffModifier
{
   @private
    NSString* _timeSpec;
    MNTimeType _timeType;
    MNTimeSignatureOptions* _options;
    float _topLine;
    float _bottomLine;
    NSMutableArray* _topGlyphs;
    //    NSMutableArray* _bottomGlyphs;
    BOOL _num;
//    NSArray* _topCodes;
//    NSArray* _bottomCodes;
    NSArray<NSNumber*>* _topNumbers;
    NSArray<NSNumber*>* _bottomNumbers;

    MNTimeSigStruct* _timeSig;
}

#pragma mark - Properties
@property (strong, nonatomic) NSString* timeSpec;
@property (assign, nonatomic) MNTimeType timeType;
@property (strong, nonatomic) MNTimeSignatureOptions* options;
@property (strong, nonatomic, readonly) MNTimeSigStruct* timeSig;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTimeSpec:(NSString*)timeSpec andPadding:(float)padding;
+ (MNTimeSignature*)timeSignatureWithType:(MNTimeType)type;

@end
