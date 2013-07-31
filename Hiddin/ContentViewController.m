//
//  ContentViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//
/*
 graph controls
 
 me/checkins
 me/groups
 me/likes
 me/posts => basically all actions, including comments and posts
 me/statuses
 
 
 */

#import "ContentViewController.h"
#import "MenuViewController.h"
#import "UIViewController+JASidePanel.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize appDelegate,content,selectedIndex;
@synthesize topButton1,topButton2,topButton3,bottomButton1,bottomButton2,bottomButton3,topView;
@synthesize toolContent,typeSelected,imageDownloadQueue,images,activeView;

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
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiddin_nav.png"]];
    
    self.imageDownloadQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadQueue.maxConcurrentOperationCount = 5;
    
    self.images = [NSMutableDictionary dictionary];
    
    AsynchImageView *currentImage = [[AsynchImageView alloc] initWithFrame:self.activeView.frame];
    currentImage.tag = 123;
    currentImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.activeView addSubview:currentImage];
    
    NSLog(@"The user has selected to see this type of content: %@",self.typeSelected);
    
    //[self getAllTaggedFacebookPhotos];
    //[self getTimeLine];
    //[self getAllPosts];
    
    self.toolContent = [[Content alloc] init];
    self.content = [NSMutableArray array];
    //self.typeSelected = @"photo_tagged";
    
    [toolContent getCurrentContent:self.content withType:self.typeSelected];
    self.selectedIndex = 0;
    [self reloadImageView];
    [self addButtons];
    
}

- (void)addButtons
{
    [self.topButton1 setImage:[UIImage imageNamed:@"hiddin_delete_B.png"] forState:UIControlStateHighlighted];
    [self.topButton1 setImage:[UIImage imageNamed:@"hiddin_delete_B.png"] forState:UIControlStateSelected];
    
    [self.topButton2 setImage:[UIImage imageNamed:@"hiddin_later_B.png"] forState:UIControlStateHighlighted];
    [self.topButton2 setImage:[UIImage imageNamed:@"hiddin_later_B.png"] forState:UIControlStateSelected];
     
    [self.topButton3 setImage:[UIImage imageNamed:@"hiddin_keep_B.png"] forState:UIControlStateHighlighted];
    [self.topButton3 setImage:[UIImage imageNamed:@"hiddin_keep_B.png"] forState:UIControlStateSelected];
    
    [self.bottomButton1 setImage:[UIImage imageNamed:@"hiddin_left_B.png"] forState:UIControlStateHighlighted];
    [self.bottomButton1 setImage:[UIImage imageNamed:@"hiddin_left_B.png"] forState:UIControlStateSelected];
    
    [self.bottomButton2 setImage:[UIImage imageNamed:@"hiddin_all_B.png"] forState:UIControlStateHighlighted];
    [self.bottomButton2 setImage:[UIImage imageNamed:@"hiddin_all_B.png"] forState:UIControlStateSelected];
    
    [self.bottomButton3 setImage:[UIImage imageNamed:@"hiddin_right_B.png"] forState:UIControlStateHighlighted];
    [self.bottomButton3 setImage:[UIImage imageNamed:@"hiddin_right_B.png"] forState:UIControlStateSelected];
}

- (void)reloadImageView
{
    //update the number which should be shown somewhere
    NSString *newContentURL = (((Content*)[self.content objectAtIndex:selectedIndex]).contentImageURL);
    NSString *newContentID = (((Content*)[self.content objectAtIndex:selectedIndex]).contentID);
    self.toolContent.contentID = newContentID;
    self.toolContent.contentLink = (((Content*)[self.content objectAtIndex:selectedIndex]).contentLink);
    
    //////////////////START QUEUE STUFF/////////////////
    //Part 1) Populate the URLs that I need.
    NSMutableArray *neededURLs = [NSMutableArray arrayWithCapacity:5];
    for (int x = selectedIndex; x <= (selectedIndex+2); x++) {
        if ((x >=0) && (x < self.content.count)) {
            [neededURLs addObject:(((Content*)[self.content objectAtIndex:x]).contentImageURL)];
        }
    }
    for (int x1 = selectedIndex-1; x1 <= (selectedIndex-2); x1--) {
        if ((x1 >=0) && (x1 < self.content.count)) {
            [neededURLs addObject:(((Content*)[self.content objectAtIndex:x1]).contentImageURL)];
        }
    }
    
    //Part 2) Get rid of the dictionary items that don't conform to these URLs
    NSArray *currentImagesKeys = [self.images allKeys];
    for (int y = 0; y < currentImagesKeys.count; y++) {
        if (![neededURLs containsObject:[currentImagesKeys objectAtIndex:y]]) { //if the url is not in the ones that we need
            [self.images removeObjectForKey:[currentImagesKeys objectAtIndex:y]];
        }
    }
    
    //Part 4) Check the rest of the necessary, in order of the current, then next ones first
    for (int z = 0; z < neededURLs.count; z++) {
        NSString *tempURL = [neededURLs objectAtIndex:z];
        if ([tempURL isEqualToString:newContentURL]) {
            AsynchImageView *currentImage = (AsynchImageView*)[self.view viewWithTag:123];
            currentImage.urlString = tempURL;

            [self.images setObject:currentImage forKey:tempURL];
            [currentImage loadImageFromNetwork:self.imageDownloadQueue];
        } else {
            if (![self.images objectForKey:tempURL]) {
                [self.images setObject:[[AsynchImageView alloc] initWithURLString:tempURL andFrame:self.activeView.frame] forKey:tempURL];
                [[self.images objectForKey:tempURL] loadImageFromNetwork:self.imageDownloadQueue];
            }
        }
    }
    

    ////////////////////////////////////////////////////
    
    //self.activeImageView = [self.images objectForKey:newContentURL];

    
}

#pragma mark - webview delegate methods
- (void)didShowMTPopupWindow:(MTPopupWindow*)sender {
    [[[UIAlertView alloc] initWithTitle:@"MTPopupWindow Delegate"
                                message:@"MTPopupWindow Showed"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)didCloseMTPopupWindow:(MTPopupWindow*)sender {
    [[[UIAlertView alloc] initWithTitle:@"MTPopupWindow Delegate"
                                message:@"MTPopupWindow Closed"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (IBAction)deletePressed:(id)sender
{
    if ([self.typeSelected isEqualToString:@"tweet_media"]) {
        
        [self deleteCurrentTweet];
        
    } else {
        /*
        NSURL *fanPageURL = [NSURL URLWithString:@"fb://profile/210227459693"];
        
        if (![[UIApplication sharedApplication] openURL: fanPageURL]) {
            //fanPageURL failed to open.  Open the website in Safari instead
            NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/pages/Blackout-Labs/210227459693"];
            [[UIApplication sharedApplication] openURL: webURL];
        }
        */

        
        //MTPopupWindow *popup = [[MTPopupWindow alloc] init];
        //popup.delegate = self;
        //[popup show];
        
        
        //THIS WAY WORKS, THE USER MUST FIRST SIGN IN USING UIWEBVIEW M.FACEBOOK.COM, THEN EVERYTHING WILL WORK AFTER
        [self.view bringSubviewToFront:self.topView];
        //[MTPopupWindow showWindowWithHTMLFile:self.toolContent.contentLink insideView:self.topView];
    
        MTPopupWindow *popup = [[MTPopupWindow alloc] init];
        popup.usesSafari = YES;
        popup.fileName = self.toolContent.contentLink;
        //popup.fileName = @"http://m.facebook.com";
        [popup showInView:self.topView];
    
        [self performPublishAction:^{
            NSLog(@"Access token is: %@",[FBSession activeSession].accessTokenData.accessToken);
        /*//CODE TO DELETE A PHOTO, WORKS BUT FACEBOOK BUG, as noted on Facebook Bugs website.
         NSString *deletePath = [NSString stringWithFormat:@"%@?access_token=%@",self.toolContent.contentID,[FBSession activeSession].accessTokenData.accessToken];
         NSLog(@"%@",deletePath);
         [FBRequestConnection startWithGraphPath:deletePath
                                      parameters:nil
                                      HTTPMethod:@"DELETE"
                               completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                                        if (!error) {
                                            NSLog(@"Results: %@", result);
         
                                        } else {
                                            NSLog(@"%@",error);
                                        }
         }];
         
         [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"untagged" ifInt:-1];*/
        
        /*//CODE TO DELETE A TAG, WORKS BUT FACEBOOK BUG, as noted on StackOverflow
         http://stackoverflow.com/questions/16804576/is-there-any-way-to-remove-photo-tags-with-facebook-api/17381078#17381078
    NSString *deletePath = [NSString stringWithFormat:@"%@/tags/%@?access_token=%@",self.toolContent.contentID,self.appDelegate.loggedInUser.id,[FBSession activeSession].accessTokenData.accessToken];
        NSLog(@"%@",deletePath);
        [FBRequestConnection startWithGraphPath:deletePath
                                 parameters:nil
                                 HTTPMethod:@"DELETE"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                              if (!error) {
                                  NSLog(@"Results: %@", result);
                                  
                              } else {
                                  NSLog(@"%@",error);
                              }
                              
         }];
         
         [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"untagged" ifInt:-1];
         */
        
        
        
    
            //[self.content removeObjectAtIndex:0];
            //[self reloadImageView];
        }];
    }
}

- (IBAction)laterPressed:(id)sender
{
    [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"later" ifInt:-1];
    [self.content removeObjectAtIndex:0];
    [self reloadImageView];
}

- (IBAction)keepPressed:(id)sender
{
    [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"keep" ifInt:-1];
    [self.content removeObjectAtIndex:0];
    [self reloadImageView];
}

- (IBAction)leftPressed:(id)sender
{
    if (self.selectedIndex > 0) {
        selectedIndex--;
    }
    [self reloadImageView];
}

- (IBAction)allPressed:(id)sender
{
    
}

- (IBAction)rightPressed:(id)sender
{
    if (self.selectedIndex < ([self.content count] - 1)) {
        selectedIndex++;
    }
    [self reloadImageView];
}

- (void)performPublishAction:(void (^)(void)) action
{
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound ||
        [FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_stream",@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}

- (void)getAllPosts
{
    //user posts that are applicable
    [FBRequestConnection startWithGraphPath:@"me/posts?limit=10000"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                              if (!error) {
                                  NSArray* postArray = [result objectForKey:@"data"]; //array of dictionaries
                                  
                                  NSLog(@"count is %i",[postArray count]);
                                  for (NSDictionary *postData in postArray) {
                                      if (!(([[postData objectForKey:@"status_type"] isEqualToString:@"wall_post"] ||
                                          [[postData objectForKey:@"status_type"] isEqualToString:@"mobile_status_update"] ||
                                          [[postData objectForKey:@"status_type"] isEqualToString:@"added_photos"] ||
                                          [[postData objectForKey:@"status_type"] isEqualToString:@"shared_story"] ||
                                          [[postData objectForKey:@"status_type"] isEqualToString:@"published_story"]) || [postData objectForKey:@"message"])) {
                                          continue; //ignore these types of stories
                                      }
                                      NSLog(@"%@",[postData objectForKey:@"story"]);
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
                                 parameters:[NSDictionary dictionaryWithObject:@"id,created_time,from,images,source,link,name" forKey:@"fields"]
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
                                      newContent.contentUserID = self.appDelegate.loggedInUser.id;
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
                                      
                                      if (![newContent alreadyExists:newContent.contentID]) {
                                          [newContent insertContent:newContent];
                                      }
                                  }
                                  
                              } else {
                                  NSLog(@"%@",error);
                              }
                              
    }];
}

- (void)getTimeLine
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
                 
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 [parameters setObject:@"200" forKey:@"count"];
                 [parameters setObject:@"1" forKey:@"include_entities"];
                 [parameters setObject:@"true" forKey:@"include_rts"];
                 [parameters setObject:@"false" forKey:@"trim_user"];
                 
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
                      
                      NSLog(@"count is %i",[twitterDictionary count]);
                      for (NSDictionary *tweetData in twitterDictionary) {
                          Content *newContent = [[Content alloc] init];
                          if ([[tweetData objectForKey:@"entities"] objectForKey:@"media"]) { //there's media attached
                              newContent.contentType = @"tweet_media";
                              newContent.contentImageURL = [[[[tweetData objectForKey:@"entities"] objectForKey:@"media"] objectAtIndex:0] objectForKey:@"media_url"];
                              
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
                          
                          newContent.contentUserID = twitterAccount.identifier;
                          
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
             // Handle failure to get account access
         }
     }];
}

- (void)deleteCurrentTweet
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
                 
                 NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/destroy/%@.json",self.toolContent.contentID]];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 [parameters setObject:self.toolContent.contentID forKey:@"id"];
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
                      
                      if ([dictionary objectForKey:@"id_str"]) { //tweet was returned, this means that it was deleted
                          [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"tweet_media_deleted" ifInt:-1];
                          [self.content removeObjectAtIndex:0];
                          [self reloadImageView];
                      }
                      
                  }];
             }
         } else {
             // Handle failure to get account access
         }
     }];

}

- (void)dealloc
{
    self.images = nil;
    self.imageDownloadQueue = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
