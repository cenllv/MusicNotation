//
//  MNEnum.m
//  MusicNotation
//
//  Created by Scott on 3/26/15.
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

#import "MNEnum.h"
#import "MNUtils.h"

@implementation MNEnum

// prevent subclassing
// http://stackoverflow.com/a/19194900/629014
+ (id)allocWithZone:(struct _NSZone*)zone
{
    if(self != [MNEnum class])
    {
        NSAssert(nil, @"Subclassing MNEnum not allowed.");
        abort();
        return nil;
    }
    return [super allocWithZone:zone];
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [NSException raise:NSInternalInconsistencyException
                    format:@"This class is abstract: %@", NSStringFromSelector(_cmd)];
    }
    return self;
}

+ (NSString*)nameForPosition:(MNPositionType)type
{
    switch(type)
    {
        case MNPositionLeft:
            return @"PositionLeft";
            break;
        case MNPositionRight:
            return @"PositionRight";
            break;
        case MNPositionAbove:
            return @"PositionAbove";
            break;
        case MNPositionBelow:
            return @"PositionBelow";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForDirection:(MNShiftDirectionType)type
{
    switch(type)
    {
        case MNShiftUp:
            return @"ShiftUp";
            break;
        case MNShiftDown:
            return @"ShiftDown";
            break;
        case MNShiftLeft:
            return @"ShiftLeft";
            break;
        case MNShiftRight:
            return @"ShiftRight";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForNoteType:(MNNoteNHMRSType)type
{
    switch(type)
    {
        //        case MNNoteNone:
        //            return @"NoteNone";
        //            break;
        case MNNoteX:
            return @"NoteX";
            break;
        case MNNoteSlash:
            return @"NoteS";
            break;
        case MNNoteHarmonic:
            return @"NoteH";
            break;
        case MNNoteRest:
            return @"NoteR";
            break;
        case MNNoteNote:
            return @"NoteN";
            break;
        case MNNoteMuted:
            return @"NoteM";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeNoteNHMRSTypeForString;
+ (MNNoteNHMRSType)typeNoteNHMRSTypeForString:(NSString*)string
{
    if(!_typeNoteNHMRSTypeForString)
    {
        _typeNoteNHMRSTypeForString = @{
            @"x" : @(MNNoteX),
            @"s" : @(MNNoteSlash),
            @"h" : @(MNNoteHarmonic),
            @"r" : @(MNNoteRest),
            @"n" : @(MNNoteNote),
            @"m" : @(MNNoteMuted),
            //            @"" : @(MNNoteNone),
        };
    }
    return [_typeNoteNHMRSTypeForString[string] unsignedIntegerValue];
}

+ (NSString*)nameForBarNoteType:(MNBarNoteType)type
{
    switch(type)
    {
        case MNBarNoteSingle:
            return @"BarNoteSingle";
            break;
        case MNBarNoteDouble:
            return @"BarNoteDouble";
            break;
        case MNBarNoteEnd:
            return @"BarNoteEnd";
            break;
        case MNBarNoteRepeatBegin:
            return @"BarNoteRepeatBegin";
            break;
        case MNBarNoteRepeatEnd:
            return @"BarNoteRepeatEnd";
            break;
        case MNBarNoteRepeatBoth:
            return @"BarNoteRepeatBoth";
            break;
        case MNBarNoteNone:
            return @"BarNoteNone";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForBarLineType:(MNBarLineType)type
{
    switch(type)
    {
        case MNBarLineNone:
            return @"BarLineNone";
            break;
        case MNBarLineSingle:
            return @"BarLineSingle";
            break;
        case MNBarLineDouble:
            return @"BarLineDouble";
            break;
        case MNBarLineEnd:
            return @"BarLineEnd";
            break;
        case MNBarLineRepeatBegin:
            return @"BarLineRepeatBegin";
            break;
        case MNBarLineRepeatEnd:
            return @"BarLineRepeatEnd";
            break;
        case MNBarLineRepeatBoth:
            return @"BarLineRepeatBoth";
            break;

        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForClefType:(MNClefType)type
{
    switch(type)
    {
        case MNClefTreble:
            return @"ClefTreble";
            break;
        case MNClefAlto:
            return @"ClefAlto";
            break;
        case MNClefBaritoneC:
            return @"ClefBaritoneC";
            break;
        case MNClefBaritoneF:
            return @"ClefBaritoneF";
            break;
        case MNClefBass:
            return @"ClefBass";
            break;
        case MNClefFrench:
            return @"ClefFrench";
            break;
        case MNClefMezzoSoprano:
            return @"ClefMezzoSoprano";
            break;
        case MNClefMovableC:
            return @"ClefMovableC";
            break;
        case MNClefPercussion:
            return @"ClefPercussion";
            break;
        case MNClefSoprano:
            return @"ClefSoprano";
            break;
        case MNClefSubBass:
            return @"ClefSubBass";
            break;
        case MNClefTenor:
            return @"ClefTenor";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeClefTypeForString;
+ (MNClefType)typeClefTypeForString:(NSString*)string
{
    if(!_typeClefTypeForString)
    {
        _typeClefTypeForString = @{
            @"treble" : @(MNClefTreble),
            @"alto" : @(MNClefAlto),
            @"baritone-c" : @(MNClefBaritoneC),
            @"baritone-f" : @(MNClefBaritoneF),
            @"bass" : @(MNClefBass),
            @"french" : @(MNClefFrench),
            @"soprano" : @(MNClefMezzoSoprano),
            @"moveable-c" : @(MNClefMovableC),
            @"percussion" : @(MNClefPercussion),
            @"soprano" : @(MNClefSoprano),
            @"subbass" : @(MNClefSubBass),
            @"tenor" : @(MNClefTenor),
        };
    }
    return [_typeClefTypeForString[string] unsignedIntegerValue];
}

+ (NSString*)nameForStemDirectionType:(MNStemDirectionType)type
{
    switch(type)
    {
        case MNStemDirectionUp:
            return @"StemDirectionUp";
            break;
        case MNStemDirectionNone:
            return @"StemDirectionNone";
            break;
        case MNStemDirectionDown:
            return @"StemDirectionDown";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForLogLevelType:(MNLogLevelType)type
{
    switch(type)
    {
        case debug:
            return @"debug";
            break;
        case info:
            return @"info";
            break;
        case logWarn:
            return @"warn";
            break;
        case error:
            return @"error";
            break;
        case fatal:
            return @"fatal";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForModeType:(MNModeType)type
{
    switch(type)
    {
        case MNModeStrict:
            return @"ModeStrict";
            break;
        case MNModeSoft:
            return @"ModeSoft";
            break;
        case MNModeFull:
            return @"ModeFull";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForTimeType:(MNTimeType)type
{
    switch(type)
    {
        case MNTime4_4:
            return @"Time4_4";
            break;
        case MNTime3_4:
            return @"Time3_4";
            break;
        case MNTime2_4:
            return @"Time2_4";
            break;
        case MNTime4_2:
            return @"Time4_2";
            break;
        case MNTime2_2:
            return @"Time2_2";
            break;
        case MNTime3_8:
            return @"Time3_8";
            break;
        case MNTime6_8:
            return @"Time6_8";
            break;
        case MNTime9_8:
            return @"Time9_8";
            break;
        case MNTime12_8:
            return @"Time12_8";
            break;
        case MNTime1_2:
            return @"Time1_2";
            break;
        case MNTime3_2:
            return @"Time3_2";
            break;
        case MNTime1_4:
            return @"Time1_4";
            break;
        case MNTime1_8:
            return @"Time1_8";
            break;
        case MNTime2_8:
            return @"Time2_8";
            break;
        case MNTime4_8:
            return @"Time4_8";
            break;
        case MNTime1_16:
            return @"Time1_16";
            break;
        case MNTime2_16:
            return @"Time2_16";
            break;
        case MNTime3_16:
            return @"Time3_16";
            break;
        case MNTime4_16:
            return @"Time4_16";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)simplNameForTimeType:(MNTimeType)type
{
    NSString* ret;
    switch(type)
    {
        case MNTime4_4:
            ret = @"4/4";
            break;
        case MNTime3_4:
            ret = @"3/4";
            break;
        case MNTime2_4:
            ret = @"2/4";
            break;
        case MNTime4_2:
            ret = @"4/2";
            break;
        case MNTime2_2:
            ret = @"2/2";
            break;
        case MNTime3_8:
            ret = @"3/8";
            break;
        case MNTime6_8:
            ret = @"6/8";
            break;
        case MNTime9_8:
            ret = @"9/8";
            break;
        case MNTime12_8:
            ret = @"12/8";
            break;
        case MNTime1_2:
            ret = @"1/2";
            break;
        case MNTime3_2:
            ret = @"3/2";
            break;
        case MNTime1_4:
            ret = @"1/4";
            break;
        case MNTime1_8:
            ret = @"1/8";
            break;
        case MNTime2_8:
            ret = @"2/8";
            break;
        case MNTime4_8:
            ret = @"4/8";
            break;
        case MNTime5_8:
            ret = @"5/8";
            break;
        case MNTime1_16:
            ret = @"1/16";
            break;
        case MNTime2_16:
            ret = @"2/16";
            break;
        case MNTime3_16:
            ret = @"3/16";
            break;
        case MNTime4_16:
            ret = @"4/16";
            break;
        case MNTime13_16:
            ret = @"13/16";
            break;
        case MNTime5_4:
            ret = @"5/4";
            break;
        default:
            MNLogError(@"Unrecognized Time Signature type");
            ret = @"0/0";
            break;
    }
    return ret;
}

static NSDictionary* _typeTimeType;
+ (MNTimeType)typeTimeTypeForString:(NSString*)string
{
    if(!_typeTimeType)
    {
        _typeTimeType = @{
            @"4/4" : @(MNTime4_4),
            @"3/4" : @(MNTime3_4),
            @"2/4" : @(MNTime2_4),
            @"4/2" : @(MNTime4_2),
            @"2/2" : @(MNTime2_2),
            @"3/8" : @(MNTime3_8),
            @"6/8" : @(MNTime6_8),
            @"9/8" : @(MNTime9_8),
            @"12/8" : @(MNTime12_8),
            @"1/2" : @(MNTime1_2),
            @"3/2" : @(MNTime3_2),
            @"1/4" : @(MNTime1_4),
            @"1/8" : @(MNTime1_8),
            @"2/8" : @(MNTime2_8),
            @"4/8" : @(MNTime4_8),
            @"1/16" : @(MNTime1_16),
            @"2/16" : @(MNTime2_16),
            @"3/16" : @(MNTime3_16),
            @"4/16" : @(MNTime4_16),
        };
    }
    return [_typeTimeType[string] unsignedIntegerValue];
}

+ (NSString*)nameForStrokeDirectionType:(MNStrokeDirectionType)type
{
    switch(type)
    {
        case MNStrokeDirectionDown:
            return @"StrokeDirectionDown";
            break;
        case MNStrokeDirectionUp:
            return @"StrokeDirectionUp";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForStrokeType:(MNStrokeType)type
{
    switch(type)
    {
        case MNStrokeBrushDown:
            return @"BrushDown";
            break;
        case MNStrokeBrushUp:
            return @"BrushUp";
            break;
        case MNStrokeRollDown:
            return @"RollDown";
            break;
        case MNStrokeRollUp:
            return @"RollUp";
            break;
        case MNStrokeRasquedoDown:
            return @"RasquedoDown";
            break;
        case MNStrokeRasquedoUp:
            return @"RasquedoUp";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeStrokeType;
+ (MNStrokeType)typeStrokeTypeForString:(NSString*)string
{
    if(!_typeStrokeType)
    {
        _typeStrokeType = @{
            @"brd" : @(MNStrokeBrushDown),
            @"bru" : @(MNStrokeBrushUp),
            @"rod" : @(MNStrokeRollDown),
            @"rou" : @(MNStrokeRollUp),
            @"rad" : @(MNStrokeRasquedoDown),
            @"rau" : @(MNStrokeRasquedoUp),
        };
    }
    return [_typeStrokeType[string] unsignedIntegerValue];
}

+ (NSString*)nameForNoteDurationType:(MNNoteDurationType)type
{
    switch(type)
    {
        case MNDurationNone:
            return @"Duration None";
            break;
        case MNDurationBreveNote:
            return @"Duration Breve Note";
            break;
        case MNDurationWholeNote:
            return @"Duration Whole Note";
            break;
        case MNDurationHalfNote:
            return @"Duration Half Note";
            break;
        case MNDurationQuarterNote:
            return @"Duration Quarter Note";
            break;
        case MNDurationEighthNote:
            return @"Duration Eighth Note";
            break;
        case MNDurationSixteenthNote:
            return @"Duration Sixteenth Note";
            break;
        case MNDurationThirtyTwoNote:
            return @"Duration Thirty Two Note";
            break;
        case MNDurationSixtyFourNote:
            return @"Duration Sixty Four Note";
            break;
        case MNDurationOneTwentyEightNote:
            return @"Duration One Twenty Eight Note";
            break;
        case MNDurationTwoFiftySixNote:
            return @"Duration Two Fifty Six Note";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeNoteDurationTypeForString;
+ (MNNoteDurationType)typeNoteDurationTypeForString:(NSString*)string
{
    if(!_typeNoteDurationTypeForString)
    {
        _typeNoteDurationTypeForString = @{
            @"-1" : @(MNDurationNone),
            @"0" : @(MNDurationBreveNote),
            @"1" : @(MNDurationWholeNote),
            @"2" : @(MNDurationHalfNote),
            @"4" : @(MNDurationQuarterNote),
            @"8" : @(MNDurationEighthNote),
            @"16" : @(MNDurationSixteenthNote),
            @"32" : @(MNDurationThirtyTwoNote),
            @"64" : @(MNDurationSixtyFourNote),
            @"128" : @(MNDurationOneTwentyEightNote),
            @"256" : @(MNDurationTwoFiftySixNote),
            @"w" : @(MNDurationWholeNote),
            @"h" : @(MNDurationHalfNote),
            @"q" : @(MNDurationQuarterNote),
            //           @"8"  : @(MNDurationEighthNote),
            //           @"16"  : @(MNDurationSixteenthNote),
            //           @"32"  : @(MNDurationThirtyTwoNote),
            //           @"64"  : @(MNDurationSixtyFourNote),
            //           @"128"  : @(MNDurationOneTwentyEight),
            //           @"b"  : @(MNDurationTwoFiftySix),
        };
    }
    return [_typeNoteDurationTypeForString[string] unsignedIntegerValue];
}

+ (NSString*)nameForTupletLocationType:(MNTupletLocationType)type
{
    switch(type)
    {
        case MNTupletLocationNone:
            return @"TupletLocationNone";
            break;
        case MNTupletLocationTop:
            return @"TupletLocationTop";
            break;
        case MNTupletLocationBottom:
            return @"TupletLocationBottom";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForKeySignatureNoteType:(MNKeySignatureNoteType)type
{
    switch(type)
    {
        case MNKeySignatureNone:
            return @"KeySignatureNone";
            break;
        case MNKeySignatureSharp:
            return @"KeySignatureSharp";
            break;
        case MNKeySignatureFlat:
            return @"KeySignatureFlat";
            break;
        case MNKeySignatureCircle:
            return @"KeySignatureCircle";
            break;
        case MNKeySignatureDegrees:
            return @"KeySignatureDegrees";
            break;
        case MNKeySignatureNatural:
            return @"KeySignatureNatural";
            break;
        case MNKeySignatureOWithSlash:
            return @"KeySignatureOWithSlash";
            break;
        case MNKeySignatureTriangle:
            return @"KeySignatureTriangle";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForSymbolCategory:(MNSymbolCategoryType)type
{
    switch(type)
    {
        case MNSymbolCategoryStaffNote:
            return @"SymbolCategoryStaffNote";
            break;
        case MNSymbolCategoryTabNote:
            return @"SymbolCategoryTabNote";
            break;
        case MNSymbolCategoryAccidental:
            return @"SymbolCategoryAccidental";
            break;
        case MNSymbolCategoryArticulation:
            return @"SymbolCategoryArticulation";
            break;
        case MNSymbolCategoryBeam:
            return @"SymbolCategoryBeam";
            break;
        case MNSymbolCategoryStaffBarLine:
            return @"SymbolCategoryStaffBarLine";
            break;
        case MNSymbolCategoryStaffConnector:
            return @"SymbolCategoryStaffConnector";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForRepetitionType:(MNRepetitionType)type
{
    switch(type)
    {
        case MNRepNone:
            return @"Rep None";
            break;
        case MNRepCodaLeft:
            return @"Rep Coda Left";
            break;
        case MNRepCodaRight:
            return @"Rep Coda Right";
            break;
        case MNRepSegnoLeft:
            return @"Rep Segno Left";
            break;
        case MNRepSegnoRight:
            return @"Rep Segno Right";
            break;
        case MNRepDC:
            return @"RepDC";
            break;
        case MNRepDCALCoda:
            return @"RepDCALCoda";
            break;
        case MNRepDCALFine:
            return @"RepDCALFine";
            break;
        case MNRepDS:
            return @"RepDS";
            break;
        case MNRepDSALCoda:
            return @"RepDSALCoda";
            break;
        case MNRepDSALFine:
            return @"RepDSALFine";
            break;
        case MNRepFine:
            return @"RepFine";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForVoltaType:(MNVoltaType)type
{
    switch(type)
    {
        case MNVoltaNona:
            return @"Volta Nona";
            break;
        case MNVoltaBegin:
            return @"Volta Begin";
            break;
        case MNVoltaMid:
            return @"Volta Mid";
            break;
        case MNVoltaEnd:
            return @"Volta End";
            break;
        case MNVoltaBeginEnd:
            return @"Volta Begin End";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForArticulationType:(MNArticulationType)type
{
    switch(type)
    {
        case MNArticulationStacato:
            return @"Articulation Stacato";
            break;
        case MNArticulationStaccatissimo:
            return @"Articulation Staccatissimo";
            break;
        case MNArticulationAccent:
            return @"Articulation Accent";
            break;
        case MNArticulationTenuto:
            return @"Articulation Tenuto";
            break;
        case MNArticulationMarcato:
            return @"Articulation Marcato";
            break;
        case MNArticulationLeftHandPizzicato:
            return @"Articulation Left Hand Pizzicato";
            break;
        case MNArticulationSnapPizzicato:
            return @"Articulation Snap Pizzicato";
            break;
        case MNArticulationNaturalHarmonicOrOpenNote:
            return @"Articulation Natural Harmonic Or Open Note";
            break;
        case MNArticulationFermataAboveStaff:
            return @"Articulation Fermata Above Staff";
            break;
        case MNArticulationFermataBelowStaff:
            return @"Articulation Fermata Below Staff";
            break;
        case MNArticulationBowUpDashUpStroke:
            return @"Articulation Bow Up Dash Up Stroke";
            break;
        case MNArticulationBowDownDashDownStroke:
            return @"Articulation Bow Down Dash Down Stroke";
            break;
        case MNArticulationChoked:
            return @"Articulation Choked";
            break;

        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeArticulationTypeForString;
+ (MNArticulationType)typeArticulationTypeForString:(NSString*)string
{
    if(!_typeArticulationTypeForString)
    {
        _typeArticulationTypeForString = @{
            @"a." : @(MNArticulationStacato),
            @"av" : @(MNArticulationStaccatissimo),
            @"a>" : @(MNArticulationAccent),
            @"a-" : @(MNArticulationTenuto),
            @"a^" : @(MNArticulationMarcato),
            @"a+" : @(MNArticulationLeftHandPizzicato),
            @"ao" : @(MNArticulationSnapPizzicato),
            @"ah" : @(MNArticulationNaturalHarmonicOrOpenNote),
            @"a@a" : @(MNArticulationFermataAboveStaff),
            @"a@u" : @(MNArticulationFermataBelowStaff),
            @"a|" : @(MNArticulationBowUpDashUpStroke),
            @"am" : @(MNArticulationBowDownDashDownStroke),
            @"a," : @(MNArticulationChoked),
        };
    }
    return [_typeArticulationTypeForString[string] unsignedIntegerValue];
}

+ (NSString*)nameForStaffConnType:(MNStaffConnectorType)type
{
    switch(type)
    {
        case MNStaffConnectorNone:
            return @"ConnNone";
            break;
        case MNStaffConnectorSingleRight:
            return @"Single Right";
            break;
        case MNStaffConnectorSingleLeft:
            return @"Single Left";
            break;
        case MNStaffConnectorSingle:
            return @"Single";
            break;
        case MNStaffConnectorDouble:
            return @"Double";
            break;
        case MNStaffConnectorBrace:
            return @"Brace";
            break;
        case MNStaffConnectorBracket:
            return @"Bracket";
            break;
        case MNStaffConnectorBoldDoubleLeft:
            return @"Bold Double Left";
            break;
        case MNStaffConnectorBoldDoubleRight:
            return @"Bold Double Right";
            break;
        case MNStaffConnectorThinDouble:
            return @"Thin Double";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForJustiticationType:(MNJustiticationType)type
{
    switch(type)
    {
        case MNJustifyLEFT:
            return @"Justify LEFT";
            break;
        case MNJustifyCENTER:
            return @"Justify CENTER";
            break;
        case MNJustifyRIGHT:
            return @"Justify RIGHT";
            break;
        case MNJustifyCENTER_STEM:
            return @"Justify CENTER_STEM";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForVerticalJustifyType:(MNVerticalJustifyType)type
{
    switch(type)
    {
        case MNVerticalJustifyTOP:
            return @"Vertical Justify TOP";
            break;
        case MNVerticalJustifyCENTER:
            return @"Vertical Justify CENTER";
            break;
        case MNVerticalJustifyBOTTOM:
            return @"Vertical Justify BOTTOM";
            break;
        case MNVerticalJustifyCENTER_STEM:
            return @"Vertical Justify CENTER_STEM";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForBendType:(MNBendDirectionType)type
{
    switch(type)
    {
        case MNBendUP:
            return @"Bend UP";
            break;
        case MNBendDOWN:
            return @"Bend DOWN";
            break;
        case MNBendNONE:
            return @"Bend NONE";
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

+ (NSString*)nameForOrnamentType:(MNOrnamentType)type
{
    switch(type)
    {
        case MNOrnament_DOWNMORDENT:
            return @"Ornament_DOWNMORDENT";
            break;
        case MNOrnament_DOWNPRALL:
            return @"Ornament_DOWNPRALL";
            break;
        case MNOrnament_LINEPRALL:
            return @"Ornament_LINEPRALL";
            break;
        case MNOrnament_MORDENT:
            return @"Ornament_MORDENT";
            break;
        case MNOrnament_MORDENT_INVERTED:
            return @"Ornament_MORDENT_INVERTED";
            break;
        case MNOrnament_PRALLDOWN:
            return @"Ornament_PRALLDOWN";
            break;
        case MNOrnament_PRALLPRALL:
            return @"Ornament_PRALLPRALL";
            break;
        case MNOrnament_PRALLUP:
            return @"Ornament_PRALLUP";
            break;
        case MNOrnament_TR:
            return @"Ornament_TR";
            break;
        case MNOrnament_TURN:
            return @"Ornament_TURN";
            break;
        case MNOrnament_TURN_INVERTED:
            return @"Ornament_TURN_INVERTED";
            break;
        case MNOrnament_UPMORDENT:
            return @"Ornament_UPMORDENT";
            break;
        case MNOrnament_UPPRALL:
            return @"Ornament_UPPRALL";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeOrnamentTypeForString;
+ (MNOrnamentType)typeOrnamentTypeForString:(NSString*)string
{
    if(!_typeOrnamentTypeForString)
    {
        _typeOrnamentTypeForString = @{
            @"mordent" : @(MNOrnament_MORDENT),
            @"mordent_inverted" : @(MNOrnament_MORDENT_INVERTED),
            @"turn" : @(MNOrnament_TURN),
            @"turn_inverted" : @(MNOrnament_TURN_INVERTED),
            @"tr" : @(MNOrnament_TR),
            @"upprall" : @(MNOrnament_UPPRALL),
            @"downprall" : @(MNOrnament_DOWNPRALL),
            @"prallup" : @(MNOrnament_PRALLUP),
            @"pralldown" : @(MNOrnament_PRALLDOWN),
            @"upmordent" : @(MNOrnament_UPMORDENT),
            @"downmordent" : @(MNOrnament_DOWNMORDENT),
            @"lineprall" : @(MNOrnament_LINEPRALL),
            @"prallprall" : @(MNOrnament_PRALLPRALL),
        };
    }
    return [_typeOrnamentTypeForString[string] unsignedIntegerValue];
}

+ (NSString*)nameForAccidentalType:(MNAccidentalType)type
{
    switch(type)
    {
        case MNAccidental_b:
            return @"Accidental_b";
            break;
        case MNAccidental_bb:
            return @"Accidental_bb";
            break;
        case MNAccidental_bbs:
            return @"Accidental_bbs";
            break;
        case MNAccidental_d:
            return @"Accidental_d";
            break;
        case MNAccidental_db:
            return @"Accidental_db";
            break;
        case MNAccidental_Hash:
            return @"Accidental_Hash";
            break;
        case MNAccidental_HashHash:
            return @"Accidental_HashHash";
            break;
        case MNAccidental_LeftParen:
            return @"Accidental_LeftParen";
            break;
        case MNAccidental_n:
            return @"Accidental_n";
            break;
        case MNAccidental_Plus:
            return @"Accidental_Plus";
            break;
        case MNAccidental_PlusPlus:
            return @"Accidental_PlusPlus";
            break;
        case MNAccidental_RightParen:
            return @"Accidental_RightParen";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeAccidentalTypeForString;
+ (MNAccidentalType)typeAccidentalTypeForString:(NSString*)string
{
    if(!_typeAccidentalTypeForString)
    {
        _typeAccidentalTypeForString = @{
            @"b" : @(MNAccidental_b),
            @"bb" : @(MNAccidental_bb),
            @"bbs" : @(MNAccidental_bbs),
            @"d" : @(MNAccidental_d),
            @"db" : @(MNAccidental_db),
            @"#" : @(MNAccidental_Hash),
            @"##" : @(MNAccidental_HashHash),
            @"{" : @(MNAccidental_LeftParen),
            @"n" : @(MNAccidental_n),
            @"+" : @(MNAccidental_Plus),
            @"++" : @(MNAccidental_PlusPlus),
            @"}" : @(MNAccidental_RightParen),
        };
    }
    return [_typeAccidentalTypeForString[string] unsignedIntegerValue];
}

+ (NSString*)nameForKeySignatureType:(MNKeySignatureType)type
{
    switch(type)
    {
        case MNKeySignature_A:
            return @"KeySignature_A";
            break;
        case MNKeySignature_Ab:
            return @"KeySignature_Ab";
            break;
        case MNKeySignature_Abm:
            return @"KeySignature_Abm";
            break;
        case MNKeySignature_Am:
            return @"KeySignature_Am";
            break;
        case MNKeySignature_ASharpm:
            return @"KeySignature_ASharpm";
            break;
        case MNKeySignature_B:
            return @"KeySignature_B";
            break;
        case MNKeySignature_Bb:
            return @"KeySignature_Bb";
            break;
        case MNKeySignature_Bbm:
            return @"KeySignature_Bbm";
            break;
        case MNKeySignature_Bm:
            return @"KeySignature_Bm";
            break;
        case MNKeySignature_C:
            return @"KeySignature_C";
            break;
        case MNKeySignature_Cb:
            return @"KeySignature_Cb";
            break;
        case MNKeySignature_Cm:
            return @"KeySignature_Cm";
            break;
        case MNKeySignature_CSharp:
            return @"KeySignature_CSharp";
            break;
        case MNKeySignature_CSharpm:
            return @"KeySignature_CSharpm";
            break;
        case MNKeySignature_D:
            return @"KeySignature_D";
            break;
        case MNKeySignature_Db:
            return @"KeySignature_Db";
            break;
        case MNKeySignature_Dm:
            return @"KeySignature_Dm";
            break;
        case MNKeySignature_DSharpm:
            return @"KeySignature_DSharp";
            break;
        case MNKeySignature_E:
            return @"KeySignature_E";
            break;
        case MNKeySignature_Eb:
            return @"KeySignature_Eb";
            break;
        case MNKeySignature_Ebm:
            return @"KeySignature_Ebm";
            break;
        case MNKeySignature_Em:
            return @"KeySignature_Em";
            break;
        case MNKeySignature_F:
            return @"KeySignature_F";
            break;
        case MNKeySignature_Fm:
            return @"KeySignature_Fm";
            break;
        case MNKeySignature_FSharp:
            return @"KeySignature_FSharp";
            break;
        case MNKeySignature_FSharpm:
            return @"KeySignature_FSharpm";
            break;
        case MNKeySignature_G:
            return @"KeySignature_G";
            break;
        case MNKeySignature_Gb:
            return @"KeySignature_Gb";
            break;
        case MNKeySignature_Gm:
            return @"KeySignature_Gm";
            break;
        case MNKeySignature_GSharpm:
            return @"KeySignature_GSharpm";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeKeySignatureType;
+ (MNKeySignatureType)typeKeySignatureTypeForString:(NSString*)string
{
    if(!_typeKeySignatureType)
    {
        _typeKeySignatureType = @{
            @"C" : @(MNKeySignature_C),
            @"Am" : @(MNKeySignature_Am),
            @"F" : @(MNKeySignature_F),
            @"Dm" : @(MNKeySignature_Dm),
            @"Bb" : @(MNKeySignature_Bb),
            @"Gm" : @(MNKeySignature_Gm),
            @"Eb" : @(MNKeySignature_Eb),
            @"Cm" : @(MNKeySignature_Cm),
            @"Ab" : @(MNKeySignature_Ab),
            @"Fm" : @(MNKeySignature_Fm),
            @"Db" : @(MNKeySignature_Db),
            @"Bbm" : @(MNKeySignature_Bbm),
            @"Gb" : @(MNKeySignature_Gb),
            @"Ebm" : @(MNKeySignature_Ebm),
            @"Cb" : @(MNKeySignature_Cb),
            @"Abm" : @(MNKeySignature_Abm),
            @"G" : @(MNKeySignature_G),
            @"Em" : @(MNKeySignature_Em),
            @"D" : @(MNKeySignature_D),
            @"Bm" : @(MNKeySignature_Bm),
            @"A" : @(MNKeySignature_A),
            @"F#m" : @(MNKeySignature_FSharpm),
            @"E" : @(MNKeySignature_E),
            @"C#m" : @(MNKeySignature_CSharpm),
            @"B" : @(MNKeySignature_B),
            @"G#m" : @(MNKeySignature_GSharpm),
            @"F#" : @(MNKeySignature_FSharp),
            @"D#m" : @(MNKeySignature_DSharpm),
            @"C#" : @(MNKeySignature_CSharpm),
            @"A#m" : @(MNKeySignature_ASharpm),
        };
    }
    return [_typeKeySignatureType[string] unsignedIntegerValue];
}

+ (NSString*)nameForNotePitchType:(MNNotePitchType)type
{
    switch(type)
    {
        case MNNotePitch_C:
            return @"C";
            break;
        case MNNotePitch_C_SHARP:
            return @"C#";
            break;
        case MNNotePitch_D:
            return @"D";
            break;
        case MNNotePitch_D_SHARP:
            return @"D#";
            break;
        case MNNotePitch_E:
            return @"E";
            break;
        case MNNotePitch_F:
            return @"F";
            break;
        case MNNotePitch_F_SHARP:
            return @"F#";
            break;
        case MNNotePitch_G:
            return @"G";
            break;
        case MNNotePitch_G_SHARP:
            return @"G#";
            break;
        case MNNotePitch_A:
            return @"A";
            break;
        case MNNotePitch_A_SHARP:
            return @"A#";
            break;
        case MNNotePitch_B:
            return @"B";
            break;
        default:
            return @"UNKNOWN";
            break;
    };
    return nil;
}

static NSDictionary* _typeNotePitchType;
+ (MNNotePitchType)typeNotePitchTypeForString:(NSString*)string
{
    if(!_typeNotePitchType)
    {
        _typeNotePitchType = @{
            @"C" : @(MNNotePitch_C),
            @"C#" : @(MNNotePitch_C_SHARP),
            @"D" : @(MNNotePitch_D),
            @"D#" : @(MNNotePitch_D_SHARP),
            @"E" : @(MNNotePitch_E),
            @"F" : @(MNNotePitch_F),
            @"F#" : @(MNNotePitch_F_SHARP),
            @"G" : @(MNNotePitch_G),
            @"G#" : @(MNNotePitch_G_SHARP),
            @"A" : @(MNNotePitch_A),
            @"A#" : @(MNNotePitch_A_SHARP),
            @"B" : @(MNNotePitch_B),
        };
    }
    return [_typeNotePitchType[string] unsignedIntegerValue];
}

+ (NSString*)nameForGlyphNameType:(MNGlyphNameType)type
{
    return @"";
}
+ (NSString*)categoryNameForGlyphNameType:(MNGlyphNameType)type
{
    //    switch ([self indexForName:name]) {
    // TODO: change to a dictionary

    //    static NSDictionary *_namesDictionary = nil;
    //    - (NSString *)nameForCategoryName:(NSString *)category {
    //        if (!_namesDictionary) {
    //            NSDictionary *tmp = @{ @"pedal_depress" : @"v36",
    //                                   @"pedal_release" : @"v5d" };
    //            _namesDictionary = [NSDictionary dictionaryWithDictionary:tmp];
    //
    //        }
    //        return [_namesDictionary objectForKey:category];
    //    }

    switch(type)
    {
        case 0x0:
            return @"zero";
        case 0x1:
            return @"one";
        case 0x2:
            return @"two";
        case 0x3:
            return @"three";
        case 0x4:
            return @"four";
        case 0x5:
            return @"five";
        case 0x6:
            return @"six";
        case 0x7:
            return @"seven";
        case 0x8:
            return @"eight";
        case 0x9:
            return @"nine";
        case 0xa:
            return @"";
        case 0xb:
            return @"";
        case 0xc:
            return @"";
        case 0xd:
            return @"";
        case 0xe:
            return @"";
        case 0xf:
            return @"";
        case 0x10:
            return @"";
        case 0x11:
            return @"";
        case 0x12:
            return @"";
        case 0x13:
            return @"";
        case 0x14:
            return @"";
        case 0x15:
            return @"";
        case 0x16:
            return @"";
        case 0x17:
            return @"";
        case 0x18:
            return @"";
        case 0x19:
            return @"";
        case 0x1a:
            return @"";
        case 0x1b:
            return @"";
        case 0x1c:
            return @"";
        case 0x1d:
            return @"";
        case 0x1e:
            return @"";
        case 0x1f:
            return @"";
        case 0x20:
            return @"";
        case 0x21:
            return @"";
        case 0x22:
            return @"";
        case 0x23:
            return @"staccato";
        case 0x24:
            return @"";
        case 0x25:
            return @"";
        case 0x26:
            return @"";
        case 0x27:
            return @"";
        case 0x28:
            return @"";
        case 0x29:
            return @"";
        case 0x2a:
            return @"";
        case 0x2b:
            return @"";
        case 0x2c:
            return @"";
        case 0x2d:
            return @"";
        case 0x2e:
            return @"";
        case 0x2f:
            return @"TAB";
        case 0x30:
            return @"";
        case 0x31:
            return @"";
        case 0x32:
            return @"";
        case 0x33:
            return @"";
        case 0x34:
            return @"";
        case 0x35:
            return @"sharp";
        case 0x36:
            return @"";
        case 0x37:
            return @"";
        case 0x38:
            return @"";
        case 0x39:
            return @"";
        case 0x3a:
            return @"";
        case 0x3b:
            return @"";
        case 0x3c:
            return @"";
        case 0x3d:
            return @"";
        case 0x3e:
            return @"";
        case 0x3f:
            return @"";
        case 0x40:
            return @"";
        case 0x41:
            return @"";
        case 0x42:
            return @"";
        case 0x43:
            return @"";
        case 0x44:
            return @"";
        case 0x45:
            return @"";
        case 0x46:
            return @"";
        case 0x47:
            return @"";
        case 0x48:
            return @"";
        case 0x49:
            return @"";
        case 0x4a:
            return @"";
        case 0x4b:
            return @"";
        case 0x4c:
            return @"";
        case 0x4d:
            return @"";
        case 0x4e:
            return @"";
        case 0x4f:
            return @"";
        case 0x50:
            return @"";
        case 0x51:
            return @"";
        case 0x52:
            return @"";
        case 0x53:
            return @"";
        case 0x54:
            return @"";
        case 0x55:
            return @"";
        case 0x56:
            return @"";
        case 0x57:
            return @"";
        case 0x58:
            return @"";
        case 0x59:
            return @"";
        case 0x5a:
            return @"";
        case 0x5b:
            return @"";
        case 0x5c:
            return @"";
        case 0x5d:
            return @"";
        case 0x5e:
            return @"";
        case 0x5f:
            return @"";
        case 0x60:
            return @"";
        case 0x61:
            return @"";
        case 0x62:
            return @"";
        case 0x63:
            return @"";
        case 0x64:
            return @"";
        case 0x65:
            return @"";
        case 0x66:
            return @"";
        case 0x67:
            return @"";
        case 0x68:
            return @"";
        case 0x69:
            return @"";
        case 0x6a:
            return @"";
        case 0x6b:
            return @"";
        case 0x6c:
            return @"";
        case 0x6d:
            return @"";
        case 0x6e:
            return @"";
        case 0x6f:
            return @"";
        case 0x70:
            return @"";
        case 0x71:
            return @"";
        case 0x72:
            return @"";
        case 0x73:
            return @"";
        case 0x74:
            return @"";
        case 0x75:
            return @"";
        case 0x76:
            return @"";
        case 0x77:
            return @"";
        case 0x78:
            return @"";
        case 0x79:
            return @"";
        case 0x7a:
            return @"";
        case 0x7b:
            return @"";
        case 0x7c:
            return @"";
        case 0x7d:
            return @"";
        case 0x7e:
            return @"";
        case 0x7f:
            return @"";
        case 0x80:
            return @"";
        case 0x81:
            return @"";
        case 0x82:
            return @"";
        case 0x83:
            return @"trebleclef";
        case 0x84:
            return @"";
        case 0x85:
            return @"flat";
        case 0x86:
            return @"";
        case 0x87:
            return @"";
        case 0x88:
            return @"";
        case 0x89:
            return @"";
        case 0x8a:
            return @"";
        case 0x8b:
            return @"";
        case 0x8c:
            return @"";
        case 0x8d:
            return @"";
        case 0x8e:
            return @"";
        case 0x8f:
            return @"";
        case 0x90:
            return @"";
        case 0x91:
            return @"";
        case 0x92:
            return @"";
        //        case 0x93:
        //            return @"";
        case 0x94:
            return @"";
        case 0x95:
            return @"";
        case 0x96:
            return @"";
        case 0x97:
            return @"";
        case 0x98:
            return @"";
        case 0x99:
            return @"";
        case 0x9a:
            return @"";
        case 0x9b:
            return @"";
        case 0x9c:
            return @"";
        case 0x9d:
            return @"";
        case 0x9e:
            return @"";
        case 0x9f:
            return @"";
        case 0xa0:
            return @"";
        case 0xa1:
            return @"";
        case 0xa2:
            return @"";
        case 0xa3:
            return @"";
        case 0xa4:
            return @"";
        case 0xa5:
            return @"";
        case 0xa6:
            return @"";
        case 0xa7:
            return @"";
        case 0xa8:
            return @"";
        case 0xa9:
            return @"";
        case 0xaa:
            return @"";
        case 0xab:
            return @"";
        case 0xac:
            return @"";
        case 0xad:
            return @"";
        case 0xae:
            return @"";
        case 0xaf:
            return @"";
        case 0xb0:
            return @"";
        case 0xb1:
            return @"";
        case 0xb2:
            return @"";
        case 0xb3:
            return @"";
        case 0xb4:
            return @"";
        case 0xb5:
            return @"";
        case 0xb6:
            return @"";
        case 0xb7:
            return @"";
        case 0xb8:
            return @"";
        case 0xb9:
            return @"";
        case 0xba:
            return @"";
        case 0xbb:
            return @"";
        case 0xbc:
            return @"";
        case 0xbd:
            return @"";
        case 0xbe:
            return @"";
        case 0xbf:
            return @"";
        case 0xc0:
            return @"";
        case 0xc1:
            return @"";
        case 0xc2:
            return @"";
        case 0xc3:
            return @"";
        default:
            return @"ERROR";
    }
}

static NSDictionary* _typeGlyphNameType;
+ (MNGlyphNameType)typeGlyphNameTypeForString:(NSString*)string
{
    if(!_typeGlyphNameType)
    {
        _typeGlyphNameType = @{
            @"v0" : @(MNGlyphName_v0),
            @"v1" : @(MNGlyphName_v1),
            @"v2" : @(MNGlyphName_v2),
            @"v3" : @(MNGlyphName_v3),
            @"v4" : @(MNGlyphName_v4),
            @"v5" : @(MNGlyphName_v5),
            @"v6" : @(MNGlyphName_v6),
            @"v7" : @(MNGlyphName_v7),
            @"v8" : @(MNGlyphName_v8),
            @"v9" : @(MNGlyphName_v9),
            @"va" : @(MNGlyphName_va),
            @"vb" : @(MNGlyphName_vb),
            @"vc" : @(MNGlyphName_vc),
            @"vd" : @(MNGlyphName_vd),
            @"ve" : @(MNGlyphName_ve),
            @"vf" : @(MNGlyphName_vf),
            @"v10" : @(MNGlyphName_v10),
            @"v11" : @(MNGlyphName_v11),
            @"v12" : @(MNGlyphName_v12),
            @"v13" : @(MNGlyphName_v13),
            @"v14" : @(MNGlyphName_v14),
            @"v15" : @(MNGlyphName_v15),
            @"v16" : @(MNGlyphName_v16),
            @"v17" : @(MNGlyphName_v17),
            @"v18" : @(MNGlyphName_v18),
            @"v19" : @(MNGlyphName_v19),
            @"v1a" : @(MNGlyphName_v1a),
            @"v1b" : @(MNGlyphName_v1b),
            @"v1c" : @(MNGlyphName_v1c),
            @"v1d" : @(MNGlyphName_v1d),
            @"v1e" : @(MNGlyphName_v1e),
            @"v1f" : @(MNGlyphName_v1f),
            @"v20" : @(MNGlyphName_v20),
            @"v21" : @(MNGlyphName_v21),
            @"v22" : @(MNGlyphName_v22),
            @"v23" : @(MNGlyphName_v23),
            @"v24" : @(MNGlyphName_v24),
            @"v25" : @(MNGlyphName_v25),
            @"v26" : @(MNGlyphName_v26),
            @"v27" : @(MNGlyphName_v27),
            @"v28" : @(MNGlyphName_v28),
            @"v29" : @(MNGlyphName_v29),
            @"v2a" : @(MNGlyphName_v2a),
            @"v2b" : @(MNGlyphName_v2b),
            @"v2c" : @(MNGlyphName_v2c),
            @"v2d" : @(MNGlyphName_v2d),
            @"v2e" : @(MNGlyphName_v2e),
            @"v2f" : @(MNGlyphName_v2f),
            @"v30" : @(MNGlyphName_v30),
            @"v31" : @(MNGlyphName_v31),
            @"v32" : @(MNGlyphName_v32),
            @"v33" : @(MNGlyphName_v33),
            @"v34" : @(MNGlyphName_v34),
            @"v35" : @(MNGlyphName_v35),
            @"v36" : @(MNGlyphName_v36),
            @"v37" : @(MNGlyphName_v37),
            @"v38" : @(MNGlyphName_v38),
            @"v39" : @(MNGlyphName_v39),
            @"v3a" : @(MNGlyphName_v3a),
            @"v3b" : @(MNGlyphName_v3b),
            @"v3c" : @(MNGlyphName_v3c),
            @"v3d" : @(MNGlyphName_v3d),
            @"v3e" : @(MNGlyphName_v3e),
            @"v3f" : @(MNGlyphName_v3f),
            @"v40" : @(MNGlyphName_v40),
            @"v41" : @(MNGlyphName_v41),
            @"v42" : @(MNGlyphName_v42),
            @"v43" : @(MNGlyphName_v43),
            @"v44" : @(MNGlyphName_v44),
            @"v45" : @(MNGlyphName_v45),
            @"v46" : @(MNGlyphName_v46),
            @"v47" : @(MNGlyphName_v47),
            @"v48" : @(MNGlyphName_v48),
            @"v49" : @(MNGlyphName_v49),
            @"v4a" : @(MNGlyphName_v4a),
            @"v4b" : @(MNGlyphName_v4b),
            @"v4c" : @(MNGlyphName_v4c),
            @"v4d" : @(MNGlyphName_v4d),
            @"v4e" : @(MNGlyphName_v4e),
            @"v4f" : @(MNGlyphName_v4f),
            @"v50" : @(MNGlyphName_v50),
            @"v51" : @(MNGlyphName_v51),
            @"v52" : @(MNGlyphName_v52),
            @"v53" : @(MNGlyphName_v53),
            @"v54" : @(MNGlyphName_v54),
            @"v55" : @(MNGlyphName_v55),
            @"v56" : @(MNGlyphName_v56),
            @"v57" : @(MNGlyphName_v57),
            @"v58" : @(MNGlyphName_v58),
            @"v59" : @(MNGlyphName_v59),
            @"v5a" : @(MNGlyphName_v5a),
            @"v5b" : @(MNGlyphName_v5b),
            @"v5c" : @(MNGlyphName_v5c),
            @"v5d" : @(MNGlyphName_v5d),
            @"v5e" : @(MNGlyphName_v5e),
            @"v5f" : @(MNGlyphName_v5f),
            @"v60" : @(MNGlyphName_v60),
            @"v61" : @(MNGlyphName_v61),
            @"v62" : @(MNGlyphName_v62),
            @"v63" : @(MNGlyphName_v63),
            @"v64" : @(MNGlyphName_v64),
            @"v65" : @(MNGlyphName_v65),
            @"v66" : @(MNGlyphName_v66),
            @"v67" : @(MNGlyphName_v67),
            @"v68" : @(MNGlyphName_v68),
            @"v69" : @(MNGlyphName_v69),
            @"v6a" : @(MNGlyphName_v6a),
            @"v6b" : @(MNGlyphName_v6b),
            @"v6c" : @(MNGlyphName_v6c),
            @"v6d" : @(MNGlyphName_v6d),
            @"v6e" : @(MNGlyphName_v6e),
            @"v6f" : @(MNGlyphName_v6f),
            @"v70" : @(MNGlyphName_v70),
            @"v71" : @(MNGlyphName_v71),
            @"v72" : @(MNGlyphName_v72),
            @"v73" : @(MNGlyphName_v73),
            @"v74" : @(MNGlyphName_v74),
            @"v75" : @(MNGlyphName_v75),
            @"v76" : @(MNGlyphName_v76),
            @"v77" : @(MNGlyphName_v77),
            @"v78" : @(MNGlyphName_v78),
            @"v79" : @(MNGlyphName_v79),
            @"v7a" : @(MNGlyphName_v7a),
            @"v7b" : @(MNGlyphName_v7b),
            @"v7c" : @(MNGlyphName_v7c),
            @"v7d" : @(MNGlyphName_v7d),
            @"v7e" : @(MNGlyphName_v7e),
            @"v7f" : @(MNGlyphName_v7f),
            @"v80" : @(MNGlyphName_v80),
            @"v81" : @(MNGlyphName_v81),
            @"v82" : @(MNGlyphName_v82),
            @"v83" : @(MNGlyphName_v83),
            @"v84" : @(MNGlyphName_v84),
            @"v85" : @(MNGlyphName_v85),
            @"v86" : @(MNGlyphName_v86),
            @"v88" : @(MNGlyphName_v88),
            @"v89" : @(MNGlyphName_v89),
            @"v8a" : @(MNGlyphName_v8a),
            @"v8b" : @(MNGlyphName_v8b),
            @"v8c" : @(MNGlyphName_v8c),
            @"v8d" : @(MNGlyphName_v8d),
            @"v8e" : @(MNGlyphName_v8e),
            @"v8f" : @(MNGlyphName_v8f),
            @"v90" : @(MNGlyphName_v90),
            @"v91" : @(MNGlyphName_v91),
            @"v92" : @(MNGlyphName_v92),
            @"v93" : @(MNGlyphName_v93),
            @"v94" : @(MNGlyphName_v94),
            @"v95" : @(MNGlyphName_v95),
            @"v96" : @(MNGlyphName_v96),
            @"v97" : @(MNGlyphName_v97),
            @"v98" : @(MNGlyphName_v98),
            @"v99" : @(MNGlyphName_v99),
            @"v9a" : @(MNGlyphName_v9a),
            @"v9b" : @(MNGlyphName_v9b),
            @"v9c" : @(MNGlyphName_v9c),
            @"v9d" : @(MNGlyphName_v9d),
            @"v9e" : @(MNGlyphName_v9e),
            @"v9f" : @(MNGlyphName_v9f),
            @"va0" : @(MNGlyphName_va0),
            @"va1" : @(MNGlyphName_va1),
            @"va2" : @(MNGlyphName_va2),
            @"va3" : @(MNGlyphName_va3),
            @"va4" : @(MNGlyphName_va4),
            @"va5" : @(MNGlyphName_va5),
            @"va6" : @(MNGlyphName_va6),
            @"va7" : @(MNGlyphName_va7),
            @"va8" : @(MNGlyphName_va8),
            @"va9" : @(MNGlyphName_va9),
            @"vaa" : @(MNGlyphName_vaa),
            @"vab" : @(MNGlyphName_vab),
            @"vac" : @(MNGlyphName_vac),
            @"vad" : @(MNGlyphName_vad),
            @"vae" : @(MNGlyphName_vae),
            @"vaf" : @(MNGlyphName_vaf),
            @"vb0" : @(MNGlyphName_vb0),
            @"vb1" : @(MNGlyphName_vb1),
            @"vb2" : @(MNGlyphName_vb2),
            @"vb3" : @(MNGlyphName_vb3),
            @"vb4" : @(MNGlyphName_vb4),
            @"vb5" : @(MNGlyphName_vb5),
            @"vb6" : @(MNGlyphName_vb6),
            @"vb7" : @(MNGlyphName_vb7),
            @"vb8" : @(MNGlyphName_vb8),
            @"vb9" : @(MNGlyphName_vb9),
            @"vba" : @(MNGlyphName_vba),
            @"vbb" : @(MNGlyphName_vbb),
            @"vbc" : @(MNGlyphName_vbc),
            @"vbd" : @(MNGlyphName_vbd),
            @"vbe" : @(MNGlyphName_vbe),
            @"vbf" : @(MNGlyphName_vbf),
            @"vc0" : @(MNGlyphName_vc0),
            @"vc1" : @(MNGlyphName_vc1),
            @"vc2" : @(MNGlyphName_vc2),
            @"vc3" : @(MNGlyphName_vc3),
        };
    }
    return [_typeGlyphNameType[string] unsignedIntegerValue];
}

@end
