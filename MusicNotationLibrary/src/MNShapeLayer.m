//
//  MNShapeLayer.m
//  MusicNotation
//
//  Created by Scott on 8/13/15.
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

#import "MNShapeLayer.h"

@implementation MNShapeLayer

//- (BOOL)pointingDeviceDownEvent:(NSEvent*)event atPoint:(CGPoint)interactionPoint
//{
//    BOOL handled = NO;
//
//    for(CALayer* sublayer in self.sublayers.reverseObjectEnumerator)
//    {
//        if(sublayer && [sublayer conformsToProtocol:@protocol(LayerResponder)])   //||
//            //           [sublayer respondsToSelector:@selector(pointingDeviceDownEvent:atPoint:)])
//        {
//            CGPoint pointInHostedLayer = [self convertPoint:interactionPoint toLayer:sublayer];
//            handled = [((id<LayerResponder>)sublayer)pointingDeviceDownEvent:event atPoint:pointInHostedLayer];
//            if(handled)
//            {
//                break;
//            }
//        }
//    }
//
//    return handled;
//}

- (void)animate
{
    POPSpringAnimation* scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3f, 1.3f)];
    scaleAnimation.springBounciness = 18.0f;
    [self pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    self.opacity = 0.5;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      POPSpringAnimation* scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
      scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
      scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
      scaleAnimation.springBounciness = 18.0f;
      [self pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
      self.opacity = 1.0;
    });
}

#if TARGET_OS_IPHONE
//- (CALayer*)hitTest:(CGPoint)thePoint
//{
//    if([self containsPoint:thePoint])
//    {
//        [self animate];
//        return self;
//    }
//    else
//    {
//        return [self.superlayer hitTest:thePoint];
//    }
//}

//- (CALayer*)hitTest:(CGPoint)point
//{
//    static NSUInteger i = 1;
//
//    NSLog(@"%.2f, %.2f", point.x, point.y);
//
//    if([self containsPoint:point])
//    {
//        NSLog(@"clicked: %lu", i++);
//        [self animate];
//    }
//    else
//    {
//        NSLog(@"no");
//    }
//    return [super hitTest:point];
//}

//- (BOOL)containsPoint:(CGPoint)p
//{
//    CGPoint touchLocation = [self convertPoint:p toLayer:self];
//
//    return NO;
//}

//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    [self animate];
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    for (UITouch *touch in touches) {
//        CGPoint touchLocation = [touch locationInView:self.superView];
////        for (id sublayer in self.superView.layer.sublayers) {
//            BOOL touchInLayer = NO;
//            if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
//                CAShapeLayer *shapeLayer = sublayer;
//                if (CGPathContainsPoint(shapeLayer.path, 0, touchLocation, YES)) {
//                    // This touch is in this shape layer
//                    touchInLayer = YES;
//                }
//            } else {
//                CALayer *layer = sublayer;
//                if (CGRectContainsPoint(layer.frame, touchLocation)) {
//                    // Touch is in this rectangular layer
//                    touchInLayer = YES;
//                }
//            }
//        }
//    }
//}

//- (CALayer*)layerForTouch:(UITouch*)touch
//{
//    [self animate];
//    return self;
//}

#elif TARGET_OS_MAC

- (BOOL)pointingDeviceDownEvent:(NSEvent*)event atPoint:(CGPoint)interactionPoint
{
    BOOL handled = NO;

    //    for(CALayer* sublayer in self.sublayers.reverseObjectEnumerator)
    //    {
    //        if(sublayer || [sublayer conformsToProtocol:@protocol(LayerResponder)] ||
    //           [sublayer respondsToSelector:@selector(pointingDeviceDownEvent:atPoint:)])
    //        {
    //            CGPoint pointInHostedLayer = [self convertPoint:interactionPoint toLayer:sublayer];
    //            handled = [self pointingDeviceDownEvent:event atPoint:pointInHostedLayer];
    //        }
    //    }

    if(CGRectContainsPoint(self.bounds, interactionPoint))
    {
        static NSUInteger i = 1;
        NSLog(@"clicked: %lu", i++);
        [self animate];
        handled = YES;
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
