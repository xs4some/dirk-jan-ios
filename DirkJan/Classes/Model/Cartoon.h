//
//  Cartoon.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 15-11-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cartoon : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * facebookId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * viewed;
@property (nonatomic, retain) NSNumber * views;

@end
