//
//  MNGlyphList.h
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

#import "IAModelBase.h"
#import "MNEnum.h"

@class MNFloatSize, MNPoint;

/*!
 *  The `MNGlyphList` class loads and stores the outline coordinates to draw symbols.
 */
@interface MNGlyphList : IAModelBase

#pragma mark - Properties
//@property(readonly, copy) NSArray *allObjects;
@property (assign, nonatomic, readonly) NSUInteger numberOfAvailableGlpyhStucts;
@property (strong, nonatomic, readonly) NSArray* availableGlyphStructsArray;
@property (strong, nonatomic, readonly) NSDictionary* availableGlyphStructsDictionary;

#pragma mark - Methods//- (id)nextObject;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

+ (instancetype)sharedInstance;

//- (NSUInteger)numberOfAvailableGlpyhs;
//- (NSArray *)availableGlyphsArray;
//- (NSDictionary *)availableGlyphsDictionary;

- (NSArray*)getOutlineForName:(NSString*)name;
- (NSUInteger)indexForName:(NSString*)name;
- (MNFloatSize*)sizeForName:(NSString*)name;
//- (MNPoint*)anchorPointForGlyphNameType:(MNGlyphNameType)type;

@end

@interface MNGlyphStruct : IAModelBase
@property (strong, nonatomic) NSString* stringOutline;
@property (strong, nonatomic) NSArray* arrayOutline;
//@property (strong, nonatomic) NSString *key;
//@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) MNPoint* anchorPoint;
@property (strong, nonatomic) MNFloatSize* size;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end