//
//  MNTestViewController.m
//  MusicNotation
//
//  Created by Scott on 8/3/15.
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

#import "MNTestViewController.h"
#if TARGET_OS_IPHONE
#elif TARGET_OS_MAC
#import "MNTestCollectionItem.h"
#endif
#import "MNTestAction.h"
#import "MNRenderLayer.h"

@interface MNTestViewController ()
@property (assign, nonatomic) NSInteger numberOfSections;
@property (assign, nonatomic) NSInteger numberOfItems;
#if TARGET_OS_IPHONE
@property (strong, nonatomic) NSMutableDictionary* rowHeights;
#elif TARGET_OS_MAC
#endif
@property (strong, nonatomic) NSMutableArray* tests;            // collection of  MNTestView
@property (strong, nonatomic) NSMutableDictionary* testItems;   // collection of TestCollectionItem
@end

@implementation MNTestViewController

- (void)start
{
    self.numberOfSections = 1;
    self.numberOfItems = 0;
    self.tests = [NSMutableArray array];
    self.testItems = [NSMutableDictionary dictionary];
}

#if TARGET_OS_IPHONE
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(nonnull UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.numberOfItems;
    }
    return 0;
}

- (CGFloat)tableView:(nonnull UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    if(indexPath.section == 0)
    {
        return ((TestCollectionItemView*)self.tests[indexPath.row]).frame.size.height;
    }
    return 0;
}

- (nonnull UITableViewCell*)tableView:(nonnull UITableView*)tableView
                cellForRowAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = @"arst";

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    TestCollectionItemView* test = self.tests[indexPath.row];
    //    cell.frame = test.frame;
    [cell.contentView addSubview:test];
    [test setNeedsDisplay];

    return cell;
}

#pragma mark - <UITableViewDelegate>

//--------------------------------
#elif TARGET_OS_MAC
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        //        self.tableView.delegate = self;
        //        self.tableView.dataSource = self;
        self.numberOfSections = 1;
        self.numberOfItems = 0;
        self.tests = [NSMutableArray array];
        self.testItems = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - <NSCollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView*)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tests.count;
}

- (nonnull NSCollectionViewItem*)collectionView:(nonnull NSCollectionView*)collectionView
            itemForRepresentedObjectAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    if([self.testItems objectForKey:indexPath])
    {
        return [self.testItems objectForKey:indexPath];
    }

    MNTestCollectionItem* testCollectionItem =
        [collectionView makeItemWithIdentifier:kTestCollectionItemid forIndexPath:indexPath];
    MNTestAction* testAction = self.tests[indexPath.item];
    [testCollectionItem setRepresentedObject:testAction];

    return testCollectionItem;
}

#pragma mark - <NSCollectionViewDelegate>

#pragma mark - <NSCollectionViewDelegateFlowLayout>

- (NSSize)collectionView:(NSCollectionView*)collectionView
                  layout:(NSCollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    MNTestAction* testAction = self.tests[indexPath.item];
    return testAction.frame.size;
}

/*
 - (NSEdgeInsets)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout
 insetForSectionAtIndex:(NSInteger)section;
 - (CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout
 minimumLineSpacingForSectionAtIndex:(NSInteger)section;
 - (CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout
 minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
 - (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout
 referenceSizeForHeaderInSection:(NSInteger)section;
 - (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout
 referenceSizeForFooterInSection:(NSInteger)section;
 */

#endif

#pragma mark - runTest

- (void)runTest:(NSString*)name func:(SEL)selector
{
    NSMethodSignature* signature = [self methodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    //    [invocation setArgument:&name atIndex:2];
    //    [invocation setArgument:&ctx atIndex:3];
    [invocation invoke];

    //    BOOL* success __unsafe_unretained;   // http://stackoverflow.com/a/22034059/629014
    //    [invocation getReturnValue:&success];
}

- (void)runTest:(NSString*)name func:(SEL)selector frame:(CGRect)frame
{
    self.numberOfItems++;
    MNTestAction* testAction = [MNTestAction testWithName:name andSelector:selector andTarget:self andFrame:frame];
    [self.tests addObject:testAction];
}

- (void)runTest:(NSString*)name func:(SEL)selector params:(NSObject*)params
{
    NSMethodSignature* signature = [self methodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    [invocation setArgument:&name atIndex:2];
    [invocation setArgument:&params atIndex:3];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [invocation invoke];
    });
}

- (void)runTest:(NSString*)name func:(SEL)selector frame:(CGRect)frame params:(NSObject*)params
{
    MNTestAction* testAction = [MNTestAction testWithName:name andSelector:selector andTarget:self andFrame:frame];
    if([params isKindOfClass:[NSDictionary class]])
    {
        testAction.params = (NSDictionary*)params;
    }
    else
    {
        MNLogError(@"Params Dictionary Error");
    }
    [self.tests addObject:testAction];
    //    [self.testItems setObject:testAction forKey:[NSIndexPath indexPathForItem:self.numberOfItems inSection:0]];
    self.numberOfItems++;
}

- (MNRenderLayer*)renderLayer
{
    CALayer* mainLayer = self.view.layer;
    if([mainLayer isKindOfClass:[MNRenderLayer class]])
    {
        return ((MNRenderLayer*)mainLayer);
    }
    else
        return nil;
}

@end
