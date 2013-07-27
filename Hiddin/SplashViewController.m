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

@interface SplashViewController () <FBLoginViewDelegate>

@end

@implementation SplashViewController

@synthesize appDelegate;

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
	// Do any additional setup after loading the view.
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        
    } else {
        
    }
    
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    //customize this later on
    loginview.readPermissions = @[@"user_photos"];
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    
    [loginview sizeToFit];

    
}


#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"in");
    // first get the buttons set for login mode
    //self.buttonPostPhoto.enabled = YES;
    //self.buttonPostStatus.enabled = YES;
    //self.buttonPickFriends.enabled = YES;
    //self.buttonPickPlace.enabled = YES;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    //[self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"info gotten");
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    //self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    //self.profilePic.profileID = user.id;
    self.appDelegate.loggedInUser = user;
    
    [self.sidePanelController setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"]];
    
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
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

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
