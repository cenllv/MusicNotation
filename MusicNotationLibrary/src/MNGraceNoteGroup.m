//
//  MNGraceNoteGroup.m
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

#import "MNGraceNoteGroup.h"
#import "MNLog.h"
#import "MNKeyProperty.h"
#import "MNStaffNote.h"
#import "MNStaff.h"
#import "MNVoice.h"
#import "MNFormatter.h"
#import "MNStaffTie.h"
#import "MNBeam.h"
#import "MNGraceNote.h"
#import "NSMutableArray+MNAdditions.h"
#import "OCTotallyLazy.h"
#import "MNTable.h"
#import "MNTickContext.h"
#import "MNConstants.h"

@implementation MNGraceNoteGroup
/*
Vex.Flow.GraceNoteGroup = (function(){
    function GraceNoteGroup(grace_notes, config) {
        if (arguments.count > 0) self.init(grace_notes, config);
    }


    // To enable logging for this class. Set `Vex.Flow.GraceNoteGroup.DEBUG` to `YES`.
    function L() { if (GraceNoteGroup.DEBUG) Vex.L("Vex.Flow.GraceNoteGroup", arguments); }
 */
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
        self.note = nil;
        //        self.index = nil;
        self.position = MNPositionLeft;
        self.width = 0;
        self.preFormatted = false;
        self.slur = nil;
        self.formatter = [MNFormatter formatter];
        self.voice = [MNVoice voiceWithNumBeats:4 beatValue:4 resolution:kRESOLUTION];
        [self.voice setStrict:NO];
        [self.voice addTickables:self.graceNotes];
        [self setValuesForKeyPathsWithDictionary:optionsDict];
    }
    return self;
}

- (instancetype)initWithGraceNoteGroups:(NSArray*)graceNotes showSlur:(BOOL)showSlur
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.graceNotes = graceNotes;
        self.showSlur = showSlur;
    }
    return self;
}

- (instancetype)initWithGraceNoteGroups:(NSArray*)graceNotes
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        self.graceNotes = graceNotes;
    }
    return self;
}

- (instancetype)initWithGraceNoteGroups:(NSArray*)graceNotes state:(BOOL)state
{
    self = [self initWithDictionary:nil];
    if(self)
    {
        [MNLog logNotYetImplementedForClass:self andSelector:_cmd];
        abort();
        self.graceNotes = graceNotes;
    }
    return self;
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*!
 *  category of this modifier
 *  @return class name
 */
+ (NSString*)CATEGORY
{
    return @"gracenotegroups";
}

// ## Static Methods
//
// Format groups inside a ModifierContext. Arrange groups inside a `ModifierContext`
+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state context:(MNModifierContext*)context
{
    NSMutableArray* gracenote_groups = modifiers;

    float gracenote_spacing = 4;

    if(!gracenote_groups || gracenote_groups.count == 0)
    {
        return NO;
    }

    NSMutableArray* group_list = [NSMutableArray array];
    BOOL hasStaff = NO;
    MNNote* prev_note = nil;
    float shiftL = 0;

    NSUInteger i;
    MNGraceNoteGroup* gracenote_group;
    MNKeyProperty* props_tmp;
    for(i = 0; i < gracenote_groups.count; ++i)
    {
        gracenote_group = gracenote_groups[i];
        MNStaffNote* note;
        if([gracenote_group.note isKindOfClass:[MNStaffNote class]])
        {
            note = (MNStaffNote*)gracenote_group.note;
        }
        else
        {
            MNLogError(@"gracenote_group note not a  MNStaffNote");
            abort();
        }

        MNStaff* staff = note.staff;
        if(note != prev_note)
        {
            // Iterate through all notes to get the displaced pixels
            for(NSUInteger n = 0; n < note.keyStrings.count; ++n)
            {
                props_tmp = note.keyProps[n];
                shiftL = (props_tmp.displaced ? note.extraLeftPx : shiftL);
            }
            prev_note = note;
        }
        if(staff != nil)
        {
            hasStaff = YES;
            [group_list push:[[MNGraceNoteGroup alloc]
                                 initWithDictionary:@{@"shift" : @(shiftL), @"gracenote_group" : gracenote_group}]];
        }
        else
        {
            [group_list push:[[MNGraceNoteGroup alloc]
                                 initWithDictionary:@{@"shift" : @(shiftL), @"gracenote_group" : gracenote_group}]];
        }
    }

    // If first note left shift in case it is displaced
    float group_shift = ((MNGraceNoteGroup*)group_list[0]).shift;
    for(i = 0; i < group_list.count; ++i)
    {
        gracenote_group = group_list[i];   //[@"gracenote_group"];
        [gracenote_group preFormat];
        group_shift = gracenote_group.width + gracenote_spacing;
    }

    state.left_shift += group_shift;

    return YES;
}

- (BOOL)preFormat
{
    if(self.preFormatted)
    {
        return self.preFormatted;
    }
    [[self.formatter joinVoices:@[ self.voice ]] formatWith:@[ self.voice ] withJustifyWidth:0];
    self.width = [self.formatter getMinTotalWidth];

    return self.preFormatted;
}

- (id)beamNotes
{
    if(self.graceNotes.count > 1)
    {
        MNBeam* beam = [MNBeam beamWithNotes:self.graceNotes];

        beam.beamWidth = 3;
        beam.partialBeamLength = 4;

        self.beam = beam;
    }
    return self;
}

- (void)draw:(CGContextRef)ctx
{
    [super draw:ctx];

    MNStaffNote* note;
    if([self.note isKindOfClass:[MNStaffNote class]])
    {
        note = (MNStaffNote*)self.note;
    }
    else
    {
        MNLogError(@"self note not a  MNStaffNote");
        abort();
    }

    //    MNLogInfo("Drawing grace note group for: %@", note);  // <- this crashes
    if(!note)
    {
        MNLogError(@"NoAttachedNote, Can't draw grace note without a parent note and parent note index.");
    }

    /*!
     *  Shift over the tick contexts of each note
     *  So that they are aligned with the note
     *  @param NSArray     array of grace notes
     *  @param  MNStaffNote the note to align with
     *  @note this block seems a little unnecessary
     */
    void (^alignGraceNotesWithNote)(NSArray*, MNStaffNote*) = ^void(NSArray* grace_notes, MNStaffNote* note) {
      MNTickContext* tickContext = note.tickContext;
      MNExtraPoints* extraPx = [tickContext getExtraPx];
      float x = tickContext.x - extraPx.left - extraPx.extraLeft;
      [grace_notes foreach:^(MNGraceNote* graceNote, NSUInteger index, BOOL* stop) {
        MNTickContext* tick_context = graceNote.tickContext;
        float x_offset = tick_context.x;
        graceNote.staff = note.staff;
        tick_context.x = x + x_offset;
      }];
    };

    alignGraceNotesWithNote(self.graceNotes, note);

    // Draw notes
    [self.graceNotes foreach:^(MNGraceNote* graceNote, NSUInteger index, BOOL* stop) {
      [graceNote draw:ctx];
    }];

    // Draw beam
    if(self.beam)
    {
        [self.beam draw:ctx];
    }

    if(self.showSlur)
    {
        // Create and draw slur
        self.slur = [[MNStaffTie alloc] initWithLastNote:self.graceNotes[0]
                                               firstNote:note
                                            firstIndices:@[ @0 ]
                                             lastIndices:@[ @0 ]];

        self.slur.cp2 = 12;
        [self.slur draw:ctx];
    }
}
@end
