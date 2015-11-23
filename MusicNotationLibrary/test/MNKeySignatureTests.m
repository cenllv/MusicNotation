//
//  MNKeySignatureTests.m
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

#import "MNKeySignatureTests.h"

@implementation MNKeySignatureTests

// TODO: the following are identical to KeyClefTests.m
// perhaps move both to MNTable.m

static NSMutableDictionary* _KeySignature;

+ (NSDictionary*)KeySignature
{
    if(!_KeySignature)
    {
        _KeySignature = [NSMutableDictionary dictionary];
    }
    return _KeySignature;
}

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

- (void)start
{
    [super start];
    //    [self runTest:@"Key Parser Test" func:@selector(parser)];
    [self runTest:@"Major Key Test" func:@selector(majorKeys:withTitle:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Minor Key Test" func:@selector(minorKeys:withTitle:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Staff Helper" func:@selector(staffHelper:withTitle:) frame:CGRectMake(10, 10, 700, 250)];
    [self runTest:@"Cancelled key test"
             func:@selector(majorKeysCanceled:withTitle:)
            frame:CGRectMake(10, 10, 830, 350)];
}

- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size withParent:(MNTestCollectionItemView*)parent
{
    /*
     Vex.Flow.Test.ThreeVoices.setupContext = function(options, x, y) {
     Vex.Flow.Test.resizeCanvas(options.canvas_sel, x || 350, y || 150);
     var ctx = Vex.getCanvasContext(options.canvas_sel);
     ctx.scale(0.9, 0.9); ctx.fillStyle = "#221"; ctx.strokeStyle = "#221";
     ctx.font = " 10pt Arial";
      MNStaff *staff =  [MNStaff staffWithRect:CGRectMake(10, 30, x || 350, 0) addTrebleGlyph].
     setContext(ctx).draw();

     return {context: ctx, staff: staff};
     }
     */
    NSUInteger w = size.width;
    NSUInteger h = size.height;

    w = w != 0 ? w : 350;
    h = h != 0 ? h : 150;

    [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (void)catchError:(NSString*)spec
{
    /*
    Vex.Flow.Test.KeySignature.catchError = function(spec) {
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

- (MNTestTuple*)majorKeys:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(10, 90, 350, 0)];

    NSArray* keys = [self class].MAJOR_KEYS;

    MNKeySignature* keySig = nil;
    for(NSUInteger i = 0; i < 8; ++i)
    {
        keySig = [MNKeySignature keySignatureWithKey:keys[i]];
        [keySig addToStaff:staff];
    }

    for(NSUInteger n = 8; n < keys.count; ++n)
    {
        keySig = [MNKeySignature keySignatureWithKey:keys[n]];
        [keySig addToStaff:staff2];
    }
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [staff2 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)majorKeysCanceled:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 10, 750, 0)] addTrebleGlyph];
    MNStaff* staff2 = [[MNStaff staffWithRect:CGRectMake(10, 90, 750, 0)] addTrebleGlyph];
    MNStaff* staff3 = [[MNStaff staffWithRect:CGRectMake(10, 170, 750, 0)] addTrebleGlyph];
    MNStaff* staff4 = [[MNStaff staffWithRect:CGRectMake(10, 250, 750, 0)] addTrebleGlyph];
    NSArray* keys = [self class].MAJOR_KEYS;

    MNKeySignature* keySig = nil;
    NSUInteger i, n;
    for(i = 0; i < 8; ++i)
    {
        keySig = [MNKeySignature keySignatureWithKey:keys[i]];
        [keySig cancelKey:@"Cb"];

        keySig.padding = 18;
        [keySig addToStaff:staff];
    }

    for(n = 8; n < keys.count; ++n)
    {
        keySig = [MNKeySignature keySignatureWithKey:keys[n]];
        [keySig cancelKey:@"C#"];
        keySig.padding = 20;
        [keySig addToStaff:staff2];
    }

    for(i = 0; i < 8; ++i)
    {
        keySig = [MNKeySignature keySignatureWithKey:keys[i]];
        [keySig cancelKey:@"E"];

        keySig.padding = 18;
        [keySig addToStaff:staff3];
    }

    for(n = 8; n < keys.count; ++n)
    {
        keySig = [MNKeySignature keySignatureWithKey:keys[n]];
        [keySig cancelKey:@"Ab"];
        keySig.padding = 20;
        [keySig addToStaff:staff4];
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

- (MNTestTuple*)minorKeys:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(10, 90, 350, 0)];
    NSArray* keys = [self class].MINOR_KEYS;

    MNKeySignature* keySig = nil;
    for(NSUInteger i = 0; i < 8; ++i)
    {
        keySig = [MNKeySignature keySignatureWithKey:keys[i]];
        [keySig addToStaff:staff];
    }

    for(NSUInteger n = 8; n < keys.count; ++n)
    {
        keySig = [MNKeySignature keySignatureWithKey:keys[n]];
        [keySig addToStaff:staff2];
    }
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [staff2 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

- (MNTestTuple*)staffHelper:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    MNStaff* staff = [MNStaff staffWithRect:CGRectMake(10, 10, 350, 0)];
    MNStaff* staff2 = [MNStaff staffWithRect:CGRectMake(10, 90, 350, 0)];
    NSArray* keys = [self class].MAJOR_KEYS;

    for(NSUInteger i = 0; i < 8; ++i)
    {
        [staff addKeySignatureWithSpec:keys[i]];
    }

    for(NSUInteger n = 8; n < keys.count; ++n)
    {
        [staff2 addKeySignatureWithSpec:keys[n]];
    }

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [staff2 draw:ctx];

      ok(YES, @"all pass");
    };
    return ret;
}

@end
