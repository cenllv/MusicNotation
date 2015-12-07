//
//  MNCarrierTest.h
//  MusicNotation
//
//  Created by Scott on 8/8/15.
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

/*!
 *  The `MNTestActionStruct` class stores the target and selector for individual
 *  tests for later invocation.
 */
@interface MNTestActionStruct : NSObject

@property (assign, nonatomic) SEL selector;
@property (strong, nonatomic) id target;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) CGRect frame;
@property (strong, nonatomic) NSObject* params;

+ (MNTestActionStruct*)testWithName:(NSString*)name
                        andSelector:(SEL)selector
                          andTarget:(id)target
                           andFrame:(CGRect)frame;

@end
