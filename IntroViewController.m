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
#import "SVProgressHUD.h"
#import "Content.h"

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
    
    Content *toolContent = [[Content alloc] init];
    NSLog(@"Max ID is: %@",[toolContent getMaxTwitterID]);
    NSLog(@"Min ID is: %@",[toolContent getMinTwitterID]);
    
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

- (void)setupView3
{
    //label is 301
    //icon next to label is 302
    //text is 303
    //imageview is 304
    //tableview is 305
    
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:self.myTableView.frame];
    photosImageView.image = [UIImage imageNamed:@"hiddin_photo_1.png"];
    photosImageView.contentMode = UIViewContentModeTop;
    photosImageView.tag = 600;
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topButton setImage:[UIImage imageNamed:@"hiddin_keep_B.png"] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(view3ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    topButton.frame = CGRectMake(200, 283, 80, 80);
    topButton.tag = 603;
    
    UIImageView *fingerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiddin_finger.png"]];
    fingerImage.frame = CGRectMake(40,40,40,40);
    fingerImage.tag = 610;
    [topButton addSubview:fingerImage];
    
    
    [UIView transitionWithView:self.view
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        //((UILabel*)[self.view viewWithTag:301]).text = @"Photos";
                        ((UIImageView*)[self.view viewWithTag:302]).image = [UIImage imageNamed:@"hiddin_photos.png"];
                        ((UILabel*)[self.view viewWithTag:303]).text = @"Tap the button to keep this photo.";
                        
                        [self.myTableView removeFromSuperview];
                        [self.view2 addSubview:photosImageView];
                        [self.view2 addSubview:topButton];
                        
                    } completion:nil];
    self.content = nil;
    myCells = nil;
    
    
    
}

- (IBAction)getStarted:(id)sender
{
    ((UILabel*)[self.view viewWithTag:303]).text = @"Swipe right to keep a tweet.";
    ((UILabel*)[self.view viewWithTag:303]).font = [UIFont boldSystemFontOfSize:18.0];
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                         if ([UIScreen mainScreen].bounds.size.height==480) {
                             [view2 setCenter:CGPointMake(view1.center.x,view1.center.y-44)];
                         } else {
                             [view2 setCenter:view1.center];
                         }
                         [view1 setCenter:CGPointMake(160, -284)];
                         
                     }
    ];
}

- (IBAction)view3ButtonPressed:(id)sender
{
    UIButton *pressedButton = (UIButton*)sender;
    if (pressedButton.tag == 603) {
        ((UILabel*)[self.view viewWithTag:303]).text = @"Tap the button to delete this photo.";
        [pressedButton setImage:[UIImage imageNamed:@"hiddin_delete_B.png"] forState:UIControlStateNormal];
        pressedButton.frame = CGRectMake(40,283,80,80);
        pressedButton.tag = 602;
        ((UIImageView*)[self.view viewWithTag:600]).image = [UIImage imageNamed:@"hiddin_photo_2.png"];
    } else if (pressedButton.tag == 602) {
        ((UILabel*)[self.view viewWithTag:303]).text = @"Tap the button to skip this photo.";
        [pressedButton setImage:[UIImage imageNamed:@"hiddin_later_B.png"] forState:UIControlStateNormal];
        pressedButton.frame = CGRectMake(120,283,80,80);
        pressedButton.tag = 601;
        ((UIImageView*)[self.view viewWithTag:600]).image = [UIImage imageNamed:@"hiddin_photo_3.png"];
    } else if (pressedButton.tag == 601) {
        ((UILabel*)[self.view viewWithTag:303]).text = @"Tap the button to save this photo.";
        [pressedButton setImage:[UIImage imageNamed:@"hiddin_save_B.png"] forState:UIControlStateNormal];
        pressedButton.frame = CGRectMake(120,[UIScreen mainScreen].bounds.size.height-80,80,80);
        pressedButton.tag = 604;
        ((UIImageView*)[self.view viewWithTag:600]).image = [UIImage imageNamed:@"hiddin_photo_4.png"];
    } else if (pressedButton.tag == 604) {
        ((UILabel*)[self.view viewWithTag:303]).text = @"Great Job!";
        for (UIButton *fingerButton in pressedButton.subviews) {
            if (fingerButton.tag == 610) {
                [fingerButton removeFromSuperview];
            }
        }
        [pressedButton setImage:[UIImage imageNamed:@"hiddin_continue.png"] forState:UIControlStateNormal];
        pressedButton.frame = CGRectMake(80,[UIScreen mainScreen].bounds.size.height-70,160,50);
        pressedButton.tag = 599;
        ((UIImageView*)[self.view viewWithTag:600]).image = [UIImage imageNamed:@"hiddin_photo_5.png"];
    } else if (pressedButton.tag == 599) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
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
        case 0: {
            cell.textLabel.text = @"This is the most recent tweet on your timeline. Swipe right to keep this tweet. Nothing will be modified.";
            cell.special = @"keep";
            UIImageView *greenArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiddin_arrow_green.png"]];
            greenArrow.frame = CGRectMake(0,9,253,67);
            greenArrow.alpha = 0.4;
            [cell addSubview:greenArrow];
            cell.tag = 500;
            break; }
        case 1:
            cell.tag = 501;
            cell.textLabel.text = @"A tweet that you swipe right on won't be shown again. You can still view them via 'Done' in the left menu.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 2: {
            cell.tag = 502;
            cell.textLabel.text = @"This is an tweet that might damage your reputation. Swipe short left to delete this tweet. It will be removed from your timeline.";
            cell.special = @"delete";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break; }
        case 3:
            cell.tag = 503;
            cell.textLabel.text = @"Did you know that 56% of employers check social network accounts before making hiring decisions?";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 4: {
            cell.tag = 504;
            cell.textLabel.text = @"You're not sure what to do with this tweet. Swipe long left to mark this tweet so you can decide later.";
            cell.special = @"later";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break; }
        case 5:
            cell.tag = 505;
            cell.textLabel.text = @"To load new tweets, tap the refresh button in the top right corner of the screen.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 6:
            cell.tag = 506;
            cell.textLabel.text = @"You can also search for keywords to help make managing tweets easier.";
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
            break;
        case 7:
            cell.tag = 507;
            cell.textLabel.text = @"Tweets are ordered by time so that the most recent ones are at the top.";
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
                
                ((UILabel*)[self.view viewWithTag:303]).text = @"Swipe short left to delete a tweet.";
                UIImageView *redArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiddin_arrow_red.png"]];
                redArrow.frame = CGRectMake(0,9,253,67);
                redArrow.alpha = 0.4;
                [((ExampleCell*)[self.view2 viewWithTag:502]) addSubview:redArrow];

                
                
            } else if (indexPath.row == 1) {
                ((ExampleCell*)[self.view2 viewWithTag:503]).userInteractionEnabled = NO;
                ((ExampleCell*)[self.view2 viewWithTag:503]).textLabel.enabled = NO;
                ((ExampleCell*)[self.view2 viewWithTag:503]).detailTextLabel.enabled = NO;
                
                ((ExampleCell*)[self.view2 viewWithTag:504]).userInteractionEnabled = YES;
                ((ExampleCell*)[self.view2 viewWithTag:504]).textLabel.enabled = YES;
                ((ExampleCell*)[self.view2 viewWithTag:504]).detailTextLabel.enabled = YES;
                
                ((UILabel*)[self.view viewWithTag:303]).text = @"Swipe long left to skip a tweet.";
                UIImageView *yellowArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiddin_arrow_yellow.png"]];
                yellowArrow.frame = CGRectMake(0,9,253,67);
                yellowArrow.alpha = 0.5;
                [((ExampleCell*)[self.view2 viewWithTag:504]) addSubview:yellowArrow];
                
            } else if (indexPath.row == 2) {
                //TODO: Go to the next part of the tutorial.
                [SVProgressHUD showSuccessWithStatus:@"Great job!"];
                [self setupView3];
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
