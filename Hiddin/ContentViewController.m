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
#import "SVProgressHUD.h"
#import "UIViewController+MJPopupViewController.h"
#import "IntroViewController.h"
#import "UIView+Badge.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize appDelegate,content,selectedIndex;
@synthesize topButton1,topButton2,topButton3,bottomButton1,bottomButton2,bottomButton3,topView;
@synthesize toolContent,typeSelected,imageDownloadQueue,images,activeView,disableGestures,caption;

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
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hiddin_nav_refresh.png"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = refreshItem;
    self.imageDownloadQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadQueue.maxConcurrentOperationCount = 5;
    
    self.images = [NSMutableDictionary dictionary];
    
    AsynchImageView *currentImage = [[AsynchImageView alloc] initWithFrame:self.activeView.frame];
    currentImage.tag = 123;
    currentImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.activeView addSubview:currentImage];
    
    self.caption = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,100)];
    self.caption.center = currentImage.center;
    self.caption.numberOfLines = 0;
    self.caption.font = [UIFont systemFontOfSize:14.0];
    self.caption.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    self.caption.textColor = [UIColor whiteColor];
    self.caption.tag = 707;
    //[self.activeView addSubview:caption];
    
    NSLog(@"The user has selected to see this type of content: %@",self.typeSelected);
    
    if (self.appDelegate.showIntroPhoto) {
        
        IntroViewController *introPhotoViewController = (IntroViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"introViewController"];
        
        [self presentViewController:introPhotoViewController animated:NO completion:nil];
        self.appDelegate.showIntroPhoto = NO;
    }
    
    self.toolContent = [[Content alloc] init];
    self.content = [NSMutableArray array];
    //self.typeSelected = @"photo_tagged";
        [toolContent getCurrentContent:self.content withType:self.typeSelected];
    
    if (self.content.count>0) {
            self.selectedIndex = 0;
            [self reloadImageView];
            [self addButtons];
        } else {
            NSLog(@"There's nothing here!");
        }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrRemove:)];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
    
    
}

- (IBAction)showOrRemove:(UITapGestureRecognizer*)recognizer
{
    if (self.disableGestures != YES) {
        if (self.topButton1.userInteractionEnabled == YES) {
            [UIView animateWithDuration:0.25 animations:^{
                self.topButton1.alpha = 0.0;
                self.topButton1.userInteractionEnabled = NO;
                
                self.topButton2.alpha = 0.0;
                self.topButton2.userInteractionEnabled = NO;
                
                self.topButton3.alpha = 0.0;
                self.topButton3.userInteractionEnabled = NO;
                
                self.bottomButton1.alpha = 0.0;
                self.bottomButton1.userInteractionEnabled = NO;
                
                self.bottomButton2.alpha = 0.0;
                self.bottomButton2.userInteractionEnabled = NO;
                
                self.bottomButton3.alpha = 0.0;
                self.bottomButton3.userInteractionEnabled = NO;
            }];
            
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.topButton1.alpha = 1.0;
                self.topButton1.userInteractionEnabled = YES;
                
                self.topButton2.alpha = 1.0;
                self.topButton2.userInteractionEnabled = YES;
                
                self.topButton3.alpha = 1.0;
                self.topButton3.userInteractionEnabled = YES;
                
                self.bottomButton1.alpha = 1.0;
                self.bottomButton1.userInteractionEnabled = YES;
                
                self.bottomButton2.alpha = 1.0;
                self.bottomButton2.userInteractionEnabled = YES;
                
                self.bottomButton3.alpha = 1.0;
                self.bottomButton3.userInteractionEnabled = YES;
            }];
        }
    }
    
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
    self.caption.text = (((Content*)[self.content objectAtIndex:selectedIndex]).contentDescription);
    
    //////////////////START QUEUE STUFF/////////////////
    //Part 1) Populate the URLs that I need.
    NSMutableArray *neededURLs = [NSMutableArray arrayWithCapacity:7];
    for (int x = selectedIndex; x <= (selectedIndex+3); x++) {
        if ((x >=0) && (x < self.content.count)) {
            [neededURLs addObject:(((Content*)[self.content objectAtIndex:x]).contentImageURL)];
        }
    }
    for (int x1 = selectedIndex-1; x1 <= (selectedIndex-3); x1--) {
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
    [self.activeView bringSubviewToFront:[self.view viewWithTag:707]];
    
    self.bottomButton1.badge.outlineWidth = 2.0;
    self.bottomButton1.badge.badgeColor = [UIColor redColor];
    self.bottomButton1.badge.placement = kBadgePlacementUpperLeft;
    self.bottomButton1.badge.badgeValue = self.selectedIndex;
    
    self.bottomButton3.badge.outlineWidth = 2.0;
    self.bottomButton3.badge.badgeColor = [UIColor redColor];
    self.bottomButton3.badge.placement = kBadgePlacementUpperLeft;
    self.bottomButton3.badge.badgeValue = self.content.count - self.selectedIndex - 1;
}

- (void)refreshData
{
    [SVProgressHUD showWithStatus:@"Reloading tweets..."];
    [((MenuViewController*)self.sidePanelController) getTimeLine];
    [SVProgressHUD dismiss];
    self.toolContent = [[Content alloc] init];
    self.content = [NSMutableArray array];
    [toolContent getCurrentContent:self.content withType:self.typeSelected];
    if (self.content.count>0) {
        self.selectedIndex = 0;
        [self reloadImageView];
        [self addButtons];
    }
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
        
        
        
    
            //[self.content removeObjectAtIndex:self.selectedIndex];
            //[self reloadImageView];
        }];
    }
}

- (IBAction)laterPressed:(id)sender
{
    [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"later" ifInt:-1];
    [self.content removeObjectAtIndex:self.selectedIndex];
    [self reloadImageView];
}

- (IBAction)keepPressed:(id)sender
{
    [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"keep" ifInt:-1];
    [self.content removeObjectAtIndex:self.selectedIndex];
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
    //save to camera roll
    UIImageView *currentImageView = (UIImageView*)[self.view viewWithTag:123];
    UIImageWriteToSavedPhotosAlbum(currentImageView.image,self,@selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:),NULL);
}

- (IBAction)rightPressed:(id)sender
{
    if (self.selectedIndex < ([self.content count] - 1)) {
        selectedIndex++;
    }
    [self reloadImageView];
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo
{
    if (error) {
        //show alert that says that they need to go and enable the settings
        [SVProgressHUD showErrorWithStatus:@"Error Saving Photo"];
    } else {
        //show quick notification that the image has been saved.
        [SVProgressHUD showSuccessWithStatus:@"Photo Saved"];
    }
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
                          [SVProgressHUD showSuccessWithStatus:@"Photo Deleted"];
                          [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"tweet_media_deleted" ifInt:-1];
                          [self.content removeObjectAtIndex:self.selectedIndex];
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
