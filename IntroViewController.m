//
//  IntroViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 8/3/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "IntroViewController.h"
#define kCellTextKey @"kCellTextKey"
#define kCellTagKey @"kCellTagKey"

@interface IntroViewController ()

@end

@implementation IntroViewController

@synthesize view1,view2,myTableView,content,myCells;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView2];
	// Do any additional setup after loading the view.
}

- (void)setupView2
{
    self.content = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    myCells = [NSMutableArray array];
    
    for (int x = 0; x < self.content.count; x++) {
        [myCells addObject:[self preloadCellswithIndexPath:[NSIndexPath indexPathForRow:x inSection:0]]];
    }
    
}

- (IBAction)getStarted:(id)sender
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [view1 setCenter:CGPointMake(160, -284)];
                     }
     ];
}

- (IBAction)skipIntroduction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.content count];
}

- (UITableViewCell*)preloadCellswithIndexPath:(NSIndexPath*)indexPath
{
    ExampleCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:[ExampleCell cellID]];
	if (!cell)
	{
		cell = [[ExampleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ExampleCell cellID]];
	}
    cell.imageView.image = [UIImage imageNamed:@"hiddin_left_twitter.png"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [cell.textLabel sizeToFit];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"This is the most recent tweet on your timeline. Swipe right to keep this tweet. Nothing will be modified.";
            cell.special = @"keep";
            cell.tag = 500;
            break;
        case 1:
            cell.tag = 501;
            cell.textLabel.text = @"A tweet that you swipe right on won't be shown again. You can still view them via 'Done' in the left menu.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 2:
            cell.tag = 502;
            cell.textLabel.text = @"This is an tweet that might damage your reputation. Swipe short left to delete this tweet. It will be removed from your timeline.";
            cell.special = @"delete";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 3:
            cell.tag = 503;
            cell.textLabel.text = @"Did you know that 56% of employers check social network accounts before making hiring decisions?";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 4:
            cell.tag = 504;
            cell.textLabel.text = @"You're not sure what to do with this tweet. Swipe long left to mark this tweet so you can decide later.";
            cell.special = @"later";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 5:
            cell.tag = 505;
            cell.textLabel.text = @"To load new tweets, tap the refresh button in the top right corner of the screen.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 6:
            cell.tag = 506;
            cell.textLabel.text = @"";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 7:
            cell.tag = 507;
            cell.textLabel.text = @"This is a sample tweet.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 8:
            cell.tag = 508;
            cell.textLabel.text = @"This is a sample tweet.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 9:
            cell.tag = 509;
            cell.textLabel.text = @"This is a sample tweet.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 10:
            cell.tag = 510;
            cell.textLabel.text = @"This is a sample tweet.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
            
    }
    
	cell.delegate = self;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [myCells objectAtIndex:indexPath.row];
}



#pragma mark - JZSwipeCellDelegate methods

- (void)swipeCell:(JZSwipeCell*)cell triggeredSwipeWithType:(JZSwipeType)swipeType
{
	if (swipeType != JZSwipeTypeNone) {
        if ([cell.special isEqualToString:@"keep"] && (swipeType==JZSwipeTypeLongLeft || swipeType==JZSwipeTypeShortLeft)) {
            return;
        }
        if ([cell.special isEqualToString:@"delete"] && (swipeType==JZSwipeTypeShortRight || swipeType==JZSwipeTypeLongRight)) {
            return;
        }
        if ([cell.special isEqualToString:@"later"] && (swipeType==JZSwipeTypeShortRight || swipeType==JZSwipeTypeShortLeft || swipeType==JZSwipeTypeLongRight)) {
            return;
        }
		NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
        if (indexPath) {
            
            [self.content removeObjectAtIndex:indexPath.row];
            [self.myCells removeObjectAtIndex:indexPath.row];
            [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self tableView:self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [self tableView:self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [self tableView:self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [self tableView:self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [self tableView:self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            [self tableView:self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            
            if (indexPath.row == 0) {
                ((ExampleCell*)[self.view2 viewWithTag:501]).userInteractionEnabled = NO;
                ((ExampleCell*)[self.view2 viewWithTag:501]).textLabel.enabled = NO;
                ((ExampleCell*)[self.view2 viewWithTag:501]).detailTextLabel.enabled = NO;
                
                ((ExampleCell*)[self.view2 viewWithTag:502]).userInteractionEnabled = YES;
                ((ExampleCell*)[self.view2 viewWithTag:502]).textLabel.enabled = YES;
                ((ExampleCell*)[self.view2 viewWithTag:502]).detailTextLabel.enabled = YES;
                
                
            } else if (indexPath.row == 1) {
                ((ExampleCell*)[self.view2 viewWithTag:503]).userInteractionEnabled = NO;
                ((ExampleCell*)[self.view2 viewWithTag:503]).textLabel.enabled = NO;
                ((ExampleCell*)[self.view2 viewWithTag:503]).detailTextLabel.enabled = NO;
                
                ((ExampleCell*)[self.view2 viewWithTag:504]).userInteractionEnabled = YES;
                ((ExampleCell*)[self.view2 viewWithTag:504]).textLabel.enabled = YES;
                ((ExampleCell*)[self.view2 viewWithTag:504]).detailTextLabel.enabled = YES;
                

            } else if (indexPath.row == 2) {
                //TODO: Go to the next part of the tutorial.
                
            }
        }
        
	}
	
}


- (void)swipeCell:(JZSwipeCell *)cell swipeTypeChangedFrom:(JZSwipeType)from to:(JZSwipeType)to
{
	// perform custom state changes here
    if (to == JZSwipeTypeShortRight || to == JZSwipeTypeLongRight) { //keep
        //trigger next step
    } else if (to == JZSwipeTypeShortLeft) { //keep
        //trigger next step
    } else if (to == JZSwipeTypeLongLeft) { //later
        //trigger next step
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
