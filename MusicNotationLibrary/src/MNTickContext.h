//
//  MNTickContext.h
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



#import "MNContextDelegate.h"
#import "MNDelegates.h"
#import "IAModelBase.h"
#import "MNExtraPoints.h"

@class MNRational, MNTickable, MNPoint, MNPadding, MNStaff, MNModifier;

/*! The `MNTickContext` class  is a A formatter for abstract
 tickable objects, such as notes, chords,
 tabs, etc.
 */
@interface MNTickContext : IAModelBase
{   //<MNContextDelegate>
   @protected
    BOOL _preFormatted;
    BOOL _postFormatted;
    float _width;
    float _x;
    float _pointsUsed;

    //    TickableMetrics* _metrics;
    id<TickableMetrics> _metrics;
    BOOL _shouldIgnoreTicks;
}

#pragma mark - Properties

@property (strong, nonatomic) MNPoint* position;

@property (assign, nonatomic) float x;

/*! Notes, tabs, chords, lyrics.
 */
@property (strong, nonatomic) NSMutableArray* tickables;

@property (strong, nonatomic) NSArray* tContexts;   // Parent array of tick contexts

@property (strong, nonatomic) MNRational* tick;
@property (strong, nonatomic) MNRational* ticks;

@property (strong, nonatomic) MNRational* currentTick;

@property (strong, nonatomic) MNRational* maxTicks;

@property (strong, nonatomic) MNRational* minTicks;

//@property (strong, nonatomic) Metrics *metrics;

/*! width of this overall
 */
@property (assign, nonatomic) float width;

//@property (assign, nonatomic) BOOL shouldIgnoreTicks;
@property (weak, nonatomic) id parent;
@property (weak, nonatomic) MNStaff* staff;

@property (strong, nonatomic, readonly) id<TickableMetrics> metrics;

@property (strong, nonatomic) MNPadding* padding;

/*! width of widest note in this context
 */
@property (assign, nonatomic) float notePoints;

@property (assign, nonatomic) CGContextRef graphicsContext;

@property (assign, nonatomic) float notePx;         // width of widest note in self context
@property (assign, nonatomic) float extraLeftPx;    // Extra left pixels for modifers & displace notes
@property (assign, nonatomic) float extraRightPx;   // Extra right pixels for modifers & displace notes
@property (assign, nonatomic) BOOL align_center;

@property (assign, nonatomic, readonly) BOOL preFormatted;
@property (assign, nonatomic, readonly) BOOL postFormatted;
@property (assign, nonatomic) BOOL shouldIgnoreTicks;
@property (assign, nonatomic) float pointsUsed;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)init;

- (BOOL)shouldIgnoreTicks;
- (float)x;
- (void)setX:(float)x;
- (float)getPointsUsed;
- (void)setPointsUsed:(float)pixelsUsed;
- (void)setPadding:(MNPadding*)padding;
- (MNRational*)getMaxTicks;
- (MNRational*)getMinTicks;
- (NSArray*)getTickables;
- (MNExtraPoints*)getExtraPx;
- (NSArray*)getCenterAlignedTickables;

//- (void)addTickable:(MNTickable *)tickable;
- (id)addTickable:(id<MNTickableDelegate>)tickable;
- (BOOL)preFormat;
- (BOOL)postFormat;
+ (MNTickContext*)getNextContext:(MNTickContext*)tContext;

@end
