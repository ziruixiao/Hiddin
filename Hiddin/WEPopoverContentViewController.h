//
//  WEPopoverContentViewController.h
//  WEPopover
//
//  Created by Werner Altewischer on 06/11/10.
//  Copyright 2010 Werner IT Consultancy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WEPopoverContentViewController : UITableViewController {

}

@property int numRows;
@property (strong,nonatomic) NSMutableArray *accounts;

- (id)initWithStyle:(UITableViewStyle)style andAccounts:(NSMutableArray*)myAccounts;

@end
