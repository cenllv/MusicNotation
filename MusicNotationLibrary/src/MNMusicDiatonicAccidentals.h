//
//  MNMusicDiatonicAccidentals.h
//  MusicNotation
//
//  Created by Scott on 3/21/15.
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

#import "IAModelBase.h"

@class IAUnison, IAm2, IAM2, IAm3, IAM3, IAp4, IAdim5, IAp5, IAm6, IAM6, IAb7, IAM7, IAoctave;

/*! The `MNMusicDiatonicAccidentals` class
 */
@interface MNMusicDiatonicAccidentals : IAModelBase
@property (strong, nonatomic) IAUnison* obj_unison;
@property (strong, nonatomic) IAm2* obj_m2;
@property (strong, nonatomic) IAM2* obj_M2;
@property (strong, nonatomic) IAm3* obj_m3;
@property (strong, nonatomic) IAM3* obj_M3;
@property (strong, nonatomic) IAp4* obj_p4;
@property (strong, nonatomic) IAdim5* obj_dim5;
@property (strong, nonatomic) IAp5* obj_p5;
@property (strong, nonatomic) IAm6* obj_m6;
@property (strong, nonatomic) IAM6* obj_M6;
@property (strong, nonatomic) IAb7* obj_b7;
@property (strong, nonatomic) IAM7* obj_M7;
@property (strong, nonatomic) IAoctave* obj_octave;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end

@interface  MNMusicNoteAccidental : IAModelBase
@property (assign, nonatomic) NSUInteger note;
@property (assign, nonatomic) NSUInteger accidental;
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
@end

@interface IAUnison :  MNMusicNoteAccidental
@end
@interface IAm2 :  MNMusicNoteAccidental
@end
@interface IAM2 :  MNMusicNoteAccidental
@end
@interface IAm3 :  MNMusicNoteAccidental
@end
@interface IAp4 :  MNMusicNoteAccidental
@end
@interface IAdim5 :  MNMusicNoteAccidental
@end
@interface IAp5 :  MNMusicNoteAccidental
@end
@interface IAm6 :  MNMusicNoteAccidental
@end
@interface IAM6 :  MNMusicNoteAccidental
@end
@interface IAb7 :  MNMusicNoteAccidental
@end
@interface IAM7 :  MNMusicNoteAccidental
@end
@interface IAoctave :  MNMusicNoteAccidental
@end
