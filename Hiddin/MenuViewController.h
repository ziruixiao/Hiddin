//
//  MenuViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "JASidePanelController.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import "SVProgressHUD.h"

@interface MenuViewController : JASidePanelController <UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) AppDelegate *appDelegate;

- (void)getAllTaggedFacebookPhotos;
- (void)getAllPosts;
- (void)getTimeLine;
- (void)getTwitterFollowers;
- (void)lookUpFollowersWithArray:(NSMutableArray*)arrayOfFollowers;

@end
