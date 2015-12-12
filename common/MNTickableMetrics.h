//
//  MNTickableMetrics.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/22/15.
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
#import "MNDelegates.h"

@class MNPoint;

/*!
 *  The `MNTickableMetrics` class
 */
@interface MNTickableMetrics : IAModelBase <TickableMetrics>

@property (assign, nonatomic) float extraLeftPx;    // Extra left pixels for modifers & displace notes
@property (assign, nonatomic) float extraRightPx;   // Extra right pixels for modifers & displace notes
@property (assign, nonatomic) float noteWidth;      // The width of the note head only.
@property (assign, nonatomic) float left_shift;     // The horizontal displacement of the note.
@property (assign, nonatomic) float modLeftPx;      // Start `X` for left modifiers.
@property (assign, nonatomic) float modRightPx;     // Start `X` for right modifiers.
@property (assign, nonatomic) float notePoints;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) MNPoint* point;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

@end
