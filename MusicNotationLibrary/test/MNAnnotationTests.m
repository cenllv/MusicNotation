//
//  MNAnnotationTests.m
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

#import "MNAnnotationTests.h"

@implementation MNAnnotationTests

static NSUInteger testFontSize;

- (void)start
{
    testFontSize = 12;

    [super start];

    float w = 500;

    [self runTest:@"Simple Annotation" func:@selector(simple:withTitle:) frame:CGRectMake(10, 10, w, 200)];
    [self runTest:@"Standard Notation Annotation" func:@selector(standard:withTitle:) frame:CGRectMake(10, 10, w, 200)];
    [self runTest:@"Harmonics" func:@selector(harmonic:withTitle:) frame:CGRectMake(10, 10, w, 200)];
    [self runTest:@"Fingerpicking" func:@selector(picking:withTitle:) frame:CGRectMake(10, 10, w, 200)];
    [self runTest:@"Bottom Annotation" func:@selector(bottom:withTitle:) frame:CGRectMake(10, 10, w, 200)];
    [self runTest:@"Test Justification Annotation Stem Up"
             func:@selector(justificationStemUp:withTitle:)
            frame:CGRectMake(10, 10, w, 700)];
    [self runTest:@"Test Justification Annotation Stem Down"
             func:@selector(justificationStemDown:withTitle:)
            frame:CGRectMake(10, 10, w, 700)];
    [self runTest:@"TabNote Annotations" func:@selector(tabNotes:withTitle:) frame:CGRectMake(10, 10, w + 100, 300)];
}

- (MNViewStaffStruct*)setupContextWithSize:(MNUIntSize*)size
                              withParent:(MNTestCollectionItemView*)parent
                               withTitle:(NSString*)title
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

    // withParent:parent withTitle:title];
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 30, w, 0)] addTrebleGlyph];
    return [MNViewStaffStruct contextWithStaff:staff andView:nil];
}

- (MNTestTuple*)simple:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];

    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNBend* (^newBend)(NSString*) = ^MNBend*(NSString* text)
    {
        return [[MNBend alloc] initWithText:text];
    };
    MNAnnotation* (^newAnnotation)(NSString*) = ^MNAnnotation*(NSString* text)
    {
        return [MNAnnotation annotationWithText:text];
    };

    NSArray* notes = @[
        [newNote(@{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(4), @"fret" : @"9"} ],
            @"duration" : @"h"
        }) addModifier:newAnnotation(@"T")
                atIndex:0],
        [[newNote(
            @{ @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"} ],
               @"duration" : @"h" }) addModifier:newAnnotation(@"T")
                                         atIndex:0] addModifier:newBend(@"Full")
                                                        atIndex:0],
    ];

    MNTabStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 20, 450, 0)] addTabGlyph];
    //    [ret.staves addObject:staff];

    //     MNVoice* voice =  [MNVoice voiceWithTimeSignature:MNTime4_4];
    //    voice.mode =  MNModeSoft;
    //    [voice addTickables:notes];

    //    MNFormatter* formatter = [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ]
    //    staff:staff];

    //    [ret.voices addObject:voice];
    //    [ret.formatters addObject:formatter];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staff
                                  withNotes:notes
                           withJustifyWidth:200];

      ok(YES, @"Simple Annotation");
    };

    return ret;
}

- (MNTestTuple*)standard:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 50, 450, 0)] addClefWithName:@"treble"];
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* tab_struct)
      {
          return [[MNStaffNote alloc] initWithDictionary:tab_struct];
      };
      MNAnnotation* (^newAnnotation)(NSString*) = ^MNAnnotation*(NSString* text)
      {
          MNAnnotation* ret = [MNAnnotation annotationWithText:text];
          //           MNFont* font =  [MNFont fontWithName:@"Times" size:testFontSize];
          //          font.italic = YES;
          //          [ret setFont:font];
          return ret;
      };

      NSArray* notes = @[
          [newNote(
              @{ @"keys" : @[ @"c/4", @"e/4" ],
                 @"duration" : @"h" }) addAnnotation:newAnnotation(@"quiet")
                                             atIndex:0],
          [newNote(
              @{ @"keys" : @[ @"c/4", @"e/4", @"c/5" ],
                 @"duration" : @"h" }) addAnnotation:newAnnotation(@"Allegro")
                                             atIndex:2]
      ];

      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staff
                                  withNotes:notes
                           withJustifyWidth:200];

      ok(YES, @"Standard Notation Annotation");
    };
    return ret;
}

- (MNTestTuple*)harmonic:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNAnnotation* (^newAnnotation)(NSString*) = ^MNAnnotation*(NSString* text)
    {
        return [MNAnnotation annotationWithText:text];
    };

    MNTabStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 20, 450, 0)] addTabGlyph];
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      NSArray* notes = @[
          [newNote(@{
              @"positions" : @[ @{@"str" : @(2), @"fret" : @"12"}, @{@"str" : @(3), @"fret" : @"12"} ],
              @"duration" : @"h"
          }) addModifier:newAnnotation(@"Harm.")
                  atIndex:0],
          [[newNote(
              @{ @"positions" : @[ @{@"str" : @(2), @"fret" : @"9"} ],
                 @"duration" : @"h" })
              addModifier:[newAnnotation(@"(8va)") setFontName:@"Times" withSize:testFontSize withStyle:@"italic"]]
              addModifier:newAnnotation(@"A.H.")
                  atIndex:0],
      ];

      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staff
                                  withNotes:notes
                           withJustifyWidth:200];

      ok(YES, @"Simple Annotation");
    };
    return ret;
}

- (MNTestTuple*)picking:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNTabNote* (^newNote)(NSDictionary*) = ^MNTabNote*(NSDictionary* tab_struct)
    {
        return [[MNTabNote alloc] initWithDictionary:tab_struct];
    };
    MNAnnotation* (^newAnnotation)(NSString*) = ^MNAnnotation*(NSString* text)
    {
        MNAnnotation* ret = [MNAnnotation annotationWithText:text];
        //         MNFont* font =  [MNFont fontWithName:@"Times" size:testFontSize];
        //        font.italic = YES;
        NSFontManager* fontManager = [NSFontManager sharedFontManager];
        NSFont* font = [fontManager fontWithFamily:@"Times" traits:NSItalicFontMask weight:5 size:12];
        [ret setFont:(MNFont*)font];
        return ret;
    };

    MNTabStaff* staff = [[MNTabStaff staffWithRect:CGRectMake(10, 20, 450, 0)] addTabGlyph];
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      NSArray* notes = @[
          [newNote(@{
              @"positions" : @[
                  @{@"str" : @(1), @"fret" : @"0"},
                  @{@"str" : @(2), @"fret" : @"1"},
                  @{@"str" : @(3), @"fret" : @"2"},
                  @{@"str" : @(4), @"fret" : @"2"},
                  @{@"str" : @(5), @"fret" : @"0"}
              ],
              @"duration" : @"h"
          }) addModifier:[[[MNVibrato alloc] init] setVibratoWidth:40]],
          [newNote(
              @{ @"positions" : @[ @{@"str" : @(6), @"fret" : @"9"} ],
                 @"duration" : @"8" }) addModifier:newAnnotation(@"p")
                                           atIndex:0],
          [newNote(
              @{ @"positions" : @[ @{@"str" : @(3), @"fret" : @"9"} ],
                 @"duration" : @"8" }) addModifier:newAnnotation(@"i")
                                           atIndex:0],
          [newNote(
              @{ @"positions" : @[ @{@"str" : @(2), @"fret" : @"9"} ],
                 @"duration" : @"8" }) addModifier:newAnnotation(@"m")
                                           atIndex:0],
          [newNote(
              @{ @"positions" : @[ @{@"str" : @(1), @"fret" : @"9"} ],
                 @"duration" : @"8" }) addModifier:newAnnotation(@"a")
                                           atIndex:0],
      ];

      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staff
                                  withNotes:notes
                           withJustifyWidth:200];

      ok(YES, @"Fingerpicking");
    };
    return ret;
}

- (MNTestTuple*)bottom:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* tab_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:tab_struct];
    };
    MNAnnotation* (^newAnnotation)(NSString*) = ^MNAnnotation*(NSString* text)
    {
        MNAnnotation* ret = [MNAnnotation annotationWithText:text];
        MNFont* font = [MNFont fontWithName:@"Times" size:testFontSize];
        //        font.italic = YES;
        [ret setVerticalJustification:MNVerticalJustifyBOTTOM];
        [ret setFont:font];
        return ret;
    };

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 20, 300, 0)] addClefWithName:@"treble"];
    [ret.staves addObject:staff];
    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];

      NSArray* notes = @[
          [newNote(
              @{ @"keys" : @[ @"f/4" ],
                 @"duration" : @"w" }) addAnnotation:newAnnotation(@"F")
                                             atIndex:0],
          [newNote(
              @{ @"keys" : @[ @"a/4" ],
                 @"duration" : @"w" }) addAnnotation:newAnnotation(@"A")
                                             atIndex:0],
          [newNote(
              @{ @"keys" : @[ @"c/5" ],
                 @"duration" : @"w" }) addAnnotation:newAnnotation(@"C")
                                             atIndex:0],
          [newNote(
              @{ @"keys" : @[ @"e/5" ],
                 @"duration" : @"w" }) addAnnotation:newAnnotation(@"E")
                                             atIndex:0],
      ];

      [MNFormatter formatAndDrawWithContext:ctx
                                  dirtyRect:CGRectZero
                                    toStaff:staff
                                  withNotes:notes
                           withJustifyWidth:200];

      ok(YES, @"Bottom Annotation");
    };
    return ret;
}

- (MNTestTuple*)justificationStemUp:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* tab_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:tab_struct];
    };
    MNAnnotation* (^newAnnotation)(NSString*, MNJustiticationType, MNVerticalJustifyType) =
        ^MNAnnotation*(NSString* text, MNJustiticationType hJustifcation, MNVerticalJustifyType vJustifcation)
    {
        MNAnnotation* ret = [MNAnnotation annotationWithText:text];
        [ret setJustification:hJustifcation];
        [ret setVerticalJustification:vJustifcation];
        return ret;
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      NSMutableArray* notes = nil;

      for(NSUInteger v = 1; v <= 4; ++v)
      {
          MNStaff* staff =
              [[MNStaff staffWithRect:CGRectMake(10, (v - 1) * 150 + 60, 400, 0)] addClefWithName:@"treble"];
          [staff draw:ctx];

          notes = [NSMutableArray arrayWithCapacity:4];

          [notes push:[newNote(
                          @{ @"keys" : @[ @"c/3" ],
                             @"duration" : @"q" }) addAnnotation:newAnnotation(@"Text", 1, v)
                                                         atIndex:0]];
          [notes push:[newNote(
                          @{ @"keys" : @[ @"c/4" ],
                             @"duration" : @"q" }) addAnnotation:newAnnotation(@"Text", 2, v)
                                                         atIndex:0]];
          [notes push:[newNote(
                          @{ @"keys" : @[ @"c/5" ],
                             @"duration" : @"q" }) addAnnotation:newAnnotation(@"Text", 3, v)
                                                         atIndex:0]];
          [notes push:[newNote(
                          @{ @"keys" : @[ @"c/6" ],
                             @"duration" : @"q" }) addAnnotation:newAnnotation(@"Text", 4, v)
                                                         atIndex:0]];

          [MNFormatter formatAndDrawWithContext:ctx
                                      dirtyRect:CGRectZero
                                        toStaff:staff
                                      withNotes:notes
                               withJustifyWidth:300];
      }

      ok(YES, @"Test Justification Annotation");
    };
    return ret;
}

- (MNTestTuple*)justificationStemDown:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNStaffNote* (^newNote)(NSDictionary*) = ^MNStaffNote*(NSDictionary* tab_struct)
    {
        return [[MNStaffNote alloc] initWithDictionary:tab_struct];
    };
    MNAnnotation* (^newAnnotation)(NSString*, MNJustiticationType, MNVerticalJustifyType) =
        ^MNAnnotation*(NSString* text, MNJustiticationType hJustifcation, MNVerticalJustifyType vJustifcation)
    {
        MNAnnotation* ret = [MNAnnotation annotationWithText:text];
        [ret setJustification:hJustifcation];
        [ret setVerticalJustification:vJustifcation];
        return ret;
    };

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      NSMutableArray* notes = nil;

      for(NSUInteger v = 1; v <= 4; ++v)
      {
          MNStaff* staff =
              [[MNStaff staffWithRect:CGRectMake(10, (v - 1) * 150 + 60, 400, 0)] addClefWithName:@"treble"];
          [staff draw:ctx];

          notes = [NSMutableArray arrayWithCapacity:4];

          [notes push:[newNote(
                          @{ @"keys" : @[ @"c/3" ],
                             @"duration" : @"q",
                             @"stem_direction" : @(-1) }) addAnnotation:newAnnotation(@"Text", 1, v)
                                                                atIndex:0]];
          [notes push:[newNote(
                          @{ @"keys" : @[ @"c/4" ],
                             @"duration" : @"q",
                             @"stem_direction" : @(-1) }) addAnnotation:newAnnotation(@"Text", 2, v)
                                                                atIndex:0]];
          [notes push:[newNote(
                          @{ @"keys" : @[ @"c/5" ],
                             @"duration" : @"q",
                             @"stem_direction" : @(-1) }) addAnnotation:newAnnotation(@"Text", 3, v)
                                                                atIndex:0]];
          [notes push:[newNote(
                          @{ @"keys" : @[ @"c/6" ],
                             @"duration" : @"q",
                             @"stem_direction" : @(-1) }) addAnnotation:newAnnotation(@"Text", 4, v)
                                                                atIndex:0]];

          [MNFormatter formatAndDrawWithContext:ctx
                                      dirtyRect:CGRectZero
                                        toStaff:staff
                                      withNotes:notes
                               withJustifyWidth:300];
      }

      ok(YES, @"Test Justification Annotation");
    };
    return ret;
}

- (MNTestTuple*)tabNotes:(MNTestCollectionItemView*)parent withTitle:(NSString*)title
{
    MNTestTuple* ret = [MNTestTuple testTuple];
    MNAnnotation* (^newAnnotation)(NSString*) = ^MNAnnotation*(NSString* text)
    {
        return [MNAnnotation annotationWithText:text];
    };

    MNTabStaff* staff = [MNTabStaff staffWithRect:CGRectMake(10, 80, 550, 0)];
    //    [ret.staves addObject:staff];

    NSArray* specs = @[
        @{
            @"positions" : @[ @{@"str" : @(3), @"fret" : @"6"}, @{@"str" : @(4), @"fret" : @"25"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(2), @"fret" : @"10"}, @{@"str" : @(5), @"fret" : @"12"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(3), @"fret" : @"5"} ],
            @"duration" : @"8"
        },
        @{
            @"positions" : @[ @{@"str" : @(1), @"fret" : @"6"}, @{@"str" : @(3), @"fret" : @"5"} ],
            @"duration" : @"8"
        }
    ];

    NSArray* notes = [specs oct_map:^MNTabNote*(NSDictionary* tab_struct) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:tab_struct];
      [tabNote->_renderOptions setDraw_stem:YES];
      return tabNote;
    }];

    NSArray* notes2 = [specs oct_map:^MNTabNote*(NSDictionary* tab_struct) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:tab_struct];
      [tabNote->_renderOptions setDraw_stem:YES];
      [tabNote setStemDirection:MNStemDirectionDown];
      return tabNote;
    }];

    NSArray* notes3 = [specs oct_map:^MNTabNote*(NSDictionary* tab_struct) {
      MNTabNote* tabNote = [[MNTabNote alloc] initWithDictionary:tab_struct];
      return tabNote;
    }];

    [notes[0] addModifier:[[newAnnotation(@"Text") setJustification:1] setVerticalJustification:1] atIndex:0];   // U
    [notes[1] addModifier:[[newAnnotation(@"Text") setJustification:2] setVerticalJustification:2] atIndex:0];   // D
    [notes[2] addModifier:[[newAnnotation(@"Text") setJustification:3] setVerticalJustification:3] atIndex:0];   // U
    [notes[3] addModifier:[[newAnnotation(@"Text") setJustification:4] setVerticalJustification:4] atIndex:0];   // D

    [notes2[0] addModifier:[[newAnnotation(@"Text") setJustification:3] setVerticalJustification:1] atIndex:0];   // U
    [notes2[1] addModifier:[[newAnnotation(@"Text") setJustification:3] setVerticalJustification:2] atIndex:0];   // D
    [notes2[2] addModifier:[[newAnnotation(@"Text") setJustification:3] setVerticalJustification:3] atIndex:0];   // U
    [notes2[3] addModifier:[[newAnnotation(@"Text") setJustification:3] setVerticalJustification:4] atIndex:0];   // D

    [notes3[0] addModifier:[newAnnotation(@"Text") setVerticalJustification:1] atIndex:0];   // U
    [notes3[1] addModifier:[newAnnotation(@"Text") setVerticalJustification:2] atIndex:0];   // D
    [notes3[2] addModifier:[newAnnotation(@"Text") setVerticalJustification:3] atIndex:0];   // U
    [notes3[3] addModifier:[newAnnotation(@"Text") setVerticalJustification:4] atIndex:0];   // D

    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;

    [voice addTickables:notes];
    [voice addTickables:notes2];
    [voice addTickables:notes3];

    //        MNFormatter* formatter =
    [[[MNFormatter formatter] joinVoices:@[ voice ]] formatToStaff:@[ voice ] staff:staff];

    ret.drawBlock = ^(CGRect dirtyRect, CGRect bounds, CGContextRef ctx) {
      [staff draw:ctx];
      [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];

      ok(YES, @"TabNotes successfully drawn");
    };
    return ret;
}

@end
