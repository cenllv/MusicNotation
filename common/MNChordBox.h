//
//  MNChord.h
//  MusicNotation
//
//  Created by Scott on 4/17/15.
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

#import "IAModelBase.h"

/*! 
 *  The `MNChordBox` class implements vertical chord notations for 6 string guitar
 */
@interface MNChordBox : IAModelBase
{
   @private
    NSUInteger _numFrets;
    NSArray* _chord;
    NSUInteger _position;
    NSString* _positionText;
    NSArray* _bars;
}

@property (strong, nonatomic) NSArray* chord;
@property (assign, nonatomic) NSUInteger position;
@property (strong, nonatomic) NSArray* bars;
//@property (assign, nonatomic) NSUInteger positionText;
- (id)setPositionText:(NSString*)positionText;

#pragma mark - Properties

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithRect:(CGRect)rect;

- (void)draw:(CGContextRef)ctx;

@end
