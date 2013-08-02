//
//  TweetsViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/29/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "TweetsViewController.h"
#import <Social/Social.h>

@interface TweetsViewController ()

@end

@implementation TweetsViewController

- (IBAction)presentTweetSheet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#opendata2013"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Check that your device has an internet connection and you have at least one Twitter account set up"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (NSURL*) initialSiteLocation {
    NSURL* siteURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"_site/tweets" isDirectory:YES];
    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];
    
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
