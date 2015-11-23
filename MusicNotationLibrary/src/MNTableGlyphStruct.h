//
//  MNTableGlyphStruct.h
//  MusicNotation
//
//  Created by Scott on 3/27/15.
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
#import "MNMetrics.h"
#import "MNEnum.h"

/*!
 *  `MNTableGlyphStruct`
 */
@interface MNTableGlyphStruct : IAModelBase
//@property (strong, nonatomic) Common *common;
//@property (strong, nonatomic) Type *type;
@property (assign, nonatomic) MNNoteNHMRSType noteNHMRSType;
// following added in addition to tables data
@property (strong, nonatomic) MNMetrics* metrics;
@property (assign, nonatomic) NSUInteger beamCount;
//@end
//
//
//@interface Common : IAModelBase
@property (assign, nonatomic) float headWidth;
@property (assign, nonatomic) BOOL stem;
@property (assign, nonatomic) float stemOffset;
@property (assign, nonatomic) BOOL flag;
@property (assign, nonatomic) NSString* codeFlagUpstem;
@property (assign, nonatomic) NSString* codeFlagDownstem;
@property (assign, nonatomic) float stemUpExtension;
@property (assign, nonatomic) float stemDownExtension;
@property (assign, nonatomic) float gracenoteStemUpExtension;
@property (assign, nonatomic) float gracenoteStemDownExtension;
@property (assign, nonatomic) float tabnoteStemUpExtension;
@property (assign, nonatomic) float tabnoteStemDownExtension;
@property (assign, nonatomic) float dotShiftY;
@property (assign, nonatomic) float lineAbove;
@property (assign, nonatomic) float lineBelow;
// following added in addition to tables data
@property (strong, nonatomic) NSString* codeHead;
@property (assign, nonatomic) BOOL rest;
@property (strong, nonatomic) NSString* position;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

@end
