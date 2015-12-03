//
//  MNKeyManagerTests.m
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

#import "MNKeyManagerTests.h"

@implementation MNKeyManagerTests

- (void)start
{
    [super start];
//    [self runTest:@"Valid Notes" func:@selector(works)];
//    [self runTest:@"Select Notes" func:@selector(selectNotes)];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)works
{
    expect(@"1");

    MNKeyManager* manager = [MNKeyManager keyManagerWithKey:@"g"];
    assertThatBool([((NSString*)[manager getAccidental:@"f"].accidental)isEqualToString:@"#"], isTrue());

    [manager setKey:@"a"];
    assertThatBool([((NSString*)[manager getAccidental:@"c"].accidental)isEqualToString:@"#"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"a"].accidental)isEqualToString:@""], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"f"].accidental)isEqualToString:@"#"], isTrue());

    [manager setKey:@"A"];
    assertThatBool([((NSString*)[manager getAccidental:@"c"].accidental)isEqualToString:@"#"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"a"].accidental)isEqualToString:@""], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"f"].accidental)isEqualToString:@"#"], isTrue());
}

- (void)selectNotes
{
    MNKeyManager* manager = [MNKeyManager keyManagerWithKey:@"f"];
    assertThatBool([((NSString*)[manager getAccidental:@"bb"].note)isEqualToString:@"bb"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"bb"].accidental)isEqualToString:@"b"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g"].note)isEqualToString:@"g"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g"].accidental)isEqualToString:@""], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g"].note)isEqualToString:@"b"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g"].accidental)isEqualToString:@""], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"a#"].note)isEqualToString:@"bb"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g#"].note)isEqualToString:@"g#"], isTrue());

    // Changes have no effect?
    assertThatBool([((NSString*)[manager getAccidental:@"g#"].note)isEqualToString:@"g#"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"bb"].note)isEqualToString:@"bb"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"bb"].accidental)isEqualToString:@"b"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g"].note)isEqualToString:@"g"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g"].accidental)isEqualToString:@""], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g"].note)isEqualToString:@"b"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g"].accidental)isEqualToString:@""], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"a#"].note)isEqualToString:@"bb"], isTrue());
    assertThatBool([((NSString*)[manager getAccidental:@"g#"].note)isEqualToString:@"g#"], isTrue());

    // Changes should propagate
    [manager reset];
    assertThatBool([manager selectNote:@"g#"].change, isTrue());
    assertThatBool([manager selectNote:@"g#"].change, isFalse());
    assertThatBool([manager selectNote:@"g"].change, isTrue());
    assertThatBool([manager selectNote:@"g"].change, isFalse());
    assertThatBool([manager selectNote:@"g#"].change, isTrue());

    [manager reset];
    MNNoteAccidentalStruct* note;

    note = [manager selectNote:@"bb"];
    assertThatBool(note.change, isFalse());
    assertThatBool([note.accidental isEqualToString:@"b"], isTrue());

    note = [manager selectNote:@"g"];
    assertThatBool(note.change, isFalse());
    assertThatBool([note.accidental isEqualToString:@""], isTrue());

    note = [manager selectNote:@"g#"];
    assertThatBool(note.change, isTrue());
    assertThatBool([note.accidental isEqualToString:@"#"], isTrue());

    note = [manager selectNote:@"g"];
    assertThatBool(note.change, isTrue());
    assertThatBool([note.accidental isEqualToString:@""], isTrue());

    note = [manager selectNote:@"g"];
    assertThatBool(note.change, isFalse());
    assertThatBool([note.accidental isEqualToString:@""], isTrue());

    note = [manager selectNote:@"g#"];
    assertThatBool(note.change, isFalse());
    assertThatBool([note.accidental isEqualToString:@"#"], isTrue());
}

@end
