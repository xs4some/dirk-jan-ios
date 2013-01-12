//
//  CartoonService.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "BaseService.h"

@interface CartoonService : BaseService

-(id)initService;
-(NSArray *)getCartoonsOnCompletion:(void(^)(NSArray *cartoons))completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
