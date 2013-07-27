//
//  ContentViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ContentViewController : UIViewController

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) IBOutlet UIImageView *imageView;

- (void)getFacebookPhotos;
@end
