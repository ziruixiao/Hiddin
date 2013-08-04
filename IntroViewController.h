//
//  IntroViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 8/3/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleCell.h"

@interface IntroViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,JZSwipeCellDelegate>

- (IBAction)skipIntroduction:(id)sender;

- (IBAction)getStarted:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic) NSMutableArray *content;
@property (strong,nonatomic) NSMutableArray *myCells;

@end
