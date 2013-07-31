//
//  ExampleCell.m
//  ExampleWithoutXib
//
//  Created by JLZ on 5/17/13.
//  Copyright (c) 2013 Jeremy Zedell. All rights reserved.
//

#import "ExampleCell.h"

@implementation ExampleCell

@synthesize cellContentID;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		// set the 4 icons for the 4 swipe types
		self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"hiddin_keep_C"], [UIImage imageNamed:@"hiddin_keep_C"], [UIImage imageNamed:@"hiddin_delete_C"], [UIImage imageNamed:@"hiddin_later_C"]);
		self.colorSet = SwipeCellColorSetMake([UIColor greenColor], [UIColor greenColor], [UIColor redColor], [UIColor yellowColor]);
    }
    return self;
}

+ (NSString*)cellID
{
	return @"ExampleCell";
}

@end
