//
//  MNTestCollectionItemView.m
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

#import "MNTestCollectionItemView.h"
#import "MNRenderLayer.h"
#import "MNCore.h"
#import "MNLayerResponder.h"

@interface MNTestCollectionItemView ()

@property (assign, nonatomic) BOOL activated;

@end

@implementation MNTestCollectionItemView

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _activated = NO;
    }
    return self;
}

- (BOOL)isFlipped
{
#if TARGET_OS_IPHONE
    return NO;
#elif TARGET_OS_MAC
    return YES;
#endif
}

- (MNStaffNote*)showStaffNote:(MNStaffNote*)staffNote
                      onStaff:(MNStaff*)staff
                  withContext:(CGContextRef)ctx
                          atX:(float)x
              withBoundingBox:(BOOL)drawBoundingBox
{
    return [((MNRenderLayer*)self.layer)showStaffNote:staffNote
                                            onStaff:staff
                                        withContext:ctx
                                                atX:x
                                    withBoundingBox:drawBoundingBox];
}

- (MNStaffNote*)showNote:(NSDictionary*)noteStruct onStaff:(MNStaff*)staff withContext:(CGContextRef)ctx atX:(float)x
{
    return [((MNRenderLayer*)self.layer)showNote:noteStruct onStaff:staff withContext:ctx atX:x withBoundingBox:NO];
}

- (MNStaffNote*)showNote:(NSDictionary*)noteStruct
                 onStaff:(MNStaff*)staff
             withContext:(CGContextRef)ctx
                     atX:(float)x
         withBoundingBox:(BOOL)drawBoundingBox
{
    return [((MNRenderLayer*)self.layer)showNote:noteStruct
                                       onStaff:staff
                                   withContext:ctx
                                           atX:x
                               withBoundingBox:drawBoundingBox];
}

- (void)setLayer:(CALayer*)layer
{
    [super setLayer:layer];
    // if([layer isKindOfClass:[RenderLayer class]])
    //#ifdef TARGET_OS_IPHONE
    //
    //#elif TARGET_OS_MAC
    if([layer conformsToProtocol:@protocol(MNLayerResponder)])
    {
        self.hostedRenderLayer = (MNRenderLayer*)layer;
    }
    //#endif
}

- (NSView*)hitTest:(NSPoint)aPoint
{
    // Hit-test against the slide's rounded-rect shape.
    NSPoint pointInSelf = [self convertPoint:aPoint fromView:self.superview];
    NSRect bounds = self.bounds;
    if(!NSPointInRect(pointInSelf, bounds))
    {
        //        NSLog(@"NO");
        //        self.layer.borderColor = nil;
        return NO;
    }
    else
    {
        //        NSLog(@"YES");
        //        //        self.layer.borderColor = [NSColor orangeColor].CGColor;
        //        if(_activated)
        //        {
        //            self.layer.borderColor = [NSColor blueColor].CGColor;
        //        }
        //        else
        //        {
        //            self.layer.borderColor = nil;
        //        }
        return [super hitTest:aPoint];
    }
}

- (void)mouseDown:(NSEvent*)theEvent
{
    [super mouseDown:theEvent];

    BOOL handled = NO;

    CGPoint pointOfMouseDown = NSPointToCGPoint([self convertPoint:[theEvent locationInWindow] fromView:nil]);
    MNRenderLayer* theRenderLayer = self.hostedRenderLayer;

    if(theRenderLayer)
    {
        //        for(CALayer* sublayer in theRenderLayer.sublayers.reverseObjectEnumerator)
        //        {
        //            if([sublayer conformsToProtocol:@protocol(LayerResponder)])
        //            {
        CGPoint pointInHostedLayer = [self.layer convertPoint:pointOfMouseDown toLayer:theRenderLayer];
        handled = [theRenderLayer pointingDeviceDownEvent:theEvent atPoint:pointInHostedLayer];
        //            }
        //        }
    }

    if(!handled)
    {
        [self.nextResponder mouseDown:theEvent];
    }

    _activated = YES;
    self.layer.borderColor = [NSColor blueColor].CGColor;
}

- (void)mouseUp:(NSEvent*)theEvent
{
    [super mouseUp:theEvent];

    _activated = NO;
    self.layer.borderColor = nil;
}

@end