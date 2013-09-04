//
//  LeftViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 7/28/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"

@class WEPopoverController;

@interface LeftViewController : UITableViewController {
    WEPopoverController *popoverController;
}

@property (strong,nonatomic) Content *toolContent;
@property (nonatomic, retain) WEPopoverController *popoverController;

@end
