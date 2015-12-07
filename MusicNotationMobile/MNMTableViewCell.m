//
//  MNMTableViewCell.m
//  MusicNotationMobile
//
//  Created by Scott Riccardelli on 12/4/15.
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

#import "MNMTableViewCell.h"
#import "MNRenderLayer.h"
#import "MNMCarrierView.h"

@implementation MNMTableViewCell

@dynamic textLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];   //[UIColor greenColor]; // for debugging
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.carrierView.translatesAutoresizingMaskIntoConstraints = NO;
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (MNMCarrierView*)carrierView
{
    if(!_carrierView)
    {
        _carrierView = [[MNMCarrierView alloc] init];
        _carrierView.translatesAutoresizingMaskIntoConstraints = NO;
        [self setNeedsUpdateConstraints];
    }
    return _carrierView;
}

- (void)prepareForReuse
{
    _carrierView = nil;
}

- (void)updateConstraints
{
    [super updateConstraints];

    NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:10];
    NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:10];

    [self.contentView addConstraints:@[ c1, c2 ]];

    [self.contentView addSubview:self.carrierView];
    NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.carrierView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
    NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.carrierView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0];

    NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.carrierView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:self.textLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:10];

    NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.carrierView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0];

    [self.contentView addConstraints:@[ c3, c4, c5, c6 ]];
}

#pragma mark - touch

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    //    // Configure the view for the selected state
    //    if(selected)
    //    {
    //        self.backgroundColor = [UIColor greenColor];
    //    }
    //    else
    //    {
    //        self.backgroundColor = [UIColor whiteColor];
    //    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    // CALayer *layer = [self.layer hitTest:point];

    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    //    //    UITouch *touch = [touches anyObject];
    //    ////    CALayer *hitLayer = [self layerForTouch:touch];
    //    //    CALayer *hitPresentationLayer = [self.layer.presentationLayer hitTest:location];
    //    //    if (hitPresentationLayer) {
    //    //        return hitPresentationLayer.modelLayer;
    //    //    }
    //    [self setSelected:YES];
    //
    //    if([touches count] == 1)
    //    {
    //        for(UITouch* touch in touches)
    //        {
    //            CGPoint point = [touch locationInView:[touch view]];
    //            point = [[touch view] convertPoint:point toView:nil];
    //
    //            //            CALayer* layer = [(CALayer*)self.layer.presentationLayer hitTest:point];
    //            CALayer* layer = [(CALayer*)self.layer hitTest:point];
    //            [layer hitTest:point];
    //
    //            //            layer = layer.modelLayer;
    //        }
    //    }
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    //    [self setSelected:NO];
}

@end
