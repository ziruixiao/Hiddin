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
    
    if (!self.appDelegate.showIntroText) {
        
        IntroViewController *introTextViewController = (IntroViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"introViewController"];
        
        [self presentViewController:introTextViewController animated:NO completion:nil];
        
        self.appDelegate.showIntroText = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData
{
    [SVProgressHUD showWithStatus:@"Reloading tweets..."];
    [((MenuViewController*)self.sidePanelController) getTimeLine];
    [SVProgressHUD dismiss];
    self.toolContent = [[Content alloc] init];
    self.content = [NSMutableArray array];

    [toolContent getCurrentContent:self.content withType:self.typeSelected];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
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
    if ([typeSelected isEqualToString:@"tweet_text"]) {
        cell.imageView.image = [UIImage imageNamed:@"hiddin_left_twitter.png"];
    } else {
        //detect retweets and change the logo a little.
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [cell.textLabel sizeToFit];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        //attributedtext here
        //self.searchDisplayController.searchBar.text;
        NSString *contentText = ((Content*)[searchResults objectAtIndex:indexPath.row]).contentDescription;
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
        
        cell.textLabel.attributedText = attString;
        cell.cellContentID = ((Content*)[searchResults objectAtIndex:indexPath.row]).contentID;
    } else {
        
        cell.textLabel.text = ((Content*)[self.content objectAtIndex:indexPath.row]).contentDescription;
        cell.cellContentID = ((Content*)[self.content objectAtIndex:indexPath.row]).contentID;
    }
    
    
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
                [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"tweet_media_deleted" ifInt:-1];
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
