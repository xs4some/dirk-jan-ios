//
//  DataImpl.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "DataImpl.h"
#import "Const.h"

@implementation DataImpl

#pragma mark - Data Protocol implementation

+(DataImpl *)sharedInstance
{
    static DataImpl *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedInstance = [[DataImpl alloc] init]; });
    
    return sharedInstance;
}

-(Cartoon *)createCartoon
{
    return [self createNewEntityOfType:@"Cartoon"];
}

-(void)removeCartoons
{
    [self deleteAllEntitiesOfType:@"Cartoon"];
}

-(NSArray *)getCartoons
{
     return [self fetchAllEntitiesOfType:@"Cartoon" withOrderBy:@"date"];
}

-(NSArray *)getCartoonsWithOfSet:(NSUInteger)ofSet
{
    return [self fetchAllEntitiesOfType:@"Cartoon" withOrderBy:@"date" andFetchLimit:kCartoonFetchLimit andOfSet:ofSet];
}

-(Cartoon *)getCartoonWithId:(NSNumber *) facebookId
{
    return (Cartoon *)[self getUniqueEntityOfType:@"Cartoon" criteriaKey:@"facebookId" andValue:facebookId];
}

@end
