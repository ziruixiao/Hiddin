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
#import "UIViewController+MJPopupViewController.h"

@interface DoneViewController ()

@end

@implementation DoneViewController
@synthesize appDelegate,toolContent,button1,button2,button3;

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
    [self loadLabels];
	// Do any additional setup after loading the view.
}

- (void)loadLabels
{
    //load the number of "done" ones into green
    //load the number of "later" ones into yellow
    //load the number of "deleted" ones into red
    
}

- (IBAction)tweetAboutIt:(id)sender
{
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"I just used #hiddin to clean my Twitter timeline! @hiddinapp"]; //Add here your text
    
    // Add an image
    //[tweetSheet addImage:[UIImage imageNamed:@"AnyCloud.co.png"]]; //Add here the name of your picture
    // Add a link
    [tweetSheet addURL:[NSURL URLWithString:@"http://itunes.com/apps/hiddin"]];
}

- (void)refreshData
{
    [SVProgressHUD showWithStatus:@"Reloading tweets..."];
    [((MenuViewController*)self.sidePanelController) getTimeLine];
    [SVProgressHUD dismiss];
    self.toolContent = [[Content alloc] init];
    self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
