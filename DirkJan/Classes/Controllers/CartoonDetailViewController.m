//
//  CartoonDetailViewController.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 09-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "CartoonDetailViewController.h"

#import "AppDelegate.h"
#import "SORelativeDateTransformer.h"

@interface CartoonDetailViewController ()

@end

@implementation CartoonDetailViewController

@synthesize cartoon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Cartoon"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[cartoon date]];
    SORelativeDateTransformer *relativeDateTransformer = [[SORelativeDateTransformer alloc] init];
    
    self.title = [relativeDateTransformer transformedValue:date];

    [ApplicationDelegate.engine imageAtURL:[NSURL URLWithString:[self.cartoon url]]
                              onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                  if (isInCache) {
                                      self.imageView.image = fetchedImage;
                                  } else
                                  {
                                      UIImageView *loadedImageView = [[UIImageView alloc] initWithImage:fetchedImage];
                                      loadedImageView.frame = self.imageView.frame;
                                      loadedImageView.alpha = 0;
                                      loadedImageView.contentMode = UIViewContentModeLeft;
                                      [self.view addSubview:loadedImageView];
                                      
                                      [UIView animateWithDuration:0.4
                                                       animations:^
                                       {
                                           loadedImageView.alpha = 1;
                                           self.imageView.alpha = 0;
                                       }
                                                       completion:^(BOOL finished)
                                       {
                                           self.imageView.image = fetchedImage;
                                           
                                           CGSize imageSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height);
                                           [self.scrollView setContentSize:imageSize];
                                           self.imageView.alpha = 1;
                                           [loadedImageView removeFromSuperview];
                                       }];
                                  }
                              }];

    
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

@end
