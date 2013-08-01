//
//  TweetsViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/29/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "TweetsViewController.h"

@interface TweetsViewController ()

@end

@implementation TweetsViewController

- (NSURL*) initialSiteLocation {
    NSURL* siteURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"_site/tweets" isDirectory:YES];
    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];

//    //Do we want to display this until the https://platform.twitter.com/jot.html is ready?
//    NSURL* twitterLoadingURL = [siteURL URLByAppendingPathComponent:@"twitter_loading.html" isDirectory:NO];
//    [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:twitterLoadingURL]];
    
//        NSError* error = nil;
//        NSString* indexHTML = [NSString stringWithContentsOfURL:indexHTMLURL encoding:NSUTF8StringEncoding error:&error];
//        NSLog(@"Actual HTML is %@, error is %@", indexHTML, error);
    
    return indexHTMLURL;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    //self.DTCWebView.scrollView.scrollEnabled = NO;
    self.DTCWebView.scrollView.bounces = NO;
}

@end
