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

//- (NSURL*) initialSiteLocation {
//    NSURL* siteURL = [self.baseDirectoryToUse URLByAppendingPathComponent:@"_site/speakers" isDirectory:YES];
//    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];
//    
////    NSError* error = nil;
////    NSString* indexHTML = [NSString stringWithContentsOfURL:indexHTMLURL encoding:NSUTF8StringEncoding error:&error];
////    
////    NSLog(@"Actual HTML is %@, error is %@", indexHTML, error);
//    
//    return indexHTMLURL;
//}

- (NSString*) uniqueTabPathComponent {
    NSString* pathComponent = @"speakers";
    return pathComponent;
}


@end
