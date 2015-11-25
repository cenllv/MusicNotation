//
//  MNClef.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
//  Benjamin W. Bohl
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

#import "MNClef.h"
#import <objc/runtime.h>
#import "MNUtils.h"
#import "MNTable.h"
#import "MNModifier.h"
#import "MNStaffModifier.h"
#import "MNMetrics.h"
#import "MNBoundingBox.h"
#import "MNPoint.h"
#import "MNStaff.h"
#import "MNMoveableClef.h"
#import "MNTable.h"
#import "MNGlyph.h"
#import "MNPadding.h"
#import "MNClefAnnotation.h"

@implementation MNClef
{
    NSString* _clefName;
}

static float kCLEF_SIZE_DEFAULT = 20;   // 40;
static float kCLEF_SIZE_SMALL = 16;     // 32;

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [self setupClef];
    }
    return self;
}

- (instancetype)initWithType:(MNClefType)clefType
{
    self = [self initWithDictionary:@{ @"type" : @(clefType) }];
    if(self)
    {
        _type = clefType;
        [self setupClef];
        [self setCodeAndName];
    }
    return self;
}

- (instancetype)initWithName:(NSString*)clefName
{
    self = [self initWithDictionary:@{ @"clefName" : clefName }];
    if(self)
    {
        _clefName = clefName;
        _type = [MNClef clefTypeForName:clefName];
        [self setupClef];
        [self setCodeAndName];
    }
    return self;
}

- (instancetype)initWithName:(NSString*)clefName size:(NSString*)size annotationName:(NSString*)annotationName
{
    self = [self initWithDictionary:@{ @"clefName" : clefName }];
    if(self)
    {
        _size = size;
        _type = [MNClef clefTypeForName:clefName];
        _clefName = clefName;
        [self setupClef];
        [self setCodeAndName];
        [self setupWithAnnotationName:annotationName];
    }
    return self;
}

- (instancetype)initWithName:(NSString*)clefName size:(NSString*)size annotation:(MNClefAnnotation*)annotation
{
    self = [self initWithDictionary:@{ @"clefName" : clefName }];
    if(self)
    {
        _size = size;
        _type = [MNClef clefTypeForName:clefName];
        _clefName = clefName;
        _name = clefName;
        [self setupClef];
        [self setCodeAndName];
        _annotation = annotation;
    }
    return self;
}

+ (MNClef*)trebleClef
{
    return [[MNClef alloc] initWithType:MNClefTreble];
}

+ (MNClef*)clefWithType:(MNClefType)type
{
    if(type == MNClefMovableC)
    {
        return [[MNMovableClef alloc] init];
    }
    else
    {
        return [[MNClef alloc] initWithType:type];
    }
}

+ (MNClef*)clefWithName:(NSString*)clefName
{
    return [[MNClef alloc] initWithName:clefName size:@"default" annotation:nil];
}

+ (MNClef*)clefWithName:(NSString*)clefName size:(NSString*)size
{
    return [[MNClef alloc] initWithName:clefName size:size annotation:nil];
}

+ (MNClef*)clefWithName:(NSString*)clefName size:(NSString*)size annotationName:(NSString*)annotationName
{
    return [[MNClef alloc] initWithName:clefName size:size annotationName:annotationName];
}

+ (MNClef*)clefWithName:(NSString*)clefName size:(NSString*)size annotation:(MNClefAnnotation*)annotation
{
    return [[MNClef alloc] initWithName:clefName size:size annotation:annotation];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return @"clef";
}

#pragma mark - Setup
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Setup
 * ---------------------------------------------------------------------------------------------------------------------
 */

- (void)setupClef
{
    if(!_size)
    {
        self.point.x = kCLEF_SIZE_DEFAULT;
    }
    else
    {
        if([_size isEqualToString:@"default"])
        {
            self.point.x = kCLEF_SIZE_DEFAULT;
        }
        else if([_size isEqualToString:@"small"])
        {
            self.point.x = kCLEF_SIZE_SMALL;
        }
        else
        {
            MNLogError(@"clef size missing error");
        }
    }
    //    self.metrics.padding.xLeftPadding = 55.0;
    //    self.metrics.padding.xRightPadding = 55.0;
    //    [[((Metrics*)self->_metrics)padding] padAllSidesBy:10];
    //    self.metrics.bounds = MNBoundingBox boundingBoxWithRect:<#(CGRect)#>
    //    self.metrics.width
    self.padding = 5;
}

- (void)setupWithAnnotationName:(NSString*)name
{
    if(name)
    {
        NSDictionary* anno_dict = MNClef.annotations[name][@"sizes"][self.size];
        NSString* code = MNClef.annotations[name][@"code"];
        float point = [anno_dict[@"point"] floatValue];
        float line = [anno_dict[@"attachments"][self.clefName][@"line"] floatValue];
        float xShift = [anno_dict[@"attachments"][self.clefName][@"x_shift"] floatValue];
        self.annotation = [MNClefAnnotation annotationWithCode:code point:point line:line xShift:xShift];
    }
}

#pragma mark - Tables
/*!---------------------------------------------------------------------------------------------------------------------
 * @name Tables
 * ---------------------------------------------------------------------------------------------------------------------
 */

static NSDictionary* _clefSizes;
// TODO: this might belong in  MNTAbles
+ (NSDictionary*)clefSizes
{
    if(!_clefSizes)
    {
        _clefSizes = @{
            @"default" : @(kCLEF_SIZE_DEFAULT),
            @"small" : @(kCLEF_SIZE_SMALL),
        };
    }
    return _clefSizes;
}

static NSDictionary* _annotations;
// TODO: this might belong in  MNTAbles
+ (NSDictionary*)annotations
{
    if(!_annotations)
    {
        _annotations = @{
            @"8va" : @{
                @"code" : @"v8",
                @"sizes" : @{
                    @"default" :
                        @{@"point" : @(20), @"attachments" : @{@"treble" : @{@"line" : @(-1.2), @"x_shift" : @(11)}}},
                    @"small" :
                        @{@"point" : @(18), @"attachments" : @{@"treble" : @{@"line" : @(-0.4), @"x_shift" : @(8)}}}
                }
            },
            @"8vb" : @{
                @"code" : @"v8",
                @"sizes" : @{
                    @"default" : @{
                        @"point" : @(20),
                        @"attachments" : @{
                            @"treble" : @{@"line" : @(6.3), @"x_shift" : @(10)},
                            @"bass" : @{@"line" : @(4), @"x_shift" : @(1)}
                        }
                    },
                    @"small" : @{
                        @"point" : @(18),
                        @"attachments" : @{
                            @"treble" : @{@"line" : @(5.8), @"x_shift" : @(6)},
                            @"bass" : @{@"line" : @(3.5), @"x_shift" : @(0.5)}
                        }
                    }
                }
            }
        };
    }
    return _annotations;
}

- (MNClefType)type
{
    if(self.name.length > 0)
    {
        return [[self class] clefTypeForName:self.name];
    }
    else if(_type == MNClefNone)
    {
        return MNClefNone;
    }
    else
    {
        return _type;
    }
}

// TODO: this might belong in  MNTAbles or might already be in  MNEnem
+ (MNClefType)clefTypeForName:(NSString*)name
{
    NSString* lookup = [name lowercaseString];
    typedef void (^CaseBlock)();
    __block MNClefType ret = 0;
    NSDictionary* d = @{
        @"treble" : ^{
          ret = MNClefTreble;
        },
        @"bass" : ^{
          ret = MNClefBass;
        },
        @"alto" : ^{
          ret = MNClefAlto;
        },
        @"tenor" : ^{
          ret = MNClefTenor;
        },
        @"percussion" : ^{
          ret = MNClefPercussion;
        },
        @"movablec" : ^{
          ret = MNClefMovableC;
        },
        @"soprano" : ^{
          ret = MNClefSoprano;
        },
        @"mezzo-soprano" : ^{
          ret = MNClefMezzoSoprano;
        },
        @"baritone-c" : ^{
          ret = MNClefBaritoneC;
        },
        @"baritone-f" : ^{
          ret = MNClefBaritoneF;
        },
        @"subbass" : ^{
          ret = MNClefSubBass;
        },
        @"french" : ^{
          ret = MNClefFrench;
        },
    };

    ((CaseBlock)d[lookup])();
    if(ret == 0)
    {
        MNLogError(@"BadArgument, unknown name passed as clef type: %@", name);
    }
    return ret;
}

+ (NSString*)clefNameForType:(MNClefType)clefType
{
    switch(clefType)
    {
        case MNClefTreble:
            return @"treble";
            break;
        case MNClefBass:
            return @"bass";
            break;
        case MNClefAlto:
            return @"alto";
            break;
        case MNClefTenor:
            return @"tenor";
            break;
        case MNClefPercussion:
            return @"percussion";
            break;
        case MNClefMovableC:
            return @"movablec";
            break;
        case MNClefMezzoSoprano:
            return @"mezzo-soprano";
            break;
        case MNClefBaritoneC:
            return @"baritone-c";
            break;
        case MNClefBaritoneF:
            return @"baritone-f";
            break;
        case MNClefSubBass:
            return @"subbass";
            break;
        case MNClefFrench:
            return @"french";
            break;
        case MNClefNone:
            return @"clefnone";
            break;
        default:
            MNLogError(@"UnknownClefTypeError");
            return @"";
            break;
    }
}

- (void)setCodeAndName
{
    if(!self->_metrics)
    {
        self->_metrics = [MNMetrics metricsZero];
    }
    MNMetrics* metrics = self->_metrics;
    switch(self.type)
    {
        case MNClefTreble:
            //            [metrics setName:@"Treble"];
            self.line = 3;   // [self setLine:2];
            self.code = @"v83";
            self.startingPitch = 46;
            break;
        case MNClefBass:
            //            [metrics setName:@"Bass"];
            self.line = 1;   // [self setLine:4];
            self.code = @"v79";
            self.startingPitch = 32;
            break;
        case MNClefAlto:
            //            [metrics setName:@"Alto"];
            self.line = 2;   // [self setLine:3];
            self.code = @"vad";
            break;
        case MNClefTenor:
            //            [metrics setName:@"Tenor"];
            self.line = 1;   // [self setLine:4];
            self.code = @"vad";
            break;
        case MNClefPercussion:
            //            [metrics setName:@"Percussion"];
            self.line = 2;   // [self setLine:3];
            self.code = @"v59";
            break;
        case MNClefMovableC:
            //            [metrics setName:@"MoveableC"];
            self.line = INT32_MAX;   // [self setLine:INT32_MAX];
            self.code = @"v12";
            break;
        case MNClefSoprano:
            //            [metrics setName:@"Soprano"];
            self.line = 4;   // [self setLine:4];
            self.code = @"vad";
            break;
        case MNClefMezzoSoprano:
            //            [metrics setName:@"MezzoSoprano"];
            self.line = 3;   // [self setLine:3];
            self.code = @"vad";
            break;
        case MNClefBaritoneC:
            //            [metrics setName:@"BaritoneC"];
            self.line = 0;   // [self setLine:0];
            self.code = @"vad";
            break;
        case MNClefBaritoneF:
            //            [metrics setName:@"BaritoneF"];
            self.line = 2;   // [self setLine:2];
            self.code = @"v79";
            break;
        case MNClefSubBass:
            //            [metrics setName:@"SubBass"];
            self.line = 0;   // [self setLine:0];
            self.code = @"v79";
            break;
        case MNClefFrench:
            //            [metrics setName:@"French"];
            self.line = 4;   // [self setLine:4];
            self.code = @"v83";
            break;
        default:
            MNLogError(@"bad choice of clef type");
            break;
    }
    metrics.code = self.code;
}

#pragma mark - Properties

- (void)setParent:(id)parent
{
    //    [super setParent:parent];
    _parent = parent;
    if([parent isKindOfClass:[MNStaff class]])
    {
        MNStaff* staff = (MNStaff*)parent;
        _staff = staff;
    }
}

- (void)setStaff:(MNStaff*)staff
{
    //    _parent = staff;
    _staff = staff;
}

- (float)line
{
    return _line;
}

#pragma mark - Methods

/*!
 *  Add this clef to the start of the given `staff`.
 *  @param staff the staff to add this modifier to
 */
- (void)addModifierToStaff:(MNStaff*)staff
{
    MNMetrics* metrics = self->_metrics;
    self.glyph = [MNGlyph glyphWithCode:metrics.code withPointSize:1];
    //    MNLogInfo(@"%@", self.glyph.description);
    [self placeGlyphOnLine:self.glyph forStaff:staff onLine:self.line];
    if(self.annotation)
    {
        MNGlyph* attachment = [[MNGlyph alloc] initWithCode:self.annotation.code withPointSize:self.annotation.point];
        attachment.metrics.xMax = 0;
        attachment.y_shift = 0;
        attachment.x_shift = self.annotation.xShift;
        [self placeGlyphOnLine:attachment forStaff:staff onLine:self.annotation.line];
        [staff addGlyph:attachment];
    }
    [staff addGlyph:self.glyph];
    //    [staff addGlyph:[staff makeSpacer:self.padding]];
}

/*!
 *  Add this clef to the end of the given `staff`.
 *  @param staff the staff to add this modifier to
 */
- (void)addEndModifierToStaff:(MNStaff*)staff
{
    MNMetrics* metrics = self->_metrics;
    self.glyph = [MNGlyph glyphWithCode:metrics.code withPointSize:1];
    [self placeGlyphOnLine:self.glyph forStaff:staff onLine:self.line];
    if(self.annotation)
    {
        MNGlyph* attachment = [[MNGlyph alloc] initWithCode:self.annotation.code withPointSize:self.annotation.point];
        attachment.metrics.xMax = 0;
        attachment.y_shift = 0;
        attachment.x_shift = self.annotation.xShift;
        [self placeGlyphOnLine:attachment forStaff:staff onLine:self.annotation.line];
        [staff addEndGlyph:attachment];
    }
    [staff addEndGlyph:self.glyph];
}

- (BOOL)preFormat
{
    [super preFormat];

    ((MNMetrics*)self->_metrics).point.x = self.staff.boundingBox.xPosition + ((MNMetrics*)self->_metrics).point.x;
    //        self.metrics.point.y = [self.staff getYForLine:self.metrics.line];
    return YES;
}

@end
