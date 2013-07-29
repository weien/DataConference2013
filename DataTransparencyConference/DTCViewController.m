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
@synthesize DTCWebView = _DTCWebView;
@synthesize urlToDisplay = _urlToDisplay;


//http://stationinthemetro.com/2012/02/23/calling-methods-from-links-in-a-uiwebview
- (void) setUpPage {
    [self.DTCWebView loadHTMLString:[self initialHTMLString] baseURL:nil];
}

- (NSString*) initialHTMLString {
    NSString *htmlString = @"<!DOCTYPE HTML><html><body><p><a href=\"DTCScheme://linkIntercept\">Generic!</a></p><p><a href=\"DTCScheme://linkInterceptWithArgument#arg\">Here, have an argument!</a></p></body></html>";
    return htmlString;
}

//http://stackoverflow.com/a/10198138/2284713 and http://stackoverflow.com/a/4442594/2284713
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSLog(@"Request URL is %@, scheme is %@", request.URL, request.URL.scheme);
    
    if ([request.URL.scheme isEqualToString:@"about"])
        return YES;
    else if ([request.URL.scheme isEqualToString: @"dtcscheme"]) {
        //handle segue
        [self performSegueWithIdentifier:@"pushNextWebView" sender:self];
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushNextWebView"]) {
        DTCViewController* dtcvc = (DTCViewController*)segue.destinationViewController;
        [dtcvc setUrlToDisplay:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DTCWebView.delegate = self;
    [self setUpPage];

//    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlToDisplay];
//    [self.DTCWebView loadRequest:request];
}

@end
