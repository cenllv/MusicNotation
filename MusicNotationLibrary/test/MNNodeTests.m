//
//  MNNodeTests.m
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

#import "MNNodeTests.h"

@implementation MNNodeTests

- (void)start
{
    [super start];
    [self runTest:@"ABCxyz" func:@selector(basicHeirarchy:)];
    [self runTest:@"ABCxyz" func:@selector(rotational:)];
    [self runTest:@"ABCxyz" func:@selector(scale:)];
    [self runTest:@"ABCxyz" func:@selector(skew:)];
    [self runTest:@"ABCxyz" func:@selector(transform:)];
    [self runTest:@"ABCxyz" func:@selector(affineInverse:)];
    [self runTest:@"ABCxyz" func:@selector(cascadeColor:)];
    [self runTest:@"ABCxyz" func:@selector(cascadeOpacity:)];
    [self runTest:@"ABCxyz" func:@selector(cascadeScale:)];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)basicHeirarchy:(id<MNTestParentDelegate>)parent
{
    // draw symbol with sub symbols
}

- (void)rotational:(id<MNTestParentDelegate>)parent
{
    // draw and rotate symbols
}

- (void)scale:(id<MNTestParentDelegate>)parent
{
    // draw and scale symbols
}

- (void)skew:(id<MNTestParentDelegate>)parent
{
    // draw and skew symbols
}

- (void)transform:(id<MNTestParentDelegate>)parent
{
    // draw and transform symbols
}

- (void)affineInverse:(id<MNTestParentDelegate>)parent
{
    // draw and invert symbols
}

- (void)cascadeColor:(id<MNTestParentDelegate>)parent
{
    // draw and cascade color change to sub symbols
}

- (void)cascadeOpacity:(id<MNTestParentDelegate>)parent
{
    // draw and cascade opacity change to sub symbols
}

- (void)cascadeScale:(id<MNTestParentDelegate>)parent
{
    // draw and cascade scale change to sub symbols
}

@end
