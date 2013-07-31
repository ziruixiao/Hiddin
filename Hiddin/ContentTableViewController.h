//
//  ContentTableViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 7/30/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Content.h"
#import "MTPopupWindow.h"
#import "AsynchImageView.h"
#import "ExampleCell.h"

@interface ContentTableViewController : UITableViewController <MTPopupWindowDelegate,JZSwipeCellDelegate>

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) NSMutableArray *content;
@property int selectedIndex;
@property (strong,nonatomic) Content *toolContent;
@property (strong,nonatomic) NSString *typeSelected;

@end