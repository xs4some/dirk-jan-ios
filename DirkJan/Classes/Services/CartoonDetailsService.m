//
//  CartoonDetailsService.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 17-11-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "CartoonDetailsService.h"
#import "Const.h"
#import "DataImpl.h"
#import "AppDelegate.h"

@interface CartoonDetailsService()

-(Cartoon *)parseJson:(id)responseJSON;

@end

@implementation CartoonDetailsService

-(id)initServiceWithFacebookId:(NSNumber *)facebookId
{
    self.facebookId = facebookId;
    
    NSString *cartoonUrl = [NSString stringWithFormat:kCartoonDetailsUrl, [facebookId stringValue] ];
    
    self = [self initServiceWithURL:cartoonUrl params:nil method:HTTPGET];
    
    return self;
}

-(Cartoon *)getCartoonInformationFromFacebook:(void(^)(Cartoon *fbInfo))completionBlock onError:(MKNKErrorBlock)errorBlock
{
    DataImpl *dataImpl = [DataImpl sharedInstance];
    
    [self onCompletion:^(MKNetworkOperation *completedOperation)
     {
         if(![completedOperation isCachedResponse])
         {
             completionBlock([self parseJson:completedOperation.responseJSON]);
         }
     }
               onError:^(NSError* error)
     {
         errorBlock(error);
     }];
    
    Cartoon *cartoon = [dataImpl getCartoonWithId:self.facebookId];
    
    [ApplicationDelegate.engine enqueueOperation:self forceReload:YES];
    
    return cartoon; //return cached data till the time request processes.
}

-(Cartoon *)parseJson:(id)responseJSON
{
    DataImpl *dataImpl = [DataImpl sharedInstance];
    
    if (![responseJSON isKindOfClass:[NSDictionary class]])
    {
#ifdef DEBUG
        NSLog(@"Returned object is not a dictionary");
#endif
        return nil;
    }
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kRfc822DateFormat];
    
    NSDictionary *cartoonDictionary = (NSDictionary *)responseJSON;
    
    NSString *imageUrl = [cartoonDictionary objectForKey:@"source"];
    NSString *date = [cartoonDictionary objectForKey:@"created_time"];
    NSNumber *facebookId = [cartoonDictionary objectForKey:@"id"];
    NSDictionary *likesDict = [cartoonDictionary objectForKey:@"likes"];
    
    if ( !imageUrl || !date || !likesDict)
    {
#if DEBUG
        NSLog(@"Missing elements in json!");
        NSLog(@"%@", responseJSON);
#endif
        return nil;
    }
    NSArray *likes = [likesDict objectForKey:@"data"];
    
    if (!likes)
    {
#if DEBUG
        NSLog(@"Missing elements in json!");
#endif
        return nil;
    }
    
    // Cartoon already in DB?
    
    Cartoon *cartoon = [dataImpl getCartoonWithId:facebookId];
    
    if (cartoon)
    {
        cartoon.imageUrl = imageUrl;
        cartoon.likes = [NSNumber numberWithInt:[likes count]];

        return cartoon;
    } else
    {
        return nil;
    }
}

@end
