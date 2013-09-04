//
//  ErrorViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 9/3/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "ErrorViewController.h"
#import "MenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "SVProgressHUD.h"
#import "ContentViewController.h"
#import "ContentTableViewController.h"

@interface ErrorViewController ()

@end

@implementation ErrorViewController
@synthesize ref;

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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiddin_nav.png"]];
    
	// Do any additional setup after loading the view.
}

- (IBAction)tryAgain:(id)sender
{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             if ([ref isEqualToString:@"photo"]) {
                 UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentNavigationController"];
                 
                 ContentViewController *tempContentVC = (ContentViewController*)[tempContentNC.viewControllers objectAtIndex:0];
                 
                 tempContentVC.typeSelected = @"tweet_media";
                 
                 self.sidePanelController.centerPanel = tempContentNC;
             } else {
                 UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
                 
                 ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
                 
                 tempContentVC.typeSelected = @"tweet_text";
                 
                 self.sidePanelController.centerPanel = tempContentNC;
             }
         } else {
             NSLog(@"no access");
             // Handle failure to get account access
             
         }
     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
