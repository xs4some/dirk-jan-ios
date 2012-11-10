//
//  AppDelegate.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "AppDelegate.h"

#import "CartoonsViewController.h"
#import "InformationViewController.h"
#import "Const.h"

@implementation AppDelegate

@synthesize engine, lastUpdated;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"LastUpdated"])
    {
        lastUpdated = [userDefaults objectForKey:@"LastUpdated"];
    }
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:nil customHeaderFields:nil];
    [self.engine useCache];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 5)
    {
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    UIColorFromRGB(kColourNavigationButtons), UITextAttributeTextColor,
                                    [UIColor clearColor], UITextAttributeTextShadowColor, nil];
    
        [[UIBarButtonItem appearance] setTitleTextAttributes: attributes forState: UIControlStateNormal];
    }
    UIViewController *viewController1 = [[CartoonsViewController alloc] initWithNibName:@"CartoonsViewController" bundle:nil];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];

    UIViewController *viewController2 = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];

    if ([[UIDevice currentDevice] systemVersion].floatValue >= 5)
    {
        if (iPhone5) {
            [navigationController1.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-568h~Landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
            [navigationController2.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-568h~Landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        } else
        {
            [navigationController1.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar~Landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
            [navigationController2.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar~Landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        }
        
        [navigationController1.navigationBar setTintColor:UIColorFromRGB(kColourNavigationBar)];
        [navigationController1.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
        
        [navigationController2.navigationBar setTintColor:UIColorFromRGB(kColourNavigationBar)];
        [navigationController2.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navigationController1, navigationController2];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.lastUpdated forKey:@"LastUpdated"];
    
    [userDefaults synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
