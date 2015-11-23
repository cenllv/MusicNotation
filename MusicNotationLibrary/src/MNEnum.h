//
//  MNEnum.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
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

/*! Position
 */
typedef NS_ENUM(NSUInteger, MNPositionType)
{
    MNPositionLeft = 1,
    MNPositionRight = 2,
    MNPositionAbove = 3,
    MNPositionBelow = 4,
    MNPositionCenter = 5,
};

typedef NS_ENUM(NSUInteger, MNShiftDirectionType)
{
    MNShiftUp = 1,
    MNShiftDown = -1,
    MNShiftLeft = 2,
    MNShiftRight = 3,
};

typedef NS_ENUM(NSUInteger, MNTextJustificationType)
{
    MNTextJustificationCenter = 3,
    MNTextJustificationLeft = 1,
    MNTextJustificationRight = 2,
};

/*! Note
 */
typedef NS_ENUM(NSUInteger, MNNoteNHMRSType)
{
    MNNoteNone = 0,
    MNNoteX = MNNoteNone,   // none ?
    MNNoteSlash = 1,        // slash
    MNNoteHarmonic = 2,     // harmonic
    MNNoteRest = 3,         // rest
    MNNoteNote = 4,         //
    MNNoteMuted = 5,        // muted
};

/*! durations
 */
typedef NS_ENUM(NSUInteger, MNBarNoteType)
{
    MNBarNoteSingle = 1,
    MNBarNoteDouble = 2,
    MNBarNoteEnd = 3,
    MNBarNoteRepeatBegin = 4,
    MNBarNoteRepeatEnd = 5,
    MNBarNoteRepeatBoth = 6,
    MNBarNoteNone = 7,
};

/*! Bar line
 */
typedef NS_ENUM(NSUInteger, MNBarLineType)
{
    MNBarLineNone = 0,
    MNBarLineSingle = 1,
    MNBarLineDouble = 2,
    MNBarLineEnd = 3,
    MNBarLineRepeatBegin = 4,
    MNBarLineRepeatEnd = 5,
    MNBarLineRepeatBoth = 6,
};

/*! Clef
 */
typedef NS_ENUM(NSUInteger, MNClefType)
{
    MNClefNone = 0,
    MNClefTreble = 1,         // "treble"
    MNClefBass = 2,           // "bass"
    MNClefAlto = 3,           // "alto"
    MNClefTenor = 4,          // "tenor"
    MNClefPercussion = 5,     // "percussion"
    MNClefSoprano = 6,        // "soprano"
    MNClefMezzoSoprano = 7,   // "mezzo-soprano"
    MNClefBaritoneC = 8,      // "baritone-c"
    MNClefBaritoneF = 9,      // "baritone-f"
    MNClefSubBass = 10,       // "subbass"
    MNClefFrench = 11,        // "french"
    MNClefMovableC = 12,      // "moveable-c"
};

/* Stem direction
 */
typedef NS_ENUM(NSInteger, MNStemDirectionType)
{
    MNStemDirectionUp = 1,
    MNStemDirectionNone = 0,
    MNStemDirectionDown = -1,
};

/*! Log level
 */
typedef NS_ENUM(NSInteger, MNLogLevelType)
{
    debug = 1,
    info = 2,
    logWarn = 3,
    error = 4,
    fatal = 5,
};

/*! Modes allow the addition of ticks in three different ways:
 *
 *  STRICT: This is the default. Ticks must fill the voice.
 *  SOFT:   Ticks can be added without restrictions.
 *  FULL:   Ticks do not need to fill the voice, but can't exceed the maximum
 *      tick length.
 */
typedef NS_ENUM(NSUInteger, MNModeType)
{
    //    None = 0,
    MNModeStrict = 1,
    MNModeSoft = 2,
    MNModeFull = 3,
};

/*! Standard time signatures
 */
typedef NS_ENUM(NSUInteger, MNTimeType)
{
    MNTime4_4 = 1,
    MNTime3_4 = 2,
    MNTime2_4 = 3,
    MNTime4_2 = 4,
    MNTime2_2 = 5,
    MNTime3_8 = 6,
    MNTime6_8 = 7,
    MNTime9_8 = 8,
    MNTime12_8 = 9,

    MNTime1_2 = 10,
    MNTime3_2 = 11,
    MNTime1_4 = 12,
    MNTime1_8 = 13,
    MNTime2_8 = 14,
    MNTime4_8 = 15,
    MNTime1_16 = 16,
    MNTime2_16 = 17,
    MNTime3_16 = 18,
    MNTime4_16 = 19,

    // TODO: add this to methods
    MNTimeC = 20,
    MNTime5_4 = 21,
    MNTime5_8 = 22,
    MNTime13_16 = 23,
};

/*! stroke direction
 */
typedef NS_ENUM(NSInteger, MNStrokeDirectionType)
{
    MNStrokeDirectionDown = -1,
    MNStrokeDirectionUp = 1,
};

/*! curve direction
 */
typedef NS_ENUM(NSInteger, MNCurveDirectionType)
{
    MNCurveDirectionDown = -1,
    MNCurveDirectionUp = 1,
};

/*! stroke types
 */
typedef NS_ENUM(NSUInteger, MNStrokeType)
{
    MNStrokeBrushDown = 1,
    MNStrokeBrushUp = 2,
    MNStrokeRollDown = 3,   // Arpegiated chord
    MNStrokeRollUp = 4,     // Arpegiated chord
    MNStrokeRasquedoDown = 5,
    MNStrokeRasquedoUp = 6,
};

/*! Note durations
 */
typedef NS_ENUM(NSInteger, MNNoteDurationType)
{
    MNDurationNone = -1,
    MNDurationBreveNote = 0,
    MNDurationWholeNote = 1,
    MNDurationHalfNote = 2,
    MNDurationQuarterNote = 4,
    MNDurationEighthNote = 8,
    MNDurationSixteenthNote = 16,
    MNDurationThirtyTwoNote = 32,
    MNDurationSixtyFourNote = 64,
    MNDurationOneTwentyEightNote = 128,
    MNDurationTwoFiftySixNote = 256,
};

/*! tuplet types
 */
typedef NS_ENUM(NSUInteger, MNTupletLocationType)
{
    MNTupletLocationNone = 0,
    MNTupletLocationTop = 1,
    MNTupletLocationBottom = -1,
};

///*! staff connector types
// */
// typedef NS_ENUM(NSUInteger, MNStaffConnectorType) {
//    MNStaffConnectorSingle = 1,
//    MNStaffConnectorDouble = 2,
//    MNStaffConnectorBrace = 3,
//    MNStaffConnectorBracket = 4,
//};

/*! key signatures
 */
typedef NS_ENUM(NSUInteger, MNKeySignatureNoteType)
{
    MNKeySignatureNone = 0,         //
    MNKeySignatureSharp = 1,        // "sharp"
    MNKeySignatureFlat = 2,         // "flat"
    MNKeySignatureNatural = 3,      // "natural"
    MNKeySignatureTriangle = 4,     // "triangle"
    MNKeySignatureOWithSlash = 5,   // "o-with-slash"
    MNKeySignatureDegrees = 6,      // "degrees"
    MNKeySignatureCircle = 7,       // "circle"
};

/*! types of modifier categories
 */
typedef NS_ENUM(NSUInteger, MNSymbolCategoryType)
{
    MNSymbolCategoryStaffNote = 0,
    MNSymbolCategoryTabNote = 1,
    MNSymbolCategoryAccidental = 2,
    MNSymbolCategoryArticulation = 3,
    MNSymbolCategoryBeam = 4,
    MNSymbolCategoryStaffBarLine = 5,
    MNSymbolCategoryStaffConnector = 6,
};

/*! staff repetition type
 */
typedef NS_ENUM(NSUInteger, MNRepetitionType)
{
    MNRepNone = 1,         // no coda or segno
    MNRepCodaLeft = 2,     // coda at beginning of Staff
    MNRepCodaRight = 3,    // coda at end of Staff
    MNRepSegnoLeft = 4,    // segno at beginning of Staff
    MNRepSegnoRight = 5,   // segno at end of Staff
    MNRepDC = 6,           // D.C. at end of Staff
    MNRepDCALCoda = 7,     // D.C. al coda at end of Staff
    MNRepDCALFine = 8,     // D.C. al Fine end of Staff
    MNRepDS = 9,           // D.S. at end of Staff
    MNRepDSALCoda = 10,    // D.S. al coda at end of Staff
    MNRepDSALFine = 11,    // D.S. al Fine at end of Staff
    MNRepFine = 12,        // Fine at end of Staff
};

/*! volta type
 */
typedef NS_ENUM(NSUInteger, MNVoltaType)
{
    MNVoltaNona = 1,
    MNVoltaBegin = 2,
    MNVoltaMid = 3,
    MNVoltaEnd = 4,
    MNVoltaBeginEnd = 5,
};

/*! articulation type
 */
typedef NS_ENUM(NSUInteger, MNArticulationType)
{
    MNArticulationStacato = 0,                     //  a.
    MNArticulationStaccatissimo = 1,               //  av
    MNArticulationAccent = 2,                      //  a>
    MNArticulationTenuto = 3,                      //  a-
    MNArticulationMarcato = 4,                     //  a^
    MNArticulationLeftHandPizzicato = 5,           //  a+
    MNArticulationSnapPizzicato = 6,               //  ao
    MNArticulationNaturalHarmonicOrOpenNote = 7,   //  ah
    MNArticulationFermataAboveStaff = 8,           //  a@a
    MNArticulationFermataBelowStaff = 9,           //  a@u
    MNArticulationBowUpDashUpStroke = 10,          //  a|
    MNArticulationBowDownDashDownStroke = 11,      //  am
    MNArticulationChoked = 12,                     //  a,
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNStaffConnectorType)
{
    MNStaffConnectorNone = 0,
    MNStaffConnectorSingleRight = 1,
    MNStaffConnectorSingleLeft = 2,
    MNStaffConnectorSingle = 3,
    MNStaffConnectorDouble = 4,
    MNStaffConnectorBrace = 5,
    MNStaffConnectorBracket = 6,
    MNStaffConnectorBoldDoubleLeft = 7,
    MNStaffConnectorBoldDoubleRight = 8,
    MNStaffConnectorThinDouble = 9
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNJustiticationType)
{
    MNJustifyLEFT = 1,
    MNJustifyCENTER = 2,
    MNJustifyRIGHT = 3,
    MNJustifyCENTER_STEM = 4
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNVerticalJustifyType)
{
    MNVerticalJustifyTOP = 1,
    MNVerticalJustifyCENTER = 2,
    MNVerticalJustifyBOTTOM = 3,
    MNVerticalJustifyCENTER_STEM = 4
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNStaffLineJustiticationType)
{
    MNStaffLineJustifyLEFT = 1,
    MNStaffLineJustifyCENTER = 2,
    MNStaffLineJustifyRIGHT = 3,
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNStaffLineVerticalJustifyType)
{
    MNStaffLineVerticalJustifyTOP = 1,
    MNStaffLineVerticalJustifyBOTTOM = 2,
};

// typedef NS_ENUM(NSUInteger, MNBendType) {
//    MNBendUP   = 0,
//    MNBendDOWN = 1,
//};

/*!
 */
typedef NS_ENUM(NSUInteger, MNBendDirectionType)
{
    MNBendUP = 1,
    MNBendNONE = 0,
    MNBendX = MNBendNONE,
    MNBendDOWN = -1,
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNOrnamentType)
{
    MNOrnament_MORDENT = 0,
    MNOrnament_MORDENT_INVERTED = 1,
    MNOrnament_TURN = 2,
    MNOrnament_TURN_INVERTED = 3,
    MNOrnament_TR = 4,
    MNOrnament_UPPRALL = 5,
    MNOrnament_DOWNPRALL = 6,
    MNOrnament_PRALLUP = 7,
    MNOrnament_PRALLDOWN = 8,
    MNOrnament_UPMORDENT = 9,
    MNOrnament_DOWNMORDENT = 10,
    MNOrnament_LINEPRALL = 11,
    MNOrnament_PRALLPRALL = 12,
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNAccidentalType)
{
    MNAccidental_Hash = 0,
    MNAccidental_HashHash = 1,
    MNAccidental_b = 2,
    MNAccidental_bb = 3,
    MNAccidental_n = 4,
    MNAccidental_LeftParen = 5,
    MNAccidental_RightParen = 6,
    MNAccidental_db = 7,
    MNAccidental_d = 8,
    MNAccidental_bbs = 9,
    MNAccidental_PlusPlus = 10,
    MNAccidental_Plus = 11,
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNKeySignatureType)
{
    MNKeySignature_C = 0,          //    "C"
    MNKeySignature_Am = 1,         //    "Am"
    MNKeySignature_F = 2,          //    "F"
    MNKeySignature_Dm = 3,         //    "Dm"
    MNKeySignature_Bb = 4,         //    "Bb"
    MNKeySignature_Gm = 5,         //    "Gm"
    MNKeySignature_Eb = 6,         //    "Eb"
    MNKeySignature_Cm = 7,         //    "Cm"
    MNKeySignature_Ab = 8,         //    "Ab"
    MNKeySignature_Fm = 9,         //    "Fm"
    MNKeySignature_Db = 10,        //    "Db"
    MNKeySignature_Bbm = 11,       //    "Bbm"
    MNKeySignature_Gb = 12,        //    "Gb"
    MNKeySignature_Ebm = 13,       //    "Ebm"
    MNKeySignature_Cb = 14,        //    "Cb"
    MNKeySignature_Abm = 15,       //    "Abm"
    MNKeySignature_G = 16,         //    "G"
    MNKeySignature_Em = 17,        //    "Em"
    MNKeySignature_D = 18,         //    "D"
    MNKeySignature_Bm = 19,        //    "Bm"
    MNKeySignature_A = 20,         //    "A"
    MNKeySignature_FSharpm = 21,   //    "F#m"
    MNKeySignature_E = 22,         //    "E"
    MNKeySignature_CSharpm = 23,   //    "C#m"
    MNKeySignature_B = 24,         //    "B"
    MNKeySignature_GSharpm = 25,   //    "G#m"
    MNKeySignature_FSharp = 26,    //    "F#"
    MNKeySignature_DSharpm = 27,   //    "D#m"
    MNKeySignature_CSharp = 28,    //    "C#"
    MNKeySignature_ASharpm = 29,   //    "A#m"
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNNotePitchType)
{
    MNNotePitch_C = 0,          //    "C"
    MNNotePitch_C_SHARP = 1,    //    "C#"
    MNNotePitch_D = 2,          //    "D"
    MNNotePitch_D_SHARP = 3,    //    "D#"
    MNNotePitch_E = 4,          //    "E"
    MNNotePitch_F = 5,          //    "F"
    MNNotePitch_F_SHARP = 6,    //    "F#"
    MNNotePitch_G = 7,          //    "G"
    MNNotePitch_G_SHARP = 8,    //    "G#"
    MNNotePitch_A = 9,          //    "A"
    MNNotePitch_A_SHARP = 10,   //    "A#"
    MNNotePitch_B = 11,         //    "B"
};

/*!
 */
typedef NS_ENUM(NSInteger, MNStaffHairpinType)
{
    MNStaffHairpinCres = 1,
    MNStaffHairpinDescres = 2,
};

/*!
 */
typedef NS_ENUM(NSInteger, MNCurveType)
{
    MNCurveNearHead = 1,
    MNCurveNearTop = 2,
};

/*!
 */
typedef NS_ENUM(NSInteger, MNPedalMarkingType)
{
    MNPedalMarkingText = 1,
    MNPedalMarkingBracket = 2,
    MNPedalMarkingMixed = 3
};

/* Tab Slide direction
 */
typedef NS_ENUM(NSInteger, MNTabSlideType)
{
    MNTabSlideSLIDE_UP = 1,
    MNTabSlideSLIDE_DOWN = -1,
};

/*!
 */
typedef NS_ENUM(NSInteger, MNTextBracketPosition)
{
    MNTextBrackTop = 1,
    MNTextBracketBottom = -1,
};

/*! String Number end type
 */
typedef NS_ENUM(NSInteger, MNLineEndType)
{
    // NONE: 1,        // No leg
    // UP: 2,          // Upward leg
    // DOWN: 3         // Downward leg

    MNLineEndTypeNONE = 1,
    MNLineEndTypeUP = 2,
    MNLineEndTypeDOWN = 3,
};

/*!
 */
typedef NS_ENUM(NSUInteger, MNGlyphNameType)
{
    MNGlyphName_v0 = 0,
    MNGlyphName_v1 = 1,
    MNGlyphName_v2 = 2,
    MNGlyphName_v3 = 3,
    MNGlyphName_v4 = 4,
    MNGlyphName_v5 = 5,
    MNGlyphName_v6 = 6,
    MNGlyphName_v7 = 7,
    MNGlyphName_v8 = 8,
    MNGlyphName_v9 = 9,
    MNGlyphName_va = 10,
    MNGlyphName_vb = 11,
    MNGlyphName_vc = 12,
    MNGlyphName_vd = 13,
    MNGlyphName_ve = 14,
    MNGlyphName_vf = 15,
    MNGlyphName_v10 = 16,
    MNGlyphName_v11 = 17,
    MNGlyphName_v12 = 18,
    MNGlyphName_v13 = 19,
    MNGlyphName_v14 = 20,
    MNGlyphName_v15 = 21,
    MNGlyphName_v16 = 22,
    MNGlyphName_v17 = 23,
    MNGlyphName_v18 = 24,
    MNGlyphName_v19 = 25,
    MNGlyphName_v1a = 26,
    MNGlyphName_v1b = 27,
    MNGlyphName_v1c = 28,
    MNGlyphName_v1d = 29,
    MNGlyphName_v1e = 30,
    MNGlyphName_v1f = 31,
    MNGlyphName_v20 = 32,
    MNGlyphName_v21 = 33,
    MNGlyphName_v22 = 34,
    MNGlyphName_v23 = 35,
    MNGlyphName_v24 = 36,
    MNGlyphName_v25 = 37,
    MNGlyphName_v26 = 38,
    MNGlyphName_v27 = 39,
    MNGlyphName_v28 = 40,
    MNGlyphName_v29 = 41,
    MNGlyphName_v2a = 42,
    MNGlyphName_v2b = 43,
    MNGlyphName_v2c = 44,
    MNGlyphName_v2d = 45,
    MNGlyphName_v2e = 46,
    MNGlyphName_v2f = 47,
    MNGlyphName_v30 = 48,
    MNGlyphName_v31 = 49,
    MNGlyphName_v32 = 50,
    MNGlyphName_v33 = 51,
    MNGlyphName_v34 = 52,
    MNGlyphName_v35 = 53,
    MNGlyphName_v36 = 54,
    MNGlyphName_v37 = 55,
    MNGlyphName_v38 = 56,
    MNGlyphName_v39 = 57,
    MNGlyphName_v3a = 58,
    MNGlyphName_v3b = 59,
    MNGlyphName_v3c = 60,
    MNGlyphName_v3d = 61,
    MNGlyphName_v3e = 62,
    MNGlyphName_v3f = 63,
    MNGlyphName_v40 = 64,
    MNGlyphName_v41 = 65,
    MNGlyphName_v42 = 66,
    MNGlyphName_v43 = 67,
    MNGlyphName_v44 = 68,
    MNGlyphName_v45 = 69,
    MNGlyphName_v46 = 70,
    MNGlyphName_v47 = 71,
    MNGlyphName_v48 = 72,
    MNGlyphName_v49 = 73,
    MNGlyphName_v4a = 74,
    MNGlyphName_v4b = 75,
    MNGlyphName_v4c = 76,
    MNGlyphName_v4d = 77,
    MNGlyphName_v4e = 78,
    MNGlyphName_v4f = 79,
    MNGlyphName_v50 = 80,
    MNGlyphName_v51 = 81,
    MNGlyphName_v52 = 82,
    MNGlyphName_v53 = 83,
    MNGlyphName_v54 = 84,
    MNGlyphName_v55 = 85,
    MNGlyphName_v56 = 86,
    MNGlyphName_v57 = 87,
    MNGlyphName_v58 = 88,
    MNGlyphName_v59 = 89,
    MNGlyphName_v5a = 90,
    MNGlyphName_v5b = 91,
    MNGlyphName_v5c = 92,
    MNGlyphName_v5d = 93,
    MNGlyphName_v5e = 94,
    MNGlyphName_v5f = 95,
    MNGlyphName_v60 = 96,
    MNGlyphName_v61 = 97,
    MNGlyphName_v62 = 98,
    MNGlyphName_v63 = 99,
    MNGlyphName_v64 = 100,
    MNGlyphName_v65 = 101,
    MNGlyphName_v66 = 102,
    MNGlyphName_v67 = 103,
    MNGlyphName_v68 = 104,
    MNGlyphName_v69 = 105,
    MNGlyphName_v6a = 106,
    MNGlyphName_v6b = 107,
    MNGlyphName_v6c = 108,
    MNGlyphName_v6d = 109,
    MNGlyphName_v6e = 110,
    MNGlyphName_v6f = 111,
    MNGlyphName_v70 = 112,
    MNGlyphName_v71 = 113,
    MNGlyphName_v72 = 114,
    MNGlyphName_v73 = 115,
    MNGlyphName_v74 = 116,
    MNGlyphName_v75 = 117,
    MNGlyphName_v76 = 118,
    MNGlyphName_v77 = 119,
    MNGlyphName_v78 = 120,
    MNGlyphName_v79 = 121,
    MNGlyphName_v7a = 122,
    MNGlyphName_v7b = 123,
    MNGlyphName_v7c = 124,
    MNGlyphName_v7d = 125,
    MNGlyphName_v7e = 126,
    MNGlyphName_v7f = 127,
    MNGlyphName_v80 = 128,
    MNGlyphName_v81 = 129,
    MNGlyphName_v82 = 130,
    MNGlyphName_v83 = 131,
    MNGlyphName_v84 = 132,
    MNGlyphName_v85 = 133,
    MNGlyphName_v86 = 134,
    MNGlyphName_v88 = 135,
    MNGlyphName_v89 = 136,
    MNGlyphName_v8a = 137,
    MNGlyphName_v8b = 138,
    MNGlyphName_v8c = 139,
    MNGlyphName_v8d = 140,
    MNGlyphName_v8e = 141,
    MNGlyphName_v8f = 142,
    MNGlyphName_v90 = 143,
    MNGlyphName_v91 = 144,
    MNGlyphName_v92 = 145,
    MNGlyphName_v93 = 146,
    MNGlyphName_v94 = 148,
    MNGlyphName_v95 = 149,
    MNGlyphName_v96 = 150,
    MNGlyphName_v97 = 151,
    MNGlyphName_v98 = 152,
    MNGlyphName_v99 = 153,
    MNGlyphName_v9a = 154,
    MNGlyphName_v9b = 155,
    MNGlyphName_v9c = 156,
    MNGlyphName_v9d = 157,
    MNGlyphName_v9e = 158,
    MNGlyphName_v9f = 159,
    MNGlyphName_va0 = 160,
    MNGlyphName_va1 = 161,
    MNGlyphName_va2 = 162,
    MNGlyphName_va3 = 163,
    MNGlyphName_va4 = 164,
    MNGlyphName_va5 = 165,
    MNGlyphName_va6 = 166,
    MNGlyphName_va7 = 167,
    MNGlyphName_va8 = 168,
    MNGlyphName_va9 = 169,
    MNGlyphName_vaa = 170,
    MNGlyphName_vab = 171,
    MNGlyphName_vac = 172,
    MNGlyphName_vad = 173,
    MNGlyphName_vae = 174,
    MNGlyphName_vaf = 175,
    MNGlyphName_vb0 = 176,
    MNGlyphName_vb1 = 177,
    MNGlyphName_vb2 = 178,
    MNGlyphName_vb3 = 179,
    MNGlyphName_vb4 = 180,
    MNGlyphName_vb5 = 181,
    MNGlyphName_vb6 = 182,
    MNGlyphName_vb7 = 183,
    MNGlyphName_vb8 = 184,
    MNGlyphName_vb9 = 185,
    MNGlyphName_vba = 186,
    MNGlyphName_vbb = 187,
    MNGlyphName_vbc = 188,
    MNGlyphName_vbd = 189,
    MNGlyphName_vbe = 190,
    MNGlyphName_vbf = 191,
    MNGlyphName_vc0 = 192,
    MNGlyphName_vc1 = 193,
    MNGlyphName_vc2 = 194,
    MNGlyphName_vc3 = 195,
};

// TODO: finish naming the notations
// https://www.wikiwand.com/en/List_of_musical_symbols
typedef NS_ENUM(NSUInteger, MNGlyphRealNameType)
{
    MNGlyphRealName_zero = 0,                // v0
    MNGlyphRealName_one = 1,                 // v1
    MNGlyphRealName_two = 2,                 // v2
    MNGlyphRealName_three = 3,               // v3
    MNGlyphRealName_four = 4,                // v4
    MNGlyphRealName_five = 5,                // v5
    MNGlyphRealName_six = 6,                 // v6
    MNGlyphRealName_seven = 7,               // v7
    MNGlyphRealName_eight = 8,               // v8
    MNGlyphRealName_nine = 9,                // v9
    MNGlyphRealName_va = 10,                 // va
    MNGlyphRealName_quarter_note = 11,       // vb
    MNGlyphRealName_vc = 12,                 // vc
    MNGlyphRealName_vd = 13,                 // vd
    MNGlyphRealName_ve = 14,                 // ve
    MNGlyphRealName_vf = 15,                 // mn
    MNGlyphRealName_v10 = 16,                // v10
    MNGlyphRealName_v11 = 17,                // v11
    MNGlyphRealName_v12 = 18,                // v12
    MNGlyphRealName_v13 = 19,                // v13
    MNGlyphRealName_v14 = 20,                // v14
    MNGlyphRealName_v15 = 21,                // v15
    MNGlyphRealName_v16 = 22,                // v16
    MNGlyphRealName_v17 = 23,                // v17
    MNGlyphRealName_v18 = 24,                // v18
    MNGlyphRealName_v19 = 25,                // v19
    MNGlyphRealName_v1a = 26,                // v1a
    MNGlyphRealName_v1b = 27,                // v1b
    MNGlyphRealName_v1c = 28,                // v1c
    MNGlyphRealName_v1d = 29,                // v1d
    MNGlyphRealName_mordent_upper = 30,      // v1e
    MNGlyphRealName_trill = 31,              // v1f
    MNGlyphRealName_v20 = 32,                // v20
    MNGlyphRealName_v21 = 33,                // v21
    MNGlyphRealName_v22 = 34,                // v22
    MNGlyphRealName_v23 = 35,                // v23
    MNGlyphRealName_v24 = 36,                // v24
    MNGlyphRealName_v25 = 37,                // v25
    MNGlyphRealName_v26 = 38,                // v26
    MNGlyphRealName_v27 = 39,                // v27
    MNGlyphRealName_v28 = 40,                // v28
    MNGlyphRealName_v29 = 41,                // v29
    MNGlyphRealName_v2a = 42,                // v2a
    MNGlyphRealName_v2b = 43,                // v2b
    MNGlyphRealName_v2c = 44,                // v2c
    MNGlyphRealName_v2d = 45,                // v2d
    MNGlyphRealName_v2e = 46,                // v2e
    MNGlyphRealName_v2f = 47,                // v2f
    MNGlyphRealName_v30 = 48,                // v30
    MNGlyphRealName_v31 = 49,                // v31
    MNGlyphRealName_v32 = 50,                // v32
    MNGlyphRealName_turn_inverted = 51,      // v33
    MNGlyphRealName_caesura_straight = 52,   // v34
    MNGlyphRealName_v35 = 53,                // v35
    MNGlyphRealName_pedal_open = 54,         // v36
    MNGlyphRealName_v37 = 55,                // v37
    MNGlyphRealName_v38 = 56,                // v38
    MNGlyphRealName_v39 = 57,                // v39
    MNGlyphRealName_v3a = 58,                // v3a
    MNGlyphRealName_v3b = 59,                // v3b
    MNGlyphRealName_v3c = 60,                // v3c
    MNGlyphRealName_v3d = 61,                // v3d
    MNGlyphRealName_v3e = 62,                // v3e
    MNGlyphRealName_v3f = 63,                // v3f
    MNGlyphRealName_v40 = 64,                // v40
    MNGlyphRealName_v41 = 65,                // v41
    MNGlyphRealName_v42 = 66,                // v42
    MNGlyphRealName_v43 = 67,                // v43
    MNGlyphRealName_v44 = 68,                // v44
    MNGlyphRealName_mordent_lower = 69,      // v45
    MNGlyphRealName_v46 = 70,                // v46
    MNGlyphRealName_v47 = 71,                // v47
    MNGlyphRealName_v48 = 72,                // v48
    MNGlyphRealName_v49 = 73,                // v49
    MNGlyphRealName_v4a = 74,                // v4a
    MNGlyphRealName_caesura_curved = 75,     // v4b
    MNGlyphRealName_v4c = 76,                // v4c
    MNGlyphRealName_coda = 77,               // v4d
    MNGlyphRealName_v4e = 78,                // v4e
    MNGlyphRealName_v4f = 79,                // v4f
    MNGlyphRealName_v50 = 80,                // v50
    MNGlyphRealName_v51 = 81,                // v51
    MNGlyphRealName_v52 = 82,                // v52
    MNGlyphRealName_v53 = 83,                // v53
    MNGlyphRealName_v54 = 84,                // v54
    MNGlyphRealName_v55 = 85,                // v55
    MNGlyphRealName_v56 = 86,                // v56
    MNGlyphRealName_v57 = 87,                // v57
    MNGlyphRealName_v58 = 88,                // v58
    MNGlyphRealName_v59 = 89,                // v59
    MNGlyphRealName_v5a = 90,                // v5a
    MNGlyphRealName_v5b = 91,                // v5b
    MNGlyphRealName_v5c = 92,                // v5c
    MNGlyphRealName_pedal_close = 93,        // v5d
    MNGlyphRealName_v5e = 94,                // v5e
    MNGlyphRealName_v5f = 95,                // v5f
    MNGlyphRealName_v60 = 96,                // v60
    MNGlyphRealName_v61 = 97,                // v61
    MNGlyphRealName_v62 = 98,                // v62
    MNGlyphRealName_v63 = 99,                // v63
    MNGlyphRealName_v64 = 100,               // v64
    MNGlyphRealName_v65 = 101,               // v65
    MNGlyphRealName_v66 = 102,               // v66
    MNGlyphRealName_v67 = 103,               // v67
    MNGlyphRealName_v68 = 104,               // v68
    MNGlyphRealName_v69 = 105,               // v69
    MNGlyphRealName_v6a = 106,               // v6a
    MNGlyphRealName_v6b = 107,               // v6b
    MNGlyphRealName_breath = 108,            // v6c
    MNGlyphRealName_v6d = 109,               // v6d
    MNGlyphRealName_v6e = 110,               // v6e
    MNGlyphRealName_tick = 111,              // v6f
    MNGlyphRealName_v70 = 112,               // v70
    MNGlyphRealName_v71 = 113,               // v71
    MNGlyphRealName_turn = 114,              // v72
    MNGlyphRealName_v73 = 115,               // v73
    MNGlyphRealName_v74 = 116,               // v74
    MNGlyphRealName_v75 = 117,               // v75
    MNGlyphRealName_v76 = 118,               // v76
    MNGlyphRealName_v77 = 119,               // v77
    MNGlyphRealName_v78 = 120,               // v78
    MNGlyphRealName_v79 = 121,               // v79
    MNGlyphRealName_v7a = 122,               // v7a
    MNGlyphRealName_v7b = 123,               // v7b
    MNGlyphRealName_v7c = 124,               // v7c
    MNGlyphRealName_v7d = 125,               // v7d
    MNGlyphRealName_v7e = 126,               // v7e
    MNGlyphRealName_v7f = 127,               // v7f
    MNGlyphRealName_v80 = 128,               // v80
    MNGlyphRealName_v81 = 129,               // v81
    MNGlyphRealName_v82 = 130,               // v82
    MNGlyphRealName_v83 = 131,               // v83
    MNGlyphRealName_v84 = 132,               // v84
    MNGlyphRealName_v85 = 133,               // v85
    MNGlyphRealName_v86 = 134,               // v86
    MNGlyphRealName_v88 = 135,               // v88
    MNGlyphRealName_v89 = 136,               // v89
    MNGlyphRealName_v8a = 137,               // v8a
    MNGlyphRealName_v8b = 138,               // v8b
    MNGlyphRealName_segno = 139,             // v8c
    MNGlyphRealName_v8d = 140,               // v8d
    MNGlyphRealName_v8e = 141,               // v8e
    MNGlyphRealName_v8f = 142,               // v8f
    MNGlyphRealName_v90 = 143,               // v90
    MNGlyphRealName_v91 = 144,               // v91
    MNGlyphRealName_v92 = 145,               // v92
    MNGlyphRealName_v93 = 146,               // v93
    MNGlyphRealName_v94 = 148,               // v94
    MNGlyphRealName_v95 = 149,               // v95
    MNGlyphRealName_v96 = 150,               // v96
    MNGlyphRealName_v97 = 151,               // v97
    MNGlyphRealName_v98 = 152,               // v98
    MNGlyphRealName_v99 = 153,               // v99
    MNGlyphRealName_v9a = 154,               // v9a
    MNGlyphRealName_v9b = 155,               // v9b
    MNGlyphRealName_v9c = 156,               // v9c
    MNGlyphRealName_v9d = 157,               // v9d
    MNGlyphRealName_v9e = 158,               // v9e
    MNGlyphRealName_v9f = 159,               // v9f
    MNGlyphRealName_va0 = 160,               // va0
    MNGlyphRealName_va1 = 161,               // va1
    MNGlyphRealName_va2 = 162,               // va2
    MNGlyphRealName_va3 = 163,               // va3
    MNGlyphRealName_va4 = 164,               // va4
    MNGlyphRealName_va5 = 165,               // va5
    MNGlyphRealName_va6 = 166,               // va6
    MNGlyphRealName_va7 = 167,               // va7
    MNGlyphRealName_va8 = 168,               // va8
    MNGlyphRealName_va9 = 169,               // va9
    MNGlyphRealName_vaa = 170,               // vaa
    MNGlyphRealName_vab = 171,               // vab
    MNGlyphRealName_vac = 172,               // vac
    MNGlyphRealName_vad = 173,               // vad
    MNGlyphRealName_vae = 174,               // vae
    MNGlyphRealName_vaf = 175,               // vaf
    MNGlyphRealName_vb0 = 176,               // vb0
    MNGlyphRealName_vb1 = 177,               // vb1
    MNGlyphRealName_vb2 = 178,               // vb2
    MNGlyphRealName_vb3 = 179,               // vb3
    MNGlyphRealName_vb4 = 180,               // vb4
    MNGlyphRealName_vb5 = 181,               // vb5
    MNGlyphRealName_vb6 = 182,               // vb6
    MNGlyphRealName_vb7 = 183,               // vb7
    MNGlyphRealName_vb8 = 184,               // vb8
    MNGlyphRealName_vb9 = 185,               // vb9
    MNGlyphRealName_vba = 186,               // vba
    MNGlyphRealName_vbb = 187,               // vbb
    MNGlyphRealName_vbc = 188,               // vbc
    MNGlyphRealName_vbd = 189,               // vbd
    MNGlyphRealName_vbe = 190,               // vbe
    MNGlyphRealName_vbf = 191,               // vbf
    MNGlyphRealName_vc0 = 192,               // vc0
    MNGlyphRealName_vc1 = 193,               // vc1
    MNGlyphRealName_vc2 = 194,               // vc2
    MNGlyphRealName_vc3 = 195,               // vc3
};

// TODO: perhaps update to use https://github.com/fastred/ReflectableEnum

@interface MNEnum : NSObject

+ (NSString*)nameForPosition:(MNPositionType)type;
+ (NSString*)nameForDirection:(MNShiftDirectionType)type;
+ (NSString*)nameForNoteType:(MNNoteNHMRSType)type;
+ (MNNoteNHMRSType)typeNoteNHMRSTypeForString:(NSString*)string;
+ (NSString*)nameForBarNoteType:(MNBarNoteType)type;
+ (NSString*)nameForBarLineType:(MNBarLineType)type;
+ (NSString*)nameForClefType:(MNClefType)type;
+ (MNClefType)typeClefTypeForString:(NSString*)string;
+ (NSString*)nameForStemDirectionType:(MNStemDirectionType)type;
+ (NSString*)nameForLogLevelType:(MNLogLevelType)type;
+ (NSString*)nameForModeType:(MNModeType)type;
+ (NSString*)nameForTimeType:(MNTimeType)type;
+ (MNTimeType)typeTimeTypeForString:(NSString*)string;
+ (NSString*)simplNameForTimeType:(MNTimeType)type;
+ (NSString*)nameForStrokeDirectionType:(MNStrokeDirectionType)type;
+ (NSString*)nameForStrokeType:(MNStrokeType)type;
+ (MNStrokeType)typeStrokeTypeForString:(NSString*)string;
+ (NSString*)nameForNoteDurationType:(MNNoteDurationType)type;
+ (MNNoteDurationType)typeNoteDurationTypeForString:(NSString*)string;
+ (NSString*)nameForTupletLocationType:(MNTupletLocationType)type;
+ (NSString*)nameForKeySignatureNoteType:(MNKeySignatureNoteType)type;
+ (NSString*)nameForSymbolCategory:(MNSymbolCategoryType)type;
+ (NSString*)nameForRepetitionType:(MNRepetitionType)type;
+ (NSString*)nameForVoltaType:(MNVoltaType)type;
+ (NSString*)nameForArticulationType:(MNArticulationType)type;
+ (MNArticulationType)typeArticulationTypeForString:(NSString*)string;
+ (NSString*)nameForStaffConnType:(MNStaffConnectorType)type;
+ (NSString*)nameForJustiticationType:(MNJustiticationType)type;
+ (NSString*)nameForVerticalJustifyType:(MNVerticalJustifyType)type;
+ (NSString*)nameForBendType:(MNBendDirectionType)type;
+ (NSString*)nameForOrnamentType:(MNOrnamentType)type;
+ (MNOrnamentType)typeOrnamentTypeForString:(NSString*)string;
+ (NSString*)nameForAccidentalType:(MNAccidentalType)type;
+ (MNAccidentalType)typeAccidentalTypeForString:(NSString*)string;
+ (NSString*)nameForKeySignatureType:(MNKeySignatureType)type;
+ (MNKeySignatureType)typeKeySignatureTypeForString:(NSString*)string;
+ (NSString*)nameForNotePitchType:(MNNotePitchType)type;
+ (MNNotePitchType)typeNotePitchTypeForString:(NSString*)string;
+ (NSString*)nameForGlyphNameType:(MNGlyphNameType)type;
+ (NSString*)categoryNameForGlyphNameType:(MNGlyphNameType)type;
+ (MNGlyphNameType)typeGlyphNameTypeForString:(NSString*)string;
@end
