//
//  MNKeySignature.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Cyril Silverman
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

#import "MNKeySignature.h"
#import "MNStaff.h"
#import "MNGlyph.h"
#import "MNClef.h"
#import "MNAccidental.h"
#import "MNPadding.h"
#import "MNTable.h"
#import "MNPoint.h"
#import "MNTableAccListStruct.h"

@interface AccidentalCodesStruct : IAModelBase
@property (strong, nonatomic) NSString* code;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float gracenoteWidth;
@property (assign, nonatomic) float shift_right;
@property (assign, nonatomic) float shiftDown;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end

@implementation AccidentalCodesStruct
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}
- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{
        @"gracenote_width" : @"gracenoteWidth",
        @"shift_right" : @"shiftRight",
        @"shift_down" : @"shiftDown",
    }];
    return propertiesEntriesMapping;
}
@end

// accidentalSpacing
@interface AccidentalSpacingStruct : IAModelBase
@property (assign, nonatomic) NSUInteger above;
@property (assign, nonatomic) NSUInteger below;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end

@implementation AccidentalSpacingStruct
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}
@end

@implementation MNKeySignature

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:nil];
    if(self)
    {
        //        [self->_metrics setCode:self.code];
    }
    return self;
}

/*!
 *  initializes with the specified key, one of:
 * 'C', 'CN', 'C#', 'C##', 'CB', 'CBB', 'D', 'DN', 'D#', 'D##', 'DB', 'DBB', 'E', 'EN', 'E#', 'E##', 'EB',
 * 'EBB', 'F', 'FN', 'F#', 'F##', 'FB', 'FBB', 'G', 'GN', 'G#', 'G##', 'GB', 'GBB', 'A', 'AN', 'A#', 'A##', 'AB', 'ABB',
 * 'B', 'BN', 'B#', 'B##', 'BB', 'BBB', 'R', 'X'
 *  @param keySpecifier the key specifier
 *  @return a key signature object
 */
- (instancetype)initWithKeySpecifier:(NSArray*)keySpecifier
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        //        self.accList = keySpecifier;
        //        [self->_metrics setCode:self.code];
    }
    return self;
}

- (instancetype)initWithAcc:(NSString*)acc andNumber:(NSUInteger)num
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.acc = acc;
        self.num = num;
        //        self.accList = [[MNTables accidentalListForAcc:acc] mutableCopy];
        self.accList = [MNTable keySignatureForSpec:acc];
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //    [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*!
 *  gets a key signature for the specified key
 *  @param key the key
 *  @return a key signature object
 */
+ (MNKeySignature*)keySignatureWithKey:(NSString*)key
{
    MNKeySignature* ret = [[MNKeySignature alloc] initWithDictionary:@{}];

    ret.key = key;
     MNTableKeySpecStruct* keySpec =
        [[MNTableKeySpecStruct alloc] initWithDictionary:MNTable.keySpecsDictionary[key]];
    if(!keySpec)
    {
        MNLogError(@"NoValidKeySignatureForKey, specify a valid key signature.");
    }
    ret.acc = [keySpec.acc isNotEqualTo:[NSNull null]] ? keySpec.acc : nil;
    ret.num = keySpec.num;
    ret.accList = [MNTable keySignatureForSpec:key];
    return ret;
}

#pragma mark - Properties

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return NSStringFromClass([self class]); //return @"keysignature";
}
- (NSString*)CATEGORY
{
    return NSStringFromClass([self class]);
}

static NSDictionary* _accidentalSpacing;
+ (NSDictionary*)accidentalSpacing
{
    // TODO: does this belong in  MNTables?
    if(!_accidentalSpacing)
    {
        _accidentalSpacing = @{
            @"#" : @{@"above" : @(6), @"below" : @(4)},
            @"b" : @{@"above" : @(4), @"below" : @(7)},
            @"n" : @{@"above" : @(3), @"below" : @(-1)}
        };
    }
    return _accidentalSpacing;
}

#pragma mark - Methods

/*!
 *  Add an accidental glyph to the `MNStaff`. `acc` is the data of the
 *  accidental to add. If the `next` accidental is also provided, extra
 *  width will be added to the initial accidental for optimal spacing.
 *  @param staff   staff
 *  @param acc     accidental to add
 *  @param nextAcc the optional next accidenal to add
 */
- (void)addAccToStaff:(MNStaff*)staff acc:(MNTableAccListStruct*)acc nextAcc:(MNTableAccListStruct*)nextAcc
{
    AccidentalCodesStruct* glyph_data =
        [[AccidentalCodesStruct alloc] initWithDictionary:MNTable.accidentalCodes[acc.type]];
    MNGlyph* glyph = [[MNGlyph alloc] initWithCode:glyph_data.code withScale:1];

    // Determine spacing between current accidental and the next accidental
    float extra_width = 0;
    if([acc.type isEqualToString:@"n"] && nextAcc)
    {
        BOOL above = nextAcc.line >= acc.line;
        AccidentalSpacingStruct* space =
            [[AccidentalSpacingStruct alloc] initWithDictionary:[self class].accidentalSpacing[nextAcc.type]];
        extra_width = above ? space.above : space.below;
    }
    glyph.width = glyph_data.width + extra_width;
    [self placeGlyphOnLine:glyph forStaff:staff onLine:acc.line];

    //    glyph.metrics.width += 10;

    [staff addGlyph:glyph];
}

/*!
 *  Cancel out a key signature provided in the `spec` parameter. This will
 *  place appropriate natural accidentals before the key signature.
 *  @param spec the key specifier
 *  @return this object
 */
- (id)cancelKey:(NSString*)spec
{
    // Get the accidental list for the cancelled key signature
    NSArray* cancel_accList = [MNTable keySignatureForSpec:spec];

    // If the cancelled key has a different accidental type, ie: # vs b
    BOOL different_types =
        (self.accList.count > 0 && [((MNTableAccListStruct*)cancel_accList[0])
                                           .type isNotEqualToString:((MNTableAccListStruct*)self.accList[0]).type]);

    // Determine how many naturals needed to add
    NSUInteger naturals = 0;
    if(different_types)
    {
        naturals = cancel_accList.count;
    }
    else
    {
        naturals = cancel_accList.count - self.accList.count;
    }

    // Return if no naturals needed
    if(naturals < 1)
    {
        return self;
    }

    // Get the line position for each natural
    NSMutableArray* cancelled = [NSMutableArray array];
    for(NSUInteger i = 0; i < naturals; ++i)
    {
        NSUInteger index = i;
        if(!different_types)
        {
            index = cancel_accList.count - naturals + i;
        }

        MNAccidental* acc = cancel_accList[index];
        [cancelled push:[[MNTableAccListStruct alloc] initWithDictionary:@{ @"type" : @"n", @"line" : @(acc.line) }]];
    }

    // Combine naturals with main accidental list for the key signature
    NSMutableSet* set = [NSMutableSet setWithArray:self.accList];
    [set addObjectsFromArray:cancel_accList];
    self.accList = [NSMutableArray arrayWithArray:set.allObjects];

    return self;
}

/*!
 *  Add the key signature to the `MNStaff`. You probably want to use the
 *  helper method `.addToStave()` instead
 *  @param staff the staff to add the modifier to
 */
- (void)addModifierToStaff:(MNStaff*)staff
{
    [self convertAccLinesWithClef:staff.clef andType:((MNTableAccListStruct*)self.accList[0]).type];
    //    NSMutableArray *tmpAccList = [NSMutableArray arrayWithArray:self.accList];
    //    [tmpAccList addObject:[NSNull null]];

    for(NSUInteger i = 0; i < self.accList.count - 1; ++i)
    {
        [self addAccToStaff:staff acc:self.accList[i] nextAcc:self.accList[i + 1]];
    }
    if(self.accList.count > 0)
    {
        [self addAccToStaff:staff acc:self.accList.lastObject nextAcc:nil];
    }
}

/*!
 *  Add the key signature to the `MNStaff`, if it's the not the `firstGlyph`
 *  a spacer will be added as well.
 *  @param staff      the staff
 *  @param firstGlyph if this is the first glyph
 *  @return this object
 */
- (id)addToStaff:(MNStaff*)staff firstGlyph:(BOOL)firstGlyph
{
    if(self.accList.count == 0)
    {
        return self;
    }

    if(!firstGlyph)
    {
        [staff addGlyph:[staff makeSpacer:self.padding]];
    }

    [self addModifierToStaff:staff];

    return self;
}

/*!
 *  Apply the accidental staff line placement based on the `clef` and
 *  the  accidental `type` for the key signature ('# or 'b').
 *  @param clef the clef of the staff
 *  @param type the type of the accidental for the clef
 */
- (void)convertAccLinesWithClef:(MNClef*)clef andType:(NSString*)type
{
    float offset = 0.0;
    NSMutableArray* tenorSharps;
    BOOL isTenorSharps = ((clef.type == MNClefTenor) && [type isEqualToString:@"#"]) ? YES : NO;

    switch(clef.type)
    {
        case MNClefBass:
            offset = 1;
            break;
        case MNClefAlto:
            offset = 0.5;
            break;
        case MNClefTenor:
            if(!isTenorSharps)
            {
                offset = -0.5;
            }
            break;
        default:
            break;
    }

    // special case for tenorsharps
    if(isTenorSharps)
    {
        tenorSharps = [NSMutableArray arrayWithArray:@[ @3, @1, @2.5, @0.5, @2, @0, @1.5 ]];
        for(NSUInteger i = 0; i < self.accList.count; ++i)
        {
            //            ((MNAccidental*)self.accList[i]).line = [tenorSharps[i] integerValue];
            MNTableAccListStruct* acc = self.accList[i];
            acc.line = [tenorSharps[i] integerValue];
        }
    }
    else
    {
        if(clef.type != MNClefTreble)
        {
            for(NSUInteger i = 0; i < self.accList.count; ++i)
            {
                MNTableAccListStruct* acc = self.accList[i];
                acc.line += offset;
            }
        }
    }
}

#pragma mark - Deprecated
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Deprecated
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (void)populateFlats:(float*)staffLine_p __attribute__((deprecated))
{
    /*
    *staffLine_p = fmodf(*staffLine_p, 3.5);
    *staffLine_p += 1.5;
     */
}

- (void)convertAccLinesWithClefOld:(MNClef*)clef andCode:(NSString*)code __attribute__((deprecated))
{
    /*
    float staffLine = 0.0;
    NSArray *sharpExceptions = @[@(1), @(4), @(4.5),];
    switch (self.keyAccType) {
        case  MNKeySignatureFlat:

            //Find starting position for first Flat
            if (self.staff.clefType ==  MNClefTreble) {
                staffLine = 1.5;
            }
            else if (self.staff.clefType ==  MNClefBass) {
                staffLine = 0.5;
            }
            else if (self.staff.clefType ==  MNClefMovableC) {
                staffLine = (self.staff.clef.line) + 3 - 1.5;
            }

            //populate flats
            for (NSUInteger i = 0; i < self.num; ++i) {
                if (i ==0) {
                    staffLine = fmodf(staffLine, 3.5);
                    staffLine += 1.5;
                }
                if (i%2 ==0 && i >0) {
                    staffLine -= 2.0;
                }
                else if (i%2 !=0) {
                    staffLine += 1.5;
                }
                 MNStaffModifier *modifier = [[MNStaffModifier alloc]initWithCode:self.metrics.code atPoint:[MNPoint
    pointZero]];
                modifier.metrics.padding = self.metrics.padding;
                modifier.metrics.point.y = [self.staff getYForLine:staffLine];//[MNTables lineForLine:staffLine]];
                [self.subModifiers addObject:modifier];
                //[self.staff addModifier:modifier];
            }
            break;


            //    [self.subModifiers addObject:modifier];


        case  MNKeySignatureSharp:
            //Find starting position for first Sharp
            if (self.staff.clefType ==  MNClefTreble) {
                staffLine = 3.0;
            }
            else if (self.staff.clefType ==  MNClefBass) {
                staffLine = 2.0;
            }
            else if (self.staff.clefType ==  MNClefMovableC) {
                staffLine = self.staff.clef.line - 0.5;
            }
            else if (self.staff.clefType ==  MNClefAlto) {
                staffLine = 2.5;
            }
            //populate Sharps (exception cloud)

            if ((self.staff.clefType ==  MNClefTenor) || ((self.staff.clefType ==  MNClefMovableC) && ([sharpExceptions
    containsObject:@(self.staff.clef.line)]))) {
                for (NSUInteger i = 0; i < self.num; ++i) {
                    if (i ==0) {
                        staffLine = fmodf(staffLine, 3.5);
                        staffLine += 2.0;
                    }
                    if (i%2 ==0 && i >0) {
                        staffLine -= 1.5;
                    }
                    else if (i%2 !=0) {
                        staffLine += 2.0;
                    }
                     MNStaffModifier *modifier = [[MNStaffModifier alloc]initWithCode:self.metrics.code atPoint:[MNPoint
    pointZero]];
                    modifier.metrics.padding = self.spacerPadding; //self.metrics.padding;
                    modifier.metrics.point.y = [self.staff getYForLine:staffLine];//[MNTables lineForLine:staffLine]];
                    [self.subModifiers addObject:modifier];
                    //[self.staff addModifier:modifier];
                }
            }
            //populate Sharps (standard cloud)
            else {
                for (NSUInteger i = 0; i < self.num; ++i) {
                    if (i == 0) {
                        staffLine = fmodf(staffLine, 3.5);
                        staffLine += 2.0;
                    }
                    if ((i%2 !=0) && (i<5)) {
                        staffLine -=1.5;
                    }
                    if ((i == 4) || (i==6)) {
                        staffLine -=1.5;
                    }
                    else if ((i%2 ==0 && i >0) || ((i%2 !=0) && (i>4))) {
                        staffLine += 2.0;
                    }
                     MNStaffModifier *modifier = [[MNStaffModifier alloc]initWithCode:self.metrics.code atPoint:[MNPoint
    pointZero]];
                    modifier.metrics.padding = self.metrics.padding;
                    modifier.metrics.point.y = [self.staff getYForLine:staffLine];//[MNTables lineForLine:staffLine]];
                    [self.subModifiers addObject:modifier];
                    //[self.staff addModifier:modifier];
                }
            }
            break;
        case  MNKeySignatureNone:
            // oops
            break;
        default:
            // oops
            break;
    }
    //    [self.staff addModifier:modifier];
     */
}

@end
