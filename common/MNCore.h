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

#import "common/MNMacros.h"
#import "common/MNConstants.h"

#import "common/MNAccidental.h"
#import "common/MNAnnotation.h"
#import "common/MNArticulation.h"
#import "common/MNBarNote.h"
#import "common/MNBeam.h"
#import "common/MNBend.h"
#import "common/MNBoundingBox.h"
#import "common/MNChordBarStruct.h"
#import "common/MNChordBox.h"
#import "common/MNClef.h"
#import "common/MNClefNote.h"
#import "common/MNCrescendo.h"
#import "common/MNCurve.h"
#import "common/MNMoveableClef.h"
#import "common/MNDot.h"
#import "common/MNEnum.h"
#import "common/MNFont.h"
#import "common/MNFormatter.h"
#import "common/MNFormatterContext.h"
#import "common/MNFretHandFinger.h"
#import "common/MNGhostNote.h"
#import "common/MNGlyph.h"
#import "common/MNGlyphLayer.h"
#import "common/MNGlyphList.h"
#import "common/MNGraceNote.h"
#import "common/MNGraceNoteGroup.h"
#import "common/MNKeyManager.h"
#import "common/MNKeyManager.h"
#import "common/MNKeySignature.h"
#import "common/MNKeyProperty.h"
#import "common/MNMetrics.h"
#import "common/MNModifier.h"
#import "common/MNModifierContext.h"
#import "common/MNMusic.h"
#import "common/MNNote.h"
#import "common/MNNoteAccidentalStruct.h"
#import "common/MNOrnament.h"
#import "common/MNPedalMarking.h"
#import "common/MNSize.h"
#import "common/MNStaff.h"
#import "common/MNStaffLineRenderOptions.h"
#import "common/MNStaffBarLine.h"
#import "common/MNStaffConnector.h"
#import "common/MNStaffHairpin.h"
#import "common/MNStaffLine.h"
#import "common/MNStaffModifier.h"
#import "common/MNStaffNote.h"
#import "common/MNStaffRepetition.h"
#import "common/MNStaffSection.h"
#import "common/MNStaffTempo.h"
#import "common/MNStaffTie.h"
#import "common/MNStaffVolta.h"
#import "common/MNStringNumber.h"
#import "common/MNStroke.h"
#import "common/MNTable.h"
#import "common/MNTableTypes.h"
#import "common/MNTabNote.h"
#import "common/MNTabSlide.h"
#import "common/MNTabStaff.h"
#import "common/MNTabTie.h"
#import "common/MNTextBracket.h"
#import "common/MNTextDynamics.h"
#import "common/MNTextNote.h"
#import "common/MNText.h"
#import "common/MNTickable.h"
#import "common/MNTickContext.h"
#import "common/MNTimeSignature.h"
#import "common/MNTimeSigNote.h"
#import "common/MNTremulo.h"
#import "common/MNTuning.h"
#import "common/MNTuningNames.h"
#import "common/MNTuplet.h"
#import "common/MNUtils.h"
#import "common/MNVibrato.h"
#import "common/MNVoice.h"
#import "common/MNVoiceGroup.h"
#import "common/MNShift.h"

#import "common/lib/MNBezierPath.h"
#import "common/lib/MNRational.h"
#import "common/lib/MNShapeLayer.h"

#endif
