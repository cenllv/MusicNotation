//
//  MNOutlineViewController.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 6/6/15.
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

#import "MNOutlineViewController.h"
#import "MNTestTrie.h"
#import "MNTestType.h"
#import "OCTotallyLazy.h"
#import "NSString+MNAdditions.h"

@interface MNOutlineViewController ()

@end

@implementation MNOutlineViewController

static id _sharedInstance;

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _sharedInstance = self;
        [self load];
    }
    return self;
}

+ (MNOutlineViewController*)sharedInstance
{
    return _sharedInstance;
}

- (void)load
{
    _tests = [NSMutableArray array];

    // examples of adding sections of tests for the sidebar if desired later

    //    Test* test1 = [[Test alloc] initWithName:@"abc"];
    //    [[test1 children] addObject:[[Test alloc] initWithName:@"qwfp"]];
    //    [[test1 children] addObject:[[Test alloc] initWithName:@"jluy"]];
    //    [[test1 children] addObject:[[Test alloc] initWithName:@"cvbk"]];
    //    Test* test2 = [[Test alloc] initWithName:@"123"];
    //    [[test2 children] addObject:[[Test alloc] initWithName:@"4536"]];
    //    [[test2 children] addObject:[[Test alloc] initWithName:@"34087456098"]];
    //    [[test2 children] addObject:[[Test alloc] initWithName:@"11119999"]];
    //    [_tests addObject:test1];
    //    [_tests addObject:test2];

    NSArray* allNumValues = REFAllValuesInMNTestType();
    NSArray* allStringValues = [allNumValues oct_map:^NSString*(NSNumber* numType) {
      NSString* camelCaseString = REFStringForMemberInMNTestType([numType integerValue]);
      return [camelCaseString camelCaseToTitleCase];
    }];

    for(NSString* typeName in allStringValues)
    {
        [_tests addObject:[[MNTestTrie alloc] initWithName:typeName]];
    }

    //    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //    NSUInteger i = [defaults objectForKey:@"lastTest"] ? [[defaults objectForKey:@"lastTest"] integerValue] : 0;
    //    [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:YES];
    //    [self.outlineView scrollRowToVisible:i];
}

#pragma mark - <NSOutlineViewDataSource>

- (NSInteger)outlineView:(NSOutlineView*)outlineView numberOfChildrenOfItem:(id)item
{
    if(!item)
    {
        return [_tests count];
    }
    else
    {
        return [[item children] count];
    }
}

- (BOOL)outlineView:(NSOutlineView*)outlineView isItemExpandable:(id)item
{
    if(!item)
    {
        return YES;
    }
    else
    {
        return [[item children] count] != 0;
    }
}

- (id)outlineView:(NSOutlineView*)outlineView child:(NSInteger)index ofItem:(id)item
{
    if(!item)
    {
        return [_tests objectAtIndex:index];
    }
    else
    {
        return [[item children] objectAtIndex:index];
    }
}

- (id)outlineView:(NSOutlineView*)outlineView objectValueForTableColumn:(NSTableColumn*)tableColumn byItem:(id)item
{
    //    if([[tableColumn identifier] isEqualToString:@"DataCell"])
    //    {
    return [item name];
    //        return [[NSCell alloc]initTextCell:@"arst"];
    //    }
    //    else
    //    {
    //        return @"Test";
    //        return [[NSCell alloc]initTextCell:@"arst"];
    //    }
}

#pragma mark - <NSOutlineViewDelegate>

- (nullable NSView*)outlineView:(nonnull NSOutlineView*)outlineView
             viewForTableColumn:(nullable NSTableColumn*)tableColumn
                           item:(nonnull id)item
{
    if([self outlineView:outlineView isGroupItem:item])
    {
        //        NSString *vId = [[[outlineView tableColumns] objectAtIndex:0] identifier];
        return [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    }
    return [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
}

- (BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item
{
    return [[item children] count] == 0;   //[item isKindOfClass:[ATDesktopFolderEntity class]];
}

- (void)outlineViewSelectionDidChange:(NSNotification*)notification
{
    //    NSLog(@"selected row: %lu", self.outlineView.selectedRow);
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"TestNotification"
                      object:[NSNumber numberWithInteger:self.outlineView.selectedRow]];
}

@end
