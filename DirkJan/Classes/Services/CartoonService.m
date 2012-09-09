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
    NSString *serviceUrl = kCartoonUrl;
    NSString *userAgent = kHttpUserAgent;
    
    self = [self initWithURLString:serviceUrl params:nil httpMethod:@"GET"];
    
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"User-Agent",
                             [ApplicationDelegate.lastUpdated rfc1123String], @"If-Modified-Since", nil];
    
    [self addHeaders:headers];
    
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
    
    if ([responseJSON count] < 1 )
    {
        return;
    }
    
    [dataImpl removeCartoons];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kCartoonDateFormat];
    
    for (NSDictionary *cartoonDictionary in (NSArray *) responseJSON) {
        Cartoon *cartoon = [dataImpl createCartoon];
        
        cartoon.name = [cartoonDictionary objectForKey:@"name"];
        cartoon.url = [cartoonDictionary objectForKey:@"url"];
        cartoon.views = [[cartoonDictionary objectForKey:@"date"] integerValue];
        cartoon.date = [dateFormatter dateFromString:[cartoonDictionary objectForKey:@"date"]].timeIntervalSince1970;
    }
        
    [dataImpl saveContext];
}


@end
