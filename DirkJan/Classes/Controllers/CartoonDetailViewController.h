//
//  CartoonDetailViewController.h
//  DirkJan
//
//  Created by Hendrik Bruinsma on 09-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Cartoon.h"

@interface CartoonDetailViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) Cartoon *cartoon;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;


- (IBAction)displayShareOptions:(id)sender;

@end
