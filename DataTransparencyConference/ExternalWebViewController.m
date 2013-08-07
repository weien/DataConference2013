//
//  WebViewController.m
//  TwitterTimelineSpike
//
//  Created by Weien on 6/19/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "ExternalWebViewController.h"

@interface ExternalWebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UIActivityIndicatorView* spinner;
@end

@implementation ExternalWebViewController
@synthesize externalLinkViewer = _externalLinkViewer;
@synthesize urlToDisplay = _urlToDisplay;
@synthesize spinner = _spinner;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;

- (void) setUrlToDisplay:(NSURL *)urlToDisplay {
    _urlToDisplay = urlToDisplay;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.spinner startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.spinner stopAnimating];
    
    [self.backButton setEnabled:[webView canGoBack]];
    [self.forwardButton setEnabled:[webView canGoForward]];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"This webpage is not available.");
    [self.spinner stopAnimating];
}

- (void) initSpinner {
    if (!self.spinner) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:self.spinner];
        self.spinner.center = CGPointMake(self.externalLinkViewer.frame.size.width / 2, self.externalLinkViewer.frame.size.height / 2);
        self.spinner.hidesWhenStopped = YES;
    }
}

- (void)openPageInBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:self.externalLinkViewer.request.URL];
}

- (IBAction)goBack:(id)sender {
    [self.externalLinkViewer goBack];
}

- (IBAction)goForward:(id)sender {
    [self.externalLinkViewer goForward];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.externalLinkViewer.delegate = self;
    [self initSpinner];
    if (!self.urlToDisplay) {
        self.urlToDisplay = [NSURL URLWithString:@"http://www.datatransparency2013.com"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlToDisplay];
    [self.externalLinkViewer loadRequest:request];
    
    [self.backButton setEnabled:[self.externalLinkViewer canGoBack]];
    [self.forwardButton setEnabled:[self.externalLinkViewer canGoForward]];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.externalLinkViewer = nil;
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
