//
//  BaseService.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 17-11-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "BaseService.h"
#import "Const.h"

@implementation BaseService

-(id)initServiceWithURL:(NSString *)serviceUrl params:(NSMutableDictionary *)params method:(HTTPMETHOD)method
{
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
    NSString *httpMethod = nil;
    
    switch (method)
    {
        case HTTPPOST:
            httpMethod = @"POST";
            break;
        
        case HTTPGET:
        default:
            httpMethod = @"GET";
            break;
    }
    
    self = [super initWithURLString:serviceUrl params:params httpMethod:httpMethod];
    
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"User-Agent", nil];
    
    [self addHeaders:headers];
    
    return self;

}

@end
