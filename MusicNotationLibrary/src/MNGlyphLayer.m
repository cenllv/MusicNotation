//
//  GlyphLayer.m
//  MusicNotation
//
//  Created by Scott on 8/11/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
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

#import "MNGlyphLayer.h"

@implementation MNGlyphShapeLayer

//- (CALayer *)hitTest:(CGPoint)p
//{
//    [super hitTest:p];
//    [self animate];
//    return self;
//}

+ (MNGlyphShapeLayer*)layer
{
    return [[MNGlyphShapeLayer alloc] init];
}

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