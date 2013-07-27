//
//  Content.h
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Content : NSObject

@property (strong,nonatomic) NSString* contentID; //the id of this content
@property (strong,nonatomic) NSString* contentType; //the type of this content
@property int contentTimestamp; //the timestamp of this content
@property (strong,nonatomic) NSString* contentUserID; //the user who can view this content
@property (strong,nonatomic) NSString* contentFromID; //the user who put up this content
@property (strong,nonatomic) NSString* contentFromName; //the name of the user who put up this content
@property (strong,nonatomic) NSString* contentImageURL; //the url of the image associated with this content
@property (strong,nonatomic) NSString* contentActive; //whether or not this content is actually shown
@property (strong,nonatomic) NSString* contentSorting; //the field used to process this after it's sorted

//lastupdate field in the back

- (void)insertContent:(Content*)newContent;
- (void)createContent:(Content*)newContent withContentID:(NSString*)myID;
- (BOOL)updateContent:(Content*)myContent inField:(NSString*)field toNew:(NSString*)newValue ifInt:(int)integer;
- (void)getCurrentContent:(NSMutableArray*)array withType:(NSString*)selectedType;
- (BOOL)alreadyExists:(NSString*)myContentID;

@end
