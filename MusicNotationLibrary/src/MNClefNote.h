//
//  MNClefNote.h
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

#import "MNNote.h"

@class MNClef, MNGlyph;

/*! The `MNClefNote` class

 */
@interface MNClefNote : MNNote
#pragma mark - Properties
@property (strong, nonatomic) NSString* clefName;
@property (strong, nonatomic) NSString* clefSize;
@property (assign, nonatomic) MNClefType clefType;
//@property (strong, nonatomic)  MNClef* clef;
//@property (strong, nonatomic) MNGlyph* glyph;
@property (strong, nonatomic) NSString* annotationName;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNClefNote*)clefNoteWithClef:(NSString*)clef;
+ (MNClefNote*)clefNoteWithClef:(NSString*)clef size:(NSString*)size;
+ (MNClefNote*)clefNoteWithClef:(NSString*)clef size:(NSString*)size annotation:(NSString*)annotation;

@end
