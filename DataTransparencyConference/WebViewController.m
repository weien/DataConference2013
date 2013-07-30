//
//  WebViewController.m
//  TwitterTimelineSpike
//
//  Created by Weien on 6/19/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UIActivityIndicatorView* spinner;
@end

@implementation WebViewController
@synthesize externalWebView = _externalWebView;
@synthesize urlToDisplay = _urlToDisplay;
@synthesize spinner = _spinner;

- (void) setUrlToDisplay:(NSURL *)urlToDisplay {
    _urlToDisplay = urlToDisplay;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.spinner startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.spinner stopAnimating];
}

- (void) initSpinner {
    if (!self.spinner) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:self.spinner];
        self.spinner.center = CGPointMake(self.externalWebView.frame.size.width / 2, self.externalWebView.frame.size.height / 2);
        //self.spinner.center = self.view.center;
        //self.spinner.backgroundColor = [UIColor blackColor];
        self.spinner.hidesWhenStopped = YES;
    }
}

- (void)openPageInBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:self.externalWebView.request.URL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.externalWebView.delegate = self;
    [self initSpinner];
    if (!self.urlToDisplay) {
        self.urlToDisplay = [NSURL URLWithString:@"http://hibariapp.com"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlToDisplay];
    [self.externalWebView loadRequest:request];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
