//
//  MNModifierContext.m
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

#import "MNModifierContext.h"
#import "MNUtils.h"
#import "MNModifier.h"
#import "MNNote.h"
#import "MNDot.h"
#import "MNAccidental.h"
#import "MNStroke.h"
#import "MNFretHandFinger.h"
#import "MNBend.h"
#import "MNVibrato.h"
#import "MNAnnotation.h"
#import "MNArticulation.h"
#import "MNUtils.h"
#import "MNStaffNote.h"
#import "MNGraceNoteGroup.h"
#import "MNStroke.h"
#import "MNStringNumber.h"
#import "MNArticulation.h"
#import "MNOrnament.h"
#import "MNEnum.h"
#import "MNUtils.h"
#import "MNKeyProperty.h"
#import "MNMetrics.h"
#import "MNOptions.h"
#import "NSString+Ruby.h"
#import "MNMath.h"
#import "OCTotallyLazy.h"

@implementation MNModifierState
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}
- (instancetype)init
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        _left_shift = 0;
        _right_shift = 0;
        _text_line = 0;
    }
    return self;
}
@end

@interface MNModifierContext ()
{
    BOOL _preFormatted;
    BOOL _postFormatted;
    float _spacing;
    MNModifierState* _state;
}
@property (assign, nonatomic) float width;
@property (assign, nonatomic, readonly, getter=formatted) BOOL formatted;
@property (strong, nonatomic) NSMutableDictionary* modifiersDict;
@property (strong, nonatomic, getter=PREFORMAT) NSArray* PREFORMAT;
@property (strong, nonatomic, getter=POSTFORMAT) NSArray* POSTFORMAT;
@end

@implementation MNModifierContext

#pragma mark - Initialization
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupModifierContext];
    }
    return self;
}

+ (MNModifierContext*)modifierContext
{
    return [[MNModifierContext alloc] init];
}

- (void)setupModifierContext
{
    // Formatting data.
    _preFormatted = NO;
    _postFormatted = NO;
    _width = 0;
    _spacing = 0;
    _state = [[MNModifierState alloc] init];
    _state.left_shift = 0;
    _state.right_shift = 0;
    _state.text_line = 0;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

// Add new modifiers to this array. The ordering is significant -- lower
// modifiers are formatted and rendered before higher ones.
// static NSArray *_PREFORMAT;
- (NSArray*)PREFORMAT
{
    if(!_PREFORMAT)
    {
        _PREFORMAT = @[
            [MNStaffNote class],
            [MNDot class],
            [MNFretHandFinger class],
            [MNAccidental class],
            [MNGraceNoteGroup class],
            [MNStroke class],
            [MNStringNumber class],
            [MNArticulation class],
            [MNOrnament class],
            [MNAnnotation class],
            [MNBend class],
            [MNVibrato class]
        ];
    }
    return _PREFORMAT;
}

// If post-formatting is required for an element, add it to this array.
// static NSArray *_POSTFORMAT;
- (NSArray*)POSTFORMAT
{
    if(!_POSTFORMAT)
    {
        _POSTFORMAT = @[
            [MNStaffNote class],
            //            [MNDot class],
            //            [MNFretHandFinger class],
            //            [MNAccidental class],
            //            [MNGraceNoteGroup class],
            //            [MNStroke class],
            //            [MNStringNumber class],
            //            [MNArticulation class],
            //            [MNOrnament class],
            //            [MNAnnotation class],
            //            [MNBend class],
            //            [MNVibrato class]
        ];
    }
    return _POSTFORMAT;
}

#pragma mark - Properties

- (NSMutableDictionary*)modifiersDict
{
    if(!_modifiersDict)
    {
        _modifiersDict = [NSMutableDictionary dictionary];
    }
    return _modifiersDict;
}

- (float)getExtraLeftPx
{
    return self.state.left_shift;
}

- (float)getExtraRightPx
{
    return self.state.right_shift;
}

- (float)width
{
    return _width;
}

- (float)extraLeftPx
{
    return self.state.left_shift;
}

- (float)extraRightPx
{
    return self.state.right_shift;
}

- (BOOL)formatted
{
    return self.preFormatted && self.postFormatted;
}

- (MNMetrics*)metrics
{
    if(!self.formatted)
    {
        MNLogError(@"UnformattedModifier, Unformatted modifier has no metrics.");
    }
    MNMetrics* ret = [MNMetrics metricsZero];
    /*
     width: self.state.left_shift + self.state.right_shift + self.spacing,
     spacing: self.spacing,
     extra_left_px: self.state.left_shift,
     extra_right_px: self.state.right_shift
     },*/
    ret.width = self.state.left_shift + self.state.right_shift + self.spacing;
    //    ret.padding.xLeftPadding = self.state.left_shift;
    //    ret.padding.xRightPadding = self.state.right_shift;
    return ret;
}

#pragma mark - Methods
- (void)addModifier:(MNModifier*)modifier
{
    /*
    addModifier: function(modifier) {
        var type = modifier.getCategory();
        if (!self.modifiers[type]) self.modifiers[type] = [];
        self.modifiers[type].push(modifier);
        modifier.setModifierContext(this);
        self.preFormatted = NO;
        return this;
    },
    */
    //    NSString* type = modifier.category;
    NSString* type = [modifier.class CATEGORY];
    if(![self.modifiersDict objectForKey:type])
    {
        [self.modifiersDict setObject:[NSMutableArray array] forKey:type];
    }
    [[self.modifiersDict objectForKey:type] addObject:modifier];
    [modifier setModifierContext:self];
    _preFormatted = NO;
}

- (NSMutableArray*)getModifiersForType:(NSString*)modifierType
{
    // getModifiers: function(type) { return self.modifiers[type]; },
    return [self.modifiersDict objectForKey:modifierType];
}

- (BOOL)preFormat
{
    /*
    preFormat: function() {
        if (self.preFormatted) return;
        self.PREFORMAT.forEach(function(modifier) {
            L("Preformatting ModifierContext: ", modifier.CATEGORY);
            modifier.format(self.getModifiers(modifier.CATEGORY), self.state, this);
        }, this);

        // Update width of this modifier context
        self.width = self.state.left_shift + self.state.right_shift;
        self.preFormatted = YES;
    },
    */
    if(self.preFormatted)
    {
        return YES;
    }
    __block BOOL success = YES;
    __weak __typeof__(self) weakSelf = self;
    [self.PREFORMAT oct_foreach:^(Class modifierClass, NSUInteger index, BOOL* stop) {
      NSString* category = [modifierClass CATEGORY];
      // NOTE: uncomment the folloing for more debug info
      //        MNLogDebug(@"%@", [NSString stringWithFormat:@"Preformatting ModifierContext: %@", category]);
      NSMutableArray* modifiers = [self getModifiersForType:category];
      //        [modifierClass performSelector:@selector(format:state:context:) withObject:modifiers
      //        withObject:self.state];

      SEL selector = @selector(format:state:context:);
      NSMethodSignature* signature = [modifierClass methodSignatureForSelector:selector];
      NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
      [invocation setSelector:selector];
      [invocation setTarget:modifierClass];
      [invocation setArgument:&modifiers atIndex:2];
      MNModifierState* state = weakSelf.state;
      [invocation setArgument:&state atIndex:3];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types-discards-qualifiers"
      __weak MNModifierContext** pointerToMC = &weakSelf;
#pragma clang diagnostic pop
      [invocation setArgument:pointerToMC atIndex:4];
      [invocation invoke];
      BOOL result;
      [invocation getReturnValue:&result];
      success &= result;
    }];

    // Update width of this modifier context
    self.width = self.state.left_shift + self.state.right_shift;
    _preFormatted = YES;

    return YES;
}

- (BOOL)postFormat
{
    /*
    postFormat: function() {
        if (self.postFormatted) return;
        self.POSTFORMAT.forEach(function(modifier) {
            L("Postformatting ModifierContext: ", modifier.CATEGORY);
            modifier.postFormat(self.getModifiers(modifier.CATEGORY), this);
        }, this);
    }
    */
    if(self.postFormatted)
    {
        return YES;
    }

    [self.POSTFORMAT oct_foreach:^(Class modifierClass, NSUInteger index, BOOL* stop) {
      NSString* category = [modifierClass CATEGORY];
      MNLogDebug(@"%@", [NSString stringWithFormat:@"Postformatting ModifierContext: %@", category]);
      NSArray* modifiers = [self getModifiersForType:category];
      [modifierClass performSelector:@selector(postFormat:) withObject:modifiers];
    }];

    //    _postformatted = YES;
    return YES;
}

@end
