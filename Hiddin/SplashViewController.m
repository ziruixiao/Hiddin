//
//  SplashViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "SplashViewController.h"
#import "UIViewController+JASidePanel.h"

@interface SplashViewController ()

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
        [self.view viewWithTag:444].userInteractionEnabled = NO;
    } else {
        [self.view viewWithTag:444].userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(sessionStateChanged:)
         name:FBSessionStateChangedNotification
         object:nil];
    }

}

- (IBAction)authButtonAction
{
    [self showFBLogin];
}

#define IOS_NEWER_OR_EQUAL_TO_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 6.0 )

- (void)showFBLogin
{
    NSArray *permissions = [NSArray arrayWithObjects:@"email, user_photos, friends_photos", nil];
    
#ifdef IOS_NEWER_OR_EQUAL_TO_6
    permissions = [NSArray arrayWithObjects:@"email", @"user_photos",@"friends_photos",nil];
#endif
    
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         //NSLog(@"%@",FBSession.activeSession.accessTokenData.accessToken);
         NSLog(@"\nfb sdk error = %@", error);
         
         if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
             NSLog(@"The user has cancelled the login, therefore I don't need to do anything.");
         } else {
             switch (state) {
                 {case FBSessionStateOpen:
                     [[FBRequest requestForMe] startWithCompletionHandler:
                      ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                          if (!error) {
                              //success
                              [self moveToDefault];
                          }
                      }];
                     break; }
                 case FBSessionStateClosed:
                     break;
                 case FBSessionStateClosedLoginFailed:
                     NSLog(@"here");
                     break;
                 default:
                     break;
             }
         }
     }];
}

- (void)moveToDefault
{
    /*
    [self.sidePanelController setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"defaultViewController"]];
     */

}

- (void)sessionStateChanged:(NSNotification*)notification
{
    /*
    if (appDelegate.facebookSession.isOpen) {
        //NSLog(@"Logged In");
    } else {
        //NSLog(@"Logged Out");
    }
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
