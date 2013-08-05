//
//  ViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/26/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "DTCViewController.h"
#import "ExternalWebViewController.h"
#import "ZipDownloader.h"

@interface DTCViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UILabel* syncBar;
@property (strong, nonatomic) NSString* lastReceivedUpdate;

@end

@implementation DTCViewController
@synthesize DTCWebView = _DTCWebView;
@synthesize urlToPassForward = _urlToPassForward;
@synthesize urlToDisplayHere = _urlToDisplayHere;
@synthesize syncBar = _syncBar;
@synthesize lastReceivedUpdate = _lastReceivedUpdate;
@synthesize baseDirectoryToUse = _baseDirectoryToUse;

#pragma mark - data handling

- (void) setUpPage {
    //to prevent the dreaded "white flash" http://stackoverflow.com/a/2722801/2284713
    self.DTCWebView.backgroundColor = [UIColor clearColor];
    self.DTCWebView.opaque = NO;
    
    //gateway: if we have update bundle, then use it; else, use [NSBundle mainBundle]
    NSString *appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *updateFilesDir = [appSupportDir stringByAppendingPathComponent:@"_site"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:updateFilesDir]) {
        NSLog(@"Using Application Support bundle");
        self.baseDirectoryToUse = [NSURL fileURLWithPath:appSupportDir];
    }
    else {
        NSLog(@"Using mainBundle bundle");
        self.baseDirectoryToUse = [[NSBundle mainBundle] bundleURL];
    }
    
    if (self.urlToDisplayHere) {
        [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:self.urlToDisplayHere]];
    }
    else {
        [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:[self initialSiteLocation]]];
    }
}

- (NSURL*) initialSiteLocation {
    NSURL* siteURL = [self.baseDirectoryToUse URLByAppendingPathComponent:@"_site/news" isDirectory:YES];
    NSURL* indexHTMLURL = [siteURL URLByAppendingPathComponent:@"index.html" isDirectory:NO];
    NSLog(@"Something's wrong -- getting superclass index.html");
    
    return indexHTMLURL;
}

- (void) fetchUpdate {
    [self showCustomSyncBar];
    
    NSError* error = nil;
    NSURL* bottleNeck = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/8902155/latestversion.txt"];
    NSString* latestVersion = [NSString stringWithContentsOfURL:bottleNeck encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"latestVersion is %@", latestVersion);
    
    //compare latestVersion (from bottleNeck) to previousVersion
    if (![latestVersion isEqualToString:self.lastReceivedUpdate]) {
        NSLog(@"latestVersion and previousVersion are different, downloading update");

        void (^completionBlock)(void) = ^() {
            [self hideCustomSyncBar];
        };
        [ZipDownloader downloadZipWithCompletion:completionBlock];
        
    }
    else {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self hideCustomSyncBar]; //back on main thread?
        });
    }
    
    self.lastReceivedUpdate = latestVersion;
}

#pragma mark - syncBar methods

- (void) showCustomSyncBar {
    if (!self.syncBar) {
        self.syncBar = [[UILabel alloc] initWithFrame:CGRectMake(0, -10.0f, self.view.frame.size.width, 10.0f)];
        [self.syncBar setBackgroundColor:[UIColor colorWithRed:200/255.0f green:120/255.0f blue:30/255.0f alpha:1.0f]];
        
        [self.syncBar setText:@"UPDATING..."];
        [self.syncBar setTextAlignment:NSTextAlignmentCenter];
        [self.syncBar setTextColor:[UIColor whiteColor]];
        [self.syncBar setFont:[UIFont systemFontOfSize:8]];
        
        [self.view addSubview:self.syncBar];
    }
    
    [UIView beginAnimations:@"showSyncBar" context:nil];
    [UIView setAnimationDuration:0.3];
    [self.syncBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
    [self.DTCWebView setFrame:CGRectMake(0, 10.0f, self.view.frame.size.width, self.view.frame.size.height-10)];
    [UIView commitAnimations];
}

- (void) hideCustomSyncBar {
//    if (CGRectIntersectsRect(self.syncBar.frame, self.view.frame)) {
        [UIView beginAnimations:@"hideSyncBar" context:nil];
        [UIView setAnimationDuration:0.3];
        [self.syncBar setFrame:CGRectMake(0, -10.0f, self.view.frame.size.width, 10.0f)];
        [self.DTCWebView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
//    }
}

#pragma mark - webView handling

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //NSLog(@"Request URL is %@, scheme is %@, last path component is %@", request.URL, request.URL.scheme, request.URL.lastPathComponent);
    if ([request.URL.scheme isEqualToString: @"file"]) {
        if ([request.URL.lastPathComponent isEqualToString:@"index.html"]) {
            return YES;
        }
        else {
            NSLog(@"Segue to next internal webview");
            self.urlToPassForward = request.URL;
            [self performSegueWithIdentifier:@"pushNextWebView" sender:self];
            return NO; //most likely; needs testing
                        // make sure that this works with the bundle switching
        }
    }
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

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    //reset background color to something more compositing-friendly
    self.DTCWebView.backgroundColor = [UIColor blackColor];
    self.DTCWebView.opaque = YES;
}

#pragma mark - segue and VC lifecycle

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushNextWebView"]) {
        DTCViewController* dtcvc = (DTCViewController*)segue.destinationViewController;
        [dtcvc setUrlToDisplayHere:self.urlToPassForward];
    }
    if ([segue.identifier isEqualToString:@"handleExternalLink"]) {
        ExternalWebViewController* wvc = (ExternalWebViewController*) segue.destinationViewController;
        [wvc setUrlToDisplay:self.urlToPassForward];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DTCWebView.delegate = self;
    
    [self setUpPage];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.DTCWebView = nil;
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
