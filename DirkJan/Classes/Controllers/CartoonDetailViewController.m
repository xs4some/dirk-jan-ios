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
#import "DataImpl.h"
#import "CartoonDetailsService.h"

#import <Twitter/Twitter.h>

@interface CartoonDetailViewController ()

@end

@implementation CartoonDetailViewController

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
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"SHARE_SAVETOPHOTOS", @"")];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"CANCEL", @"")];
    
    [actionSheet showInView:self.view];
}

- (IBAction)nextCartoon:(id)sender
{
    if (self.selectedCartoon < [self.cartoons count] - 1)
    {
        self.selectedCartoon += 1;
        if ( self.selectedCartoon == [self.cartoons count] - 1)
        {
            self.nextButton.enabled = NO;
        } else
        {
            self.previousButton.enabled = YES;
        }
        [self loadSelectdCartoon];
    }
}

- (IBAction)previousCartoon:(id)sender
{
    if (self.selectedCartoon > 0)
    {
        self.selectedCartoon -= 1;
        if (self.selectedCartoon == 0)
        {
            self.previousButton.enabled = NO;
        } else
        {
            self.nextButton.enabled = YES;
        }
        [self loadSelectdCartoon];
    }
}

- (void)loadSelectdCartoon
{
    self.facebookId = [[self.cartoons objectAtIndex:self.selectedCartoon] facebookId];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    CartoonDetailsService *cartoonDetailService = [[CartoonDetailsService alloc] initServiceWithFacebookId:self.facebookId];
    
    DataImpl *dataImpl = [DataImpl sharedInstance];
    
    Cartoon *cartoon = [dataImpl getCartoonWithId:self.facebookId];
    
    cartoon = [cartoonDetailService getCartoonInformationFromFacebook:^(Cartoon *cartoonFromService) {
        if (!cartoonFromService)
        {
            // Something went wrong
        } else
        {
//            self.cartoonTitle.title = cartoonFromService.name;

            [ApplicationDelegate.engine imageAtURL:[NSURL URLWithString:[cartoonFromService imageUrl]]
                                      onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                          if (isInCache) {
                                              self.imageView.image = fetchedImage;
                                              cartoon.viewed = @(YES);
                                              [dataImpl saveContext];
                                              
                                              CGSize imageSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height);
                                              [self.scrollView setContentSize:imageSize];
                                              [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES]; 
                                                                                           
                                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                          } else
                                          {
                                              DataImpl *dataImpl = [DataImpl sharedInstance];
                                              
                                              Cartoon *cartoonInDb = [dataImpl getCartoonWithId:[cartoon facebookId]];
                                              cartoonInDb.viewed = @(YES);
                                              cartoon.viewed = @(YES);
                                              [dataImpl saveContext];
                                              
                                              UIImageView *loadedImageView = [[UIImageView alloc] initWithImage:fetchedImage];
                                              loadedImageView.frame = self.imageView.frame;
                                              loadedImageView.alpha = 0;
                                              loadedImageView.contentMode = UIViewContentModeRight;
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
                                                   [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                                                   
                                                   self.imageView.alpha = 1;
                                                   [loadedImageView removeFromSuperview];
                                               }];
                                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                          }
                                      }];

        }
    } onError:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
                        
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        

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
    if (kEnableEmail && [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"SHARE_MAIL", @"")])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController addAttachmentData:UIImagePNGRepresentation(self.imageView.image) mimeType:@"" fileName:[[self.cartoons objectAtIndex:self.selectedCartoon] name]];
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
    
    if (kEnableTwitter && [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"SHARE_TWITTER", @"")])
    {
        TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
        [tweetController addImage:self.imageView.image];
        [tweetController setInitialText:NSLocalizedString(@"SHARED_WITH", @"")];
        
        [self presentModalViewController:tweetController animated:YES];

    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"SHARE_SAVETOPHOTOS", @"")])
    {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (error)
    {
        UIAlertView *saveFailedAlert = [[UIAlertView alloc] initWithTitle: nil
                                                                  message: [error localizedDescription]
                                                                 delegate: nil
                                                        cancelButtonTitle: NSLocalizedString(@"OK", @"")
                                                        otherButtonTitles: nil];
        [saveFailedAlert show];
    } else
    {
        UIAlertView *savedAlert = [[UIAlertView alloc] initWithTitle: nil
                                                             message: NSLocalizedString(@"SAVEDTOPHOTOS", @"")
                                                            delegate: nil
                                                   cancelButtonTitle: NSLocalizedString(@"OK", @"")
                                                   otherButtonTitles: nil];
        [savedAlert show];
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
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"SHARE_BUTTON", @"")
                                                                    style: UIBarButtonItemStylePlain
                                                                   target: self
                                                                   action: @selector(displayShareOptions:)];
    
    [self.navigationItem setRightBarButtonItem:shareButton];
    
    if (self.selectedCartoon == 0)
    {
        self.previousButton.enabled = NO;
    }
    
    if ( self.selectedCartoon == [self.cartoons count] - 1)
    {
        self.nextButton.enabled = NO;
    }
    
    self.facebookId = [[self.cartoons objectAtIndex:self.selectedCartoon] facebookId];
    
    [self loadSelectdCartoon];
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
