//
//  MNMovableClef.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
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

#import "MNMoveableClef.h"
#import "MNStaff.h"
#import "MNMetrics.h"
#import "MNPoint.h"

@implementation MNMovableClef

#pragma mark - Initialization

- (instancetype)init
{
    self = [super initWithType:MNClefMovableC];
    if(self)
    {
        self.type = MNClefMovableC;
        [((MNMetrics*)self->_metrics)setName:@"MoveableC"];
        [self setCodeAndName];
        [self setupMovableCClef];
    }
    return self;
}

- (void)setupMovableCClef
{
    [((MNMetrics*)self->_metrics)setLine:INT32_MAX];
    [((MNMetrics*)self->_metrics)setCode:@"v12"];
    self.startingPitch = 39;
    [((MNMetrics*)self->_metrics)setPoint:[MNPoint pointZero]];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

#pragma mark - Properties

- (void)setLine:(float)line
{
    [((MNMetrics*)self->_metrics)setLine:line];
    //    self.metrics.st
}

- (float)line
{
    return [((MNMetrics*)self->_metrics)line];
}

#pragma mark - Methods
- (BOOL)preFormat
{
    return [super preFormat];
}

#pragma mark - Rendering
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Rendering
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (void)draw:(CGContextRef)ctx
{
    // additional drawing code here...
    if([((MNMetrics*)self->_metrics)line] == INT32_MAX)
    {
        MNLogError(@"MNClefMovableCException, remember to set the line number.");
    }

    [super draw:ctx];
}

//- (void) renderToStaff:(CGContextRef)ctx {
//    // additional drawing code here...
//    if (self.metrics.line == INT32_MAX) {
//         [MNLog LogError:@"MNClefMovableCException, remember to set the line number."];
//    }
//
//    [super renderToStaff:context];
//
//}

@end
