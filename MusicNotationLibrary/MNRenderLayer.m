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
@property (strong, nonatomic) MNTestBlockStruct* testTuple;
@property (strong, nonatomic) NSString* testName;

@end

//#ifdef TARGET_OS_IPHONE
//#elif TARGET_OS_MAC

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

- (MNTestBlockStruct*)invokeTest
{
    NSMethodSignature* signature = [_target methodSignatureForSelector:self.selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:self.selector];
    [invocation setTarget:self.target];
//    NSString* name = @"";

// set the TestCollectionItemView

#if TARGET_OS_IPHONE
    // MNMTableViewCell* arg2 = (MNMTableViewCell*)self.parentView;
    MNMCarrierView* arg2 = (MNMCarrierView*)self.parentView;
//    self.bounds = arg2.frame;
#elif TARGET_OS_MAC
    id arg2 = self.parentView;
#endif

    [invocation setArgument:&arg2 atIndex:2];
    //    [invocation setArgument:&ctx atIndex:3];

    // set additional params
    if(self.testAction)
    {
        if(self.testAction.params)
        {
            id arg3 = _testAction.params;
            [invocation setArgument:&arg3 atIndex:3];
        }
    }

    [invocation invoke];
    MNTestBlockStruct* ret __unsafe_unretained;   // http://stackoverflow.com/a/22034059/629014
    [invocation getReturnValue:&ret];
    self.testTuple = ret;
    return ret;
}

- (void)setNeedsDisplay
{
    //    if(_testTuple)
    //    {
    [super setNeedsDisplay];
    //    }
    //    else
    //    {
    //        NSLog(@"need to setup layer first.");
    //    }
}

- (void)setTestAction:(MNTestAction*)testAction
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

- (void)clearLayer
{
    _testTuple = nil;
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
    if(self.testTuple.backgroundColor)
    {
        [self.testTuple.backgroundColor setFill];
    }
    else
    {
        [SHEET_MUSIC_COLOR setFill];
        //    [[MNColor randomBGColor:YES] setFill];
    }
    [outline fill];

#if TARGET_OS_IPHONE
    float superLayerWidth = self.superlayer.bounds.size.width;
    float testWidth = self.testAction.frame.size.width;
    float scale = superLayerWidth / testWidth;
    CGContextScaleCTM(ctx, scale, scale);
#endif

    if(self.testTuple.drawBlock)
    {
        self.testTuple.drawBlock(CGRectZero, self.bounds, ctx);
    }

#if TARGET_OS_IPHONE
    CGContextRestoreGState(ctx);
    UIGraphicsPopContext();
#elif TARGET_OS_MAC
    [NSGraphicsContext restoreGraphicsState];
#endif
    //        CGContextRestoreGState(ctx);
}

//- (MNStaffNote*)showStaffNote:(MNStaffNote*)ret
//                      onStaff:(MNStaff*)staff
//                  withContext:(CGContextRef)ctx
//                          atX:(float)x
//              withBoundingBox:(BOOL)drawBoundingBox
//{
//    MNLogInfo(@"");
//    MNTickContext* tickContext = [[MNTickContext alloc] init];
//    [[tickContext addTickable:ret] preFormat];
//    tickContext.x = x;
//    tickContext.pointsUsed = 20;
//    ret.staff = staff;
//    [ret draw:ctx];
//    if(drawBoundingBox)
//    {
//        [ret.boundingBox draw:ctx];
//    }
//    return ret;
//}
//
//- (MNStaffNote*)showNote:(NSDictionary*)noteStruct onStaff:(MNStaff*)staff withContext:(CGContextRef)ctx atX:(float)x
//{
//    return [self showNote:noteStruct onStaff:staff withContext:ctx atX:x withBoundingBox:NO];
//}
//
//- (MNStaffNote*)showNote:(NSDictionary*)noteStruct
//                 onStaff:(MNStaff*)staff
//             withContext:(CGContextRef)ctx
//                     atX:(float)x
//         withBoundingBox:(BOOL)drawBoundingBox
//{
//    MNStaffNote* ret = [[MNStaffNote alloc] initWithDictionary:noteStruct];
//    return [self showStaffNote:ret onStaff:staff withContext:ctx atX:x withBoundingBox:drawBoundingBox];
//}

//- (void)setBorderColor:(NSColor*)newBorderColor
- (void)setBorderColor:(CGColorRef)borderColor
{
    //    if(_borderColor != [NSColor colorWithCGColor:borderColor])
    //    {
    //        _borderColor = [NSColor colorWithCGColor:borderColor];
    //        NSColor* borderColor = [NSColor blueColor];
    //        self.borderColor = _borderColor.CGColor;
    [super setBorderColor:borderColor];
    self.borderWidth = (self.borderColor ? RENDERLAYER_BORDER_WIDTH : 0.0);
    //        [self setNeedsDisplay];
    //    }
}

- (void)addSublayer:(CALayer*)layer
{
    [super addSublayer:layer];
}

#if TARGET_OS_IPHONE

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
