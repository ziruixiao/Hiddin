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

@interface ContentTableViewController ()

@end

@implementation ContentTableViewController

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
    
    NSLog(@"The user has selected to see this type of content: %@",self.typeSelected);

     self.toolContent = [[Content alloc] init];
     self.content = [NSMutableArray array];
     //self.typeSelected = @"photo_tagged";
     
     [toolContent getCurrentContent:self.content withType:self.typeSelected];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // Return the number of rows in the section.
    return self.content.count;
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
    
    cell.textLabel.text = ((Content*)[self.content objectAtIndex:indexPath.row]).contentDescription;
    cell.cellContentID = ((Content*)[self.content objectAtIndex:indexPath.row]).contentID;
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
        NSString *selectedContentID = ((ExampleCell*)cell).cellContentID;
        
        self.toolContent.contentID = selectedContentID;
        
		if (indexPath && selectedContentID)
		{
            if ([self.action isEqualToString:@"keep"]) {
                //UPDATE DATABASE
                [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"keep" ifInt:-1];
                [self.content removeObjectAtIndex:indexPath.row]; //change this to the indexpath
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            } else if ([self.action isEqualToString:@"later"]) {
                //UPDATE DATABASE
                [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"later" ifInt:-1];
                [self.content removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            } else if ([self.action isEqualToString:@"delete"]) {
                [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"tweet_media_deleted" ifInt:-1];
                [self.content removeObjectAtIndex:indexPath.row]; //change this to the indexpath
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self deleteTweetWithID:selectedContentID];
            }
            
		}
	}
	
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
