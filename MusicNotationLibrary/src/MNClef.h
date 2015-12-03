//
//  MNClef.h
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


#import "MNStaffModifier.h"

@class MNClefAnnotation;

/*! 
 *  The `MNClef` class performs
 */
@interface MNClef : MNStaffModifier
{
   @protected
    //    __weak  MNStaff *_staff;
}

#pragma mark - Properties

@property (assign, nonatomic) float line;
@property (strong, nonatomic) NSDictionary* clefCodes;
@property (assign, nonatomic) MNClefType type;
@property (assign, nonatomic) NSUInteger startingPitch;
@property (strong, nonatomic) NSString* size;
@property (strong, nonatomic, readonly) NSString* clefName;
@property (strong, nonatomic) MNClefAnnotation* annotation;

#pragma mark - Methods
- (instancetype)initWithType:(MNClefType)clefType;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNClef*)trebleClef;
+ (MNClef*)clefWithType:(MNClefType)type;

+ (MNClef*)clefWithName:(NSString*)clefName;
+ (MNClef*)clefWithName:(NSString*)clefName size:(NSString*)size;
+ (MNClef*)clefWithName:(NSString*)clefName size:(NSString*)size annotationName:(NSString*)annotationName;
+ (MNClef*)clefWithName:(NSString*)clefName size:(NSString*)size annotation:(MNClefAnnotation*)annotation;

- (void)setCodeAndName;

+ (NSString*)clefNameForType:(MNClefType)clefType;

- (void)addModifierToStaff:(MNStaff*)staff;
- (void)addEndModifierToStaff:(MNStaff*)staff;

@end

