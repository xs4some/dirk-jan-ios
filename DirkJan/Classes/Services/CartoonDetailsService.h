//
//  CartoonDetailsService.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 17-11-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "BaseService.h"
#import "Cartoon.h"

@interface CartoonDetailsService : BaseService

@property (nonatomic, retain) NSNumber *facebookId;

-(id)initServiceWithFacebookId:(NSNumber *)facebookId;
-(Cartoon *)getCartoonInformationFromFacebook:(void(^)(Cartoon *fbInfo))completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
