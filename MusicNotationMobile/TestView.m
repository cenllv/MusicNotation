//
//  MTMTestView.m
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

//#import "TestView.h"
//#import "MNBezierPath.h"
//#import "MNColor.h"
//
////@implementation ViewStaffStruct
////+ (MNViewStaffStruct*)contextWithStaff:(MNStaff*)staff andView:(MTMTestView*)testView;
////{
////    MNViewStaffStruct* ret = [[MNViewStaffStruct alloc] init];
////    ret.staff = staff;
////    ret.view = testView;
////    return ret;
////}
////@end
//
//
//@interface MTMTestView ()
//@property (strong, nonatomic) NSMutableArray* handlers;
//@property (assign, nonatomic) BOOL loaded;
//@end
//
//@implementation MTMTestView
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if(self)
//    {
//        self.backgroundColor = (MNColor*)MNColor.greenColor;
//    }
//    return self;
//}
//
//- (BOOL)isFlipped
//{
//    return NO;
//}
//
//- (void)viewWillDraw
//{
//    if(!self.loaded)
//    {
//        self.loaded = YES;
//        if(self.loadBlock)
//        {
//            self.loadBlock(self.bounds);
//        }
//    }
//}
//
//- (void)drawRect:(CGRect)dirtyRect
//{
//    [super drawRect:dirtyRect];
////    if([self needsToDrawRect:dirtyRect])
////    {
//        // for debugging
//        //        self.backgroundColor = [MNColor randomBGColor:YES];
//
//        [self.backgroundColor set];
//
////        NSRectFill(dirtyRect);
//        [super drawRect:dirtyRect];
//
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        for(DrawBlock drawBlock in self.handlers)
//        {
//            CGContextSaveGState(ctx);
//            if(drawBlock)
//            {
//                drawBlock(dirtyRect, self.bounds, ctx);
//            }
//
//            CGContextRestoreGState(ctx);
//        }
//
//        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.alignment = kCTTextAlignmentLeft;
//        UIFont* font1 = [UIFont fontWithName:@"Helvetica" size:12];
//
//        NSAttributedString* titleString = [[NSAttributedString alloc]
//                                           initWithString:self.title
//                                           attributes:@{NSParagraphStyleAttributeName : paragraphStyle,
//                                           NSFontAttributeName : font1}];
//        //    [title drawInRect:CGRectMake(self.x, y - 3, 50, 100)];
//        [titleString drawAtPoint:CGPointMake(10, 10)];
//
//        NSLog(@"MNTestView redraw DrawBlock %f %f %f %f", dirtyRect.origin.x, dirtyRect.origin.y,
//        dirtyRect.size.width,
//              dirtyRect.size.height);
////    }
//}
//
////- (BOOL)wantsUpdateLayer
////{
////    return YES;
////}
//
////- (void)updateLayer
////{
////    CALayer* layer = self.layer;
////    layer.backgroundColor = [NSColor greenColor].CGColor;
////}
//
////- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
////{
////    layer.backgroundColor = [NSColor greenColor].CGColor;
////    [[NSColor clearColor] set];
////    NSRectFill(self.bounds);
////
////    NSGraphicsContext* context = [NSGraphicsContext currentContext];
////    //    [context saveGraphicsState];
////    //    if (self.drawBlock) {
////    //        self.drawBlock(dirtyRect, self.bounds, context);
////    //    }
////    //    [context restoreGraphicsState];
////    for(DrawBlock drawBlock in self.handlers)
////    {
////        [context saveGraphicsState];
////        drawBlock(self.bounds, self.bounds, context);
////        [context restoreGraphicsState];
////    }
////
////    NSLog(@"redraw");
////}
//
//+ (void)background:(CGRect)bounds;
//{
//    CGRect rect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
//     MNBezierPath* outline =  [MNBezierPath bezierPathWithRect:rect];
//    //    [SHEET_MUSIC_COLOR setFill];
//    [[MNColor randomBGColor:YES] setFill];
//    [outline fill];
//    //    [outline setLineWidth:1.0];
//    //    [MNColor.blackColor setStroke];
//    //    [outline setLineWidth:3.0];
//    //    [outline stroke];
//}
//
//- (NSMutableArray*)handlers
//{
//    if(!_handlers)
//    {
//        _handlers = [NSMutableArray array];
//    }
//    return _handlers;
//}
//
//- (void)setDrawBlock:(DrawBlock)drawBlock
//{
//    //    _drawBlock = drawBlock;
//    // TODO: decide to draw after each method call or at end of start
//    [self.handlers addObject:drawBlock];
//    //    [self setNeedsDisplay:YES];
//}
//
//+ (void)start:(UIView*)parent;
//{
//    // any additional setup...
//}
//
//+ (MTMTestView*)createCanvasTest:(CGSize)size withParent:(UIView*)parent;
//{
//    MTMTestView* test = [[MTMTestView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    [parent addSubview:test];
//    test.translatesAutoresizingMaskIntoConstraints = YES;
////    [test setNeedsDisplay:YES];
//    return test;
//}
//
//+ (MTMTestView*)createCanvasTest:(CGSize)size withParent:(UIView*)parent withTitle:(NSString*)title;
//{
//    MTMTestView* test = [[MTMTestView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    [parent addSubview:test];
//    test.title = title;
//    test.translatesAutoresizingMaskIntoConstraints = YES;
//    //    [test setNeedsDisplay:YES];
//
//    return test;
//}
//
//+ (MTMTestView*)createCanvasWithOutAdding:(CGSize)size withParent:(UIView*)parent withTitle:(NSString*)title;
//{
//    MTMTestView* test = [[MTMTestView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    test.title = title;
//    test.translatesAutoresizingMaskIntoConstraints = YES;
//    return test;
//}
//
//@end