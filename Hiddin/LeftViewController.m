//
//  LeftViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 7/28/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "LeftViewController.h"
#import "MenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "ContentViewController.h"
#import "ContentTableViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"Photos";
            break;
        case 2:
            return @"Words";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
         case 0: {
            switch (indexPath.row) {
                 case 0: {
                    //CREATE CELL HERE
                    
                    break; }
            }
            break; }
        case 1: {
            switch (indexPath.row) {
                 case 0: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_twitter.png"];
                    cell.textLabel.text = @"Tweeted Photos";
                    break; }
                 case 1: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_facebook.png"];
                    cell.textLabel.text = @"Tagged Photos";
                    break; }
                 /*case 2: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_instagram.png"];
                    cell.textLabel.text = @"My Photos";
                    break; }*/
            }
            break; }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_twitter.png"];
                    cell.textLabel.text = @"Tweets";
                    break; }
                case 1: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_facebook.png"];
                    cell.textLabel.text = @"Posts";
                    break; }
                /*case 2: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_instagram.png"];
                    cell.textLabel.text = @"Comments";
                    break; }*/
            }
            break; }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentNavigationController"];
        
        ContentViewController *tempContentVC = (ContentViewController*)[tempContentNC.viewControllers objectAtIndex:0];
        
        if (indexPath.row == 0) {
            tempContentVC.typeSelected = @"tweet_media";
        } else if (indexPath.row == 1) {
            tempContentVC.typeSelected = @"photo_tagged";
        }
        [self.sidePanelController setCenterPanel:tempContentNC];
        
        [self.sidePanelController showCenterPanelAnimated:YES];
        
    } else if (indexPath.section == 2) {
        UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTableNavigationController"];
        
        ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
        
        if (indexPath.row == 0) {
            tempContentVC.typeSelected = @"tweet_text";
        } else if (indexPath.row == 1) {
            tempContentVC.typeSelected = @"post_text";
        }
        [self.sidePanelController setCenterPanel:tempContentNC];
        
        [self.sidePanelController showCenterPanelAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end