//
//  MNStaffTieTests.m
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

#import "MNStaffTieTests.h"

@implementation MNStaffTieTests

- (void)start
{
    [super start];
    float w = 600, h = 150;
    [self runTest:@"Simple StaffTie" func:@selector(simple:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Chord StaffTie" func:@selector(chord:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Stem Up StaffTie" func:@selector(stemUp:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"No End Note" func:@selector(noEndNote:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"No Start Note" func:@selector(noStartNote:) frame:CGRectMake(10, 10, w, h)];
}

- (void)tearDown
{
    [super tearDown];
}

//- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(id<MNTestParentDelegate>)parent
//{
//    NSUInteger w = size.width;
////    NSUInteger h = size.height;
//
//    w = w != 0 ? w : 350;
////    h = h != 0 ? h : 150;
//
//    // [MNFont setFont:@" 10pt Arial"];
//
//    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
//    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
//}

+ (void)tieNotes:(NSArray*)notes
     withIndices:(NSArray*)indices
           staff:(MNStaff*)staff
         context:(CGContextRef)ctx
       dirtyRect:(CGRect)dirtyRect
{
    MNVoice* voice = [[MNVoice voiceWithTimeSignature:MNTime4_4] addTickables:notes];
    // MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:250];
    [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

    MNStaffTie* tie = [[MNStaffTie alloc] initWithNoteTie:[[MNNoteTie alloc] initWithDictionary:@{
                                              @"first_note" : notes[0],
                                              @"last_note" : notes[1],
                                              @"first_indices" : indices,
                                              @"last_indices" : indices,
                                          }]];
    [tie draw:ctx];
}

+ (void)drawTie:(NSArray*)notes
    withIndices:(NSArray*)indices
        options:(NSDictionary*)options
        context:(CGContextRef)ctx
      dirtyRect:(CGRect)dirtyRect
{
    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];
    [staff draw:ctx];
    [[self class] tieNotes:notes withIndices:indices staff:staff context:ctx dirtyRect:CGRectZero];
}

- (MNTestBlockStruct*)simple:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [[self class] drawTie:@[
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"h" }) addAccidental:newAcc(@"b")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],
          newNote(
              @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"h" }),
      ] withIndices:@[ @0, @1 ]
                    options:nil
                    context:ctx
                  dirtyRect:CGRectZero];
      ok(YES, @"Simple Test");
    };
    return ret;
}

- (MNTestBlockStruct*)chord:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [[self class] drawTie:@[
          newNote(
              @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"h" }),
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"f/4", @"a/4" ],
                 @"stem_direction" : @(-1),
                 @"duration" : @"h" }) addAccidental:newAcc(@"n")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],
      ] withIndices:@[ @0, @1, @2 ]
                    options:nil
                    context:ctx
                  dirtyRect:CGRectZero];
      ok(YES, @"Chord test");
    };
    return ret;
}

- (MNTestBlockStruct*)stemUp:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [[self class] drawTie:@[
          newNote(
              @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"h" }),
          [[newNote(
              @{ @"keys" : @[ @"c/4", @"f/4", @"a/4" ],
                 @"stem_direction" : @(1),
                 @"duration" : @"h" }) addAccidental:newAcc(@"n")
                                             atIndex:0] addAccidental:newAcc(@"#")
                                                              atIndex:1],
      ] withIndices:@[ @0, @1, @2 ]
                    options:nil
                    context:ctx
                  dirtyRect:CGRectZero];
      ok(YES, @"Stem up test");
    };
    return ret;
}

- (MNTestBlockStruct*)noEndNote:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)] addTrebleGlyph];

    NSArray* notes = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
        newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }),
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:250];

    MNStaffTie* tie = [[MNStaffTie alloc] initWithNoteTie:[[MNNoteTie alloc] initWithDictionary:@{
                                              @"first_note" : notes[1],
                                              @"last_note" : [NSNull null],
                                              @"first_indices" : @[ @2 ],
                                              @"last_indices" : @[ @2 ],
                                          }] andText:@"H"];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [tie draw:ctx];

      ok(YES, @"No end note");
    };
    return ret;
}

- (MNTestBlockStruct*)noStartNote:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* note_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:note_struct];
    };
    MNAccidental* (^newAcc)(NSString*) = ^MNAccidental*(NSString* type)
    {
        return [MNAccidental accidentalWithType:type];
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)] addTrebleGlyph];

    NSArray* notes = @[
        [[newNote(
            @{ @"keys" : @[ @"c/4", @"e/4", @"a/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }) addAccidental:newAcc(@"b")
                                           atIndex:0] addAccidental:newAcc(@"#")
                                                            atIndex:1],
        newNote(
            @{ @"keys" : @[ @"d/4", @"e/4", @"f/4" ],
               @"stem_direction" : @(-1),
               @"duration" : @"h" }),
    ];
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    [voice addTickables:notes];

    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatWith:@[ voice ] withJustifyWidth:250];

    MNStaffTie* tie = [[MNStaffTie alloc] initWithNoteTie:[[MNNoteTie alloc] initWithDictionary:@{
                                              @"first_note" : [NSNull null],
                                              @"last_note" : notes[0],
                                              @"first_indices" : @[ @2 ],
                                              @"last_indices" : @[ @2 ],
                                          }] andText:@"H"];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
      [tie draw:ctx];

      ok(YES, @"No end note");
    };
    return ret;
}
@end
