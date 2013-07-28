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
@synthesize appDelegate,imageView,content,selectedIndex;
@synthesize topButton1,topButton2,topButton3,bottomButton1,bottomButton2,bottomButton3,topView;
@synthesize toolContent;

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
    
    //[self getAllTaggedFacebookPhotos];
    
    self.toolContent = [[Content alloc] init];
    self.content = [NSMutableArray array];
    [toolContent getCurrentContent:self.content withType:@"photo_tagged"];
    self.selectedIndex = 0;
    
    [self reloadImageView];
	// Do any additional setup after loading the view.
    
    [self addButtons];
    
    
    //[self getTimeLine];
     
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
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:newContentURL]];
    self.toolContent.contentID = newContentID;
    self.toolContent.contentLink = (((Content*)[self.content objectAtIndex:selectedIndex]).contentLink);
    self.imageView.image = [UIImage imageWithData: data];
}

#pragma mark - webview delegate methods

// To really see the difference between "will show" and "did show" it is helpful
// to set the animation transistion to a longer time.

- (void) didShowMTPopupWindow:(MTPopupWindow*)sender {
    [[[UIAlertView alloc] initWithTitle:@"MTPopupWindow Delegate"
                                message:@"MTPopupWindow Showed"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void) didCloseMTPopupWindow:(MTPopupWindow*)sender {
    [[[UIAlertView alloc] initWithTitle:@"MTPopupWindow Delegate"
                                message:@"MTPopupWindow Closed"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}



- (IBAction)deletePressed:(id)sender
{
    //MTPopupWindow *popup = [[MTPopupWindow alloc] init];
    //popup.delegate = self;
    //[popup show];
    [self.view bringSubviewToFront:self.topView];
    [MTPopupWindow showWindowWithHTMLFile:self.toolContent.contentLink insideView:self.topView];
    
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

- (void)getAllComments
{
    //tagged photos
    [FBRequestConnection startWithGraphPath:@"me/photos?limit=10000"
                                 parameters:[NSDictionary dictionaryWithObject:@"id,created_time,from,images,source" forKey:@"fields"]
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
                                      
                                      if (![newContent alreadyExists:newContent.contentID]) {
                                          [newContent insertContent:newContent];
                                      }
                                  }
                                  
                              } else {
                                  NSLog(@"%@",error);
                              }
                              
                          }];

}

- (void)getAllTaggedFacebookPhotos
{
    //tagged photos
    [FBRequestConnection startWithGraphPath:@"me/photos?limit=10000"
                                 parameters:[NSDictionary dictionaryWithObject:@"id,created_time,from,images,source,link" forKey:@"fields"]
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
                 [parameters setObject:@"20" forKey:@"count"];
                 [parameters setObject:@"1" forKey:@"include_entities"];
                 
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
                      NSLog(@"%@",twitterDictionary);
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
