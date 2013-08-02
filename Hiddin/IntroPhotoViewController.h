//
//  IntroPhotoViewController.h
//  Hiddin
//
//  Created by Felix Xiao on 8/2/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MJSecondPopupDelegate;

@interface IntroPhotoViewController : UIViewController
@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;

@end



@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(IntroPhotoViewController*)introPhotoViewController;
@end
