//
//  Data.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "Data.h"
#import "Const.h"

@interface Data (/*Private methods*/)

@end

@implementation Data

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

-(id)init
{
    if((self = [super init]))
    {
        [self managedObjectContext];
    }
    return self;
}

#pragma mark - Core Data stack

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
#if kDebug
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
            
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Content.sqlite"];
    
    NSError *error = nil;
    NSDictionary *migrationOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:migrationOptions error:&error])
    {
        
#if kDebug
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
        
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark Common methods
-(id)createNewEntityOfType:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:__managedObjectContext];
}

-(NSArray *)fetchAllEntitiesOfType:(NSString *) entityName
{
    return [self fetchAllEntitiesOfType:entityName withOrderBy:nil andFetchLimit:0 andOfSet:0];
}

-(NSArray *)fetchAllEntitiesOfType:(NSString *) entityName withOrderBy:(NSString *)orderAttribute
{
    return [self fetchAllEntitiesOfType:entityName withOrderBy:orderAttribute andFetchLimit:0 andOfSet:0];
}

-(NSArray *)fetchAllEntitiesOfType:(NSString *) entityName withOrderBy:(NSString *)orderAttribute andFetchLimit:(NSUInteger) fetchlimit
{
    return [self fetchAllEntitiesOfType:entityName withOrderBy:orderAttribute andFetchLimit:fetchlimit andOfSet:0];
}

-(NSArray *)fetchAllEntitiesOfType:(NSString *)entityName withOrderBy:(NSString *)orderAttribute andFetchLimit:(NSUInteger) fetchlimit andOfSet:(NSUInteger)ofSet
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    
    if (orderAttribute)
    {
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:orderAttribute ascending:NO]];
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    if (fetchlimit || fetchlimit == 0) {
        [fetchRequest setFetchLimit:fetchlimit];
    }
    
    if (ofSet || ofSet == 0) {
        [fetchRequest setFetchOffset:ofSet];
    }
    
    NSError *error;
    
    return [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

-(void)deleteAllEntitiesOfType:(NSString *)entityName
{
    [self deleteAllEntitiesOfType:entityName andPredicate:nil];
}

-(void)deleteAllEntitiesOfType:(NSString *)entityName andPredicate:(NSPredicate *) predicate
{
    if (!entityName) {
        return;
    }
    
    NSArray *results = [self getAllEntitiesOfType:entityName andPredicate:predicate];
    
    if ([results count] > 0) {
        for (NSManagedObject *managedObject in results)
        {
            [__managedObjectContext deleteObject:managedObject];
        }
    }
}


-(NSArray *)getAllChildEntitiesOfType:(NSString *)childEntitiy withParentObject:(id)parentObject andParentAttribute:(NSString *) parentAttribute
{
    if (!childEntitiy || !parentObject || !parentAttribute) {
        return [NSArray array];
    }
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:childEntitiy inManagedObjectContext:__managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO]]];
    
    //TODO: Match the foreign key with the primary key of the parent w
    [request setPredicate:[NSPredicate predicateWithFormat:@"(%@ == %@)", parentAttribute, parentObject]];
    
    
    
    NSError *error = nil;
    return [__managedObjectContext executeFetchRequest:request error:&error];
    
}

-(NSArray *)getAllEntitiesOfType:(NSString *)entityName andPredicate:(NSPredicate *) predicate
{
    if (!entityName) {
        return [NSArray array];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error;
    return [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

-(NSArray*)getEntitiesOfType:(NSString *)entityName criteriaKey:(NSString *)keyName andValue:(NSObject *)value
{
    if (!entityName || !keyName || !value)
        return [NSArray array];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",keyName, value];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
    return results;
}

-(id)getUniqueEntityOfType:(NSString *)entityName criteriaKey:(NSString *)keyName andValue:(NSObject *)value
{
    if (!entityName || !keyName || !value)
        return nil;
    
    NSArray *results = [self getEntitiesOfType:entityName criteriaKey:keyName andValue:value];
    
    if (results && results.count >= 1)
        return [results objectAtIndex:0];
    else
        return nil;
}

@end

