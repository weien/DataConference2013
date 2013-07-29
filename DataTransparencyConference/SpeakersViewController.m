//
//  SpeakersViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/29/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "SpeakersViewController.h"

@interface SpeakersViewController ()

@end

@implementation SpeakersViewController

//- (NSString*) initialHTMLString {
//    NSString *htmlString = @"<!DOCTYPE HTML><html><body><p><a href=\"DTCScheme://linkIntercept\">Speakers!</a></p><p><a href=\"DTCScheme://linkInterceptWithArgument#arg\">Here, have an argument!</a></p></body></html>";
//    return htmlString;
//}

- (NSURL*) initialSiteLocation {
    NSURL* siteURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"_site/speakers" isDirectory:YES];
    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];
    
    NSError* error = nil;
    NSString* indexHTML = [NSString stringWithContentsOfURL:indexHTMLURL encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"Actual HTML is %@, error is %@", indexHTML, error);
    
    return indexHTMLURL;
}

@end
