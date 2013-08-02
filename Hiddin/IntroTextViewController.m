//
//  IntroTextViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 8/2/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//
/*

 */

#import "IntroTextViewController.h"

@interface IntroTextViewController ()

@end

@implementation IntroTextViewController

@synthesize delegate;


- (IBAction)closePopup:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
