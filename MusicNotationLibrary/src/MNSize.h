//
//  MNSize.h
//  MusicNotation
//
//  Created by Scott on 3/23/15.
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

/*!
 *  The `MNFloatSize` class
 */
@interface MNFloatSize : IAModelBase
{
   @private
    float _width;
    float _height;
}
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;
+ (MNFloatSize*)sizeWithWidth:(float)width andHeight:(float)height;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end

/*!
 *  The `MNUIntSize` class
 */
@interface MNUIntSize : IAModelBase
{
   @private
    NSUInteger _width;
    NSUInteger _height;
}
@property (assign, nonatomic) NSUInteger width;
@property (assign, nonatomic) NSUInteger height;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNUIntSize*)sizeWithWidth:(NSUInteger)width andHeight:(NSUInteger)height;
@end
