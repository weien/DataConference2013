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

- (NSString*) initialHTMLString {
    NSString *htmlString = @"<!DOCTYPE HTML><html><body><p><a href=\"DTCScheme://linkIntercept\">Tweets!</a></p><p><a href=\"DTCScheme://linkInterceptWithArgument#arg\">Here, have an argument!</a></p></body></html>";
    return htmlString;
}

@end
