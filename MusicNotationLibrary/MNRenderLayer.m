//
//  MNRenderLayer.m
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

#import "MNRenderLayer.h"
#import "MNTestBlockStruct.h"
#import "MNCore.h"
#import "MNGlyphLayer.h"

#if TARGET_OS_IPHONE

#import "MNMTableViewCell.h"
#import "MNMCarrierView.h"

#endif

#define RENDERLAYER_BORDER_WIDTH 4.0

@interface MNRenderLayer ()

@property (assign, nonatomic) SEL selector;
@property (strong, nonatomic) id target;
@property (strong, nonatomic) MNTestBlockStruct* testBlockStruct;
@property (strong, nonatomic) NSString* testName;

@end

@implementation MNRenderLayer

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.borderColor = nil;
    }
    return self;
}

#if TARGET_OS_IPHONE
- (void)setParentView:(UIView*)parentView
{
    _parentView = parentView;
    self.delegate = parentView;
    self.frame = parentView.bounds;
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
}

#elif TARGET_OS_MAC
#endif

/*!
 *  Runs the individual test that was cached earlier by the controller.
 *  This initializes and formats the notations.
 *  @return a callback block for actually drawing the test.
 */
- (MNTestBlockStruct*)invokeTest
{
    NSMethodSignature* signature = [_target methodSignatureForSelector:self.selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:self.selector];
    [invocation setTarget:self.target];

#if TARGET_OS_IPHONE
    MNMCarrierView* parentView = (MNMCarrierView*)self.parentView;
#elif TARGET_OS_MAC
    MNTestCollectionItemView* parentView = self.parentView;
#endif

    [invocation setArgument:&parentView atIndex:2];

    // set additional params
    if(self.testAction)
    {
        if(self.testAction.params)
        {
            // this arg can be any object except nil
            id arg3 = self.testAction.params;
            [invocation setArgument:&arg3 atIndex:3];
        }
    }

    [invocation invoke];

    // http://stackoverflow.com/a/22034059/629014
    MNTestBlockStruct* ret __unsafe_unretained;
    [invocation getReturnValue:&ret];
    self.testBlockStruct = ret;
    return ret;
}

- (void)setTestAction:(MNTestActionStruct*)testAction
{
    _testAction = testAction;
    self.selector = _testAction.selector;
    self.target = _testAction.target;
    self.testName = _testAction.name;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self invokeTest];
      // TODO: needs a semaphore to indicate when setup is complete
      dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
      });
    });
}

#pragma mark - Draw

- (void)clearLayer
{
    _testBlockStruct = nil;
    [self setNeedsDisplay];
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
#if TARGET_OS_IPHONE
    //    ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSaveGState(ctx);
    CGContextClearRect(ctx, self.bounds);
#elif TARGET_OS_MAC
    NSGraphicsContext* gc = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:YES];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:gc];
#endif

    MNBezierPath* outline = [MNBezierPath bezierPathWithRect:self.bounds];
    if(self.testBlockStruct.backgroundColor)
    {
        [self.testBlockStruct.backgroundColor setFill];
    }
    else
    {
        [SHEET_MUSIC_COLOR setFill];

        // // NOTE: uncomment to allow for a random background color
        //  [[MNColor randomBGColor:YES] setFill];
    }
    [outline fill];

#if TARGET_OS_IPHONE
    float superLayerWidth = self.superlayer.bounds.size.width;
    float testWidth = self.testAction.frame.size.width;
    float scale = superLayerWidth / testWidth;
    if(scale > 1.f)
    {
        scale = .8f;
    }
    CGContextScaleCTM(ctx, scale, scale);
#endif

    if(self.testBlockStruct.drawBlock)
    {
        self.testBlockStruct.drawBlock(CGRectZero, self.bounds, ctx);
    }

#if TARGET_OS_IPHONE
    CGContextRestoreGState(ctx);
    UIGraphicsPopContext();
#elif TARGET_OS_MAC
    [NSGraphicsContext restoreGraphicsState];
#endif
}

/*!
 *  Sets the border color of a cell for the Mac app
 *  @param borderColor the border color to highlight
 */
- (void)setBorderColor:(CGColorRef)borderColor
{
    [super setBorderColor:borderColor];
    self.borderWidth = (self.borderColor ? RENDERLAYER_BORDER_WIDTH : 0.0);
}

#if TARGET_OS_IPHONE

#pragma mark - Touch methods

- (CALayer*)hitTest:(CGPoint)interactionPoint
{
    //    for(CALayer* sublayer in self.sublayers.reverseObjectEnumerator)
    //    {
    //        CGPoint pointInHostedLayer = [self convertPoint:interactionPoint toLayer:sublayer];
    //        if ([sublayer containsPoint:pointInHostedLayer]) {
    //
    //        }
    //    }

    return [super hitTest:interactionPoint];
}

//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//}

//- (CALayer*)layerForTouch:(UITouch*)touch
//{
//    return self;
//}

#elif TARGET_OS_MAC

- (BOOL)pointingDeviceDownEvent:(NSEvent*)event atPoint:(CGPoint)interactionPoint
{
    BOOL handled = NO;

    for(CALayer* sublayer in self.sublayers.reverseObjectEnumerator)
    {
        if(sublayer && [sublayer conformsToProtocol:@protocol(MNLayerResponder)])   //||
        //           [sublayer respondsToSelector:@selector(pointingDeviceDownEvent:atPoint:)])
        {
            CGPoint pointInHostedLayer = [self convertPoint:interactionPoint toLayer:sublayer];
            handled = [((id<MNLayerResponder>)sublayer)pointingDeviceDownEvent:event atPoint:pointInHostedLayer];
            if(handled)
            {
                break;
            }
        }
    }

    return handled;
}

- (BOOL)pointingDeviceUpEvent:(NSEvent*)event atPoint:(CGPoint)interactionPoint
{
    return NO;
}

- (BOOL)pointingDeviceDraggedEvent:(NSEvent*)event atPoint:(CGPoint)interactionPoint
{
    return NO;
}

- (BOOL)pointingDeviceCancelledEvent:(NSEvent*)event
{
    return NO;
}

#endif

@end
