//
//  CartoonService.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "CartoonService.h"

#import "AppDelegate.h"
#import "Const.h"

#import "DataImpl.h"

@interface CartoonService()

-(void)parseJson:(id)responseJSON;

@end

@implementation CartoonService

-(id)initService
{
    
    NSString *cartoonAlbumUrl = [NSString stringWithFormat:kCartoonAlbumUrl, kCartoonFetchLimit];

    self = [self initServiceWithURL:cartoonAlbumUrl params:nil method:HTTPGET];
    
    return self;
}

-(NSArray *)getCartoonsOnCompletion:(void(^)(NSArray *cartoons))completionBlock onError:(MKNKErrorBlock)errorBlock
{
    DataImpl *dataImpl = [DataImpl sharedInstance];
    
    [self onCompletion:^(MKNetworkOperation *completedOperation)
     {
         if(![completedOperation isCachedResponse])
         {
             [self parseJson:completedOperation.responseJSON];
             completionBlock([dataImpl getCartoons]);
         }
     }
               onError:^(NSError* error)
     {
         errorBlock(error);
     }];
    
    NSArray *result = [dataImpl getCartoons];
    
    [ApplicationDelegate.engine enqueueOperation:self forceReload:YES];
    
    return result; //return cached data till the time request processes.
}


-(void)parseJson:(id)responseJSON
{
    DataImpl *dataImpl = [DataImpl sharedInstance];
    
    NSArray *cartoonArray = [responseJSON objectForKey:@"data"];
    
    if ([cartoonArray count] < 1 )
    {
        return;
    }
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kRfc822DateFormat];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

    for (NSDictionary *cartoonDictionary in cartoonArray)
    {
        
        NSString *name = [cartoonDictionary objectForKey:@"name"];
        NSString *url = [cartoonDictionary objectForKey:@"link"];
        NSString *date = [cartoonDictionary objectForKey:@"created_time"];
        NSNumber *facebookId = [numberFormatter numberFromString:[cartoonDictionary objectForKey:@"id"]];
        
        if (!url || ! facebookId || !date)
        {
#if DEBUG
            NSLog(@"Missing elements in json!");
            NSLog(@"%@", cartoonDictionary);
#endif
            continue;
        }
        
        // Cartoon already in DB?
        
        Cartoon *cartoon = [dataImpl getCartoonWithId:facebookId];
        
        if (!cartoon)
        {
            cartoon = [dataImpl createCartoon];
         
            cartoon.name = name;
            cartoon.facebookId = facebookId;
            cartoon.url = url;
            cartoon.date = [dateFormatter dateFromString:date];
            cartoon.viewed = NO;
        }
    }
        
    [dataImpl saveContext];
}


@end
