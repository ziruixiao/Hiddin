//
//  ErrorViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 9/3/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "ErrorViewController.h"

@interface ErrorViewController ()

@end

@implementation ErrorViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
