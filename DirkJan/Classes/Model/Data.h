//
//  Data.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol DataProtocol
+(id)sharedInstance;

@end

@interface Data : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;

-(id)createNewEntityOfType:(NSString *) entityName;

-(NSArray *)getEntitiesOfType:(NSString *) entityName criteriaKey:(NSString *)keyName andValue:(NSObject *)value;
-(NSObject *)getUniqueEntityOfType:(NSString *) entityName criteriaKey:(NSString *)keyName andValue:(NSObject *)value;
-(NSArray *)getAllEntitiesOfType:(NSString *)entityName andPredicate:(NSPredicate *) predicate;
-(NSArray *)getAllChildEntitiesOfType:(NSString *)childEntitiy withParentObject:(NSObject *)parentObject andParentAttribute:(NSString *) parentAttribute;

-(NSArray *)fetchAllEntitiesOfType:(NSString *) entityName;
-(NSArray *)fetchAllEntitiesOfType:(NSString *) entityName withOrderBy:(NSString *)orderAttribute;
-(NSArray *)fetchAllEntitiesOfType:(NSString *) entityName withOrderBy:(NSString *)orderAttribute andFetchLimit:(NSUInteger) fetchlimit;
-(NSArray *)fetchAllEntitiesOfType:(NSString *) entityName withOrderBy:(NSString *)orderAttribute andFetchLimit:(NSUInteger) fetchlimit andOfSet:(NSUInteger)ofSet;


-(void)deleteAllEntitiesOfType:(NSString *) entityName;
-(void)deleteAllEntitiesOfType:(NSString *) entityName andPredicate:(NSPredicate *) predicate;

@end
