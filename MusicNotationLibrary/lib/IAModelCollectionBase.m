//
//  ModelCollectionBaseClass.m
//  RKTestApp
//
//  Created by Omar on 8/25/12.
//  Copyright (c) 2012 InfusionApps. All rights reserved.
//

#import "IAModelCollectionBase.h"

@interface IAModelCollectionBase ()
@property (nonatomic, strong) NSMutableArray* collection;
@end

@implementation IAModelCollectionBase
//@synthesize collection;

- (id)init;
{
    self = [super init];
    if(self)
    {
        self.collection = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithArray:(NSArray*)array;
{
    self = [super init];
    if(self)
    {
        self.collection = [[NSMutableArray alloc] init];

        for(NSDictionary* dic in array)
        {
            IAModelBase* modelClass = [[[self classForModelBase] alloc] initWithDictionary:dic];
            [_collection addObject:modelClass];
        }
    }
    return self;
}

- (Class)classForModelBase;
{
    return [self class];
}

- (NSUInteger)count;
{
    return _collection.count;
}

- (void)addEntry:(IAModelBase*)entry;
{
    [_collection addObject:entry];
}

- (IAModelBase*)entryAtIndex:(int)index;
{
    return [_collection objectAtIndex:index];
}

@end
