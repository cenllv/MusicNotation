//
//  MNBrowserWindowController.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
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

#import "MNTestType.h"

@interface MNBrowserWindowController
    : NSWindowController <NSCollectionViewDelegate, NSSplitViewDelegate, NSToolbarDelegate>
{
    __weak IBOutlet NSSplitView* _splitView;
    __weak IBOutlet NSCollectionView* _collectionView;
    __weak IBOutlet NSToolbar* _toolbar;
    __weak IBOutlet NSToolbarItem* _showHideToolbarButton;
    __weak IBOutlet NSToolbarItem* windowTitleToolbarItem;
}

@property (weak) IBOutlet NSButton* differentSublayerBackgroundsCheckBox;
@property (weak) IBOutlet NSButton* showBoundingBoxesCheckBox;
@property (weak) IBOutlet NSButton* labelBoundingBoxesCheckBox;
@property (weak) IBOutlet NSButton* repeatLastTestCheckBox;

@property (weak) IBOutlet NSScrollView* textScrollView;

@property (assign, nonatomic) MNTestType testType;

/*!
 *  Adds text to the debug text view of the main app.
 *  @param string th
 */
- (void)appendText:(nonnull NSAttributedString*)string;

@end
