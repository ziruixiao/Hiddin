//
//  SplashViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "SplashViewController.h"
#import "UIViewController+JASidePanel.h"
#import "MenuViewController.h"
#import "ContentViewController.h"
#import "ContentTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SplashViewController () <FBLoginViewDelegate>

@end

@implementation SplashViewController

@synthesize appDelegate,buttonsContainer,fbConnectButton,twitterConnectButton;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
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
	// Do any additional setup after loading the view.
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.buttonsContainer.layer.cornerRadius = 8;
    self.buttonsContainer.layer.masksToBounds = YES;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        
    } else {
        
    }
    /*
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    //customize this later on
    loginview.readPermissions = @[@"user_photos",@"user_likes",@"user_checkins",@"user_groups",@"read_stream"];
    loginview.frame = CGRectMake(0,0,240,60);
    loginview.delegate = self;
    
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"hiddin_facebook_login.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, 271, 37);
        }
    }
    loginview.delegate = self;
    
    
    
    
    [self.fbConnectButton addSubview:loginview];
    */
    
}

#pragma mark - FBLoginViewDelegate
- (void)loginViewShowingLoggedInUser:(FBLoginView*)loginView
{
    NSLog(@"The user has logged in.");
    // first get the buttons set for login mode
    //self.buttonPostPhoto.enabled = YES;
    //self.buttonPostStatus.enabled = YES;
    //self.buttonPickFriends.enabled = YES;
    //self.buttonPickPlace.enabled = YES;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    //[self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
}

- (void)loginViewFetchedUserInfo:(FBLoginView*)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"Facebook Graph populated.");
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    //self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    //self.profilePic.profileID = user.id;
    self.appDelegate.loggedInUser = user;
    
    /*
    UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
    
    ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
    */
    
    UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentNavigationController"];
    
    ContentViewController *tempContentVC = (ContentViewController*)[tempContentNC.viewControllers objectAtIndex:0];
    
    tempContentVC.typeSelected = @"photo_tagged";
    
    
    [self.sidePanelController setCenterPanel:tempContentNC];
    
    [self.sidePanelController showCenterPanelAnimated:YES];
    
    
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView*)loginView
{
    // test to see if we can use the share dialog built into the Facebook application
    NSLog(@"logged out ");
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    //BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    //BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    
    //self.buttonPostStatus.enabled = canShareFB || canShareiOS6;
    //self.buttonPostPhoto.enabled = NO;
    //self.buttonPickFriends.enabled = NO;
    //self.buttonPickPlace.enabled = NO;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    //[self.buttonPostStatus setTitle:@"Post Status Update (Logged Off)" forState:self.buttonPostStatus.state];
    
    //self.profilePic.profileID = nil;
    //self.labelFirstName.text = nil;
    //self.loggedInUser = nil;
}

- (void)loginView:(FBLoginView*)loginView handleError:(NSError*)error
{
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

- (IBAction)triggerTwitterConnect
{
    
    UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
    
    ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
    
    /*
     UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentNavigationController"];
     
     ContentViewController *tempContentVC = (ContentViewController*)[tempContentNC.viewControllers objectAtIndex:0];
    */
    tempContentVC.typeSelected = @"tweet_text";
    
    [((MenuViewController*)self.sidePanelController) getTimeLine];
    
    [self.sidePanelController setCenterPanel:tempContentNC];
    
    [self.sidePanelController showCenterPanelAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
