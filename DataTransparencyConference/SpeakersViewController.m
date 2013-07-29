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

- (NSString*) initialHTMLString {
    NSString *htmlString = @"<!DOCTYPE HTML><html><body><p><a href=\"DTCScheme://linkIntercept\">Speakers!</a></p><p><a href=\"DTCScheme://linkInterceptWithArgument#arg\">Here, have an argument!</a></p></body></html>";
    return htmlString;
}

@end
