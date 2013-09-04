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
#import "TDBadgedCell.h"
#import "IntroViewController.h"
#import "WEPopoverController.h"
#import "WEPopoverContentViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

@synthesize toolContent,popoverController;

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
    self.toolContent = [[Content alloc] init];
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
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
            return @"Tweets";
            break;
        case 3:
            return @"Settings";
            break;
        case 4:
            return @"Facebook";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    int myArray[6] = {0,0,0,0,0,0};
    
    [toolContent getMenuCounts:myArray];
    
    // Configure the cell...
    // Load future sources
    cell.badge.radius = 12;
    cell.badge.fontSize = 18;
    cell.badge.badgeTextColor = [UIColor blackColor];
    cell.badge.showShadow = NO;

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
                    cell.textLabel.text = @"To-Do";
                    cell.badgeString = [NSString stringWithFormat:@"%i",myArray[0]];
                    cell.badgeColor = [UIColor colorWithRed:47/255.0 green:190/255.0 blue:245/255.0 alpha:1.000];
                    break; }
                case 1: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_later.png"];
                    cell.textLabel.text = @"Later";
                    cell.badgeString = [NSString stringWithFormat:@"%i",myArray[1]];
                    cell.badgeColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:102/255.0 alpha:1.000];
                    break; }
                case 2: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_keep.png"];
                    cell.textLabel.text = @"Done";
                    cell.badgeString = [NSString stringWithFormat:@"%i",myArray[2]];
                    cell.badgeColor = [UIColor colorWithRed:102/255.0 green:255/255.0 blue:204/255.0 alpha:1.000];
                    break; }
            }
            break; }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_twitter.png"];
                    cell.textLabel.text = @"To-Do";
                    cell.badgeString = [NSString stringWithFormat:@"%i",myArray[3]];
                    cell.badgeColor = [UIColor colorWithRed:47/255.0 green:190/255.0 blue:245/255.0 alpha:1.000];
                    break; }
                case 1: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_later.png"];
                    cell.textLabel.text = @"Later";
                    cell.badgeString = [NSString stringWithFormat:@"%i",myArray[4]];
                    cell.badgeColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:102/255.0 alpha:1.000];
                    break; }
                case 2: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_keep.png"];
                    cell.textLabel.text = @"Done";
                    cell.badgeString = [NSString stringWithFormat:@"%i",myArray[5]];
                    cell.badgeColor = [UIColor colorWithRed:102/255.0 green:255/255.0 blue:204/255.0 alpha:1.000];
                    break; }
            }
            break; }
        case 3: {
            switch (indexPath.row) {
                case 0: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_reload.png"];
                    cell.textLabel.text = @"Refresh Content";
                    
                    break; }
                case 1: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_help.png"];
                    cell.textLabel.text = @"Tutorial";
                    break; }
            }
            break; }
        case 4: {
            switch (indexPath.row) {
                case 0: {
                    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_facebook.png"];
                    cell.textLabel.text = @"Facebook";
                    break; }
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
        
        if (indexPath.row == 0) { //photo queue
            tempContentVC.typeSelected = @"tweet_media";
        } else if (indexPath.row == 1) { //photo later
            tempContentVC.typeSelected = @"tweet_media_later";
        } else if (indexPath.row == 2) { //photo done
            tempContentVC.typeSelected = @"tweet_media_done";
        }
        [self.sidePanelController setCenterPanel:tempContentNC];
        
        [self.sidePanelController showCenterPanelAnimated:YES];
        
    } else if (indexPath.section == 2) {
        UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
        
        ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
        
        if (indexPath.row == 0) {
            tempContentVC.typeSelected = @"tweet_text";
        } else if (indexPath.row == 1) {
            tempContentVC.typeSelected = @"tweet_text_later";
        } else if (indexPath.row == 2) {
            tempContentVC.typeSelected = @"tweet_text_done";
        }
        
        [self.sidePanelController setCenterPanel:tempContentNC];
        
        [self.sidePanelController showCenterPanelAnimated:YES];
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //[((MenuViewController*)self.sidePanelController) getTimeLine];
            
            if (self.popoverController) {
                [self.popoverController dismissPopoverAnimated:YES];
                self.popoverController = nil;
                
            } else {
                NSLog(@"here");
                UIViewController *contentViewController = [[WEPopoverContentViewController alloc] initWithStyle:UITableViewStylePlain];
                
                self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
                [self.popoverController presentPopoverFromRect:[tableView cellForRowAtIndexPath:indexPath].frame
                                                        inView:self.view
                                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                                      animated:YES];
            }
        } else if (indexPath.row == 1) {
            IntroViewController *introPhotoViewController = (IntroViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"introViewController"];
            
            [self presentViewController:introPhotoViewController animated:NO completion:nil];
        }
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
