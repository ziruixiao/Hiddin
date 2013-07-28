//
//  ContentViewController.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "ContentViewController.h"
#import "MenuViewController.h"
#import "UIViewController+JASidePanel.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize appDelegate,imageView,content,selectedIndex;
@synthesize topButton1,topButton2,topButton3,bottomButton1,bottomButton2,bottomButton3;
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
    self.imageView.image = [UIImage imageWithData: data];
}

- (IBAction)deletePressed:(id)sender
{
    
    [self performPublishAction:^{
        
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
         }];*/
        
        /*//CODE TO DELETE A TAG, WORKS BUT FACEBOOK BUG, as noted on StackOverflow
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
                              
    }];*/
        
        
        
    [self.toolContent updateContent:self.toolContent inField:@"sorting" toNew:@"untagged" ifInt:-1];
    [self.content removeObjectAtIndex:0];
    [self reloadImageView];
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

- (void) performPublishAction:(void (^)(void)) action {
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

- (void)getAllTaggedFacebookPhotos
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
