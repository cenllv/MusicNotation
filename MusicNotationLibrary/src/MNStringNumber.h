//
//  MNStringNumber.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Larry Kuhns
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

#import "MNModifier.h"
#import "MNEnum.h"

@class MNStaffNote;

/*!
 *  The `MNStringNumber` which renders string
 *  number annotations beside notes.
 */
@interface MNStringNumber : MNModifier
{
    NSArray* _nums;
    MNStaffNote* _lastNote;
    //    MNLineEndType _lineEndType;
    float _yOffset;
    float _xOffset;
    BOOL _dashed;
    MNLineEndType _leg;
    NSString* _stringNumber;
}

#pragma mark - Properties
@property (strong, nonatomic) NSArray* nums;
//@property (assign, nonatomic) MNRendererLineEndType lineEndType;
//@property (assign, nonatomic) float yOffset;
//@property (assign, nonatomic) float xOffset;
@property (assign, nonatomic) float radius;
@property (assign, nonatomic) MNLineEndType leg;
@property (strong, nonatomic) NSString* stringNumber;
//@property (assign, nonatomic) BOOL dashed;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNums:(NSArray*)nums;
- (instancetype)initWithString:(NSString*)nums;

- (MNStringNumber*)setYOffset:(float)y;
- (float)yOffset;
- (MNStringNumber*)setXOffset:(float)x;
- (float)xOffset;

- (id)setPosition:(MNPositionType)position;
- (id)setLineEndType:(MNLineEndType)leg;
- (id)setLastNote:(MNStaffNote*)lastNote;
- (id)setDashed:(BOOL)dashed;

@end
