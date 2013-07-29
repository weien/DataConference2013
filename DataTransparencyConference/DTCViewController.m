//
//  ViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/26/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "DTCViewController.h"

@interface DTCViewController () <UIWebViewDelegate>
@end

@implementation DTCViewController
@synthesize DTCWebView = _mainWebView;


//http://stationinthemetro.com/2012/02/23/calling-methods-from-links-in-a-uiwebview
- (void) setUpPage {
    NSString *htmlString = @"<!DOCTYPE HTML><html><body><p><a href=\"DTCScheme://linkIntercept\">Log me!</a></p><p><a href=\"DTCScheme://linkInterceptWithArgument#arg\">Log me with argument!</a></p></body></html>";
    [self.DTCWebView loadHTMLString:htmlString baseURL:nil];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSLog(@"Request URL is %@, scheme is %@", request.URL, request.URL.scheme);
    
    if ([request.URL.scheme isEqualToString:@"about"])
        return YES;
    else if ([request.URL.scheme isEqualToString: @"dtcscheme"]) {
        //handle segue
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DTCWebView.delegate = self;
    [self setUpPage];
}

@end
