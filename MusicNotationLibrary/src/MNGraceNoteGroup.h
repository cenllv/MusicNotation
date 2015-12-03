//
//  MNGraceNoteGroup.h
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

@class MNVoice, MNFormatter, MNStaffTie, MNBeam, MNGraceNote;

/*! The `MNGraceNoteGroup` class implements `GraceNoteGroup` which is used to format and
      render grace notes.

 A grace note is a kind of music notation used to denote several kinds of musical ornaments,
 usually printed smaller to indicate that it is melodically and harmonically nonessential.
 When occurring by itself, a single grace note normally indicates the intention of either
 an appoggiatura or an acciaccatura. When they occur in groups, grace notes can be i
 nterpreted to indicate any of several different classes of ornamentation, depending on
 interpretation.

 Notation
 In notation a grace note is distinguished from a regular note by print size. A grace note
 is indicated by printing a note that is much smaller than a regular note, sometimes with
 a slash through the note stem (if two or more grace notes, there might be a slash through
 the note stem of the first note but not the subsequent grace note). The presence or
 absence of a slash through a note stem is often interpreted to indicate the intention
 of an acciaccatura or an appoggiatura, respectively.

 The works of some composers, especially Frédéric Chopin, may contain long series of notes
 printed in the small type reserved for grace notes simply to show that the amount of time
 to be taken up by those notes as a whole unit is a subjective matter to be decided by the
 performer. Such a group of small printed notes may or may not have an accompanying principal
 note, and so may or may not be considered as grace notes in analysis.

 Function
 A grace note represents an ornament, and distinguishing whether a given singular grace note
 is to be played as an appoggiatura or acciaccatura in the performance practice of a given
 historical period (or in the practice of a given composer) is usually the subject of lively
 debate. This is because we must rely on literary, interpretative accounts of performance
 practice in those days before such time as audio recording was implemented, and even then,
 only a composer's personal or sanctioned recording could directly document usage.

 As either an appoggiatura or an acciaccatura, grace notes occur as notes of short duration
 before the sounding of the relatively longer-lasting note which immediately follows them.
 This longer note, to which any grace notes can be considered harmonically and melodically
 subservient (except in the cases of certain appoggiaturas, in which the ornament may be
 held for a longer duration than the note it ornaments), is called the principal in
 relation to the grace notes.

 */
@interface MNGraceNoteGroup : MNModifier
#pragma mark - Properties
//@property (weak, nonatomic) MNStaff* staff;
@property (strong, nonatomic) NSArray<MNGraceNote*>* graceNotes;
//@property (strong, nonatomic)  MNVoice* voice;
@property (strong, nonatomic) MNFormatter* formatter;
@property (assign, nonatomic) BOOL showSlur;
@property (strong, nonatomic) MNStaffTie* slur;
@property (assign, nonatomic) float shift;
@property (strong, nonatomic) MNBeam* beam;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithGraceNoteGroups:(NSArray<MNGraceNote*>*)groups;
- (instancetype)initWithGraceNoteGroups:(NSArray<MNGraceNote*>*)graceNotes showSlur:(BOOL)showSlur;

- (id)beamNotes;

@end
