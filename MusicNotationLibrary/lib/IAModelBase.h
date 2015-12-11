//
//  ModelBaseClass.h
//  RKTestApp
//
//  Created by Omar on 8/25/12.
//  Copyright (c) 2012 InfusionApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+MNAdditions.h"
//#import "DPObject.h"

@interface IAModelBase : NSObject   // DPObject

@property (strong, nonatomic) NSMutableDictionary* propertiesToDictionaryEntriesMapping;
@property (strong, nonatomic) NSMutableDictionary* classesForArrayEntries;

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping;
- (NSMutableDictionary*)classesForArrayEntries;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

- (void)setValuesForKeyPathsWithDictionary:(NSDictionary*)keyedValues;
- (NSMutableDictionary*)dictionaryWithValuesForKeyPaths:(NSArray*)keyPaths;

- (id)merge:(id)other;

@end
//
//@interface IAModelBase (JSONDescription)
//- (NSString*)description;
//- (NSDictionary*)dictionarySerialization;
//@end