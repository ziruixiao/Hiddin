//
//  AppDelegate.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "AppDelegate.h"

NSString *const FBSessionStateChangedNotification =
@"FelixXiao.com.Hiddin.Login:FBSessionStateChangedNotification";

@implementation AppDelegate
@synthesize MyContent,databasePath,dirPaths,docsDir;
@synthesize loggedInUser,showIntroPhoto,showIntroText;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createEditableCopyOfDatabaseIfNeeded];
    [self createDefaultCopyOfDatabaseIfNeeded];
    [self openDB];
    
    return YES;
}

//DONE - CREATES WRITEABLE COPY OF DATABASE IN THE DOCUMENTS FOLDER OF THE APP (IF NEEDED)
- (void)createEditableCopyOfDatabaseIfNeeded
{
    //check for existance of MyPhotos database
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MyContent.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return;
    
    //a writable MyPhotos database does not exist, so copy the default to the appropriate location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MyContent.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0,@"Failed to create writable database file with message '%@'.",[error localizedDescription]);
    }
}

//DONE - CREATES A DEFAULT COPY OF DATABASE IN THE DOCUMENTS FOLDER OF THE APP (IF NEEDED)
- (void)createDefaultCopyOfDatabaseIfNeeded
{
    //check for existance of MyPhotos_Default database
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MyContent_Default.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return;
    
    //a writable MyPhotos_Default database does not exist, so copy the default to the appropriate location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MyContent.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0,@"Failed to create writable database file with message '%@'.",[error localizedDescription]);
    }
}

//DONE - OPENS THE LOCAL DATABASE
- (void)openDB
{
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"MyContent.sqlite"]];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open_v2(dbpath,&MyContent,SQLITE_OPEN_READWRITE,NULL) == SQLITE_OK) {
        NSLog(@"The local database has been opened.");
    } else {
        NSLog(@"The local database could not be opened.");
    }
    
}

//DONE - CLOSES THE LOCAL DATABASE
- (void)closeDB
{
    sqlite3_close(MyContent);
    NSLog(@"The local database has been closed.");
}

#pragma mark Facebook Commands
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

@end
