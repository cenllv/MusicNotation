//
//  MNModifierContext.h
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


#import "MNEnum.h"
#import "MNModifier.h"
#import "MNMetrics.h"
#import "IAModelBase.h"
#import "MNDelegates.h"

@interface MNModifierState : IAModelBase
@property (assign, nonatomic) float left_shift;
@property (assign, nonatomic) float right_shift;
@property (assign, nonatomic) float text_line;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end

/*! The `MNModifierContext` class implements various types of modifiers to notes (e.g. bends,
 fingering positions etc.)

 */
@interface MNModifierContext : IAModelBase

#pragma mark - Properties

//@property (strong, nonatomic, readonly) Metrics *metrics;
@property (assign, nonatomic, readonly) float width;
@property (assign, nonatomic, readonly) BOOL preFormatted;
@property (assign, nonatomic, readonly) BOOL postFormatted;
@property (assign, nonatomic, readonly) float spacing;
@property (strong, nonatomic, readonly) MNModifierState* state;
//@property (assign, nonatomic) CGContextRef graphicsContext;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNModifierContext*)modifierContext;
- (NSString*)description;
- (void)addModifier:(MNModifier*)modifier;
//- (NSArray *)getModifiersForType:(NSString *)modifierType;

- (NSMutableArray*)getModifiersForType:(NSString*)modifierType;

- (float)getExtraLeftPx;
- (float)getExtraRightPx;

- (BOOL)preFormat;
- (BOOL)postFormat;

@end