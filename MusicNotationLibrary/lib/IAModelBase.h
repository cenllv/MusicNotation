//
//  ModelBaseClass.h
//  RKTestApp
//
//  Created by Omar on 8/25/12.
//  Copyright (c) 2012 InfusionApps. All rights reserved.
//

//@import Foundation;
@import Foundation;
#import <TargetConditionals.h>
#ifdef TARGET_OS_IPHONE
//@import UIKit;
#elif TARGET_OS_MAC
@import AppKit;
#endif

#import "NSMutableDictionary+MNAdditions.h"

#define CollectionSuffiex @[ @"Array", @"Items", @"List", @"Collection" ];

@interface IAModelBase : NSObject

@property (strong, nonatomic) NSMutableDictionary* propertiesToDictionaryEntriesMapping;
@property (strong, nonatomic) NSMutableDictionary* classesForArrayEntries;

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
- (NSMutableDictionary*)classesForArrayEntries;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;


- (void)setValuesForKeyPathsWithDictionary:(NSDictionary*)keyedValues;
- (NSMutableDictionary*)dictionaryWithValuesForKeyPaths:(NSArray*)keyPaths;

@end

@interface IAModelBase (JSONDescription)
- (NSString*)description;
- (NSDictionary*)dictionarySerialization;
@end