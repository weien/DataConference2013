//
//  NewsViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/29/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

//- (NSURL*) initialSiteLocation {
//    NSURL* siteURL = [self.baseDirectoryToUse URLByAppendingPathComponent:@"_site/news" isDirectory:YES];
//    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];
//    
//    return indexHTMLURL;
//}

- (NSString*) uniqueTabPathComponent {
    NSString* pathComponent = @"news";
    return pathComponent;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
//    [self fetchUpdate]; //just for testing
}

@end
