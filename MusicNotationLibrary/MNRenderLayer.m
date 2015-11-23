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
#import "MNTestTuple.h"
#import "MNCore.h"
#import "MNGlyphLayer.h"

#define RENDERLAYER_BORDER_WIDTH 4.0

@interface MNRenderLayer ()

@property (assign, nonatomic) SEL selector;
@property (strong, nonatomic) id target;
@property (strong, nonatomic) MNTestTuple* testTuple;
@property (strong, nonatomic) NSString* testName;

@end

//#ifdef TARGET_OS_IPHONE
//@implementation RenderLayer
//@end
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

- (MNTestTuple*)invokeTest
{
    NSMethodSignature* signature = [_target methodSignatureForSelector:self.selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:self.selector];
    [invocation setTarget:self.target];
    //    NSString* name = @"";

    // set the TestCollectionItemView
    id arg2 = self.parentView;
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
    MNTestTuple* ret __unsafe_unretained;   // http://stackoverflow.com/a/22034059/629014
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
//    CGContextSaveGState(ctx);

    CGRect dirtyRect = self.bounds;

    NSGraphicsContext* gc = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:YES];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:gc];

    MNBezierPath* outline = [MNBezierPath bezierPathWithRect:dirtyRect];
    [SHEET_MUSIC_COLOR setFill];
    //    [[MNColor randomBGColor:YES] setFill];

    [outline fill];

    if(!_testTuple)
    {
        return;
    }

    MNStaff* staff;
    if(self.testTuple.staves.count > 0)
    {
        staff = self.testTuple.staves[0];
    }

    if(self.testTuple.voices.count == 0)
    {
        [staff draw:ctx];
    }

    for(NSUInteger i = 0; i < self.testTuple.staves.count; ++i)
    {
        staff = self.testTuple.staves[i];
        [staff draw:ctx];
    }

    for(NSUInteger i = 0; i < self.testTuple.voices.count; ++i)
    {
        //        if(self.testTuple.staves.count == i + 1)
        //        {
        staff = self.testTuple.staves[i];
        //        }
        //        [staff draw:ctx];
        MNVoice* voice = self.testTuple.voices[i];
        [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
    }

    for(NSUInteger i = 0; i < self.testTuple.beams.count; ++i)
    {
        NSArray* beams = self.testTuple.beams[i];
        if(beams.count < 1)
        {
            continue;
        }
        [beams foreach:^(MNBeam* beam, NSUInteger index, BOOL* stop) {
          [beam draw:ctx];
        }];
        //        [beam draw:ctx];
    }

    for(NSUInteger i = 0; i < self.testTuple.drawables.count; ++i)
    {
        id<MNTickableDelegate> drawable = self.testTuple.drawables[i];
        if([drawable respondsToSelector:@selector(draw:)])
        {
            [drawable draw:ctx];
        }
    }

    if(self.testTuple.drawBlock)
    {
        self.testTuple.drawBlock(CGRectZero, self.bounds, ctx);
    }

    //    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.alignment = kCTTextAlignmentLeft;
    //
    //#if TARGET_OS_IPHONE
    //    UIFont* font1 = [UIFont fontWithName:@"Helvetica" size:12];
    //#elif TARGET_OS_MAC
    //    NSFont* font1 = [NSFont fontWithName:@"Helvetica" size:12];
    //#endif
    //
    //     MNFont* font1 =  [MNFont fontWithName:@"Helvetica" size:12];

    // TODO: change to NSTextField
    //    NSAttributedString* titleString = [[NSAttributedString alloc]
    //        initWithString:self.testName
    //            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1}];
    //    [titleString drawAtPoint:CGPointMake(10, 10)];

    [NSGraphicsContext restoreGraphicsState];

//    CGContextRestoreGState(ctx);
}

- (MNStaffNote*)showStaffNote:(MNStaffNote*)ret
                      onStaff:(MNStaff*)staff
                  withContext:(CGContextRef)ctx
                          atX:(float)x
              withBoundingBox:(BOOL)drawBoundingBox
{
    MNLogInfo(@"");
    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:ret] preFormat];
    tickContext.x = x;
    tickContext.pixelsUsed = 20;
    ret.staff = staff;
    [ret draw:ctx];
    if(drawBoundingBox)
    {
        [ret.boundingBox draw:ctx];
    }
    return ret;
}

- (MNStaffNote*)showNote:(NSDictionary*)noteStruct onStaff:(MNStaff*)staff withContext:(CGContextRef)ctx atX:(float)x
{
    return [self showNote:noteStruct onStaff:staff withContext:ctx atX:x withBoundingBox:NO];
}

- (MNStaffNote*)showNote:(NSDictionary*)noteStruct
                 onStaff:(MNStaff*)staff
             withContext:(CGContextRef)ctx
                     atX:(float)x
         withBoundingBox:(BOOL)drawBoundingBox
{
    MNStaffNote* ret = [[MNStaffNote alloc] initWithDictionary:noteStruct];
    return [self showStaffNote:ret onStaff:staff withContext:ctx atX:x withBoundingBox:drawBoundingBox];
}

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

@end

//#endif