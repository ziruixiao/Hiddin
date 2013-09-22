//
//  DoneViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 9/3/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "DoneViewController.h"
#import "MenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "ContentTableViewController.h"
#import "ContentViewController.h"

@interface DoneViewController ()

@end

@implementation DoneViewController
@synthesize appDelegate,toolContent,button1,button2,button3,ref;

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
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiddin_nav.png"]];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hiddin_nav_refresh.png"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = refreshItem;
    
    
    
    //[self loadLabels];
	// Do any additional setup after loading the view.
}
/*
- (void)loadLabels
{
    int myArray[8] = {0,0,0,0,0,0,0,0};
    
    [toolContent getMenuCounts:myArray];
    
    //load the number of "done" ones into green
    button1.text = [NSString stringWithFormat:@"%i",(myArray[2]+myArray[5])];
    
    //load the number of "later" ones into yellow
    button2.text = [NSString stringWithFormat:@"%i",(myArray[1]+myArray[4])];
    //load the number of "deleted" ones into red
    button3.text = [NSString stringWithFormat:@"%i",(myArray[6]+myArray[7])];
    
}*/

- (IBAction)tweetAboutIt:(id)sender
{
     if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
         NSLog(@"twitter avail");
     
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"I just used #hiddin to clean my Twitter timeline! @hiddinapp http://itunes.com/apps/hiddin"]; //Add here your text
    
    // Add an image
    //[tweetSheet addImage:[UIImage imageNamed:@"AnyCloud.co.png"]]; //Add here the name of your picture
    // Add a link
         [self presentViewController:tweetSheet animated:YES completion:nil];
     }
}

- (void)refreshData
{
    [SVProgressHUD showWithStatus:@"Reloading tweets..."];
    [((MenuViewController*)self.sidePanelController) getTimeLine];
    [SVProgressHUD dismiss];
    self.toolContent = [[Content alloc] init];
    if ([ref isEqualToString:@""]) {
        UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
        
        ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
        
        tempContentVC.typeSelected = @"tweet_text";
        
        self.sidePanelController.centerPanel = tempContentNC;
        
    } else {
        
        UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentNavigationController"];
        
        ContentViewController *tempContentVC = (ContentViewController*)[tempContentNC.viewControllers objectAtIndex:0];
        
        tempContentVC.typeSelected = @"tweet_media";
        
        self.sidePanelController.centerPanel = tempContentNC;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
