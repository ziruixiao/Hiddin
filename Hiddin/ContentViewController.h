//
//  ContentViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Content.h"
#import "MTPopupWindow.h"

@interface ContentViewController : UIViewController <MTPopupWindowDelegate>

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) NSMutableArray *content;
@property int selectedIndex;
@property (strong,nonatomic) IBOutlet UIButton *topButton1;
@property (strong,nonatomic) IBOutlet UIButton *topButton2;
@property (strong,nonatomic) IBOutlet UIButton *topButton3;
@property (strong,nonatomic) IBOutlet UIButton *bottomButton1;
@property (strong,nonatomic) IBOutlet UIButton *bottomButton2;
@property (strong,nonatomic) IBOutlet UIButton *bottomButton3;
@property (strong,nonatomic) IBOutlet UIView *topView;

@property (strong,nonatomic) Content *toolContent;

- (void)getAllTaggedFacebookPhotos;
- (void)getAllComments;

- (void)reloadImageView;

- (IBAction)deletePressed:(id)sender;
- (IBAction)laterPressed:(id)sender;
- (IBAction)keepPressed:(id)sender;

- (IBAction)leftPressed:(id)sender;
- (IBAction)allPressed:(id)sender;
- (IBAction)rightPressed:(id)sender;

@end
