//
//  MNTestCollectionItem.m
//  MusicNotation
//
//  Created by Scott on 8/5/15.
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

#import "MNTestCollectionItem.h"
#import "MNTestActionStruct.h"
#import "MNRenderLayer.h"
#import "MNMacros.h"
#import "MNTestCollectionItemView.h"

#define RENDERLAYER_CORNER_RADIUS 8.0

NSString* const kTestCollectionItemid = @"testCollectionItemid";

@interface MNTestCollectionItem ()

@property (strong, nonatomic) MNTestActionStruct* test;
@property (strong, nonatomic) MNRenderLayer* renderLayer;
//@property (strong, nonatomic) NSTextField* textField; // already a convenience property with this name
@property (strong, nonatomic) NSTextField* textLabel;

@end

@implementation MNTestCollectionItem

- (instancetype)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
    }
    return self;
}

- (void)dealloc
{
    for(NSView* subView in self.view.subviews)
    {
        [subView removeFromSuperview];
    }
    for(CALayer* layer in self.view.layer.sublayers)
    {
        [layer removeFromSuperlayer];
    }
}

#pragma mark - properties

- (MNRenderLayer*)renderLayer
{
    if(!_renderLayer)
    {
        _renderLayer = [[MNRenderLayer alloc] init];
        _renderLayer.delegate = _renderLayer;
        _renderLayer.drawsAsynchronously = YES;
        _renderLayer.frame = self.view.frame;
        _renderLayer.parentView = (MNTestCollectionItemView*)self.view;
        _renderLayer.backgroundColor = SHEET_MUSIC_COLOR.CGColor;
        _renderLayer.cornerRadius = RENDERLAYER_CORNER_RADIUS;
    }
    return _renderLayer;
}

- (NSTextField*)textLabel
{
    if(!_textLabel)
    {
        _textLabel = [[NSTextField alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
        _textLabel.editable = NO;
        _textLabel.selectable = YES;
        //    textField.backgroundColor = [NSColor clearColor];
        _textLabel.drawsBackground = NO;
        _textLabel.stringValue = self.test.name ?: @"";
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

#pragma mark - NSViewController lifecycle

- (void)loadView
{
    self.view = [[MNTestCollectionItemView alloc] init];
    [self.view addSubview:self.textLabel];
}

- (void)viewWillAppear
{
    //    [self.renderLayer clearLayer];
    [super viewWillAppear];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
}

- (void)viewDidDisappear
{
    [super viewDidDisappear];
    //    [self.renderLayer clearLayer];
    //    [self prepareForReuse];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setLayer:self.renderLayer];
    [self.view setWantsLayer:YES];
    //    [self.collectionView invalidateLayoutOfLayer:self.collectionView.layer];
}

#pragma mark - <NSCollectionViewElement>

- (void)prepareForReuse
{
    [super prepareForReuse];
    //    [self.renderLayer clearLayer];
    //    for(NSView* subView in self.view.subviews)
    //    {
    //        [subView removeFromSuperview];
    //    }

//    for(CALayer* layer in self.view.layer.sublayers)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [layer removeFromSuperlayer];
//        });
//    }

    //
    //    [self.view addSubview:self.textLabel];

    //    self.textLabel.stringValue = @"Arst";
    //    [self.textLabel sizeToFit];
}

- (void)applyLayoutAttributes:(NSCollectionViewLayoutAttributes*)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.view.frame = layoutAttributes.frame;
}

- (void)setRepresentedObject:(id)newRepresentedObject
{
    [super setRepresentedObject:newRepresentedObject];

    if([newRepresentedObject isKindOfClass:[MNTestActionStruct class]])
    {
        if(self.renderLayer.testAction != newRepresentedObject)
        {
            self.textLabel.stringValue = ((MNTestActionStruct*)newRepresentedObject).name;
            [self.textLabel sizeToFit];
            self.renderLayer.testAction = newRepresentedObject;
        }
    }
}

@end
