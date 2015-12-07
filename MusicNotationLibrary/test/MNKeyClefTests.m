//
//  MNKeyClefTests.m
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

#import "MNKeyClefTests.h"

@implementation MNKeyClefTests

- (void)start
{
    [super start];
    float w = 550, h = 370;
    //    [self runTest:@"Key Parser Test"  func:@selector(parser)];
    [self runTest:@"Major Key Clef Test" func:@selector(majorKeys:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Minor Key Clef Test" func:@selector(minorKeys:) frame:CGRectMake(10, 10, w, h)];
    [self runTest:@"Staff Helper" func:@selector(staffHelper:) frame:CGRectMake(10, 10, w, h)];
}

- (void)tearDown
{
    [super tearDown];
}

static NSDictionary* _ClefKeySignature;

static NSArray* _MAJOR_KEYS;
+ (NSArray*)MAJOR_KEYS
{
    if(!_MAJOR_KEYS)
    {
        _MAJOR_KEYS =
            @[ @"C", @"F", @"Bb", @"Eb", @"Ab", @"Db", @"Gb", @"Cb", @"G", @"D", @"A", @"E", @"B", @"F#", @"C#" ];
    }
    return _MAJOR_KEYS;
}

static NSArray* _MINOR_KEYS;
+ (NSArray*)MINOR_KEYS
{
    if(!_MINOR_KEYS)
    {
        _MINOR_KEYS = @[
            @"Am",
            @"Dm",
            @"Gm",
            @"Cm",
            @"Fm",
            @"Bbm",
            @"Ebm",
            @"Abm",
            @"Em",
            @"Bm",
            @"F#m",
            @"C#m",
            @"G#m",
            @"D#m",
            @"A#m"
        ];
    }
    return _MINOR_KEYS;
}


- (void)catchError:(NSString*)spec
{
    /*
    Vex.Flow.Test.ClefKeySignature.catchError = function(spec) {
        try {
             [MNKeySignature keySignatureWithKey:spec);
        } catch (e) {
            equal(e.code, "BadKeySignature", e.message);
        }
    }
     */
    [MNLog logNotYetImplementedForClass:[self class] andSelector:_cmd];
    abort();
}

- (void)parser
{
    expect(@"11");
    [[self class] catchError:@"asdf"];
    [[self class] catchError:@"D!"];
    [[self class] catchError:@"E#"];
    [[self class] catchError:@"D#"];
    [[self class] catchError:@"#"];
    [[self class] catchError:@"b"];
    [[self class] catchError:@"Kb"];
    [[self class] catchError:@"Fb"];
    [[self class] catchError:@"Ab"];
    [[self class] catchError:@"Dbm"];
    [[self class] catchError:@"B#m"];

    [MNKeySignature keySignatureWithKey:@"B"];
    [MNKeySignature keySignatureWithKey:@"C"];
    [MNKeySignature keySignatureWithKey:@"Fm"];
    [MNKeySignature keySignatureWithKey:@"Ab"];
    [MNKeySignature keySignatureWithKey:@"Abm"];
    [MNKeySignature keySignatureWithKey:@"F#"];
    [MNKeySignature keySignatureWithKey:@"G#m"];

    ok(YES, @"all pass");
}

- (MNTestBlockStruct*)majorKeys:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 370, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(10, 90, 370, 0)];
      MNStaff* staff3 = [MNStaff staffWithRect:CGRectMake(10, 170, 370, 0)];
      MNStaff* staff4 = [MNStaff staffWithRect:CGRectMake(10, 260, 370, 0)];
      [staff addClefWithName:@"treble"];
      [staff2 addClefWithName:@"bass"];
      [staff3 addClefWithName:@"alto"];
      [staff4 addClefWithName:@"tenor"];
      NSArray* keys = [self class].MAJOR_KEYS;

      for(NSUInteger n = 0; n < 8; ++n)
      {
          MNKeySignature* keySig = [MNKeySignature keySignatureWithKey:keys[n]];
          MNKeySignature* keySig2 = [MNKeySignature keySignatureWithKey:keys[n]];
          [keySig addToStaff:staff];
          [keySig2 addToStaff:staff2];
      }

      for(NSUInteger i = 8; i < keys.count; ++i)
      {
          MNKeySignature* keySig3 = [MNKeySignature keySignatureWithKey:keys[i]];
          MNKeySignature* keySig4 = [MNKeySignature keySignatureWithKey:keys[i]];
          [keySig3 addToStaff:staff3];
          [keySig4 addToStaff:staff4];
      }

      [staff draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];
      [staff4 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)minorKeys:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {

      MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 370, 0)];
      MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(10, 90, 370, 0)];
      MNStaff* staff3 = [MNStaff staffWithRect:CGRectMake(10, 170, 370, 0)];
      MNStaff* staff4 = [MNStaff staffWithRect:CGRectMake(10, 260, 370, 0)];
      [staff addClefWithName:@"treble"];
      [staff2 addClefWithName:@"bass"];
      [staff3 addClefWithName:@"alto"];
      [staff4 addClefWithName:@"tenor"];
      NSArray* keys = [self class].MINOR_KEYS;

      for(NSUInteger n = 0; n < 8; ++n)
      {
          MNKeySignature* keySig3 = [MNKeySignature keySignatureWithKey:keys[n]];
          MNKeySignature* keySig4 = [MNKeySignature keySignatureWithKey:keys[n]];
          [keySig3 addToStaff:staff3];
          [keySig4 addToStaff:staff4];
      }

      for(NSUInteger i = 8; i < keys.count; ++i)
      {
          MNKeySignature* keySig = [MNKeySignature keySignatureWithKey:keys[i]];
          MNKeySignature* keySig2 = [MNKeySignature keySignatureWithKey:keys[i]];
          [keySig addToStaff:staff];
          [keySig2 addToStaff:staff2];
      }

      [staff draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];
      [staff4 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestBlockStruct*)staffHelper:(id<MNTestParentDelegate>)parent
{
    MNTestBlockStruct* ret = [MNTestBlockStruct testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 370, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(10, 90, 370, 0)];
    MNStaff* staff3 = [MNStaff staffWithRect:CGRectMake(10, 170, 370, 0)];
    MNStaff* staff4 = [MNStaff staffWithRect:CGRectMake(10, 260, 370, 0)];
    NSArray* keys = [self class].MAJOR_KEYS;

    [staff addClefWithName:@"treble"];
    [staff2 addClefWithName:@"bass"];
    [staff3 addClefWithName:@"alto"];
    [staff4 addClefWithName:@"tenor"];

    for(NSUInteger n = 0; n < 8; ++n)
    {
        [staff addKeySignature:keys[n]];
        [staff2 addKeySignature:keys[n]];
    }

    for(NSUInteger i = 8; i < keys.count; ++i)
    {
        [staff3 addKeySignature:keys[i]];
        [staff4 addKeySignature:keys[i]];
    }
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [staff2 draw:ctx];
      [staff3 draw:ctx];
      [staff4 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

@end
