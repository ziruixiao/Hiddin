//
//  ContentTableViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 7/30/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "ContentTableViewController.h"
#import "MenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "Content.h"
#define kCellTextKey @"kCellTextKey"
#define kCellTagKey @"kCellTagKey"
#import "IntroViewController.h"
#import "DoneViewController.h"
#import "ErrorViewController.h"

@interface ContentTableViewController ()

@end

@implementation ContentTableViewController {
    NSMutableArray *searchResults;
}

@synthesize appDelegate,typeSelected,toolContent,content,action;

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
    [SVProgressHUD dismiss];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiddin_nav.png"]];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hiddin_nav_refresh.png"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = refreshItem;
    
    NSLog(@"The user has selected to see this type of content: %@",self.typeSelected);

     self.toolContent = [[Content alloc] init];
     self.content = [NSMutableArray array];
     //self.typeSelected = @"photo_tagged";

    [toolContent getCurrentContent:self.content withType:self.typeSelected];
    
    if (self.content.count < 1 && self.appDelegate.showIntroText == YES) {
            //set to doneviewcontroller
        UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"doneNavigationController"];
        
        DoneViewController *tempContentVC = (DoneViewController*)[tempContentNC.viewControllers objectAtIndex:0];
        
        tempContentVC.ref = @"text";
        
        
        self.sidePanelController.centerPanel = tempContentNC;
    }
   if (!self.appDelegate.showIntroText) {
        
        IntroViewController *introViewController = (IntroViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"introViewController"];
        
        [self presentViewController:introViewController animated:NO completion:nil];
        
       self.appDelegate.showIntroText = YES;
       self.appDelegate.showIntroPhoto = YES;
   }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString*)relativeDateFromTimestamp:(int)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDate *todayDate = [NSDate date];
    double ti = [date timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
    	return @"never";
    } else 	if (ti < 60) {
    	return @"less than a minute ago";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%d hours ago", diff];
    } else {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%d days ago", diff];
    }
}

- (void)refreshData
{
    [SVProgressHUD showWithStatus:@"Reloading tweets..."];
    [((MenuViewController*)self.sidePanelController) getTimeLine];
    
    self.toolContent = [[Content alloc] init];
    self.content = [NSMutableArray array];

    [toolContent getCurrentContent:self.content withType:self.typeSelected];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = ((Content*)[content objectAtIndex:[indexPath row]]).contentDescription;
    
    CGSize constraint = CGSizeMake(260, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height + 50.0f, 95.0f);
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [self.content count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExampleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ExampleCell cellID]];
	if (!cell)
	{
		cell = [[ExampleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ExampleCell cellID]];
	}
    if ([typeSelected isEqualToString:@"tweet_text"]||[typeSelected isEqualToString:@"tweet_text_later"]||[typeSelected isEqualToString:@"tweet_text_done"]) {
        cell.imageView.contentMode = UIViewContentModeTop;
        if ([typeSelected isEqualToString:@"tweet_text_done"]) {
            cell.imageView.image = [UIImage imageNamed:@"hiddin_left_keep.png"];
        } else if ([typeSelected isEqualToString:@"tweet_text_later"]) {
            cell.imageView.image = [UIImage imageNamed:@"hiddin_left_later.png"];
        } else if (![((Content*)[self.content objectAtIndex:indexPath.row]).contentUserID isEqualToString:((Content*)[self.content objectAtIndex:indexPath.row]).contentFromName]) {
            cell.imageView.image = [UIImage imageNamed:@"hiddin_left_retweet.png"];
        } else {
            
            cell.imageView.image = [UIImage imageNamed:@"hiddin_left_twitter.png"];
        }
        
        
        
    }
    
    //add a number label
        
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [cell.textLabel sizeToFit];
    int contentTime = 0;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        //attributedtext here
        //self.searchDisplayController.searchBar.text;
        NSString *contentText = ((Content*)[searchResults objectAtIndex:indexPath.row]).contentDescription;
        contentTime = ((Content*)[searchResults objectAtIndex:indexPath.row]).contentTimestamp;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:contentText];
        
        UIColor *bananaColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:102/255.0 alpha:0.7];
        NSArray *searchTerms = [self.searchDisplayController.searchBar.text componentsSeparatedByString:@" "];
        
        for (NSString *keyword in searchTerms) {
            if (!([keyword isEqualToString:@" "]||[keyword isEqualToString:@""])) {
                NSLog(@"%i",[contentText rangeOfString:keyword options:NSCaseInsensitiveSearch].location);
                
                NSRange range = NSMakeRange(0,contentText.length);
                while(range.location != NSNotFound)
                {
                    range = [contentText rangeOfString:keyword options:NSCaseInsensitiveSearch range:range];
                    if(range.location != NSNotFound)
                    {
                        [attString addAttribute:NSBackgroundColorAttributeName value:bananaColor range:NSMakeRange(range.location, keyword.length)];
                        range = NSMakeRange(range.location + range.length, contentText.length - (range.location + range.length));
                    }
                }
            }
        }
        
        //[attString addAttribute:NSBackgroundColorAttributeName value:bananaColor range:NSMakeRange(0, contentText.length)];
        
        
        cell.cellContentID = ((Content*)[searchResults objectAtIndex:indexPath.row]).contentID;
        
        NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:[self relativeDateFromTimestamp:contentTime]];
        //TODO: ADD THE ALIGNMENT HERE AND ADD THE TIME
        [attString insertAttributedString:timeString atIndex:attString.length];
        
        cell.textLabel.attributedText = attString;
        
    } else {
        contentTime = ((Content*)[self.content objectAtIndex:indexPath.row]).contentTimestamp;
        
        cell.textLabel.text = ((Content*)[self.content objectAtIndex:indexPath.row]).contentDescription;
        cell.cellContentID = ((Content*)[self.content objectAtIndex:indexPath.row]).contentID;
    }
    
    //add time ago

    //this string is the time in relative [self relativeDateFromTimestamp:contentTime];
    
	cell.delegate = self;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    JZSwipeCell *cell = (JZSwipeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
	[cell triggerSwipeWithType:(JZSwipeType)((arc4random() % 4) + 1)];
     */
}

#pragma mark - JZSwipeCellDelegate methods

- (void)swipeCell:(JZSwipeCell*)cell triggeredSwipeWithType:(JZSwipeType)swipeType
{
	if (swipeType != JZSwipeTypeNone)
	{
        
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
        }
        
        NSString *selectedContentID = ((ExampleCell*)cell).cellContentID;
        
        NSLog(@"the selected ID is %@",selectedContentID);
        self.toolContent.contentID = selectedContentID;
        
		if (indexPath && selectedContentID)
		{
            if ([self.action isEqualToString:@"keep"]) {
                //UPDATE DATABASE
                [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"keep" ifInt:-1];
                if ([self.searchDisplayController isActive]) {
                    [searchResults removeObjectAtIndex:indexPath.row];
                    [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    for (int x = 0; x < self.content.count; x++) {
                        if ([((Content*)[self.content objectAtIndex:x]).contentID isEqualToString:selectedContentID]) {
                            [self.content removeObjectAtIndex:x];
                            break;
                        }
                    }
                } else {
                    [self.content removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                
                
                
            } else if ([self.action isEqualToString:@"later"]) {
                //UPDATE DATABASE
                [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"later" ifInt:-1];
                if ([self.searchDisplayController isActive]) {
                    [searchResults removeObjectAtIndex:indexPath.row];
                    [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    for (int x = 0; x < self.content.count; x++) {
                        if ([((Content*)[self.content objectAtIndex:x]).contentID isEqualToString:selectedContentID]) {
                            [self.content removeObjectAtIndex:x];
                            break;
                        }
                    }
                } else {
                    [self.content removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                
            } else if ([self.action isEqualToString:@"delete"]) {
                [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"tweet_text_deleted" ifInt:-1];
                if ([self.searchDisplayController isActive]) {
                    [searchResults removeObjectAtIndex:indexPath.row];
                    [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    for (int x = 0; x < self.content.count; x++) {
                        if ([((Content*)[self.content objectAtIndex:x]).contentID isEqualToString:selectedContentID]) {
                            [self.content removeObjectAtIndex:x];
                            break;
                        }
                    }

                } else {
                    [self.content removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
               
                [self deleteTweetWithID:selectedContentID];
            }
            
		}
	}
	
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.contentDescription contains[cd] %@",
                                    searchText];
    
    searchResults = [[self.content filteredArrayUsingPredicate:resultPredicate] mutableCopy];
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) aSearchBar {
	[self.tableView reloadData];
}

- (void)deleteTweetWithID:(NSString*)tweetID
{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             self.appDelegate.allAccounts = [arrayOfAccounts mutableCopy];
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts firstObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/destroy/%@.json",tweetID]];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 [parameters setObject:tweetID forKey:@"id"];
                 [parameters setObject:@"true" forKey:@"trim_user"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                      NSLog(@"%@",dictionary);
                      
                      if (![dictionary objectForKey:@"id_str"]) { //tweet was returned, this means that it was deleted
                          NSLog(@"ERROR");
                      }
                      
                  }];
             }
         } else {
             // Handle failure to get account access
             NSLog(@"no access");
             UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"errorNavigationController"];
             
             ErrorViewController *tempContentVC = (ErrorViewController*)[tempContentNC.viewControllers objectAtIndex:0];
             
             tempContentVC.ref = @"text";
             
             self.sidePanelController.centerPanel = tempContentNC;
             
         }
     }];
    


}

- (void)swipeCell:(JZSwipeCell *)cell swipeTypeChangedFrom:(JZSwipeType)from to:(JZSwipeType)to
{
	// perform custom state changes here
    if (to == JZSwipeTypeShortRight || to == JZSwipeTypeLongRight) { //keep
        self.action = @"keep";
    } else if (to == JZSwipeTypeShortLeft) { //keep
        self.action = @"delete";
    } else if (to == JZSwipeTypeLongLeft) { //later
        self.action = @"later";
    }
    
    
}

@end
