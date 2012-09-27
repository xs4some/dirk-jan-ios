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
#import "Const.h"

#import <Twitter/Twitter.h>

@interface CartoonDetailViewController ()

@end

@implementation CartoonDetailViewController

@synthesize cartoon;

- (IBAction)displayShareOptions:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"SHARE_VIA", @"")
                                                             delegate: self
                                                    cancelButtonTitle: nil
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: nil];
    
    if (kEnableEmail && [MFMailComposeViewController canSendMail])
    {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"SHARE_MAIL", @"")];
    }

    if (kEnableTwitter && [TWTweetComposeViewController canSendTweet])
    {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"SHARE_TWITTER", @"")];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"CANCEL", @"")];
    
    [actionSheet showInView:self.view];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#if DEBUG
    NSLog(@"%@", [error localizedDescription]);
#endif
    [self dismissModalViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (kEnableEmail && [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"SHARE_MAIL", @"")]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController addAttachmentData:UIImagePNGRepresentation(self.imageView.image) mimeType:@"" fileName:[self.cartoon name]];
        [mailController setMessageBody:NSLocalizedString(@"SHARED_WITH", @"") isHTML:NO];
        [mailController setSubject:NSLocalizedString(@"SHARE_MAIL_SUBJECT", @"")];
        [mailController setMailComposeDelegate:self];
        [[mailController navigationBar] setTintColor:[UIColor colorWithRed:0.984 green:0.953 blue:0.620 alpha:1]];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    UIColorFromRGB(kColourNavigationButtons), UITextAttributeTextColor,
                                    [UIColor clearColor], UITextAttributeTextShadowColor, nil];

        [[mailController navigationBar] setTitleTextAttributes:attributes];
        
        [self presentModalViewController:mailController animated:YES];
    }
    
    if (kEnableTwitter && [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"SHARE_TWITTER", @"")]) {
        TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
        [tweetController addImage:self.imageView.image];
        [tweetController setInitialText:NSLocalizedString(@"SHARED_WITH", @"")];
        
        [self presentModalViewController:tweetController animated:YES];

    }
}

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
    
    if (kEnableEmail && [MFMailComposeViewController canSendMail] &&
        kEnableTwitter && [TWTweetComposeViewController canSendTweet])
    {
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"SHARE_BUTTON", @"")
                                                                        style: UIBarButtonItemStylePlain
                                                                       target: self
                                                                       action: @selector(displayShareOptions:)];
        
        [self.navigationItem setRightBarButtonItem:shareButton];
    }

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
