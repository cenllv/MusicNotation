//
//  Header.h
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

#ifndef MusicNotation_MNCore_Header_h
#define MusicNotation_MNCore_Header_h

#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC

#endif

#import "MusicNotation/MNMacros.h"
#import "MusicNotation/MNConstants.h"

#import "MusicNotation/MNAccidental.h"
#import "MusicNotation/MNAnnotation.h"
#import "MusicNotation/MNArticulation.h"
#import "MusicNotation/MNBarNote.h"
#import "MusicNotation/MNBeam.h"
#import "MusicNotation/MNBend.h"
#import "MusicNotation/MNBoundingBox.h"
#import "MusicNotation/MNChordBarStruct.h"
#import "MusicNotation/MNChordBox.h"
#import "MusicNotation/MNClef.h"
#import "MusicNotation/MNClefNote.h"
#import "MusicNotation/MNCrescendo.h"
#import "MusicNotation/MNCurve.h"
#import "MusicNotation/MNMoveableClef.h"
#import "MusicNotation/MNDot.h"
#import "MusicNotation/MNEnum.h"
#import "MusicNotation/MNFont.h"
#import "MusicNotation/MNFormatter.h"
#import "MusicNotation/MNFormatterContext.h"
#import "MusicNotation/MNFretHandFinger.h"
#import "MusicNotation/MNGhostNote.h"
#import "MusicNotation/MNGlyph.h"
#import "MusicNotation/MNGlyphLayer.h"
#import "MusicNotation/MNGlyphList.h"
#import "MusicNotation/MNGraceNote.h"
#import "MusicNotation/MNGraceNoteGroup.h"
#import "MusicNotation/MNKeyManager.h"
#import "MusicNotation/MNKeyManager.h"
#import "MusicNotation/MNKeySignature.h"
#import "MusicNotation/MNKeyProperty.h"
#import "MusicNotation/MNMetrics.h"
#import "MusicNotation/MNModifier.h"
#import "MusicNotation/MNModifierContext.h"
#import "MusicNotation/MNMusic.h"
#import "MusicNotation/MNNote.h"
#import "MusicNotation/MNNoteAccidentalStruct.h"
#import "MusicNotation/MNOrnament.h"
#import "MusicNotation/MNPedalMarking.h"
#import "MusicNotation/MNSize.h"
#import "MusicNotation/MNStaff.h"
#import "MusicNotation/MNStaffLineRenderOptions.h"
#import "MusicNotation/MNStaffBarLine.h"
#import "MusicNotation/MNStaffConnector.h"
#import "MusicNotation/MNStaffHairpin.h"
#import "MusicNotation/MNStaffLine.h"
#import "MusicNotation/MNStaffModifier.h"
#import "MusicNotation/MNStaffNote.h"
#import "MusicNotation/MNStaffRepetition.h"
#import "MusicNotation/MNStaffSection.h"
#import "MusicNotation/MNStaffTempo.h"
#import "MusicNotation/MNStaffTie.h"
#import "MusicNotation/MNStaffVolta.h"
#import "MusicNotation/MNStringNumber.h"
#import "MusicNotation/MNStroke.h"
#import "MusicNotation/MNTable.h"
#import "MusicNotation/MNTableTypes.h"
#import "MusicNotation/MNTabNote.h"
#import "MusicNotation/MNTabSlide.h"
#import "MusicNotation/MNTabStaff.h"
#import "MusicNotation/MNTabTie.h"
#import "MusicNotation/MNTextBracket.h"
#import "MusicNotation/MNTextDynamics.h"
#import "MusicNotation/MNTextNote.h"
#import "MusicNotation/MNText.h"
#import "MusicNotation/MNTickable.h"
#import "MusicNotation/MNTickContext.h"
#import "MusicNotation/MNTimeSignature.h"
#import "MusicNotation/MNTimeSigNote.h"
#import "MusicNotation/MNTremulo.h"
#import "MusicNotation/MNTuning.h"
#import "MusicNotation/MNTuningNames.h"
#import "MusicNotation/MNTuplet.h"
#import "MusicNotation/MNUtils.h"
#import "MusicNotation/MNVibrato.h"
#import "MusicNotation/MNVoice.h"
#import "MusicNotation/MNVoiceGroup.h"
#import "MusicNotation/MNShift.h"

#import "MusicNotation/lib/MNBezierPath.h"
#import "MusicNotation/lib/MNRational.h"
#import "MusicNotation/lib/MNShapeLayer.h"

#endif
