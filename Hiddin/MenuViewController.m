//
//  MenuViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize appDelegate;

//EMPTY - CUSTOM INITIALIZATION
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//EMPTY - WHAT HAPPENS BEFORE VIEWWILLAPPEAR
- (void)awakeFromNib
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
	// Do any additional setup after loading the view.
    
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                        message:@"AnyCloud requires an internet connection. Please connect and try again." delegate:nil cancelButtonTitle: @"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        
        /*show new controller
        ModalIntroViewController *modalIntroViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modalIntroViewController"];
        [self setCenterPanel:modalIntroViewController];
         */
        
    } else {
        
        if (![FBSession openActiveSessionWithAllowLoginUI:NO]) {

        } else {

        }
    
        //IF A FACEBOOK LOGIN EXISTS, GO TO THIS PAGE
        if (!FBSession.activeSession.accessTokenData.accessToken) {
            /*show not facebook login
            ModalIntroViewController *modalIntroViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modalIntroViewController"];
            [self setCenterPanel:modalIntroViewController];
             */
        
        } else {
            /*show active viewcontroller
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"defaultViewController"];
            [self setCenterPanel:centerViewController];
             */
        }
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end