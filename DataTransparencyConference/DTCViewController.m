//
//  ViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/26/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "DTCViewController.h"
#import "WebViewController.h"

@interface DTCViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UILabel* syncBar;
@end

@implementation DTCViewController
@synthesize DTCWebView = _DTCWebView;
@synthesize urlToPassForward = _urlToPassForward;
@synthesize urlToDisplayHere = _urlToDisplayHere;
@synthesize syncBar = _syncBar;

- (void) setUpPage {
//    NSString* indexHTML = [NSString stringWithContentsOfURL:indexHTMLURL encoding:NSUTF8StringEncoding error:nil]; //the actual HTML
    if (self.urlToDisplayHere) {
        [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:self.urlToDisplayHere]];
    }
    else {
        [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:[self initialSiteLocation]]];
    }
}

- (NSURL*) initialSiteLocation {
    NSURL* siteURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"_site/news" isDirectory:YES];
    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];
    return indexHTMLURL;
}

- (IBAction) addCustomSyncBar {   
    if (!self.syncBar) {
        self.syncBar = [[UILabel alloc] initWithFrame:CGRectMake(0, -10.0f, self.view.frame.size.width, 10.0f)];
        [self.syncBar setBackgroundColor:[UIColor grayColor]];
        
        [self.syncBar setText:@"Syncing..."];
        [self.syncBar setTextAlignment:NSTextAlignmentCenter];
        [self.syncBar setTextColor:[UIColor whiteColor]];
        [self.syncBar setFont:[UIFont systemFontOfSize:8]];
        
        [self.view addSubview:self.syncBar];
    }

    if (!CGRectIntersectsRect(self.syncBar.frame, self.view.frame)) {
        [UIView beginAnimations:@"showSyncBar" context:nil];
        [UIView setAnimationDuration:0.3];
        [self.syncBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
        [self.DTCWebView setFrame:CGRectMake(0, 10.0f, self.view.frame.size.width, self.view.frame.size.height-10)];
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:@"hideSyncBar" context:nil];
        [UIView setAnimationDuration:0.3];
        [self.syncBar setFrame:CGRectMake(0, -10.0f, self.view.frame.size.width, 10.0f)];
        [self.DTCWebView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
    }
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"Request URL is %@, scheme is %@, last path component is %@", request.URL, request.URL.scheme, request.URL.lastPathComponent);
    if ([request.URL.lastPathComponent isEqualToString:@"index.html"] ||
        [request.URL.lastPathComponent isEqualToString:@"twitter_loading.html"]) {
        return YES;
    }
    else if ([request.URL.scheme isEqualToString: @"file"]) {
        NSLog(@"Here's where we segue to next webview");
        self.urlToPassForward = request.URL;
        [self performSegueWithIdentifier:@"pushNextWebView" sender:self];
        return NO; //most likely
    }
//    else if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
//        return NO;
//    }
    else if ([request.URL.absoluteString isEqualToString:@"https://twitter.com/i/jot"] ||
        [request.URL.absoluteString isEqualToString:@"https://platform.twitter.com/jot.html"]) {
        return YES;
    }
    else if ([request.URL.scheme isEqualToString:@"http"] ||
             [request.URL.scheme isEqualToString:@"https"]) {
        self.urlToPassForward = request.URL;
        [self performSegueWithIdentifier:@"handleExternalLink" sender:self];
        return NO;
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushNextWebView"]) {
        DTCViewController* dtcvc = (DTCViewController*)segue.destinationViewController;
        [dtcvc setUrlToDisplayHere:self.urlToPassForward];
    }
    if ([segue.identifier isEqualToString:@"handleExternalLink"]) {
        WebViewController* wvc = (WebViewController*) segue.destinationViewController;
        [wvc setUrlToDisplay:self.urlToPassForward];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DTCWebView.delegate = self;
    [self setUpPage];
}

#pragma mark - autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
