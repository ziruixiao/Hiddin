//
//  DoneViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 9/3/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Content.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface DoneViewController : UIViewController

@property (strong,nonatomic) AppDelegate *appDelegate;

@property (strong,nonatomic) Content *toolContent;
@property (strong, nonatomic) IBOutlet UILabel *button1;
@property (strong, nonatomic) IBOutlet UILabel *button2;
@property (strong, nonatomic) IBOutlet UILabel *button3;

@property (strong,nonatomic) NSString *ref;

- (IBAction)tweetAboutIt:(id)sender;
@end
