//
//  MNAnimationTest.m
//  MusicNotation
//
//  Created by Scott on 4/17/15.
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

#import "MNAnimationTests.h"

@interface AnimationGlyphBox : NSObject
@end
@implementation AnimationGlyphBox
- (void)drawLayer:(CALayer*)theLayer inContext:(CGContextRef)ctx
{
    NSLog(@"GlyphBox drawLayer");

    CGPoint center;
    center.x = CGRectGetMidX(theLayer.bounds);
    center.y = CGRectGetMidY(theLayer.bounds);

    CGContextSaveGState(ctx);

    [MNColor.blackColor setFill];
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

@interface MNAnimationTests ()

//@property (strong, nonatomic) MNButton* animateButton;
//@property (strong, nonatomic) AnimationGlyphBox* boxDelegate;
//@property (strong, nonatomic) CALayer* box;

- (IBAction)animate:(MNButton*)sender;

@end

@implementation MNAnimationTests

- (void)start
{
    [super start];
    [self runTest:@"Basic" func:@selector(basic:) frame:CGRectMake(0, 0, 700, 300)];
}

- (MNTestTuple*)basic:(MNTestCollectionItemView*)parent
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    //    AnimationTests* test = [self createCanvasTest:CGSizeMake(700, 300) withParent:parent withTitle:@"Basic"];
    // test.backgroundColor = [MNColor randomBGColor:YES];

    MNAnimationTests* test = self;

    //    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
    //      test.view.wantsLayer = YES;
    //      CALayer* layer = [CALayer layer];
    //      layer.frame = test.view.frame;
    //      test.view.layer.opacity = 1.0;
    //      layer.backgroundColor = [MNColor randomBGColor:YES].CGColor;
    //      [test.view setLayer:layer];
    //      //    test.backgroundColor = [MNColor randomBGColor:NO];
    //      layer.delegate = test;
    //      [test.view.layer setNeedsDisplay];
    //};

    parent.translatesAutoresizingMaskIntoConstraints = YES;

    test.box = [CALayer layer];
    test.box.opacity = 1.0;
    test.box.backgroundColor = [NSColor redColor].CGColor;   //[MNColor randomBGColor:NO].CGColor;
    test.box.bounds = CGRectMake(0, 0, 100, 150);
    test.box.position = CGPointMake(100, 100);   // 100, CGRectGetMidY(test.frame));
    test.boxDelegate = [[AnimationGlyphBox alloc] init];
    test.box.delegate = test.boxDelegate;

    //      [test.view.layer addSublayer:test.box];
    [parent.layer addSublayer:test.box];
    test.box.transform = CATransform3DMakeRotation(0, 0, 0, 0);   // 90.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
    [test.box setNeedsDisplay];

    test.animateButton = [[MNButton alloc] init];
    [test.animateButton setButtonType:NSMomentaryPushInButton];
    [test.animateButton setBezelStyle:NSRoundedBezelStyle];
    [test.animateButton setTarget:self];
    test.animateButton.title = @"Animate";
    [test.animateButton sizeToFit];
    [test.animateButton setTarget:test];
    [test.animateButton setAction:@selector(animate:)];
    CGSize size = test.animateButton.frame.size;
    // TODO: button is incorrectly positioned
    //    test.animateButton.layer.position = CGPointMake(250, 250);
    test.animateButton.layer.frame = NSRectFromCGRect(CGRectMake(100, 350, size.width, size.height));
    test.animateButton.wantsLayer = YES;
    test.animateButton.layer.backgroundColor = [NSColor redColor].CGColor;
    //      [test.view addSubview:test.animateButton];
    dispatch_async(dispatch_get_main_queue(), ^{
      [parent addSubview:test.animateButton];
    });

    //        });

    //    test.animateButton.layer.position=NSMakePoint(0, 80.);
    //    [test.layer addSublayer:test.animateButton.layer];

    //    NSView* aView = [[NSView alloc]initWithFrame:CGRectMake(150, 150, 100, 100)];
    //    aView.wantsLayer = YES;
    //    aView.layer.backgroundColor = [NSColor blueColor].CGColor;
    //// either of the following add this view to the test view
    ////    [test addSubview:aView];
    ////    [test.layer addSublayer:aView.layer];

    //    test.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
    /*
    {
        CGContextRef ctx = MNGraphicsContext();

        //      // [[self class] background:dirtyRect];
        //
        // write the text at the top
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = kCTTextAlignmentCenter;

        // http://iosfonts.com/
        // Programming iOS 6, 3rd Edition, Attributed Strings
        // http://goo.gl/CSmaQe

        //      if(NSIntersectsRect(dirtyRect, CGRectMake(5, 5, bounds.size.width, 200)))
        //      {
        //          MNFont* font1 =  [MNFont fontWithName:@"TimesNewRomanPS-BoldMT" size:25];
        //          NSString* titleMessage = @"Animation Test";
        //          NSAttributedString* title = [[NSAttributedString alloc]
        //              initWithString:titleMessage
        //                  attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName :
        //                  font1}];
        //          [title drawInRect:CGRectMake(5, 5, bounds.size.width, 200)];
        //      }

        //      // TODO: do the following lines do anything?
        //      MNFont* descriptionFont =  [MNFont fontWithName:@"ArialMT" size:15];
        //      NSString* subTitleMessage = @"";
        //      __block NSAttributedString* description = [[NSAttributedString alloc]
        //          initWithString:subTitleMessager
        //              attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName :
        //              descriptionFont}];
        //
        //      CGContextSetLineWidth(ctx, 1.0f);

        MNGlyphStruct* trebleGlyph =  [MNGlyphList sharedInstance].availableGlyphStructsDictionary[@"v7a"];

        // render the glyph

        // TODO: render by passing glyph struct

        NSUInteger x = 50;
        NSUInteger shift = 50;
        NSUInteger y = 200;
        float scale = 1;
        BOOL drawBB = YES;
        for(NSUInteger i = 0; i < 7; ++i)
        {
            //          MNColor* color = MNColor.blackColor;
            //              (MNColor*)[MNColor randomBGColor:YES];
            [MNColor.blackColor setFill];
            //          [MNColor.blackColor setStroke];
             [MNGlyph renderGlyph:ctx
                              atX:x
                              atY:y
                        withScale:scale
                     forGlyphCode:trebleGlyph.name
                renderBoundingBox:drawBB];
            scale *= 1.2;
            x += (shift *= 1.2);
            drawBB = !drawBB;
        }
    };
     */

    return ret;
}

- (IBAction)animate:(MNButton*)sender
{
    [sender setEnabled:NO];

    NSLog(@"animation begin");

    CGFloat translationX = 100;
    CGPoint finalPosition =
        CGPointMake(translationX, self.box.position.y);   // self.box.position.x + translationX, self.box.position.y);

    [CATransaction begin];
    {
        [CATransaction setCompletionBlock:^{
          self.box.position = finalPosition;
          self.box.transform = CATransform3DMakeRotation(0, 0, 0, 0);
          [sender setEnabled:YES];
          NSLog(@"animation complete");
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
