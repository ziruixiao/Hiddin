//
//  AsynchImageView.m
//  GetPix
//
//  Created by Darren Venn on 3/30/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import "AsynchImageView.h"

@implementation AsynchImageView
@synthesize finishedLoading,spinner;

// This class implements a "self-loading" UIImageView. When a new AsynchImageView is
// created, the frame etc. are set up, but the image itself is not loaded until
// the loadImageFromNetwork method is called.
// With this version, when the loadImageFromNetwork method is called, an NSOperation
// is created and added to the queue. The NSURLConnection call, and handling of the
// reply is done in the GetImageOperation class.

- (id)initWithURLString:(NSString*) urlString andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.urlString = urlString;
        // image is grey tile before loading
        self.backgroundColor = [UIColor blackColor];
        // set the tag so we can find this image on the UI if we need to
        self.finishedLoading = NO;
        
        //add the spinner
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.spinner.center = self.center;
        [self addSubview:self.spinner];
        [self.spinner startAnimating];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithURLString:@"" andFrame:frame];
}

- (void)loadImageFromNetwork:(NSOperationQueue*) queue {
    // add an operation to the queue, setting up a KVO to listen for the reply
    self.loadOperation = [[GetImageOperation alloc] initWithURLString:self.urlString];
    [self.loadOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [queue addOperation:self.loadOperation];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)operation change:(NSDictionary *)change context:(void *)context {
    // when the image is finished loading, respond by loading the data into this class's image object, so that
    // it appears on the ScrollView.
    if ([operation isEqual:self.loadOperation]) {
        [self.loadOperation removeObserver:self forKeyPath:@"isFinished"];
        if ([self.loadOperation imageWasFound]) {
            [self.spinner stopAnimating];
            self.image=[UIImage imageWithData:[self.loadOperation data]];
            self.finishedLoading = YES;
            
        }
        else {
            // if there was a problem loading the image then show a "timeout" image.
            //self.image=[UIImage imageNamed:@"TimeOut.jpg"];
            NSLog(@"THERE WAS A PROBLEM. IN THE FUTURE, PROMPT A RELOAD OPTION AND AN ERROR SCREEN.");
        }
        // notify that we are done with this image back to the ViewController
        self.loadOperation = nil; // this line is important!
    }
}

- (void) dealloc {

    @try{
        [self.loadOperation removeObserver:self forKeyPath:@"isFinished" context:NULL];
    }@catch(id anException){
        //do nothing. If we can't remove the observer then there was no attachment.
    }
    self.urlString = nil;
    self.loadOperation = nil;
    
}

@end
