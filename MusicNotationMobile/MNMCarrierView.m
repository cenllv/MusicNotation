//
//  MNMCarrierView.m
//  MusicNotationMobile
//
//  Created by Scott Riccardelli on 12/6/15.
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

#import "MNMCarrierView.h"
#import "MNRenderLayer.h"
#import "MNShapeLayer.h"

@implementation MNMCarrierView

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor redColor];
        self.layer.delegate = self;
        [(MNRenderLayer*)self.layer setParentView:self];
    }
    return self;
}

+ (Class)layerClass
{
    return [MNRenderLayer class];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.layer setNeedsDisplay];
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
    [self.layer drawLayer:layer inContext:ctx];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    CALayer* layer = [self.layer hitTest:point];
    if([layer isKindOfClass:[MNShapeLayer class]])
    {
        [(MNShapeLayer*)layer animate];
    }

    return [super hitTest:point withEvent:event];
}

@end
