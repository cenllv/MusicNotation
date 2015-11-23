//
//  MNStaffRepetition.h
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

@class MNStaff;   //,  MNFont;

/*! The `MNStaffRepetition` class implements repetitions (Coda, signo, D.C., etc.)

 */
@interface MNStaffRepetition : MNStaffModifier
{
   @private
    float _x;
}

#pragma mark - Properties
@property (assign, nonatomic) MNRepetitionType symbol_type;
@property (assign, nonatomic) float x;
//@property (assign, nonatomic) NSUInteger y_shift;
//@property (assign, nonatomic) NSUInteger x_shift;

@property (strong, nonatomic) NSString* fontName;
@property (assign, nonatomic) NSUInteger fontSize;
@property (assign, nonatomic) BOOL fontItalic;
@property (assign, nonatomic) BOOL fontBold;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithType:(MNRepetitionType)type x:(float)x y_shift:(float)y_shift;

//- (void)draw:(CGContextRef)ctx staff:(MNStaff*)staff x:(float)x;
//- (void)drawCodaFixed:(CGContextRef)ctx staff:(MNStaff*)staff x:(float)x;
//- (void)drawSignoFixed:(CGContextRef)ctx staff:(MNStaff*)staff x:(float)x;
//- (void)drawSymbolText:(CGContextRef)ctx
//                 staff:(MNStaff*)staff
//                     x:(float)x
//              withText:(NSString*)text
//                isCoda:(BOOL)drawCoda;

@end
