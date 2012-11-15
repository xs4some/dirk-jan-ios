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
    NSString *userAgent = nil;
    
    if (iPad)
    {
        userAgent = kHttpUserAgentiPad;
        if (Retina)
        {
            userAgent = [NSString stringWithFormat:@"%@:[Retina]", userAgent];
        } else
        {
            userAgent = [NSString stringWithFormat:@"%@:[nonRetina]", userAgent];
        }
    } else
    {
        userAgent = kHttpUserAgentiPhone;
        if (Retina)
        {
            if (iPhone5)
            {
                userAgent = [NSString stringWithFormat:@"%@:[568h]", userAgent];
            }
            userAgent = [NSString stringWithFormat:@"%@:[Retina]", userAgent];
        } else
        {
            userAgent = [NSString stringWithFormat:@"%@:[nonRetina]", userAgent];
        }
    }
    
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
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kCartoonDateFormat];

    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];

    for (NSDictionary *cartoonDictionary in (NSArray *) responseJSON) {
        
        NSString *name = [cartoonDictionary objectForKey:@"name"];
        NSString *url = [cartoonDictionary objectForKey:@"url"];
        NSNumber *views = [nf numberFromString:[cartoonDictionary objectForKey:@"views"]];
        NSString *date = [cartoonDictionary objectForKey:@"date"];
        
        if (!name || !url || ! views || !date)
        {
#if DEBUG
            NSLog(@"Missing elements in json!");
#endif
            continue;
        }
        
        NSArray *idArray = [url componentsSeparatedByString:@"_"];
        NSNumber *facebookId = nil;
        
        if (idArray && [idArray count] > 3)
        {
            facebookId = [nf numberFromString:[idArray objectAtIndex:1]];
        } else
        {
#if DEBUG
            NSLog(@"%@", cartoonDictionary);

            NSLog(@"Photo ID cannot be found, skipping this cartoon…");
#endif
            continue;
        }
        
        // Cartoon already in DB?
        
        Cartoon *cartoon = [dataImpl getCartoonWithId:facebookId];
        
        if (cartoon)
        {
            cartoon.views = views;
        } else
        {
            cartoon = [dataImpl createCartoon];
         
            cartoon.name = name;
            cartoon.facebookId = facebookId;
            cartoon.url = url;
            cartoon.views = views;
            cartoon.date = [dateFormatter dateFromString:date];
            cartoon.viewed = NO;
        }
    }
        
    [dataImpl saveContext];
}


@end
