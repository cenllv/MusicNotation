//
//  MNFormatter.m
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

#import "MNFormatter.h"
#import "MNEnum.h"
#import "MNRational.h"
#import "MNMetrics.h"
#import "MNModifierContext.h"
#import "MNTickContext.h"
#import "MNStaff.h"
#import "MNVoice.h"
#import "MNTabStaff.h"
#import "MNTextNote.h"
#import "MNBeam.h"
#import "MNTickable.h"
#import "MNStaffConnector.h"
#import "MNKeyProperty.h"
#import "MNFormatterContext.h"
#import "MNBoundingBox.h"
#import "MNStemmableNote.h"
#import "MNStaffNote.h"

typedef void (^AddFunction)(MNTickable*, id);

@implementation MNFormatter

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

+ (MNFormatter*)formatter
{
    return [[MNFormatter alloc] init];
}

- (instancetype)init
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupFormatter];
    }
    return self;
}

- (void)setupFormatter
{
    // Minimum width required to render all the notes in the voices.
    _minTotalWidth = 0;

    // self is set to `YES` after `minTotalWidth` is calculated.
    _hasMinTotalWidth = NO;

    // The suggested amount of space for each tick.
    _pixelsPerTick = 0;

    // Total number of ticks in the voice.
    _totalTicks = RationalZero();

    // Arrays of tick and modifier contexts.
    //    self.tContexts = nil;
    //    self.mContexts = nil;
}

#pragma mark PRIVATE Methods

/*!
 *  Helper function to locate the next non-rest note(s).
 *  @param notes          <#notes description#>
 *  @param restLine       <#restLine description#>
 *  @param lookAheadIndex <#lookAheadIndex description#>
 *  @param shouldCompare  <#shouldCompare description#>
 *  @return the next rest line
 */
+ (float)lookAhead:(NSArray*)notes
       andRestLine:(float)restLine
                by:(NSUInteger)lookAheadIndex
   makeComparisons:(BOOL)shouldCompare
{
    // If no valid next note group, next_rest_line is same as current.
    float next_rest_line = restLine;
    NSUInteger i = lookAheadIndex;
    ++i;
    while(i < notes.count)
    {
        if(!((MNStaffNote*)notes[i]).isRest && !((MNStaffNote*)notes[i]).shouldIgnoreTicks)
        {
            next_rest_line = [((MNStaffNote*)notes[i])lineForRest];
            break;
        }
        i++;
    }

    // Locate the mid point between two lines.
    if(shouldCompare && restLine != next_rest_line)
    {
        float top = MAX(restLine, next_rest_line);
        float bot = MIN(restLine, next_rest_line);
        next_rest_line = mnmidline(top, bot);
    }

    return next_rest_line;
}

// private
/*!
 *  Take an array of `voices` and place aligned tickables in the same context. Returns
 *  a mapping from `tick` to `context_type`, a list of `tick`s, and the resolution
 *  multiplier.
 *  @param voices      Array of `Voice` instances.
 *  @param contextType A context class (e.g., `ModifierContext`, `TickContext`)
 *  @param add_fn      Function to add tickable to context.
 *  @return <#return value description#>
 */
- (MNFormatterContext*)createContexts:(NSArray<MNVoice*>*)voices
                      withContextType:(Class)contextType
                       andAddFunction:(AddFunction)add_fn
{
    if(!voices || voices.count == 0)
    {
        MNLogError(@"BadArgument, No voices to format");
    }

    // Initialize tick maps.
    MNRational* totalTicks = [((MNVoice*)voices[0])totalTicks];
    NSMutableDictionary* tickToContextMap = [NSMutableDictionary dictionary];
    NSMutableArray* tickList = [NSMutableArray array];
    NSMutableArray* contexts = [NSMutableArray array];

    NSUInteger resolutionMultiplier = 1;

    // Find out highest common multiple of resolution multipliers.
    // The purpose of self is to find out a common denominator
    // for all fractional tick values in all tickables of all voices,
    // so that the values can be expanded and the numerator used
    // as an integer tick value.
    NSUInteger i;   // shared iterator
    MNVoice* voice = nil;
    for(i = 0; i < voices.count; ++i)
    {
        voice = (MNVoice*)voices[i];
        if(!([voice.totalTicks equalsRational:totalTicks]))
        {
            MNLogError(@"TickMismatch, Voices should have same total note duration in ticks.");
        }

        if(voice.mode == MNModeStrict && !voice.isComplete)
        {
            MNLogError(@"IncompleteVoice, Voice does not have enough notes.");
        }

        NSUInteger lcm = [MNRational LCM:resolutionMultiplier with:voice.resolutionMultiplier];
        if(resolutionMultiplier < lcm)
        {
            resolutionMultiplier = lcm;
        }
    }

    // For each voice, extract notes and create a context for every
    // new tick that hasn't been seen before.
    for(i = 0; i < voices.count; ++i)
    {
        voice = voices[i];

        NSArray* tickables = voice.tickables;

        // Use resolution multiplier as denominator to expand ticks
        // to suitable integer values, so that no additional expansion
        // of fractional tick values is needed.
        MNRational* ticksUsed = [MNRational rationalWithNumerator:0 andDenominator:resolutionMultiplier];

        for(NSUInteger j = 0; j < tickables.count; ++j)
        {
            id<MNTickableDelegate> tickable = tickables[j];
            NSUInteger integerTicks = ticksUsed.numerator;   // unsignedIntegerValue];

            // If we have no tick context for self tick, create one.
            NSNumber* numIntegerTicks = [NSNumber numberWithUnsignedInteger:integerTicks];
            if(!tickToContextMap[numIntegerTicks])
            {
                id newContext = [[contextType alloc] init];
                [contexts push:newContext];
                tickToContextMap[numIntegerTicks] = newContext;
            }

            // Add self tickable to the TickContext.
            add_fn(tickable, tickToContextMap[numIntegerTicks]);

            // Maintain a sorted list of tick contexts.
            [tickList push:numIntegerTicks];   //.push(integerTicks);
            [ticksUsed add:tickable.ticks];    // .add(tickable.getTicks());
        }
    }

    MNFormatterContext* ret = [[MNFormatterContext alloc] init];
    ret.map = tickToContextMap;
    ret.array = contexts;
    ret.list = [[MNUtils sortAndUnique:tickList
        withCmp:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2) {
          NSUInteger a = [obj1 unsignedIntegerValue];
          NSUInteger b = [obj2 unsignedIntegerValue];
          if(a < b)
          {
              return (NSComparisonResult)NSOrderedAscending;
          }
          else if(a > b)
          {
              return (NSComparisonResult)NSOrderedDescending;
          }
          else
          {
              return (NSComparisonResult)NSOrderedSame;
          }
        }
        andEq:^BOOL(NSNumber* obj1, NSNumber* obj2) {
          return [obj1 unsignedIntegerValue] == [obj2 unsignedIntegerValue];
        }] mutableCopy];
    ret.resolutionMultiplier = resolutionMultiplier;
    return ret;
}

#pragma mark - STATIC Methods

/*!
 *  Helper function to format and draw a single voice. Returns a bounding
 *  box for the notation.
 *  @param ctx    the core graphics opaque type drawing environment
 *  @param staff  The staff to which to draw (`MNStaff` or `MNTabStaff`)
 *  @param notes  Array of `MNNote` instances (`MNStaffNote`, `MNTextNote`, `MNTabNote`, etc.)
 *  @param params One of below:
 *                  Setting `autobeam` only `(context, staff, notes, YES)` or `(ctx, staff, notes, {autobeam: YES})`
 *                  Setting `align_rests` a struct is needed `(context, staff, notes, {align_rests: YES})`
 *                  Setting both a struct is needed `(context, staff, notes, {autobeam: YES, align_rests: YES})`
 *                      `autobeam` automatically generates beams for the notes.
 *                      `align_rests` aligns rests with nearby notes.
 *
 *  @return a bounding box
 */
+ (MNBoundingBox*)formatAndDrawWithContext:(CGContextRef)ctx
                                 dirtyRect:(CGRect)dirtyRect
                                   toStaff:(MNStaff*)staff
                                 withNotes:(NSArray*)notes
                                withParams:(NSDictionary*)params
{
    NSDictionary* options = [NSMutableDictionary merge:@{ @"auto_beam" : @NO, @"align_rests" : @NO } with:params];

    // Start by creating a voice and adding all the notes to it.
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;      // setMode(Vex.Flow.Voice.Mode.SOFT);
    [voice addTickables:notes];   // voice.addTickables(notes);

    // Then create beams, if requested.
    NSArray<MNBeam*>* beams = nil;
    if([options[@"auto_beam"] boolValue])
    {
        beams = [MNBeam applyAndGetBeams:voice direction:MNStemDirectionNone groups:nil];
    }

    // Instantiate a `Formatter` and format the notes.
    MNFormatter* formatter = [[MNFormatter alloc] init];
    [formatter joinVoices:@[ voice ] params:@{ @"align_rests" : options[@"align_rests"] }];
    [formatter formatToStaff:@[ voice ] staff:staff options:@{ @"align_rests" : options[@"align_rests"] }];

    // Render the voice and beams to the staff.
    [voice setStaff:staff];
    [voice draw:ctx dirtyRect:dirtyRect toStaff:staff];
    if(beams != nil)
    {
        for(int i = 0; i < beams.count; ++i)
        {
            [((MNBeam*)beams[i])draw:ctx];
        }
    }

    // Return the bounding box of the voice.
    return voice.boundingBox;
}
+ (MNBoundingBox*)formatAndDrawWithContext:(CGContextRef)ctx
                                   toStaff:(MNStaff*)staff
                                 withNotes:(NSArray*)notes
                          withJustifyWidth:(float)justifyWidth
{
    NSDictionary* options = [NSMutableDictionary merge:@{ @"auto_beam" : @NO, @"align_rests" : @NO } with:@{}];

    // Start by creating a voice and adding all the notes to it.
    MNVoice* voice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    voice.mode = MNModeSoft;      // setMode(Vex.Flow.Voice.Mode.SOFT);
    [voice addTickables:notes];   // voice.addTickables(notes);

    // Then create beams, if requested.
    NSArray<MNBeam*>* beams = nil;
    if([options[@"auto_beam"] boolValue])
    {
        beams = [MNBeam applyAndGetBeams:voice direction:MNStemDirectionNone groups:nil];
    }

    // Instantiate a `Formatter` and format the notes.
    MNFormatter* formatter = [[MNFormatter alloc] init];
    [formatter joinVoices:@[ voice ] params:@{ @"align_rests" : options[@"align_rests"] }];
    [formatter formatWith:@[ voice ]
         withJustifyWidth:justifyWidth
               andOptions:@{
                   @"align_rests" : options[@"align_rests"]
               }];

    // Render the voice and beams to the staff.
    [voice setStaff:staff];
    [voice draw:ctx dirtyRect:CGRectZero toStaff:staff];
    if(beams != nil)
    {
        for(int i = 0; i < beams.count; ++i)
        {
            [((MNBeam*)beams[i])draw:ctx];
        }
    }

    return voice.boundingBox;
}

+ (MNBoundingBox*)formatAndDrawWithContext:(CGContextRef)ctx
                                 dirtyRect:(CGRect)dirtyRect
                                   toStaff:(MNStaff*)staff
                                 withNotes:(NSArray*)notes
{
    return [MNFormatter formatAndDrawWithContext:ctx dirtyRect:dirtyRect toStaff:staff withNotes:notes withParams:nil];
}

+ (MNBoundingBox*)formatAndDrawWithContext:(CGContextRef)ctx
                                 dirtyRect:(CGRect)dirtyRect
                                   toStaff:(MNStaff*)staff
                                 withNotes:(NSArray*)notes
                          withJustifyWidth:(float)justifyWidth
{
    if(justifyWidth == 0)
    {
        justifyWidth = staff.width;
    }
    return [MNFormatter formatAndDrawWithContext:ctx toStaff:staff withNotes:notes withJustifyWidth:justifyWidth];
}

/*!
 *  Helper function to format and draw aligned tab and staff notes in two
 *  separate staffs.
 *
 *  @param ctx      the core graphics opaque type drawing environment
 *  @param staff    A `MNTabStaff` instance on which to render `MNTabNote`s.
 *  @param tabStaff A `MNStaff` instance on which to render `MNNote`s.
 *  @param tabNotes Array of `MNTabNote` instances for the tab staff (`MNTabNote`, `BarNote`, etc.)
 *  @param notes    Array of `MNNote` instances for the staff (`MNStaffNote`, `BarNote`, etc.)
 *  @param autobeam Automatically generate beams.
 *  @param params   A configuration object:
 *                      `autobeam` automatically generates beams for the notes.
 *                      `align_rests` aligns rests with nearby notes.
 *  @return YES if successful
 */
+ (BOOL)formatAndDrawTabWithContext:(CGContextRef)ctx
                          dirtyRect:(CGRect)dirtyRect
                       withTabStaff:(MNTabStaff*)staff
                       withTabStaff:(MNTabStaff*)tabStaff
                        andTabNotes:(NSArray*)tabNotes
                           andNotes:(NSArray*)notes
                            andBeam:(BOOL)autobeam
                         withParams:(NSDictionary*)params
{
    NSDictionary* opts = @{ @"auto_beam" : @(autobeam), @"align_rests" : @NO };

    opts = [NSMutableDictionary merge:opts with:params];

    // Create a `4/4` voice for `notes`.
    MNVoice* notevoice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    notevoice.mode = MNModeSoft;
    [notevoice addTickables:notes];

    // Create a `4/4` voice for `tabnotes`.
    MNVoice* tabvoice = [MNVoice voiceWithTimeSignature:MNTime4_4];
    tabvoice.mode = MNModeSoft;
    [tabvoice addTickables:tabNotes];

    // Generate beams if requested.
    NSArray<MNBeam*>* beams = nil;
    if([opts[@"auto_beam"] boolValue])
    {
        beams = [MNBeam applyAndGetBeams:notevoice direction:MNStemDirectionNone groups:nil];
    }

    // Instantiate a `Formatter` and align tab and staff notes.
    MNFormatter* formatter = [[MNFormatter alloc] init];
    [formatter joinVoices:@[ notevoice ] params:@{ @"align_rests" : opts[@"align_rests"] }];
    [formatter joinVoices:@[ tabvoice ]];
    [formatter formatToStaff:@[ notevoice, tabvoice ] staff:staff options:@{ @"align_rests" : opts[@"align_rests"] }];

    // Render voices and beams to staffs.
    [notevoice draw:ctx dirtyRect:dirtyRect toStaff:staff];
    [tabvoice draw:ctx dirtyRect:dirtyRect toStaff:tabStaff];
    if(beams != nil)
    {
        for(NSUInteger i = 0; i < beams.count; ++i)
        {
            [((MNBeam*)beams[i])draw:ctx];
        }
    }

    // Draw a connector between tab and note staffs.
    MNStaffConnector* connector = [[MNStaffConnector alloc] initWithTopStaff:staff andBottomStaff:tabStaff];
    [connector draw:ctx];
    return YES;
}

/*!
 *  Auto position rests based on previous/next note positions.
 *  @param notes         An array of notes.
 *  @param alignAllNotes If set to NO, only aligns non-beamed notes.
 *  @param alignTuplets  If set to NO, ignores tuplets.
 */
+ (void)alignRestsToNotes:(NSArray*)notes withNoteAlignment:(BOOL)alignAllNotes andTupletAlignment:(BOOL)alignTuplets
{
    for(NSUInteger i = 0; i < notes.count; ++i)
    {
        if([notes[i] isKindOfClass:[MNStaffNote class]] && ((MNStaffNote*)notes[i]).isRest)
        {
            MNStaffNote* note = notes[i];

            if(note.tuplet && !alignTuplets)
            {
                continue;
            }

            // If activated rests not on default can be rendered as specified.
            NSString* position = note.glyphStruct.position.uppercaseString;   // note.getGlyph().position.toUpperCase();
            if([position isNotEqualToString:@"R/4"] && [position isNotEqualToString:@"B/4"])
            {
                continue;
            }

            if(alignAllNotes || note.beam != nil)
            {
                // Align rests with previous/next notes.
                MNKeyProperty* props = note.keyProps[0];
                if(i == 0)
                {
                    props.line = [self lookAhead:notes andRestLine:props.line by:i makeComparisons:NO];
                    [note setKeyLine:0 withLine:props.line];   // .setKeyLine(0, props.line);
                }
                else if(i > 0 && i < notes.count)
                {
                    // If previous note is a rest, use its line number.
                    float rest_line;
                    if(((MNStaffNote*)notes[i - 1]).isRest)
                    {
                        rest_line = ((MNKeyProperty*)((MNStaffNote*)notes[i - 1]).keyProps[0]).line;
                        props.line = rest_line;
                    }
                    else
                    {
                        rest_line = [((MNStaffNote*)notes[i - 1])lineForRest];
                        // Get the rest line for next valid non-rest note group.
                        props.line = [self lookAhead:notes andRestLine:rest_line by:i makeComparisons:YES];
                    }
                    [note setKeyLine:0 withLine:props.line];
                }
            }
        }
    }
}

/*!
 *  Find all the rests in each of the `voices` and align them
 *  to neighboring notes. If `align_all_notes` is `NO`, then only
 *  align non-beamed notes.

 *  @param voices        the collection of voices
 *  @param alignAllNotes <#alignAllNotes description#>
 */
- (void)alignRests:(NSArray<MNVoice*>*)voices alignAllNotes:(BOOL)alignAllNotes
{
    /*
    // ## Prototype Methods
    Formatter.prototype = @{

    alignRests: function(voices, align_all_notes) {
        if (!voices || !voices.count)  [MNLog LogError:@"BadArgument",
                                                          "No voices to format rests");
        for (var i = 0; i < voices.count; i++) {
            new Formatter.AlignRestsToNotes(voices[i].tickables, align_all_notes);
        }
    },
     */
    if(!voices || voices.count == 0)
    {
        MNLogError(@"BadArgument, No voices to format rests");
    }
    for(NSUInteger i = 0; i < voices.count; ++i)
    {
        [MNFormatter alignRestsToNotes:((MNVoice*)voices[i]).tickables
                     withNoteAlignment:alignAllNotes
                    andTupletAlignment:NO];
    }
}

/*!
 *  Calculate the minimum width required to align and format `voices`.
 *  @param voices the collection of voices
 *  @return <#return value description#>
 */
- (float)preCalculateMinTotalWidth:(NSArray<MNVoice*>*)voices
{
    // Cache results.
    if(self.hasMinTotalWidth)
    {
        return self.minTotalWidth;
    }

    // Create tick contexts if not already created.
    if(!self.tContexts)
    {
        if(!voices)
        {
            MNLogError(@"BadArgument, 'voices' required to run preCalculateMinTotalWidth");
        }
        [self createTickContexts:voices];
    }

    MNFormatterContext* contexts = self.tContexts;
    NSArray* contextList = contexts.list;
    NSDictionary* contextMap = contexts.map;

    self.minTotalWidth = 0;

    // Go through each tick context and calculate total width.
    for(NSUInteger i = 0; i < contextList.count; ++i)
    {
        id<MNContextDelegate> context = contextMap[contextList[i]];

        // `preFormat` gets them to descend down to their tickables and modifier
        // contexts, and calculate their widths.
        [context preFormat];
        self.minTotalWidth += context.width;
    }

    self.hasMinTotalWidth = YES;

    return self.minTotalWidth;
}

/*!
 *  Get minimum width required to render all voices. Either `format` or
 *  `preCalculateMinTotalWidth` must be called before self method.
 *  @return <#return value description#>
 */
- (float)getMinTotalWidth
{
    /*
    getMinTotalWidth: function() {
        if (!self.hasMinTotalWidth) {
             [MNLog LogError:@"NoMinTotalWidth",
                               "Need to call 'preCalculateMinTotalWidth' or 'preFormat' before" +
                               " calling 'getMinTotalWidth'");
        }

        return self.minTotalWidth;
    },

     */
    if(!self.hasMinTotalWidth)
    {
        MNLogError(@"NoMinTotalWidth, Need to call 'preCalculateMinTotalWidth' or 'preFormat' before calling "
                   @"'getMinTotalWidth'");
    }

    return self.minTotalWidth;
}

/*!
 *  Create `ModifierContext`s for each tick in `voices`.
 *  @param voices the collection of voices
 *  @return <#return value description#>
 */
- (MNFormatterContext*)createModifierContexts:(NSArray<MNVoice*>*)voices
{
    /*
    createModifierContexts: function(voices) {
        var contexts = createContexts(voices,
                                      Vex.Flow.ModifierContext,
                                      function(tickable, context) {
                                          tickable.addToModifierContext(context);
                                      });
        self.mContexts = contexts;
        return contexts;
    },

     */
    MNFormatterContext* contexts = [self createContexts:voices
                                        withContextType:[MNModifierContext class]
                                         andAddFunction:^(MNTickable* tickable, MNModifierContext* context) {
                                           [tickable addToModifierContext:context];
                                         }];
    self.mContexts = contexts;
    return contexts;
}

/*!
 *  Create `TickContext`s for each tick in `voices`. Also calculate the
 *  total number of ticks in voices.
 *
 *  @param voices the collection of voices
 *  @return <#return value description#>
 */
- (MNFormatterContext*)createTickContexts:(NSArray<MNVoice*>*)voices
{
    /*
    createTickContexts: function(voices) {
        var contexts = createContexts(voices,
                                      Vex.Flow.TickContext,
                                      function(tickable, context) { context.addTickable(tickable); });

        contexts.array.forEach(function(context) {
            context.tContexts = contexts.array;
        });

        self.totalTicks = voices[0].getTicksUsed().clone();
        self.tContexts = contexts;
        return contexts;
    },
     */
    MNFormatterContext* contexts = [self createContexts:voices
                                        withContextType:[MNTickContext class]
                                         andAddFunction:^(MNTickable* tickable, MNTickContext* context) {
                                           [context addTickable:tickable];
                                         }];
    [contexts.array oct_foreach:^(MNTickContext* context, NSUInteger index, BOOL* stop) {
      context.tContexts = contexts.array;
    }];
    self.totalTicks = [((MNVoice*)[voices firstObject]).ticksUsed clone];
    self.tContexts = contexts;
    return contexts;
}

/*!
 *  this is the core formatter logic. Format voices and justify them
 *  to `justifyWidth` pixels. `graphicsContext` is required to justify elements
 *  that can't retreive widths without a canvas. self method sets the `x` positions
 *  of all the tickables/notes in the formatter.
 *
 *  @param voices the collection of voices
 *  @param staff  the staff being drawn onto
 *  @return YES if successful
 */
- (BOOL)preFormatWithContext:(CGContextRef)ctx voices:(NSArray<MNVoice*>*)voices staff:(MNStaff*)staff
{
    return [self preFormatWith:0 voices:voices staff:staff];
}
- (BOOL)preFormat
{
    return [self preFormatWith:0 voices:@[] staff:nil];
}
- (BOOL)preFormatWith:(float)justifyWidth voices:(NSArray<MNVoice*>*)voices staff:(MNStaff*)staff
{
    // Initialize context maps.
    MNFormatterContext* contexts = self.tContexts;
    NSArray* contextList = contexts.list;
    NSDictionary* contextMap = contexts.map;

    // If voices and a staff were provided, set the staff for each voice
    // and preFormat to apply Y values to the notes;
    if(voices && staff)
    {
        [voices oct_foreach:^(MNVoice* voice, NSUInteger index, BOOL* stop) {
          [voice setStaff:staff];
          [voice preFormat];
        }];
    }

    // Figure out how many pixels to allocate per tick.
    if(justifyWidth == 0)
    {
        self.pixelsPerTick = 0;
    }
    else
    {
        self.pixelsPerTick = justifyWidth / (self.totalTicks.floatValue * contexts.resolutionMultiplier);
    }

    // Now distribute the ticks to each tick context, and assign them their
    // own X positions.
    float x = 0;
    float center_x = justifyWidth / 2;
    float white_space = 0;   // White space to right of previous note
    float tick_space = 0;    // Pixels from prev note x-pos to curent note x-pos
    // NSNumber* prev_tick = nil;
    float prev_tick_value = 0;   // NSUInteger prev_tick_value = 0;
    float prev_width = 0;
    id<TickableMetrics> lastMetrics = nil;
    float initial_justify_width = justifyWidth;
    self.minTotalWidth = 0;

    NSNumber* tick;
    float tickValue;   // NSUInteger tickValue;
    id<MNContextDelegate> context;

    // Pass 1: Give each note maximum width requested by context.
    for(NSUInteger i = 0; i < contextList.count; ++i)
    {
        tick = contextList[i];
        tickValue = tick.floatValue;
        context = contextMap[tick];

        // Make sure that all tickables in self context have calculated their
        // space requirements.
        [context preFormat];

        id<TickableMetrics> selfMetrics = context.metrics;   // .getMetrics();
        float width = context.width;
        self.minTotalWidth += width;
        float min_x = 0;
        float points_used = width;

        // Calculate space between last note and next note.
        tick_space = MIN((tickValue - prev_tick_value) * self.pixelsPerTick, points_used);

        // Shift next note up `tick_space` pixels.
        float set_x = x + tick_space;

        // Calculate the minimum next note position to allow for right modifiers.
        if(lastMetrics != nil)
        {
            min_x = x + prev_width - lastMetrics.extraLeftPx;
        }

        // Determine the space required for the previous tick.
        // The `shouldIgnoreTicks` bool is YES for elements in the staff
        // that don't consume ticks (bar lines, key and time signatures, etc.)
        set_x = context.shouldIgnoreTicks ? (min_x + context.width) : mnmax(set_x, min_x);

        if([context shouldIgnoreTicks] && justifyWidth)
        {
            // self note stole room... recalculate with new justification width.
            justifyWidth -= context.width;
            self.pixelsPerTick = justifyWidth / (self.totalTicks.floatValue * contexts.resolutionMultiplier);
        }

        // Determine pixels needed for left modifiers.
        float left_px = selfMetrics.extraLeftPx;

        // Determine white space to right of previous tick (from right modifiers.)
        if(lastMetrics != nil)
        {
            white_space = (set_x - x) - (prev_width - lastMetrics.extraLeftPx);
        }

        // Deduct pixels from white space quota.
        if(i > 0)
        {
            if(white_space > 0)
            {
                if(white_space >= left_px)
                {
                    // Have enough white space for left modifiers - no offset needed.
                    left_px = 0;
                }
                else
                {
                    // Decrease left modifier offset by amount of white space.
                    left_px -= white_space;
                }
            }
        }

        // Adjust the tick x position with the left modifier offset.
        set_x += left_px;

        // Set the `x` value for the context, which sets the `x` value for all
        // tickables in self context.
        context.x = set_x;                  //.setX(set_x);
        context.pointsUsed = points_used;   //.setPixelsUsed(pixels_used);  // ??? Remove self if nothing breaks

        lastMetrics = selfMetrics;
        prev_width = width;
        // prev_tick = tick;
        x = set_x;
    }

    self.hasMinTotalWidth = YES;
    if(justifyWidth > 0)
    {
        // Pass 2: Take leftover width, and distribute it to proportionately to
        // all notes.
        float remaining_x = initial_justify_width - (x + prev_width);
        float leftover_pixels_per_tick = remaining_x / (self.totalTicks.floatValue * contexts.resolutionMultiplier);
        float accumulated_space = 0;
        prev_tick_value = 0;

        for(NSUInteger i = 0; i < contextList.count; ++i)
        {
            tick = contextList[i];
            tickValue = tick.floatValue;
            context = contextMap[tick];
            tick_space = (tickValue - prev_tick_value) * leftover_pixels_per_tick;
            accumulated_space = accumulated_space + tick_space;
            context.x = (context.x + accumulated_space);
            // prev_tick = tick;
            prev_tick_value = tickValue;

            // Move center aligned tickables to middle
            NSArray<MNTickable*>* centeredTickables = [context getCenterAlignedTickables];   //.getCenterAlignedTickables();

            [centeredTickables oct_foreach:^(MNTickable* tickable, NSUInteger index, BOOL* stop) {
              tickable.centerXShift = center_x - context.x;
            }];
        }
    }
    return YES;
}

/*!
 *  self is the top-level call for all formatting logic completed
 *  after `x` *and* `y` values have been computed for the notes
 *  in the voices.
 *
 *  @param voices the collection of voices
 *  @return <#return value description#>
 */
- (BOOL)postFormat   //:(NSArray<MNVoice*>*)voices
{
    // Postformat modifier contexts
    [self.mContexts.list oct_foreach:^(NSNumber* mContext, NSUInteger index, BOOL* stop) {
      [self.mContexts.map[mContext] postFormat];
    }];

    // Postformat tick contexts
    [self.tContexts.list oct_foreach:^(NSNumber* mContext, NSUInteger index, BOOL* stop) {
      [self.tContexts.map[mContext] postFormat];
    }];
    return YES;
}

- (id)joinVoices:(NSArray<MNVoice*>*)voices
{
    [self joinVoices:voices params:nil];
    return self;
}

/*!
 *  Take all `voices` and create `ModifierContext`s out of them. self tells
 *  the formatters that the voices belong on a single staff.
 *
 *  @param voices the collection of voices
 *  @param params <#params description#>
 */
- (void)joinVoices:(NSArray<MNVoice*>*)voices params:(NSDictionary*)params
{
    [self createModifierContexts:voices];
    self.hasMinTotalWidth = NO;
}

- (id)formatWith:(NSArray<MNVoice*>*)voices
{
    [self formatWith:voices withJustifyWidth:0];
    return self;
}

- (id)formatWith:(NSArray<MNVoice*>*)voices withJustifyWidth:(float)justifyWidth
{
    return [self formatWith:voices withJustifyWidth:justifyWidth andOptions:@{}];
}

/*!
 *  Align rests in voices, justify the contexts, and position the notes
 *  so voices are aligned and ready to render onto the staff. self method
 *  mutates the `x` positions of all tickables in `voices`.
 *
 *  Voices are full justified to fit in `justifyWidth` pixels.
 *
 *  Set `options.context` to the rendering context. Set `options.align_rests`
 *  to YES to enable rest alignment.
 *
 *  @param voices       the collection of voices
 *  @param justifyWidth the width to fit the notes into
 *  @param options      <#options description#>
 *  @return this formatter object
 */
- (id)formatWith:(NSArray<MNVoice*>*)voices withJustifyWidth:(float)justifyWidth andOptions:(NSDictionary*)options
{
    NSDictionary* opts = @{ @"align_rests" : @(NO), @"context" : [NSNull null] };
    opts = [NSMutableDictionary merge:opts with:options];
    [self alignRests:voices alignAllNotes:[opts[@"align_rests"] boolValue]];
    [self createTickContexts:voices];

    MNStaff* staff = opts[@"staff"];

    [self preFormatWith:justifyWidth voices:voices staff:staff];

    if(opts[@"staff"] && opts[@"staff"] != [NSNull null])
    {
        [self postFormat];
    }
    return self;
}

- (id)formatToStaff:(NSArray<MNVoice*>*)voices staff:(MNStaff*)staff
{
    return [self formatToStaff:voices staff:staff options:nil];
}

/*!
 *  this method is just like `format` except that the `justifyWidth` is inferred
 *  from the `MNStaff`.
 *  @param voices  the collection of voices
 *  @param staff   <#staff description#>
 *  @param options the collection of voices
 *  @return <#return value description#>
 */
- (id)formatToStaff:(NSArray<MNVoice*>*)voices staff:(MNStaff*)staff options:(nonnull NSDictionary*)options
{
    // TODO: this could be one spot to reduce width from clefs, time sigs, etc.
    float justifyWidth = staff.noteEndX - staff.noteStartX - 10;
    MNLogInfo(@"Formatting voices to width: %f", justifyWidth);
    //    NSDictionary* opts = @{@"context" : [NSValue valueWithPointer:staff.graphicsContext]};
    NSDictionary* dict = staff ?  @{ @"staff" : staff } : nil;
    NSDictionary* params = [NSMutableDictionary merge:options with:dict];
    return [self formatWith:voices withJustifyWidth:justifyWidth andOptions:params];
}

- (void)draw:(CGContextRef)ctx
{
    [MNFormatter formatAndDrawWithContext:ctx dirtyRect:CGRectZero toStaff:nil withNotes:nil];
}

@end
