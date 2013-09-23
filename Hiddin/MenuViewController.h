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

@class WEPopoverController;

@interface MenuViewController : JASidePanelController <UIGestureRecognizerDelegate,UIAlertViewDelegate> {
    WEPopoverController *popoverController;
}

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (nonatomic, retain) WEPopoverController *popoverController;

- (void)getAllTaggedFacebookPhotos;
- (void)getAllPosts;
- (void)getTimeLine;
- (void)getTwitterFollowers;
- (void)lookUpFollowersWithArray:(NSMutableArray*)arrayOfFollowers;
- (void)switchAccounts;


@end
