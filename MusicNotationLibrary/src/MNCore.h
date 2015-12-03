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

//#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC

#endif

#import "MNMacros.h"
#import "MNConstants.h"

#import "MNAccidental.h"
#import "MNAnnotation.h"
#import "MNArticulation.h"
#import "MNBarNote.h"
#import "MNBeam.h"
#import "MNBend.h"
#import "MNBezierPath.h"
#import "MNBoundingBox.h"
#import "MNChordBarStruct.h"
#import "MNChordBox.h"
#import "MNClef.h"
#import "MNClefNote.h"
#import "MNCurve.h"
#import "MNMoveableClef.h"
#import "MNDot.h"
#import "MNEnum.h"
#import "MNFont.h"
#import "MNFormatter.h"
#import "MNFormatterContext.h"
#import "MNFretHandFinger.h"
#import "MNGhostNote.h"
#import "MNGlyph.h"
#import "MNGlyphLayer.h"
#import "MNGlyphList.h"
#import "MNGraceNote.h"
#import "MNGraceNoteGroup.h"
#import "MNKeyManager.h"
#import "MNKeyManager.h"
#import "MNKeySignature.h"
#import "MNKeyProperty.h"
#import "MNMetrics.h"
#import "MNModifier.h"
#import "MNModifierContext.h"
#import "MNMusic.h"
#import "MNNote.h"
#import "MNNoteAccidentalStruct.h"
#import "MNOrnament.h"
#import "MNPedalMarking.h"
#import "MNRational.h"
#import "MNShapeLayer.h"
#import "MNSize.h"
#import "MNStaff.h"
#import "MNStaffLineRenderOptions.h"
#import "MNStaffBarLine.h"
#import "MNStaffConnector.h"
#import "MNStaffHairpin.h"
#import "MNStaffLine.h"
#import "MNStaffModifier.h"
#import "MNStaffNote.h"
#import "MNStaffRepetition.h"
#import "MNStaffSection.h"
#import "MNStaffTempo.h"
#import "MNStaffTie.h"
#import "MNStaffVolta.h"
#import "MNStringNumber.h"
#import "MNStroke.h"
#import "MNTable.h"
#import "MNTableTypes.h"
#import "MNTabNote.h"
#import "MNTabSlide.h"
#import "MNTabStaff.h"
#import "MNTabTie.h"
#import "MNTextBracket.h"
#import "MNTextNote.h"
#import "MNText.h"
#import "MNTickable.h"
#import "MNTickContext.h"
#import "MNTimeSignature.h"
#import "MNTimeSigNote.h"
#import "MNTremulo.h"
#import "MNTuning.h"
#import "MNTuningNames.h"
#import "MNTuplet.h"
#import "MNUtils.h"
#import "MNVibrato.h"
#import "MNVoice.h"
#import "MNVoiceGroup.h"
#import "MNShift.h"
#endif
