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

- (NSString*) initialHTMLString {
    NSString *htmlString = @"<!DOCTYPE HTML><html><body><p><a href=\"DTCScheme://linkIntercept\">News!</a></p><p><a href=\"DTCScheme://linkInterceptWithArgument#arg\">Here, have an argument!</a></p></body></html>";
    return htmlString;
}

@end
