//
//  SessionsViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/29/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "SessionsViewController.h"

@interface SessionsViewController ()

@end

@implementation SessionsViewController

- (NSURL*) initialSiteLocation {
    NSURL* siteURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"_site/program" isDirectory:YES];
    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];
    
//    NSError* error = nil;
//    NSString* indexHTML = [NSString stringWithContentsOfURL:indexHTMLURL encoding:NSUTF8StringEncoding error:&error];
//
//    NSLog(@"Actual HTML is %@, error is %@", indexHTML, error);
    
    return indexHTMLURL;
}

@end
