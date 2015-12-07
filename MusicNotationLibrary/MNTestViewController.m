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
#import "MNMTableViewCell.h"
#import "MNMCarrierView.h"
#elif TARGET_OS_MAC
#import "MNTestCollectionItem.h"
#endif
#import "MNTestActionStruct.h"
#import "MNRenderLayer.h"

@interface MNTestViewController ()
@property (assign, nonatomic) NSInteger numberOfSections;
@property (assign, nonatomic) NSInteger numberOfItems;
@property (strong, nonatomic) NSMutableArray<MNTestActionStruct*>* tests;

@end

@implementation MNTestViewController

- (void)start
{
    self.numberOfSections = 1;
    self.numberOfItems = 0;
    self.tests = [NSMutableArray array];
    [MNText showBoundingBox:NO];
}

- (void)tearDown
{
}

- (void)audioSetup
{
}

static NSString* const reuseId = @"customTestCell";

#if TARGET_OS_IPHONE
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[MNMTableViewCell class] forCellReuseIdentifier:reuseId];
        self.tableView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: this may not be helping
    self.tableView.estimatedRowHeight = 500.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(nonnull UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.tests.count;
    }
    return 0;
}

- (CGFloat)tableView:(nonnull UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    if(indexPath.section == 0)
    {
        MNTestActionStruct* testAction = ((MNTestActionStruct*)self.tests[indexPath.row]);
        return testAction.frame.size.height;
    }
    return 0;
}

- (void)tableView:(UITableView*)tableView
  willDisplayCell:(UITableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
    MNMTableViewCell* mnmCell = (MNMTableViewCell*)cell;
    MNRenderLayer* layer = (MNRenderLayer*)mnmCell.carrierView.layer;
    [cell layoutSubviews];
    [mnmCell.contentView setNeedsLayout];
    layer.parentView = mnmCell.carrierView;
}

- (nonnull UITableViewCell*)tableView:(nonnull UITableView*)tableView
                cellForRowAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    //    static NSString* cellIdentifier = @"testCell";
    MNMTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];

    if(!cell)
    {
        cell = [[MNMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.contentMode = UIViewContentModeScaleAspectFit;
    }

    MNTestActionStruct* testAction = self.tests[indexPath.row];

    cell.textLabel.text = testAction.name;
    MNRenderLayer* layer = (MNRenderLayer*)cell.carrierView.layer;
    layer.testAction = testAction;

    return cell;
}

//#pragma mark - <UITableViewDelegate>

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
        //        self.testItems = [NSMutableDictionary dictionary];
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
    //    if([self.testItems objectForKey:indexPath])
    //    {
    //        return [self.testItems objectForKey:indexPath];
    //    }

    MNTestCollectionItem* testCollectionItem =
        [collectionView makeItemWithIdentifier:kTestCollectionItemid forIndexPath:indexPath];
    MNTestActionStruct* testAction = self.tests[indexPath.item];
    [testCollectionItem setRepresentedObject:testAction];

    return testCollectionItem;
}

#pragma mark - <NSCollectionViewDelegate>

#pragma mark - <NSCollectionViewDelegateFlowLayout>

- (NSSize)collectionView:(NSCollectionView*)collectionView
                  layout:(NSCollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    MNTestActionStruct* testAction = self.tests[indexPath.item];
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

#pragma mark - Run Test

/*!
 *  Runs a basic test immediately with no drawing.
 *  @param name     the name of the test
 *  @param selector method to call for the test
 */
- (void)runTest:(NSString*)name func:(SEL)selector
{
    NSMethodSignature* signature = [self methodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    //    [invocation setArgument:&name atIndex:2];
    //    [invocation setArgument:&ctx atIndex:3];
    [invocation invoke];

    // NOTE: http://stackoverflow.com/a/22034059/629014
    //    BOOL* success __unsafe_unretained;
    //    [invocation getReturnValue:&success];
}

- (void)runTest:(NSString*)name func:(SEL)selector frame:(CGRect)frame
{
    self.numberOfItems++;
    MNTestActionStruct* testAction =
        [MNTestActionStruct testWithName:name andSelector:selector andTarget:self andFrame:frame];
    [self.tests addObject:testAction];
}

//- (void)runTest:(NSString*)name func:(SEL)selector params:(NSObject*)params
//{
//    NSMethodSignature* signature = [self methodSignatureForSelector:selector];
//    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
//    [invocation setSelector:selector];
//    [invocation setTarget:self];
//    [invocation setArgument:&name atIndex:2];
//    [invocation setArgument:&params atIndex:3];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//      [invocation invoke];
//    });
//}

- (void)runTest:(NSString*)name func:(SEL)selector frame:(CGRect)frame params:(NSObject*)params
{
    MNTestActionStruct* testAction =
        [MNTestActionStruct testWithName:name andSelector:selector andTarget:self andFrame:frame];
    if([params isKindOfClass:[NSDictionary class]] || [params isKindOfClass:[NSArray class]])
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

#pragma mark - <MNNoteDrawNotesDelegate>

+ (MNStaff*)setupContextWithSize:(MNUIntSize*)size   // withParent:(id<MNTestParentDelegate>)parent
{
    NSUInteger w = size.width;
    //    NSUInteger h = size.height;

    w = w != 0 ? w : 450;
    //    h = h != 0 ? h : 140;

    //    // [MNFont setFont:@" 10pt Arial"];

    MNStaff* staff = [[MNStaff staffWithRect:CGRectMake(10, 40, w, 0)] addTrebleGlyph];
    return staff;
}

+ (MNStaffNote*)showStaffNote:(MNStaffNote*)ret
                      onStaff:(MNStaff*)staff
                  withContext:(CGContextRef)ctx
                          atX:(float)x
              withBoundingBox:(BOOL)drawBoundingBox
{
    MNLogInfo(@"");
    MNTickContext* tickContext = [[MNTickContext alloc] init];
    [[tickContext addTickable:ret] preFormat];
    tickContext.x = x;
    tickContext.pointsUsed = 20;
    ret.staff = staff;
    [ret draw:ctx];
    if(drawBoundingBox)
    {
        [ret.boundingBox draw:ctx];
    }
    return ret;
}

+ (MNStaffNote*)showNote:(NSDictionary*)noteStruct onStaff:(MNStaff*)staff withContext:(CGContextRef)ctx atX:(float)x
{
    return [self showNote:noteStruct onStaff:staff withContext:ctx atX:x withBoundingBox:NO];
}

+ (MNStaffNote*)showNote:(NSDictionary*)noteStruct
                 onStaff:(MNStaff*)staff
             withContext:(CGContextRef)ctx
                     atX:(float)x
         withBoundingBox:(BOOL)drawBoundingBox
{
    MNStaffNote* ret = [[MNStaffNote alloc] initWithDictionary:noteStruct];
    return [self showStaffNote:ret onStaff:staff withContext:ctx atX:x withBoundingBox:drawBoundingBox];
}

@end
