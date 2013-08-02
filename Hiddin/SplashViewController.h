//
//  SplashViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SplashViewController : UIViewController

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIView *buttonsContainer;
@property (strong, nonatomic) IBOutlet UIButton *twitterConnectButton;
@property (strong, nonatomic) IBOutlet UIView *fbConnectButton;

- (IBAction)triggerTwitterConnect;

@end
