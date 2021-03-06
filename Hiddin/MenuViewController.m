//
//  MenuViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "MenuViewController.h"
#import "SplashViewController.h"
#import "Content.h"
#import "ContentViewController.h"
#import "ContentTableViewController.h"
#import "LeftViewController.h"
#import "ErrorViewController.h"

#import "WEPopoverController.h"
#import "WEPopoverContentViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize appDelegate;
@synthesize popoverController;

//EMPTY - CUSTOM INITIALIZATION
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//EMPTY - WHAT HAPPENS BEFORE VIEWWILLAPPEAR
- (void)awakeFromNib
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showAccounts];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    
    //[self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
	// Do any additional setup after loading the view.
    
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                        message:@"Hiddin requires an internet connection. Please connect and try again." delegate:nil cancelButtonTitle: @"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        
        /*show new controller
        ModalIntroViewController *modalIntroViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modalIntroViewController"];
        [self setCenterPanel:modalIntroViewController];
         */
        
    } else {
        //we need a new way to check
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] && appDelegate.showIntroText == YES){
            UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
            
            ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
            
            tempContentVC.typeSelected = @"tweet_text";
            
            
            [self setCenterPanel:tempContentNC];
            
            [self showCenterPanelAnimated:YES];
            
        }
        else {
            SplashViewController *splashViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"splashViewController"];
            [self setCenterPanel:splashViewController];
        }
    }
}

- (void)getAllPosts
{
    //user posts that are applicable
    [FBRequestConnection startWithGraphPath:@"me/posts?limit=100"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                              if (!error) {
                                  NSArray* postArray = [result objectForKey:@"data"]; //array of dictionaries
                                  NSLog(@"%@",result);
                                  NSLog(@"count is %i",[postArray count]);
                                  for (NSDictionary *postData in postArray) {
                                      if (!(([[postData objectForKey:@"status_type"] isEqualToString:@"wall_post"] ||
                                             [[postData objectForKey:@"status_type"] isEqualToString:@"mobile_status_update"] ||
                                             [[postData objectForKey:@"status_type"] isEqualToString:@"added_photos"] ||
                                             [[postData objectForKey:@"status_type"] isEqualToString:@"shared_story"] ||
                                             [[postData objectForKey:@"status_type"] isEqualToString:@"published_story"]) || [postData objectForKey:@"message"])) {
                                          continue; //ignore these types of stories
                                      }
                                      //NSLog(@"%@",[postData objectForKey:@"story"]);
                                      /*
                                       Content *newContent = [[Content alloc] init];
                                       newContent.contentUserID = self.appDelegate.loggedInUser.id;
                                       newContent.contentFromID = [[postData objectForKey:@"from"] objectForKey:@"id"];
                                       newContent.contentFromName = [[postData objectForKey:@"from"] objectForKey:@"name"];
                                       
                                       if ([postData objectForKey:@"message"]) { //rare case, probably an actual status
                                       newContent.contentDescription = [[postData objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"\"" withString:@"*"];
                                       } else {
                                       newContent.contentDescription = [[postData objectForKey:@"story"] stringByReplacingOccurrencesOfString:@"\"" withString:@"*"];
                                       }
                                       
                                       NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                                       [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
                                       NSDate* date = [dateFormatter dateFromString:[postData objectForKey:@"created_time"]];
                                       newContent.contentTimestamp = [date timeIntervalSince1970]/1;
                                       */
                                      
                                  }
                                  
                                  
                                  /*=
                                   
                                   for each dictionary in this array
                                   PAGE LIKES
                                   objectForKey:application => objectForKey:name == "Pages"
                                   APPROVED FRIEND
                                   objectForKey:status_type == "approved_friend"
                                   STATUS LIKES
                                   objectForKey:story contains "likes a status."
                                   WALL POSTS
                                   objectForKey:status_type == "wall_post"
                                   NEW PHOTOS
                                   objectForKey:status_type == "added_photos"
                                   NEW FRIEND
                                   objectForKey:status_type == "approved_friend"
                                   
                                   objectForKey:id is the post ID, comes in the form of userid_postid. separate by _?
                                   
                                   objectForKey:type is almost always "status"? it is for changing phone numbers, status_type just isn't shown for these
                                   objectForKey:story shows what's seen byeveryone else
                                   objectForKey:status_type is "wall_post" when I post happy birthday on people's walls
                                   status_type is "added_photos" for pictures that I post
                                   status_type is "approved_friend" for friend requests
                                   
                                   objectForKey:link will take you to the Facebook photo viewer or the link attached.
                                   objectForKey:picture means that it's actually a picture
                                   objectForKey:object_id check to make sure that this doesn't already exist in the datbabse
                                   
                                   objectForKey:comments is a dictionary, objectForKey:data is an array
                                   for each dictionary in this array, it's a comment
                                   objectForKey:id is the comment id, which is POST_COMMENTID
                                   objectForKey:created_time is the FB time
                                   objectForKey:can_remove is true or false, this might be important?
                                   objectForKey:from => objectForKey:name is  the user's name
                                   objectForKey:from => objectForKey:id is that user's id. check to see if this is me.
                                   
                                   facebook.com/USERID/posts/POSTID takes you to the story
                                   */
                                  
                                  
                                  
                              } else {
                                  NSLog(@"%@",error);
                              }
                              
                          }];
    
}

- (void)getAllTaggedFacebookPhotos
{
    //tagged photos
    [FBRequestConnection startWithGraphPath:@"me/photos?limit=10000"
                                 parameters:[NSDictionary dictionaryWithObject:@"id,created_time,from,images,source,link,name,picture" forKey:@"fields"]
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                              if (!error) {
                                  //NSLog(@"Results: %@", result);
                                  
                                  NSArray* imageArray = [result objectForKey:@"data"]; //array of dictionaries
                                  
                                  NSLog(@"count is %i",[imageArray count]);
                                  for (NSDictionary *imageData in imageArray) {
                                      Content *newContent = [[Content alloc] init];
                                      
                                      newContent.contentID = [imageData objectForKey:@"id"];
                                      newContent.contentType = @"photo_tagged";
                                      NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                                      [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
                                      NSDate* date = [dateFormatter dateFromString:[imageData objectForKey:@"created_time"]];
                                      newContent.contentTimestamp = [date timeIntervalSince1970]/1;
                                      //newContent.contentUserID = self.appDelegate.loggedInUser.id;
                                      newContent.contentFromID = [[imageData objectForKey:@"from"] objectForKey:@"id"];
                                      newContent.contentFromName = [[imageData objectForKey:@"from"] objectForKey:@"name"];
                                      
                                      NSArray *arrayOfURLs = [imageData objectForKey:@"images"];
                                      for (NSDictionary *urlData in arrayOfURLs) {
                                          if ([[urlData objectForKey:@"width"] integerValue] == 720) {
                                              newContent.contentImageURL = [urlData objectForKey:@"source"];
                                              break;
                                          }
                                      }
                                      if (!newContent.contentImageURL) {
                                          newContent.contentImageURL = [imageData objectForKey:@"source"];
                                      }
                                      
                                      newContent.contentActive = @"yes";
                                      newContent.contentSorting = @"none";
                                      newContent.contentLink = [imageData objectForKey:@"link"];
                                      newContent.contentDescription = [imageData objectForKey:@"name"];
                                      newContent.contentThumbnailURL = [imageData objectForKey:@"picture"];
                                      if (![newContent alreadyExists:newContent.contentID]) {
                                          [newContent insertContent:newContent];
                                      }
                                  }
                                  
                              } else {
                                  NSLog(@"%@",error);
                              }
                              
                          }];
}

- (void)showAccounts
{
    if (self.popoverController) {
		[self.popoverController dismissPopoverAnimated:YES];
		self.popoverController = nil;
		
	} else {
        NSLog(@"here");
		UIViewController *contentViewController = [[WEPopoverContentViewController alloc] initWithStyle:UITableViewStylePlain];
		
		self.popoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
		[self.popoverController presentPopoverFromRect:CGRectMake(0, 0, 320, 80)
												inView:self.centerPanel.view
							  permittedArrowDirections:UIPopoverArrowDirectionUp
											  animated:YES];
	}

}

- (void)switchAccounts
{
    UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
    
    ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
    
    tempContentVC.typeSelected = @"tweet_text";
    NSLog(@"run");
    
    [self setCenterPanel:tempContentNC];
    
    [self showCenterPanelAnimated:YES];
    [SVProgressHUD dismiss];
}


- (void)getTimeLine
{
    

    [self getMinTimeline];
    [self getMaxTimeline];
}

- (void)getMinTimeline
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
             self.appDelegate.allAccounts = [NSMutableArray array];
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount;
                 
                 //prompt popup here
                 for (int x =0; x < arrayOfAccounts.count; x++) {
                     [self.appDelegate.allAccounts addObject:((ACAccount*)[arrayOfAccounts objectAtIndex:x]).username];
                     if ([((ACAccount*)[arrayOfAccounts objectAtIndex:x]).username isEqualToString:appDelegate.selectedAccount]) {
                         twitterAccount = [arrayOfAccounts objectAtIndex:x];
                         break;
                     }
                 }
                 
                 if ([appDelegate.selectedAccount isEqualToString:@""]) {
                     twitterAccount = [arrayOfAccounts firstObject];
                     appDelegate.selectedAccount = twitterAccount.username;
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:appDelegate.selectedAccount forKey:@"selectedAccount"];
                                         
                     
                 }
                 
                 //CHECK THE DATABASE AND GET THE LOWEST AND THE HIGHEST ID
                 //SEND 2 SEPARATE REQUESTS EACH TIME
                 
                 //REQUEST 1////////////////////////
                 
                 Content *toolContent = [[Content alloc] init];
                 
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 [parameters setObject:@"200" forKey:@"count"];
                 [parameters setObject:@"1" forKey:@"include_entities"];
                 [parameters setObject:@"true" forKey:@"include_rts"];
                 [parameters setObject:@"false" forKey:@"trim_user"];
                 if (![[toolContent getMaxTwitterID] isEqualToString:@"0"])
                     [parameters setObject:[toolContent getMaxTwitterID] forKey:@"since_id"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 postRequest.account = twitterAccount;
                 
                 
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      
                      NSDictionary *twitterDictionary = [NSJSONSerialization
                                                         JSONObjectWithData:responseData
                                                         options:NSJSONReadingMutableLeaves
                                                         error:&error];
                      //NSLog(@"%@",twitterDictionary);
                      
                      UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
                      
                      ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
                      //[tempContentVC refreshData];
                      [tempContentVC viewDidLoad];
                      
                      tempContentVC.typeSelected = @"tweet_text";
                      NSLog(@"run");
                      
                      [self setCenterPanel:tempContentNC];
                      
                      [self showCenterPanelAnimated:YES];
                      [SVProgressHUD dismiss];
                      
                      NSLog(@"first response received about now");
                      NSLog(@"count is %i",[twitterDictionary count]);
                      for (NSDictionary *tweetData in twitterDictionary) {
                          Content *newContent = [[Content alloc] init];
                          if ([[tweetData objectForKey:@"entities"] objectForKey:@"media"]) { //there's media attached
                              newContent.contentType = @"tweet_media";
                              newContent.contentImageURL = [[[[tweetData objectForKey:@"entities"] objectForKey:@"media"] objectAtIndex:0] objectForKey:@"media_url"];
                              newContent.contentThumbnailURL = [NSString stringWithFormat:@"%@:thumb",newContent.contentImageURL];
                              
                          } else {
                              newContent.contentType = @"tweet_text";
                              newContent.contentImageURL = @"none";
                          }
                          
                          
                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                          NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                          [dateFormatter setLocale:usLocale];
                          [dateFormatter setDateStyle:NSDateFormatterLongStyle];
                          [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
                          
                          [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
                          
                          NSDate *date = [dateFormatter dateFromString:[tweetData objectForKey:@"created_at"]];
                          
                          newContent.contentTimestamp = [date timeIntervalSince1970]/1;
                          
                          newContent.contentID = [tweetData objectForKey:@"id_str"];
                          
                          if ([tweetData objectForKey:@"retweeted_status"]) {
                              newContent.contentFromID = [[tweetData objectForKey:@"retweeted_status"] objectForKey:@"id_str"];
                              newContent.contentFromName = [[[tweetData objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"screen_name"];
                              newContent.contentLink = [NSString stringWithFormat:@"http://twitter.com/%@/status/%@",newContent.contentFromName,newContent.contentFromID];
                          } else {
                              
                              newContent.contentFromID = [[tweetData objectForKey:@"user"] objectForKey:@"id_str"];
                              newContent.contentFromName = [[tweetData objectForKey:@"user"] objectForKey:@"screen_name"];
                              newContent.contentLink = [NSString stringWithFormat:@"http://twitter.com/%@/status/%@",newContent.contentFromName,newContent.contentID];
                          }
                          
                          newContent.contentDescription = [[tweetData objectForKey:@"text"] stringByReplacingOccurrencesOfString:@"\"" withString:@"*"];
                          newContent.contentActive = @"yes";
                          newContent.contentSorting = @"none";
                          
                          newContent.contentUserID = twitterAccount.username;
                          
                          if (![newContent alreadyExists:newContent.contentID]) {
                              [newContent insertContent:newContent];
                          }
                          
                      }
                      
                      
                      
                      /*
                       if (self.dataSource.count != 0) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                       [self.tweetTableView reloadData];
                       });
                       }
                       */
                  }];
             }
         } else {
             NSLog(@"no access");
             // Handle failure to get account access
             UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"errorNavigationController"];
             
             ErrorViewController *tempContentVC = (ErrorViewController*)[tempContentNC.viewControllers objectAtIndex:0];
             
             tempContentVC.ref = @"text";
             
             self.centerPanel = tempContentNC;
         }
     }];

}

- (void)getMaxTimeline
{
    ACAccountStore *account2 = [[ACAccountStore alloc] init];
    ACAccountType *accountType2 = [account2
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account2 requestAccessToAccountsWithType:accountType2
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts2 = [account2
                                         accountsWithAccountType:accountType2];
             self.appDelegate.allAccounts = [arrayOfAccounts2 mutableCopy];
             if ([arrayOfAccounts2 count] > 0)
             {
                 ACAccount *twitterAccount2;
                 
                 //prompt popup here
                 for (int x =0; x < arrayOfAccounts2.count; x++) {
                     [self.appDelegate.allAccounts addObject:((ACAccount*)[arrayOfAccounts2 objectAtIndex:x]).username];
                     if ([((ACAccount*)[arrayOfAccounts2 objectAtIndex:x]).username isEqualToString:appDelegate.selectedAccount]) {
                         twitterAccount2 = ((ACAccount*)[arrayOfAccounts2 objectAtIndex:x]);
                         break;
                     }2
                     
                     
                 }
                 
                 if ([appDelegate.selectedAccount isEqualToString:@""]) {
                     twitterAccount2 = [arrayOfAccounts2 firstObject];
                 }
                 
                 //CHECK THE DATABASE AND GET THE LOWEST AND THE HIGHEST ID
                 //SEND 2 SEPARATE REQUESTS EACH TIME
                 
                 //REQUEST 1////////////////////////
                 
                 Content *toolContent = [[Content alloc] init];
                 
                 NSURL *requestURL2 = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                 
                 NSMutableDictionary *parameters2 =
                 [[NSMutableDictionary alloc] init];
                 [parameters2 setObject:@"200" forKey:@"count"];
                 [parameters2 setObject:@"1" forKey:@"include_entities"];
                 [parameters2 setObject:@"true" forKey:@"include_rts"];
                 [parameters2 setObject:@"false" forKey:@"trim_user"];
                 if ([[toolContent getMinTwitterID] isEqualToString:@"0"]) {
                     
                 } else {
                     
                 
                     [parameters2 setObject:[toolContent getMinTwitterID] forKey:@"max_id"];
                 
                 
                 SLRequest *postRequest2 = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL2 parameters:parameters2];
                 postRequest2.account = twitterAccount2;
                 
                 
                 
                 [postRequest2 performRequestWithHandler:
                  ^(NSData *responseData2, NSHTTPURLResponse
                    *urlResponse2, NSError *error2)
                  {
                      [SVProgressHUD dismiss];
                      NSDictionary *twitterDictionary2 = [NSJSONSerialization
                                                         JSONObjectWithData:responseData2
                                                         options:NSJSONReadingMutableLeaves
                                                         error:&error2];
                      //NSLog(@"%@",twitterDictionary);
                      
                      UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentTextNavigationController"];
                      
                      ContentTableViewController *tempContentVC = (ContentTableViewController*)[tempContentNC.viewControllers objectAtIndex:0];
                      
                      tempContentVC.typeSelected = @"tweet_text";
                      [tempContentVC viewDidLoad];
                      NSLog(@"run");
                      
                      [self setCenterPanel:tempContentNC];
                      
                      [self showCenterPanelAnimated:YES];
                      NSLog(@"response received right about now");

                      NSLog(@"count is %i",[twitterDictionary2 count]);
                      for (NSDictionary *tweetData in twitterDictionary2) {
                          Content *newContent = [[Content alloc] init];
                          if ([[tweetData objectForKey:@"entities"] objectForKey:@"media"]) { //there's media attached
                              newContent.contentType = @"tweet_media";
                              newContent.contentImageURL = [[[[tweetData objectForKey:@"entities"] objectForKey:@"media"] objectAtIndex:0] objectForKey:@"media_url"];
                              newContent.contentThumbnailURL = [NSString stringWithFormat:@"%@:thumb",newContent.contentImageURL];
                              
                          } else {
                              newContent.contentType = @"tweet_text";
                              newContent.contentImageURL = @"none";
                          }
                          
                          
                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                          NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                          [dateFormatter setLocale:usLocale];
                          [dateFormatter setDateStyle:NSDateFormatterLongStyle];
                          [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
                          
                          [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
                          
                          NSDate *date = [dateFormatter dateFromString:[tweetData objectForKey:@"created_at"]];
                          
                          newContent.contentTimestamp = [date timeIntervalSince1970]/1;
                          
                          newContent.contentID = [tweetData objectForKey:@"id_str"];
                          
                          if ([tweetData objectForKey:@"retweeted_status"]) {
                              newContent.contentFromID = [[tweetData objectForKey:@"retweeted_status"] objectForKey:@"id_str"];
                              newContent.contentFromName = [[[tweetData objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"screen_name"];
                              newContent.contentLink = [NSString stringWithFormat:@"http://twitter.com/%@/status/%@",newContent.contentFromName,newContent.contentFromID];
                          } else {
                              
                              newContent.contentFromID = [[tweetData objectForKey:@"user"] objectForKey:@"id_str"];
                              newContent.contentFromName = [[tweetData objectForKey:@"user"] objectForKey:@"screen_name"];
                              newContent.contentLink = [NSString stringWithFormat:@"http://twitter.com/%@/status/%@",newContent.contentFromName,newContent.contentID];
                          }
                          
                          newContent.contentDescription = [[tweetData objectForKey:@"text"] stringByReplacingOccurrencesOfString:@"\"" withString:@"*"];
                          newContent.contentActive = @"yes";
                          newContent.contentSorting = @"none";
                          
                          newContent.contentUserID = twitterAccount2.username;
                          
                          if (![newContent alreadyExists:newContent.contentID]) {
                              [newContent insertContent:newContent];
                          }
                          
                      }
                      
                      /*
                       if (self.dataSource.count != 0) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                       [self.tweetTableView reloadData];
                       });
                       }
                       */
                  }];
                 }
             }
         } else {
             NSLog(@"no access");
             // Handle failure to get account access
             UINavigationController *tempContentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"errorNavigationController"];
             
             ErrorViewController *tempContentVC = (ErrorViewController*)[tempContentNC.viewControllers objectAtIndex:0];
             
             tempContentVC.ref = @"text";
             
             self.centerPanel = tempContentNC;
         }
     }];
    
}

- (void)getTwitterFollowers
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
                 
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/ids.json?cursor=-1&count=5000"];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 __block NSMutableArray *arrayOfFollowers = [NSMutableArray array];
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      NSDictionary *twitterDictionary = [NSJSONSerialization
                                                         JSONObjectWithData:responseData
                                                         options:NSJSONReadingMutableLeaves
                                                         error:&error];
                      NSLog(@"%@",twitterDictionary);
                      
                      NSLog(@"count is %i",[[twitterDictionary objectForKey:@"ids"] count]);
                      arrayOfFollowers = [twitterDictionary objectForKey:@"ids"];
                      [self lookUpFollowersWithArray:arrayOfFollowers];
                }];
             }
         } else {
             // Handle failure to get account access
         }
     }];

}

- (void)lookUpFollowersWithArray:(NSMutableArray*)arrayOfFollowers
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
                 
                 
                 NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/users/lookup.json?include_entities=false?user_id=%@",[arrayOfFollowers componentsJoinedByString:@","]]];
                 
                 
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      NSDictionary *twitterDictionary = [NSJSONSerialization
                                                         JSONObjectWithData:responseData
                                                         options:NSJSONReadingMutableLeaves
                                                         error:&error];
                      NSLog(@"%@",twitterDictionary);

                  }];
             }
         } else {
             // Handle failure to get account access
         }
     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end