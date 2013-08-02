//
//  AppDelegate.h
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //private variables for accessing SQLite database
    sqlite3 *MyContent;
    NSString *databasePath;
    NSString *docsDir;
    NSArray *dirPaths;
}

//SQLite database properties
@property (nonatomic) sqlite3 *MyContent;
@property (strong,nonatomic) NSString *databasePath;
@property (strong,nonatomic) NSString *docsDir;
@property (strong,nonatomic) NSArray *dirPaths;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@property BOOL showIntroPhoto;
@property BOOL showIntroText;

//SQLite database methods
- (void)openDB;
- (void)closeDB;

@end
