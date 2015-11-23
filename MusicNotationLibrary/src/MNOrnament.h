//
//  MNOrnament.h
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

#import "MNModifier.h"
#import "MNEnum.h"

@class MNAccidental, MNStaffNote, MNOrnamentData;

/*! The `MNOrnament` class implements ornaments as modifiers that can be
      attached to notes. The complete list of ornaments is available in
      `tables.js` under `Vex.Flow.ornamentCodes`.

 */
@interface MNOrnament : MNModifier
{
   @private
    NSString* _type;
    MNPositionType _position;
    BOOL _delayed;
    NSString* _accidental_upper;
    NSString* _accidental_lower;
    float _font_scale;

    float _shiftRight;
    float _shift_y;
    float _shiftUp;

    MNOrnamentData* _ornament;
}
#pragma mark - Properties
//@property (strong, nonatomic)  MNStaffNote *note;
//@property (assign, nonatomic) NSUInteger index;
@property (strong, nonatomic) NSString* type;
@property (assign, nonatomic) MNPositionType position;
//@property (assign, nonatomic) BOOL delayed;
@property (strong, nonatomic) NSString* accidental_upper;
@property (strong, nonatomic) NSString* accidental_lower;
@property (assign, nonatomic) float font_scale;
//@property (strong, nonatomic)  MNAccidental *accidental_upper;
//@property (strong, nonatomic)  MNAccidental *accidental_lower;

@property (assign, nonatomic, readonly) float shiftRight;
@property (assign, nonatomic, readonly) float shift_y;
@property (assign, nonatomic, readonly) float shiftUp;

@property (strong, nonatomic) MNOrnamentData* ornament;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNOrnament*)ornamentWithType:(NSString*)type;

//+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state;

- (id)setDelayed:(BOOL)delayed;
- (BOOL)delayed;
- (id)setUpperAccidental:(NSString*)accidental;
- (id)setLowerAccidental:(NSString*)accidental;

@end
