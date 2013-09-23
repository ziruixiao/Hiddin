//
//  AppDelegate.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "AppDelegate.h"

NSString *const FBSessionStateChangedNotification =
@"com.felixxiao.Hiddin.Login:FBSessionStateChangedNotification";

@implementation AppDelegate
@synthesize MyContent,databasePath,dirPaths,docsDir;
@synthesize loggedInUser,showIntroPhoto,showIntroText;
@synthesize allAccounts,selectedAccount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createEditableCopyOfDatabaseIfNeeded];
    [self createDefaultCopyOfDatabaseIfNeeded];
    [self openDB];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults objectForKey:@"selectedAccount"] isEqualToString:@""]&&[defaults objectForKey:@"selectedAccount"]) {
        selectedAccount = [defaults objectForKey:@"selectedAccount"];
        self.showIntroText = YES;
        self.showIntroPhoto = YES;
    } else {
        selectedAccount = @"";
        [self setupDefaultAccount];
    }
    
    return YES;
}

- (void)setupDefaultAccount
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
             self.allAccounts = [NSMutableArray array];
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount;
                 
                 //prompt popup here
                 for (int x =0; x < arrayOfAccounts.count; x++) {
                     [self.allAccounts addObject:((ACAccount*)[arrayOfAccounts objectAtIndex:x]).username];
                     if ([((ACAccount*)[arrayOfAccounts objectAtIndex:x]).username isEqualToString:self.selectedAccount]) {
                         twitterAccount = [arrayOfAccounts objectAtIndex:x];
                         break;
                     }
                 }
                 
                 if ([self.selectedAccount isEqualToString:@""]) {
                     
                     twitterAccount = [arrayOfAccounts firstObject];
                     self.selectedAccount = twitterAccount.username;
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:self.selectedAccount forKey:@"selectedAccount"];
                     
                     
                     NSString * post = @"http://www.hidd.in/post.php?accounts=";
                     for (int y =0; y < self.allAccounts.count; y++) {
                         post = [post stringByAppendingFormat:@"%@,",[self.allAccounts objectAtIndex:y]];
                     }
                     NSLog (@"%@",post);
                     
                     NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:post]];
                     NSURLResponse * response = nil;
                     NSError * error = nil;
                     NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                           returningResponse:&response
                                                                       error:&error];
                     
                     if (error == nil)
                     {
                         // Parse data here
                     }

                     
                     
                 }
                 
             }
         }
     }];
    

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedAccount forKey:@"selectedAccount"];
    [FBSession.activeSession close];
}

@end
