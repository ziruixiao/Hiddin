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

@interface ContentTableViewController : UITableViewController <MTPopupWindowDelegate,JZSwipeCellDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) NSMutableArray *content;
@property (strong,nonatomic) Content *toolContent;
@property (strong,nonatomic) NSString *typeSelected;

@property (strong,nonatomic) NSString *action;

- (void)refreshData;

@end
