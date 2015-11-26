//
//  MNAnimationTest.m
//  MusicNotation
//
//  Created by Scott on 4/17/15.
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

#import "MNAnimationTests.h"

@interface AnimationGlyphBox : CALayer
@end

@implementation AnimationGlyphBox

- (void)drawLayer:(CALayer*)theLayer inContext:(CGContextRef)ctx
{
    MNLogDebug(@"AnimationGlyphBox drawLayer");

    CGPoint center;
    center.x = CGRectGetMidX(theLayer.bounds);
    center.y = CGRectGetMidY(theLayer.bounds);

    CGContextSaveGState(ctx);

    //    [NSColor.blackColor setFill];
    MNGlyphStruct* trebleGlyph = [MNGlyphList sharedInstance].availableGlyphStructsDictionary[@"v3d"];
    [MNGlyph renderGlyph:ctx
                      atX:center.x - 30
                      atY:center.y
                withScale:2
             forGlyphCode:trebleGlyph.name
        renderBoundingBox:NO];

    CGContextRestoreGState(ctx);
}

@end

@implementation MNAnimationTests

- (void)start
{
    [super start];
    [self runTest:@"Basic" func:@selector(basic:) frame:CGRectMake(0, 0, 700, 300)];
}

- (void)tearDown
{
    [super tearDown];
    MNAnimationTests* test = self;
    [test.box removeFromSuperlayer];
    [test.animateButton removeFromSuperview];
}

- (MNTestTuple*)basic:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    ret.backgroundColor = [MNColor randomBGColor:YES];
    MNAnimationTests* test = self;

    parent.translatesAutoresizingMaskIntoConstraints = YES;
    test.box = [CALayer layer];
    test.box.opacity = 1.0;
    test.box.backgroundColor = [NSColor whiteColor].CGColor;
    test.box.bounds = CGRectMake(0, 0, 100, 150);
    test.box.position = CGPointMake(100, 100);
    test.boxDelegate = [[AnimationGlyphBox alloc] init];
    test.box.delegate = test.boxDelegate;
    test.box.transform = CATransform3DMakeRotation(0, 0, 0, 0);
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //      [parent.layer addSublayer:test.box];
    //      [test.box setNeedsDisplay];
    //    });

    test.animateButton = [[MNButton alloc] init];
    [test.animateButton setButtonType:NSMomentaryPushInButton];
    [test.animateButton setBezelStyle:NSRoundedBezelStyle];
    [test.animateButton setTarget:self];
    test.animateButton.title = @"Animate";
    [test.animateButton sizeToFit];
    [test.animateButton setTarget:test];
    [test.animateButton setAction:@selector(animate:)];
    CGSize size = test.animateButton.frame.size;
    test.animateButton.layer.frame = NSRectFromCGRect(CGRectMake(0, 0, size.width, size.height));
    CGRect rect = test.animateButton.frame;
    rect.origin = CGPointMake(20, parent.frame.size.height - 50);
    test.animateButton.frame = rect;
    test.animateButton.wantsLayer = YES;
    //    test.animateButton.layer.backgroundColor = [NSColor redColor].CGColor;
    dispatch_async(dispatch_get_main_queue(), ^{
      [parent.layer addSublayer:test.box];
      [test.box setNeedsDisplay];
      [parent addSubview:test.animateButton];
    });

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      MNGlyphStruct* trebleGlyph = [MNGlyphList sharedInstance].availableGlyphStructsDictionary[@"v7a"];
      float x = 50, shift = 50, y = 200, scale = 1;
      BOOL drawBB = YES;
      for(NSUInteger i = 0; i < 7; ++i)
      {
          [MNColor.blackColor setFill];
          [MNGlyph renderGlyph:ctx atX:x atY:y withScale:scale forGlyphCode:trebleGlyph.name renderBoundingBox:drawBB];
          scale *= 1.2;
          x += (shift *= 1.2);
          drawBB = !drawBB;
      }
    };

    return ret;
}

- (IBAction)animate:(MNButton*)sender
{
    [sender setEnabled:NO];

    MNLogDebug(@"animation begin");

    CGFloat translationX = 100;
    CGPoint finalPosition = CGPointMake(translationX, self.box.position.y);

    [CATransaction begin];
    {
        [CATransaction setCompletionBlock:^{
          self.box.position = finalPosition;
          self.box.transform = CATransform3DMakeRotation(0, 0, 0, 0);
          [sender setEnabled:YES];
          MNLogDebug(@"animation complete");
        }];

        // spin
        CABasicAnimation* myAnimation = [CABasicAnimation animation];
        myAnimation.removedOnCompletion = YES;
        myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        myAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        myAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        myAnimation.toValue = [NSNumber numberWithFloat:((360 * M_PI) / 180)];
        myAnimation.duration = 1.0;
        myAnimation.repeatCount = 1.0;   // HUGE_VALF;
        [self.box addAnimation:myAnimation forKey:@"testAnimation"];

        // translate
        CABasicAnimation* myAnimation2 = [CABasicAnimation animation];
        myAnimation2.removedOnCompletion = YES;
        myAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
        myAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        myAnimation2.fromValue = [NSNumber numberWithFloat:0.0];
        myAnimation2.toValue = [NSNumber numberWithFloat:500];
        myAnimation2.duration = 1.0;
        myAnimation2.repeatCount = 1.0;
        [self.box addAnimation:myAnimation2 forKey:@"testAnimation2"];
    }
    [CATransaction commit];
}

@end
