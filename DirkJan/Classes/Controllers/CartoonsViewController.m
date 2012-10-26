//
//  CartoonsViewController.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "CartoonsViewController.h"

#import "AppDelegate.h"
#import "CartoonService.h"
#import "Cartoon.h"
#import "CartoonCell.h"
#import "MBProgressHUD.h"
#import "SORelativeDateTransformer.h"
#import "CartoonDetailViewController.h"
#import "Const.h"

#import "tgmath.h"

@interface CartoonsViewController ()

@end

@implementation CartoonsViewController

@synthesize bannerIsVisible, bannerView, orientation;

#pragma mark - iAD methods

#if kEnableAdds
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        [self setBannerIsVisible:NO];
        [self.tableView reloadData];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        [self setBannerIsVisible:YES];
        [self.tableView reloadData];
    }
}

#endif

- (void)reloadData
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.hidden = NO;
    
    CartoonService *cartoonService = [[CartoonService alloc] initService];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSArray *tmpCartoons = [cartoonService getCartoonsOnCompletion:^(NSArray *cartoonsFromService)
                            {
                                if (! cartoonsFromService || [cartoonsFromService count] < 1 ) {
                                    //TODO: Do something, when the results are strange.
                                } else {
                                    //TODO: show that
                                    [self.refreshControl endRefreshing];
                                    self.cartoons = cartoonsFromService;
                                }
                                
                                [self.tableView reloadData];
                                
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            } onError:^(NSError *error) {
                                //TODO: Show error, or not.
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            }];
    
    self.cartoons = tmpCartoons;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"CARTOON_TITLE", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"warning.png"];
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        self.navigationItem.titleView = label;
        [label sizeToFit];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#if kEnableAdds
    [self setBannerIsVisible:NO];
    [self.bannerView setDelegate:self];
    self.bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//    [self.view addSubview:self.bannerView];
#endif
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadData)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = UIColorFromRGB(kColourNavigationBar);
    
    self.refreshControl = refreshControl;
    
    [self.tableView setSeparatorColor:UIColorFromRGB(kColourCellSeperator)];
    [self.tableView setBackgroundColor:UIColorFromRGB(kColourOddCells)];
    
    
    [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
#if kEnableAdds
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    } else
    {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    }
#endif
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if kEnableAdds
    if (self.bannerIsVisible) {
        switch (self.orientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return 32;
                break;
                
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
            default:
                return 50;
                break;
        }
        return 22;
    }
#endif
    
    return 24.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.cartoons) {
        return 1;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cartoons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CartoonCell";

    #if kEnableAdds
    if (self.bannerIsVisible && indexPath.row == 0)
    {
        UITableViewCell *addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddCell"];
        
        [addCell addSubview:self.bannerView];
        
        return addCell;
    }
#endif
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        cell.textLabel.textColor = UIColorFromRGB(0x414141);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.text = @">";
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x414141);
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(kColourNavigationBar);
    }
    
    if(indexPath.row % kColourCellsInaRow)
    {
        cell.contentView.backgroundColor = UIColorFromRGB(kColourOddCells);
    } else
    {
        cell.contentView.backgroundColor = UIColorFromRGB(kColourEvenCells);
    }
    
#if kEnableAdds
    Cartoon *cartoon = [self.cartoons objectAtIndex:indexPath.row - 1];
#else
    Cartoon *cartoon = [self.cartoons objectAtIndex:indexPath.row];
#endif
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[cartoon date]];
    
    SORelativeDateTransformer *relativeDateTransformer = [[SORelativeDateTransformer alloc] init];
    
    cell.textLabel.text = [relativeDateTransformer transformedValue:date];

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CartoonDetailViewController *controller = [[CartoonDetailViewController alloc] init];

#if kEnableAdds
    controller.cartoon = [self.cartoons objectAtIndex:indexPath.row - 1];
#else
    controller.cartoon = [self.cartoons objectAtIndex:indexPath.row];
#endif
    
    [controller setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
