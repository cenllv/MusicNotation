//
//  MNStaffLine.h
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

#import "MNModifier.h"
#import "MNRenderOptions.h"
#import "MNStaffLineRenderOptions.h"

@class MNStaffLineRenderOptions, MNStaffLineNotesStruct;

/*!
 *  The `MNStaffLine` class implements `StaveLine` which are simply lines that connect
 *  two notes. This object is highly configurable, see the `render_options`.
 *  A simple line is often used for notating glissando articulations, but you
 *  can format a `StaveLine` with arrows or colors for more pedagogical
 *  purposes, such as diagrams.
 */
@interface MNStaffLine : MNModifier
#pragma mark - Properties
//@property (strong, nonatomic)  MNFont* font;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) MNStaffLineNotesStruct* staff_line_notes;
- (id)setNotes:(MNStaffLineNotesStruct*)notes;
- (MNStaffLineRenderOptions*)renderOptions;
- (id)setRenderOptions:(MNStaffLineRenderOptions*)renderOptions;
@property (strong, nonatomic) MNStaffNote* first_note;
@property (strong, nonatomic) NSArray* first_indices;
@property (strong, nonatomic) MNStaffNote* last_note;
@property (strong, nonatomic) NSArray* last_indices;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNotes:(MNStaffLineNotesStruct*)notes;

@end
