//
//  DataImpl.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Data.h"
#import "Cartoon.h"

@interface DataImpl : Data <DataProtocol>

-(Cartoon *)createCartoon;
-(void)removeCartoons;
-(NSArray *)getCartoons;
-(NSArray *)getCartoonsWithOfSet:(NSUInteger) ofSet;

@end
