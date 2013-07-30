//
//  ViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/26/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "DTCViewController.h"

@interface DTCViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UILabel* syncBar;
@end

@implementation DTCViewController
@synthesize DTCWebView = _DTCWebView;
@synthesize urlToDisplay = _urlToDisplay;
@synthesize syncBar = _syncBar;

- (void) setUpPage {
//    NSString* indexHTML = [NSString stringWithContentsOfURL:indexHTMLURL encoding:NSUTF8StringEncoding error:nil]; //the actual HTML
    
    [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:[self initialSiteLocation]]];
}

- (NSURL*) initialSiteLocation {
    NSURL* siteURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"_site" isDirectory:YES];
    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];
    return indexHTMLURL;
}

- (IBAction) addCustomSyncBar {
//    int *x = NULL;
//    *x = 42; //to test crashes
    
    if (!self.syncBar) {
        self.syncBar = [[UILabel alloc] initWithFrame:CGRectMake(0, -10.0f, self.view.frame.size.width, 10.0f)];
        [self.syncBar setBackgroundColor:[UIColor blackColor]];
        
        [self.syncBar setText:@"Syncing..."];
        [self.syncBar setTextAlignment:NSTextAlignmentCenter];
        [self.syncBar setTextColor:[UIColor whiteColor]];
        [self.syncBar setFont:[UIFont systemFontOfSize:8]];
        
        [self.view addSubview:self.syncBar];
    }
    
    [UIView beginAnimations:@"showSyncBar" context:nil];
    [UIView setAnimationDuration:0.3];
    [self.syncBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
    //move the UIWebView as well? see how it looks
    [UIView commitAnimations];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSLog(@"Request URL is %@, scheme is %@, last path component is %@", request.URL, request.URL.scheme, request.URL.lastPathComponent);
    
    if ([request.URL.scheme isEqualToString: @"file"] && ![request.URL.lastPathComponent isEqualToString:@"index.html"]) {
        NSLog(@"Here's where we segue to next webview");
        //[self performSegueWithIdentifier:@"pushNextWebView" sender:self];
        //maybe return something?
    }
    else if ([request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
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
