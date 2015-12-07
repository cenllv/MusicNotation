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
#import "MNTestCollectionItemView.h"
#import "MNTestBlockStruct.h"
#import "MNNoteDrawNotesDelegate.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "OCTotallyLazy.h"

/*!
 *  The `MNTestViewController` class is the main controller for each collection of tests.
 *  It caches the tests and later 
 */
@interface MNTestViewController
#if TARGET_OS_IPHONE
    : UITableViewController <UITableViewDataSource, UITableViewDelegate, MNNoteDrawNotesDelegate>
#elif TARGET_OS_MAC
    : NSViewController <NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout, MNNoteDrawNotesDelegate>
#endif

/*!
 *  Loads the collection of tests for the test type.
 */
- (void)start;

/*!
 *  Unloads resources and prepares the container view for reuse.
 */
- (void)tearDown;

/*!
 *  Sets up the audio controller.
 */
- (void)audioSetup;

/*!
 *  Runs a basic test immediately with no drawing.
 *  @param name     the name of the test
 *  @param selector method to call for the test
 */
- (void)runTest:(nullable NSString*)name func:(nonnull SEL)selector;

/*!
 *  Caches a drawing test for later rendering.
 *  @param name     the name of the test
 *  @param selector method to call for the test
 *  @param frame    the frame for rendering the test
 */
- (void)runTest:(nonnull NSString*)name func:(nonnull SEL)selector frame:(CGRect)frame;

/*!
 *  Caches a drawing test for later rendering that takes params later
 *  @param name     the name of the test
 *  @param selector method to call for the test
 *  @param frame    the frame for rendering the test
 *  @param frame    the frame for rendering the test
 */
- (void)runTest:(nonnull NSString*)name
           func:(nonnull SEL)selector
          frame:(CGRect)frame
         params:(nullable NSObject*)params;

@end
