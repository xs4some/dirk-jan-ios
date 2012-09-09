//
//  CartoonService.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "MKNetworkOperation.h"

@interface CartoonService : MKNetworkOperation

-(id)initService;
-(NSArray *)getCartoonsOnCompletion:(void(^)(NSArray *cartoons))completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
