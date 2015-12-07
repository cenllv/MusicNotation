//
//  MNMTableViewController.m
//  MusicNotationMobile
//
//  Created by Scott on 8/1/15.
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

#import "MNMTableViewController.h"
#import "MNMProxyTestViewController.h"
#import "MNTestType.h"
#import "Tests.h"
#import "NSString+Ruby.h"
#import "MNColor.h"

@interface MNMTableViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSUInteger _testCount;
}

@property (strong, nonatomic) NSMutableArray<NSString*>* rawTestTitles;
@property (strong, nonatomic) NSMutableArray<NSString*>* formattedTestTitles;
@property (strong, nonatomic) NSArray<UIImage*>* cachedImages;
@property (assign, nonatomic) NSUInteger testCount;

@end

@implementation MNMTableViewController

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
    }
    return self;
}

- (NSArray*)rawTestTitles
{
    if(!_rawTestTitles)
    {
        _rawTestTitles = [NSMutableArray array];
        NSArray* allNumValues = REFAllValuesInMNTestType();
        for(NSNumber* numType in allNumValues)
        {
            NSString* typeString = REFStringForMemberInMNTestType([numType integerValue]);
            [_rawTestTitles addObject:typeString];
        }
    }
    return _rawTestTitles;
}

- (NSUInteger)testCount
{
    if(_testCount == 0)
    {
        _testCount = REFAllValuesInMNTestType().count;
    }
    return _testCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSMutableArray<NSString*>*)formattedTestTitles
{
    if(!_formattedTestTitles)
    {
        _formattedTestTitles = [NSMutableArray arrayWithCapacity:self.rawTestTitles.count];

        for(NSUInteger i = 0; i < self.testCount; ++i)
        {
            [_formattedTestTitles addObject:[self convertTestStringToTitleString:i]];
        }
    }
    return _formattedTestTitles;
}

- (NSString*)convertTestStringToTitleString:(NSInteger)row
{
    NSString* title = [self.rawTestTitles[row] camelCaseToTitleCase];
    NSArray<NSString*>* parts = [title split:@" "];
    if(parts.count >= 3)
    {
        parts = [parts subarrayWithRange:NSMakeRange(0, parts.count - 2)];
        title = [parts componentsJoinedByString:@" "];
    }
    return title;
}

- (NSInteger)tableView:(nonnull UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testCount;
}

+ (UIImage*)imageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 64, 32);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSArray<UIImage*>*)cachedImages
{
    if(!_cachedImages)
    {
        NSUInteger size = REFAllValuesInMNTestType().count;
        id tmp_cachedImages = [NSMutableArray arrayWithCapacity:size];
        for(NSUInteger i = 0; i < size; ++i)
        {
            tmp_cachedImages[i] = [[self class] imageFromColor:[MNColor randomBGColor:YES]];
        }
        _cachedImages = tmp_cachedImages;
    }
    return _cachedImages;
}

- (nonnull UITableViewCell*)tableView:(nonnull UITableView*)tableView
                cellForRowAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"cellTestTypeId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSUInteger row = indexPath.row;
    cell.imageView.image = self.cachedImages[row];
    cell.textLabel.text = self.formattedTestTitles[row];
    cell.detailTextLabel.text = self.rawTestTitles[row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"testSegue"])
    {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = indexPath.row;
        MNMProxyTestViewController* testController = (MNMProxyTestViewController*)[segue destinationViewController];
        testController.title = self.rawTestTitles[row];
        testController.testType = row;
    }
}

@end
