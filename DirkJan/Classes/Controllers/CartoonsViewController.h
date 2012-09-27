//
//  CartoonsViewController.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface CartoonsViewController : UITableViewController <ADBannerViewDelegate>

@property (nonatomic,retain) NSArray *cartoons;
@property (nonatomic) Boolean bannerIsVisible;
@property (nonatomic, retain) ADBannerView *bannerView;
@property (nonatomic) UIInterfaceOrientation orientation;

@end
