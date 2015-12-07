//
//  MNWrappedLayout.m
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

#import "MNWrappedLayout.h"
#import "MNTestViewController.h"

// TODO: the following constants need to be tweaked or serve no use and need to be removed entirely

#define SLIDE_WIDTH \
    700.0   // width  of the SlideCarrier image (which includes shadow margins) in points, and thus the width  that we
            // give to a Slide's root view
#define SLIDE_HEIGHT \
    150.0   // height of the SlideCarrier image (which includes shadow margins) in points, and thus the height that we
            // give to a Slide's root view

#define SLIDE_SHADOW_MARGIN \
    10.0   // margin on each side between the actual slide shape edge and the edge of the SlideCarrier image
#define SLIDE_CORNER_RADIUS 8.0   // corner radius of the slide shape in points
#define SLIDE_BORDER_WIDTH 4.0    // thickness of border when shown, in points

#define X_PADDING 10.0
#define Y_PADDING 10.0

@implementation MNWrappedLayout

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setItemSize:NSMakeSize(SLIDE_WIDTH, SLIDE_HEIGHT)];
        [self setMinimumInteritemSpacing:X_PADDING];
        [self setMinimumLineSpacing:Y_PADDING];
        [self setSectionInset:NSEdgeInsetsMake(Y_PADDING, X_PADDING, Y_PADDING, X_PADDING)];
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(NSRect)newBounds
{
    return YES;
}

- (NSCollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSCollectionViewLayoutAttributes* attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    //    [attributes setZIndex:[indexPath item]];
    //    attributes.frame = [self.testViewController frameAtIndex:indexPath.item];
    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(NSRect)rect
{
    NSArray* layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    //    for(NSCollectionViewLayoutAttributes* attributes in layoutAttributesArray)
    //    {
    //        [attributes setZIndex:[[attributes indexPath] item]];
    //        attributes.frame = [self.testViewController frameAtIndex:attributes.indexPath.item];
    //
    //    }
    return layoutAttributesArray;
}

@end
