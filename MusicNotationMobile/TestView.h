//
//  MTMTestView.h
//  MusicNotationMobile
//
//  Created by Scott on 8/3/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
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
////
//
//#import <UIKit/UIKit.h>
//#import "MNVex.h"
//#import "MNCore.h"
//
//@class  MNColor;
//
// typedef void (^DrawBlock)(CGRect dirtyRect, CGRect bounds, CGContextRef context);
// typedef void (^LoadViewBlock)(CGRect rect);
//
////======================================================================================================================
///** The `MNTestView` class
//
// */
//@interface MTMTestView : UIView <UITableViewDataSource>
//
//#pragma mark - Properties
///**---------------------------------------------------------------------------------------------------------------------
// * @name Properties
// *
// ---------------------------------------------------------------------------------------------------------------------
// */
//@property (strong, nonatomic) DrawBlock drawBlock;
//@property (strong, nonatomic) LoadViewBlock loadBlock;
//@property (strong, nonatomic)  MNColor* backgroundColor;
//@property (strong, nonatomic) NSString* title;
//
//#pragma mark - Methods
///**---------------------------------------------------------------------------------------------------------------------
// * @name Methods
// *
// ---------------------------------------------------------------------------------------------------------------------
// */
//- (void)drawRect:(CGRect)dirtyRect;
//- (void)setDrawBlock:(DrawBlock)drawBlock;
//+ (void)start:(UIView*)parent;
//+ (MTMTestView*)createCanvasTest:(CGSize)size withParent:(UIView*)parent;
//+ (MTMTestView*)createCanvasTest:(CGSize)size withParent:(UIView*)parent withTitle:(NSString*)title;
//+ (MTMTestView*)createCanvasWithOutAdding:(CGSize)size withParent:(UIView*)parent withTitle:(NSString*)title;
//+ (void)background:(CGRect)bounds;
//
//@end
//
////@interface ViewStaffStruct : IAModelBase
////@property (strong, nonatomic) MNStaff* staff;
////@property (strong, nonatomic) MTMTestView* view;
////+ (MNViewStaffStruct*)contextWithStaff:(MNStaff*)staff andView:(MTMTestView*)testView;
////@end
