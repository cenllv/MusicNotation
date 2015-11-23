//
//  MTMTableViewController.m
//  MusicNotationMobile
//
//  Created by Scott on 8/1/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
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

#import "TableViewController.h"
#import "MNTestViewController.h"
#import <ReflectableEnum/ReflectableEnum.h>
#import "TestType.h"
#import "Tests.h"

@interface MTMTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray* tests;
@end

@implementation MTMTableViewController

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
    }
    return self;
}

- (NSArray*)tests
{
    if(!_tests)
    {
        _tests = [NSMutableArray array];
        NSArray* allNumValues = REFAllValuesInTestType();
        for(NSNumber* numType in allNumValues)
        {
            NSString* typeString = REFStringForMemberInTestType([numType integerValue]);
            [_tests addObject:typeString];
        }
    }
    return _tests;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tests.count;
}

- (nonnull UITableViewCell*)tableView:(nonnull UITableView*)tableView
                cellForRowAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.accessoryView = nil;
    cell.textLabel.text = self.tests[indexPath.row];

    //    switch(indexPath.section)
    //    {
    //        case 0:
    //        {
    //            switch(indexPath.row)
    //            {
    //                case 0:
    //                {
    //                }
    //                break;
    //            }
    //        }
    //        break;
    //    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"testSegue"])
    {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = indexPath.row;
        //        NSDate* object = self.objects[indexPath.row];

        //        LessonTabController* tabController = (LessonTabController*)[segue destinationViewController];
        //        LessonDetailViewController* controller = (LessonDetailViewController*)[tabController.viewControllers
        //        firstObject];
        // UINavigationController* navController = (UINavigationController*)[tabController.viewControllers firstObject];
        //        LessonDetailViewController* controller = (LessonDetailViewController*)[navController
        //        topViewController];
        //        [controller setDetailItem:object];
        //        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //        controller.navigationItem.leftItemsSupplementBackButton = YES;

        //        MTMTestViewController* testController = [[MTMTestViewController alloc]initWithTestType:indexPath.row];

        MTMTestViewController* testController = (MTMTestViewController*)[segue destinationViewController];
        testController.testType = row;
    }
}

@end
