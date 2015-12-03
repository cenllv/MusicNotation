//
//  MNBeamConfig.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/22/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
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

#import "IAModelBase.h"
#import "MNEnum.h"

/*!
 * The `MNBeamConfig` class
 *
 * `config` - The configuration object
 *   `groups` - Array of `Fractions` that represent the beat structure to beam the notes
 *   `stem_direction` - Set to apply the same direction to all notes
 *   `beam_rests` - Set to `YES` to include rests in the beams
 *   `beam_middle_only` - Set to `YES` to only beam rests in the middle of the beat
 *   `show_stemlets` - Set to `YES` to draw stemlets for rests
 *   `maintain_stem_directions` - Set to `YES` to not apply new stem
 */
@interface MNBeamConfig : IAModelBase

@property (strong, nonatomic) NSMutableArray* groups;
@property (assign, nonatomic) MNStemDirectionType stemDirection;
@property (assign, nonatomic) BOOL beamRests;
@property (assign, nonatomic) BOOL beamMiddleOnly;
@property (assign, nonatomic) BOOL showStemlets;
@property (assign, nonatomic) BOOL maintainStemDirections;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

@end