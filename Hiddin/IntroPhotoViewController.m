//
//  IntroPhotoViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 8/2/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//
/*
 1) FULL DIM ON VIEW.
    -"Social networks are great. They let you share photos and thoughts."
    -"However, they can also hurt you?" OR "Not everything you post is meant for everyone to see"
    -"Hiddin gives you control over the content that friends, parents, employers, admissions officers, etc. can see"
    -"Click the button below to learn how this works."
 2) INTERACTIVE TUTORIAL 
    -Go through the buttons and encourage the user to try them out.
 3) OTHER TOPICS
    -Introduce the menu and the screen for tweets
    -Encourage them to come back often and also to show their friends.
 */

#import "IntroPhotoViewController.h"

@interface IntroPhotoViewController ()

@end

@implementation IntroPhotoViewController

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
    self.view.backgroundColor = [UIColor clearColor];
    
}


@end
