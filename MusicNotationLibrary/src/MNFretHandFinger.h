//
//  MNFretHandFinger.h
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

@class MNStaffNote;

/*! The `MNFretHandFinger` class draws string numbers into the notation.

 Tapping is a guitar playing technique, where a string is fretted and set into vibration
 as part of a single motion of being pushed onto the fretboard, as opposed to the standard
 technique being fretted with one hand and picked with the other. It is similar to the
 technique of hammer-ons and pull-offs, but used in an extended way compared to them:
 hammer-ons would be performed by only the fretting hand, and in conjunction with
 conventionally picked notes; whereas tapping passages involve both hands and consist of
 only tapped, hammered and pulled notes. Some players (such as Stanley Jordan) use
 exclusively tapping, and it is standard on some instruments, such as the Chapman Stick.

 */
@interface MNFretHandFinger : MNModifier
{
   @private
    NSString* _finger;
    float _xOffset;
    float _yOffset;
}

#pragma mark - Properties

@property (strong, nonatomic) NSString* finger;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFingerNumber:(NSString*)fingerNumber andPosition:(MNPositionType)position;

- (id)setYOffset:(float)y;
- (float)yOffset;
- (id)setPosition:(MNPositionType)position;

@end
