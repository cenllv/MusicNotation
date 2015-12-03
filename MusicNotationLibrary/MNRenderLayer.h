//
//  MNRenderLayer.h
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

#import "MNTestAction.h"
#import "MNLayerResponder.h"

@class MNStaff, MNStaffNote, MNTestCollectionItemView;

@interface MNRenderLayer : CALayer <MNLayerResponder>

@property (weak, nonatomic) MNTestCollectionItemView* parentView;
@property (strong, nonatomic) MNTestAction* _Nullable testAction;

- (void)clearLayer;

- (MNStaffNote* _Null_unspecified)showStaffNote:(MNStaffNote* _Null_unspecified)staffNote
                                        onStaff:(MNStaff* _Null_unspecified)staff
                                    withContext:(CGContextRef _Null_unspecified)ctx
                                            atX:(float)x
                                withBoundingBox:(BOOL)drawBoundingBox;

- (MNStaffNote* _Null_unspecified)showNote:(NSDictionary* _Null_unspecified)noteStruct
                                   onStaff:(MNStaff* _Null_unspecified)staff
                               withContext:(CGContextRef _Null_unspecified)ctx
                                       atX:(float)x;
- (MNStaffNote* _Null_unspecified)showNote:(NSDictionary* _Null_unspecified)noteStruct
                                   onStaff:(MNStaff* _Null_unspecified)staff
                               withContext:(CGContextRef _Null_unspecified)ctx
                                       atX:(float)x
                           withBoundingBox:(BOOL)drawBoundingBox;

@end
