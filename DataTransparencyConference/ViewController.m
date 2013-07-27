//
//  ViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/26/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@end

@implementation ViewController
@synthesize mainWebView = _mainWebView;


//http://stationinthemetro.com/2012/02/23/calling-methods-from-links-in-a-uiwebview
- (void) setUpPage {
    NSString *htmlString = @"<!DOCTYPE HTML><html><body><p><a href=\"selector://linkIntercept\">Log me!</a></p><p><a href=\"selector://linkInterceptWithArgument#arg\">Log me with argument!</a></p></body></html>";
    [self.mainWebView loadHTMLString:htmlString baseURL:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainWebView.delegate = self;
    [self setUpPage];
}

@end
