//
//  MNTestViewController.h
//  MusicNotation
//
//  Created by Scott on 8/3/15.
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

#import "MNCore.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "MNTestCollectionItemView.h"
#import "MNTestTuple.h"
#import "MNViewStaffStruct.h"

@class MNRenderLayer;

#if TARGET_OS_IPHONE

typedef UIButton MNButton;

@interface MNTestViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property UITableViewCell* currentCell;

#elif TARGET_OS_MAC

typedef NSButton MNButton;

@interface MNTestViewController : NSViewController <NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout>

#endif

- (void)start;
- (void)tearDown;

//- (CGRect)frameAtIndex:(NSUInteger)index;

- (void)runTest:(NSString*)name func:(SEL)selector;
- (void)runTest:(NSString*)name func:(SEL)selector params:(NSObject*)params;
- (void)runTest:(NSString*)name func:(SEL)selector frame:(CGRect)frame;
- (void)runTest:(NSString*)name func:(SEL)selector frame:(CGRect)frame params:(NSObject*)params;

- (MNRenderLayer*)renderLayer;

@end
