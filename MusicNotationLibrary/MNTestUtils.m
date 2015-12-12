//
//  MNTestUtils.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 12/5/15.
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

#import "MNTestUtils.h"
#import "Tests.h"
#import "MNTestType.h"
#import "NSString+MNAdditions.h"

@implementation MNTestUtils

static NSDictionary* _classForType;

+ (NSDictionary*)classForTestType
{
    if(!_classForType)
    {
        _classForType = @{
            @(NoneTestType) : [MNNoneTests class],
            @(AccidentalTestType) : [MNAccidentalTests class],
            @(AnimationTestType) : [MNAnimationTests class],
            @(AnnotationTestType) : [MNAnnotationTests class],
            @(ArticulationTestType) : [MNArticulationTests class],
            @(AutoBeamFormattingTestType) : [MNAutoBeamFormattingTests class],
            @(BeamTestType) : [MNBeamTests class],
            @(BendTestType) : [MNBendTests class],
            @(BoundingBoxTestType) : [MNBoundingBoxTests class],
            @(ChordTestType) : [MNChordTest class],
            @(ClefTestType) : [MNClefTests class],
            @(CurveTestType) : [MNCurveTests class],
            @(DotTestType) : [MNDotTests class],
            @(FontTestType) : [MNFontTests class],
            @(FormatterTestType) : [MNFormatterTests class],
            @(GraceNoteTestType) : [MNGraceNoteTests class],
            @(KeyClefTestType) : [MNKeyClefTests class],
            @(KeyManagerTestType) : [MNKeyManagerTests class],
            @(KeySignatureTestType) : [MNKeySignatureTests class],
            @(LayerNoteTestsTestType) : [MNLayerNoteTests class],
            @(ModifierTestType) : [MNModifierTests class],
            @(MusicTestType) : [MNMusicTests class],
            @(NodeTestType) : [MNNodeTests class],
            @(NoteHeadTestType) : [MNNoteHeadTests class],
            @(NotationsGridTestType) : [MNNotationsGridTests class],
            @(OrnamentTestType) : [MNOrnamentTests class],
            @(PedalMarkingTestType) : [MNPedalMarkingTests class],
            @(PercussionTestType) : [MNPercussionTests class],
            @(RestsTestType) : [MNRestsTest class],
            @(RhythmTestType) : [MNRhythmTests class],
            @(SheetMusicExamplesTestType) : [MNSheetMusicExamplesTests class],
            @(StaffTestType) : [MNStaffTests class],
            @(StaffConnectorTestType) : [MNStaffConnectorTests class],
            @(StaffHairpinTestType) : [MNStaffHairpinTests class],
            @(StaffLineTestType) : [MNStaffLineTests class],
            @(StaffModifierTestType) : [MNStaffModifierTests class],
            @(StaffNoteTestType) : [MNStaffNoteTests class],
            @(StaffTieTestType) : [MNStaffTieTests class],
            @(StringNumberTestType) : [MNStringNumberTests class],
            @(StrokesTestType) : [MNStrokesTests class],
            @(TableTestType) : [MNTableTests class],
            @(TabNoteTestType) : [MNTabNoteTests class],
            @(TabSlideTestType) : [MNTabSlideTests class],
            @(TabStaffTestType) : [MNTabStaffTests class],
            @(TabTieTestType) : [MNTabTieTests class],
            @(TextBracketTestType) : [MNTextBracketTests class],
            @(TextNoteTestType) : [MNTextNoteTests class],
            @(TextTestType) : [MNTextTests class],
            @(ThreeVoiceTestType) : [MNThreeVoiceTests class],
            @(TickContextTestType) : [MNTickContextTests class],
            @(TimeSignatureTestType) : [MNTimeSignatureTests class],
            @(TuningTestType) : [MNTuningTests class],
            @(TupletTestType) : [MNTupletTests class],
            @(VibratoTestType) : [MNVibratoTests class],
            @(VoiceTestType) : [MNVoiceTests class],
        };
        NSArray* allNumValues = REFAllValuesInMNTestType();
        if(allNumValues.count - 1 != _classForType.count)
        {
            NSLog(@"%@:%tu out of sync with %@:%tu", VariableName(_classForType), _classForType.count,
                  VariableName(self.testType), allNumValues.count);
            NSMutableSet *set1, *set2;
            set1 = [[NSMutableSet alloc] init];
            [set1 addObjectsFromArray:allNumValues];
            set2 = [[NSMutableSet alloc] init];
            [set2 addObjectsFromArray:_classForType.allKeys];
            [set1 minusSet:set2];
            for(NSNumber* num in set1)
            {
                MNTestType missingType = [num integerValue];
                NSString* missingTypeString = REFStringForMemberInMNTestType(missingType);
                if([missingTypeString isNotEqualToString:@""])
                {
                    NSLog(@"missing class for type: %@", missingTypeString);
                }
            }
        }
    }

    return _classForType;
}

@end
