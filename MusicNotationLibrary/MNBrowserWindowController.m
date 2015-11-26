//
//  MNBrowserWindowController.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
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

#import "MNBrowserWindowController.h"
#import "Tests.h"
#import "MNWrappedLayout.h"
#import "MNTestCollectionItem.h"
#import "NSString+MNAdditions.h"
#import "MNOutlineViewController.h"

@interface MNBrowserWindowController () <NSSplitViewDelegate>

@property (strong, nonatomic) NSDictionary* classForType;
@property (strong, nonatomic) MNTestViewController* testViewController;
@property (strong) IBOutlet NSSplitViewController* splitViewController;

@property (strong, nonatomic) NSTextView* theTextView;

@end

@implementation MNBrowserWindowController

- (instancetype)init
{
    self = [super initWithWindowNibName:@"BrowserWindow"];
    self = [super init];   // WithCoder:coder];
    if(self)
    {
        //        static const int ddLogLevel = LOG_LEVEL_ALL;

        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"TestNotification"
                                                   object:nil];

        //        [_toolbar setAllowsUserCustomization:NO];
        //        [_toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
    }
    return self;
}

- (void)dealloc
{
    //    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    [_collectionView registerClass:[MNTestCollectionItem class] forItemWithIdentifier:kTestCollectionItemid];

    // set up the defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"hasLaunchedOnce"])
    {
        if([[defaults objectForKey:@"repeatLastTest"] boolValue])
        {
            self.testType =
                [defaults objectForKey:@"lastTest"] ? [[defaults objectForKey:@"lastTest"] integerValue] : NoneTestType;
        }
        else
        {
            self.testType = NoneTestType;
        }

        // // // UNCOMMENT TO DISABLE PREVIOUS TEST // // //
        //        self.testType = NoneTestType;

        self.differentSublayerBackgroundsCheckBox.state =
            [[defaults objectForKey:@"differentSublayerBackgrounds"] boolValue];
        self.showBoundingBoxesCheckBox.state = [[defaults objectForKey:@"showBoundingBoxes"] boolValue];
        ;
        self.labelBoundingBoxesCheckBox.state = [[defaults objectForKey:@"labelBoundingBoxes"] boolValue];
        ;
        self.repeatLastTestCheckBox.state = [[defaults objectForKey:@"repeatLastTest"] boolValue];
        ;
    }
    else
    {
        self.differentSublayerBackgroundsCheckBox.state = NO;
        self.showBoundingBoxesCheckBox.state = NO;
        self.labelBoundingBoxesCheckBox.state = NO;
        self.repeatLastTestCheckBox.state = YES;
        [defaults setObject:@(self.differentSublayerBackgroundsCheckBox.state) forKey:@"differentSublayerBackgrounds"];
        [defaults setObject:@(self.showBoundingBoxesCheckBox.state) forKey:@"showBoundingBoxes"];
        [defaults setObject:@(self.labelBoundingBoxesCheckBox.state) forKey:@"labelBoundingBoxes"];
        [defaults setObject:@(self.repeatLastTestCheckBox.state) forKey:@"repeatLastTest"];
        [defaults synchronize];
    }

    [self loadTest:self.testType];

    //    _splitView.delegate = self;

    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor underPageBackgroundColor], nil]];

    //    CGRect oldBounds = _collectionView.enclosingScrollView.contentView.bounds;
    //    _collectionView.enclosingScrollView.contentView.bounds = CGRectMake(0, 0, oldBounds.size.width,
    //    oldBounds.size.height);

    //    _collectionView.enclosingScrollView.hasHorizontalScroller = YES;
    //    _collectionView.enclosingScrollView.hasVerticalScroller = YES;
    //    _collectionView.enclosingScrollView.allowsMagnification = YES;
    //    _collectionView.enclosingScrollView.maxMagnification = 2;
    //    _collectionView.enclosingScrollView.minMagnification = 0.5;
    //    _collectionView.enclosingScrollView.magnification = 1.0;

    //    _splitViewController.splitView = _splitView;
    //    _splitViewController.splitViewItems
    ((NSButton*)_showHideToolbarButton.view).title = @"Hide";

    // set up the text output view
    NSSize contentSize = [self.textScrollView contentSize];

    [self.textScrollView setBorderType:NSNoBorder];
    [self.textScrollView setHasVerticalScroller:YES];
    [self.textScrollView setHasHorizontalScroller:NO];
    [self.textScrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

    self.textScrollView.scrollerKnobStyle = NSScrollerKnobStyleLight;

    self.theTextView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];
    [self.theTextView setMinSize:NSMakeSize(0.0, contentSize.height)];
    [self.theTextView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [self.theTextView setVerticallyResizable:YES];
    [self.theTextView setHorizontallyResizable:NO];
    [self.theTextView setAutoresizingMask:NSViewWidthSizable];

    [[self.theTextView textContainer] setContainerSize:NSMakeSize(contentSize.width, FLT_MAX)];
    [[self.theTextView textContainer] setWidthTracksTextView:YES];
    [self.theTextView setBackgroundColor:[NSColor blackColor]];
    [self.textScrollView setDocumentView:self.theTextView];

    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    // TODO: remove this test
    //        [[NSMutableAttributedString alloc] initWithString:@"firstsecondthird"];
    //
    //    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0,
    //    5)];
    //    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:NSMakeRange(5,
    //    6)];
    //    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(11,
    //    5)];

    self.theTextView.textStorage.attributedString = attributedString;

    [self appendText:attributedString];
    [self appendText:attributedString];
    [self appendText:attributedString];
}

- (void)appendText:(NSAttributedString*)attributedString
{
    //    [self privateAppendText:[[NSAttributedString alloc] initWithString:@"\r\n"]];
    [self privateAppendText:attributedString];
}

- (void)privateAppendText:(NSAttributedString*)attributedString
{
    NSUInteger loc = self.theTextView.textStorage.string.length;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.theTextView insertText:attributedString replacementRange:NSMakeRange(loc, attributedString.length)];
    });
}

- (void)receiveTestNotification:(NSNotification*)notification
{
    if([[notification name] isEqualToString:@"TestNotification"])
    {
        [self loadTest:[((NSNumber*)notification.object)integerValue]];
    }
}

- (NSDictionary*)classForType
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
            @(EveryThingTestType) : [NSNull null],
            @(FontTestType) : [MNFontTests class],
            @(FormatterTestType) : [MNFormatterTests class],
            @(GraceNoteTestType) : [MNGraceNoteTests class],
            @(KeyClefTestType) : [MNKeyClefTests class],
            @(KeyManagerTestType) : [MNKeyManagerTests class],
            @(KeySignatureTestType) : [MNKeySignatureTests class],
            @(LayerNoteTestsTestType) : [MNLayerNoteTests class],
            @(MocksType) : [NSNull null],
            @(ModifierTestType) : [NSNull null],
            @(MusicTestType) : [NSNull null],
            @(NodeTestType) : [NSNull null],
            @(NoteHeadTestType) : [MNNoteHeadTests class],
            @(NotationsGridTestType) : [MNNotationsGridTests class],
            @(OrnamentTestType) : [MNOrnamentTests class],
            @(ParseTestType) : [NSNull null],
            @(PedalMarkingTestType) : [MNPedalMarkingTests class],
            @(PercussionTestType) : [MNPercussionTests class],
            @(PlayNoteTestType) : [NSNull null],
            @(RestsTestType) : [MNRestsTest class],
            @(RhythmTestType) : [MNRhythmTests class],
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
            NSLog(@"%@:%lu out of sync with %@:%lu", VariableName(_classForType), _classForType.count,
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

#pragma mark CheckBoxe Options

- (IBAction)differentSublayerBackgroundsToggle:(NSButton*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(sender.state) forKey:@"differentSublayerBackgrounds"];
    [defaults synchronize];
}

- (IBAction)showBoundingBoxesToggle:(NSButton*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(sender.state) forKey:@"showBoundingBoxes"];
    [defaults synchronize];
}

- (IBAction)labelBoundingBoxesToggle:(NSButton*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(sender.state) forKey:@"labelBoundingBoxes"];
    [defaults synchronize];
}

- (IBAction)repeatLastTestToggle:(NSButton*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(sender.state) forKey:@"repeatLastTest"];
    [defaults synchronize];
}

- (void)loadTest:(MNTestType)testType
{
    _testType = testType;

    NSMutableString* windowTitleString = [NSMutableString stringWithFormat:@" Running : "];
    [windowTitleString appendString:[REFStringForMemberInMNTestType(_testType) camelCaseToTitleCase]];

    ((NSTextField*)windowTitleToolbarItem.view).stringValue = windowTitleString;

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(_testType) forKey:@"lastTest"];
    [defaults synchronize];

    if([self.classForType objectForKey:@(_testType)] != [NSNull null])
    {
        Class clazz = [self.classForType objectForKey:@(_testType)];
        if([clazz isSubclassOfClass:[MNTestViewController class]])
        {
            if(self.testViewController)
            {
                [self.testViewController tearDown];
            }

            self.testViewController = [[clazz alloc] init];
            [self.testViewController start];
            _collectionView.delegate = self.testViewController;
            _collectionView.dataSource = self.testViewController;
            //            ((NSScrollView*)_collectionView.superview).allowsMagnification = YES;

            MNWrappedLayout* layout = [[MNWrappedLayout alloc] init];
            layout.collectionView.delegate = self;
            layout.testViewController = self.testViewController;
            _collectionView.collectionViewLayout = layout;
            NSOutlineView* outlinView = [[MNOutlineViewController sharedInstance] outlineView];
            if(outlinView)
            {
                [outlinView selectRowIndexes:[NSIndexSet indexSetWithIndex:_testType] byExtendingSelection:NO];
                [outlinView scrollRowToVisible:_testType];
            }
        }
        else
        {
            // handle other test type...
        }
    }
}

#pragma mark - <NSToolbarDelegate>

- (IBAction)showHide:(NSToolbarItem*)sender
{
    NSButton* button = (NSButton*)sender;

    //    NSView* subView = [_splitView.subviews objectAtIndex:0];

    if([button.title isEqualToString:@"Show"])   // state == NSOnState)
    {
        //        button.state = NSOffState;
        [[self.splitViewController.splitViewItems[0] animator] setCollapsed:NO];
        button.title = @"Hide";
    }
    else if([button.title isEqualToString:@"Hide"])   // state == NSOffState)
    {
        //        button.state = NSOnState;
        [[self.splitViewController.splitViewItems[0] animator] setCollapsed:YES];
        button.title = @"Show";
    }
}

@end
