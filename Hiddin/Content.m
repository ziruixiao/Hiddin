//
//  Content.m
//  Hiddin
//
//  Created by Felix Xiao on 7/27/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "Content.h"
#import <sqlite3.h>

@implementation Content
{
    //private variables for accessing SQLite database
    sqlite3 *MyContent;
}

@synthesize contentID,contentType,contentTimestamp,contentUserID,contentFromID,contentFromName,contentImageURL,contentActive,contentSorting,contentLink,contentDescription,contentThumbnailURL;

- (void)insertContent:(Content*)newContent
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO local (id,type,timestamp,userID,fromID,fromName,imageURL,active,sorting,lastupdate,link,description,thumbnailURL) VALUES (\"%@\",\"%@\",%i,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%i,\"%@\",\"%@\",\"%@\")",newContent.contentID,newContent.contentType,newContent.contentTimestamp,newContent.contentUserID,newContent.contentFromID,newContent.contentFromName,newContent.contentImageURL,newContent.contentActive,newContent.contentSorting,newContent.contentTimestamp,newContent.contentLink,newContent.contentDescription,newContent.contentThumbnailURL];
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //NSLog(@"A new content has been added to the database via SQL statement: %s",query_stmt);
        } else {
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
        }
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
    }
    
    sqlite3_finalize(statement);
}

- (void)createContent:(Content*)newContent withContentID:(NSString*)myID
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM local WHERE id=\"%@\"",myID];
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            
            //field 0: currently: 'id'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,0)];
            newContent.contentID = temp;
            
            //field 1: currently: 'type'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,1)];
            newContent.contentType = temp;
            
            //field 2: currently: 'timestamp'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,2)];
            newContent.contentTimestamp = [temp integerValue];
            
            //field 3: currently: 'userID'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,3)];
            newContent.contentUserID = temp;
            
            //field 4: currently: 'fromID'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,4)];
            newContent.contentFromID = temp;
            
            //field 5: currently: 'fromName'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,5)];
            newContent.contentFromName = temp;
            
            //field 6: currently: 'imageURL'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,6)];
            newContent.contentImageURL = temp;
            
            //field 7: currently: 'active'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,7)];
            newContent.contentActive = temp;
            
            //field 8: currently: 'sorting'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,8)];
            newContent.contentSorting = temp;
            
            //field 9: currently: 'lastupdate'
            
            //field 10: currently: 'link'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,10)];
            newContent.contentLink = temp;
            
            //field 11: currently: 'description'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,11)];
            newContent.contentDescription = temp;
            
            //field 12: currently: 'thumbnailURL'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,12)];
            newContent.contentThumbnailURL = temp;
            
        } else {
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
        }
        
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
    }

}

- (BOOL)updateContent:(Content*)myContent inField:(NSString*)field toNew:(NSString*)newValue ifInt:(int)integer
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    sqlite3_stmt *statement;
    NSString *querySQL = @"";
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    int newTimestamp = [[NSNumber numberWithDouble: timeStamp] integerValue];
    
    if ([newValue isKindOfClass:[NSString class]]) { //value is text
        querySQL = [NSString stringWithFormat: @"UPDATE local SET \%@=\"%@\",lastupdate=%i WHERE id=\"%@\"",field,newValue,newTimestamp,myContent.contentID];
    } else if (integer>=0) { //value is int or BOOL
        querySQL = [NSString stringWithFormat: @"UPDATE local SET \%@=\%i,lastupdate=%i WHERE id=\"%@\"",field,integer,newTimestamp,myContent.contentID];
    } else {}
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"A row in the database has been updated with the statement: %s",query_stmt);
            return YES;
        } else {
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
            return NO;
        }
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
        return NO;
    }
    
    sqlite3_finalize(statement);

}

- (void)getCurrentContent:(NSMutableArray*)array withType:(NSString*)selectedType
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    sqlite3_stmt *statement;
    
    
    NSString *querySQL;
    
    if ([selectedType isEqualToString:@"tweet_media_later"]) {
        selectedType = @"tweet_media";
        querySQL = [NSString stringWithFormat: @"SELECT * FROM local WHERE type=\"%@\" AND sorting='later' ORDER BY lastupdate DESC",selectedType];
    } else if ([selectedType isEqualToString:@"tweet_media_done"]) {
        selectedType = @"tweet_media";
        querySQL = [NSString stringWithFormat: @"SELECT * FROM local WHERE type=\"%@\" AND sorting='keep' ORDER BY lastupdate DESC",selectedType];
    } else if ([selectedType isEqualToString:@"tweet_text_later"]) {
        selectedType = @"tweet_text";
        querySQL = [NSString stringWithFormat: @"SELECT * FROM local WHERE type=\"%@\" AND sorting='later' ORDER BY lastupdate DESC",selectedType];
    } else if ([selectedType isEqualToString:@"tweet_text_done"]) {
        selectedType = @"tweet_text";
        querySQL = [NSString stringWithFormat: @"SELECT * FROM local WHERE type=\"%@\" AND sorting='keep' ORDER BY lastupdate DESC",selectedType];
    } else {
        querySQL = [NSString stringWithFormat: @"SELECT * FROM local WHERE type=\"%@\" AND sorting='none' ORDER BY lastupdate DESC",selectedType];
    }
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            Content *tempContent = [[Content alloc] init];
            //field 0: currently: 'id'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,0)];
            [tempContent createContent:tempContent withContentID:temp];
            [array addObject:tempContent];
            
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
    }
}

- (void)getMenuCounts:(int[])array
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local WHERE type='tweet_media' OR type='tweet_text'"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            NSString *temp2;
            
            //field 1: currently: 'type'
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,1)];
            
            //field 8: currently: 'sorting'
            temp2 = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,8)];
            
            
            if ([temp isEqualToString:@"tweet_media"]) {
                if ([temp2 isEqualToString:@"none"]) {
                    array[0]++;
                } else if ([temp2 isEqualToString:@"later"]) {
                    array[1]++;
                } else if ([temp2 isEqualToString:@"keep"]) {
                    array[2]++;
                }
                
            } else if ([temp isEqualToString:@"tweet_text"]) {
                if ([temp2 isEqualToString:@"none"]) {
                    array[3]++;
                } else if ([temp2 isEqualToString:@"later"]) {
                    array[4]++;
                } else if ([temp2 isEqualToString:@"keep"]) {
                    array[5]++;
                }
            }
            
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
    }
}

- (NSString*)getMaxTwitterID
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT MAX(id) FROM local WHERE type='tweet_media' OR type='tweet_text'"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            
            const char* myStatement = (const char*) sqlite3_column_text(statement,0);
            if (myStatement) {
                temp = [[NSString alloc] initWithUTF8String:myStatement];
                return temp;
            }
            
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
    }
    return @"none";
}

- (NSString*)getMinTwitterID
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT MIN(id) FROM local WHERE type='tweet_media' OR type='tweet_text'"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            const char* myStatement = (const char*) sqlite3_column_text(statement,0);
            if (myStatement) {
                temp = [[NSString alloc] initWithUTF8String:myStatement];
                return temp;
            }
            
            
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
    }
    return @"none";
}

- (BOOL)alreadyExists:(NSString*)myContentID
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local WHERE id=\"%@\"",myContentID];
    
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            return YES;
        } else {
            return NO;
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
    }
    return NO;
}


@end
