//
//  BaseService.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 17-11-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "MKNetworkOperation.h"

typedef enum {
    HTTPGET,
    HTTPPOST
} HTTPMETHOD;

typedef enum {
    HTTPOK = 200,
    HTTPBADREQUEST = 400,
    HTTPUNAUTHORISED = 401,
    HTTPFORBIDDEN = 403,
    HTTPPRECONDITIONFAILED = 412,
    HTTPSERVERERROR = 500,
    HTTPINVALIDRESPONSE
} ErrorResponse;

@interface BaseService : MKNetworkOperation

-(id)initServiceWithURL:(NSString *)urlString params:(NSMutableDictionary *)params method:(HTTPMETHOD)method;

@end
