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

@end

@implementation DTCViewController
@synthesize DTCWebView = _DTCWebView;
@synthesize urlToPassForward = _urlToPassForward;
@synthesize urlToDisplayHere = _urlToDisplayHere;
@synthesize syncBar = _syncBar;

#pragma mark - data handling

- (void) receiveUpdateNotification:(NSNotification *) notification
{
    //reload webview if ZipDownloader has unzipped an update for us
    if ([[notification name] isEqualToString:@"SiteContentDidUpdate"]) {
        //NSLog (@"Successfully received the update notification!");
        [self.DTCWebView reload];
    }
}

- (void) setUpPage {
    //to prevent the dreaded "white flash" http://stackoverflow.com/a/2722801/2284713
    self.DTCWebView.backgroundColor = [UIColor clearColor];
    self.DTCWebView.opaque = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUpdateNotification:)
                                                 name:@"SiteContentDidUpdate"
                                               object:nil];
    
    if (self.urlToDisplayHere) { //was forwarded from another DTCViewController
        //        NSError* error = nil;
        //        NSString* indexHTML = [NSString stringWithContentsOfURL:self.urlToDisplayHere encoding:NSUTF8StringEncoding error:&error];
        //        NSLog(@"Actual HTML is %@, error is %@", indexHTML, error);
        
        [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:self.urlToDisplayHere]];
    }
    else {
        NSString* pathComponent = [NSString stringWithFormat:@"_site/%@/index.html", [self uniqueTabPathComponent]];
        NSURL* processedURL = [self reformedURLWithCorrectDirectoryUsingPathComponent:pathComponent];
        [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:processedURL]];
    }
    
}

- (NSURL*) reformedURLWithCorrectDirectoryUsingPathComponent:(NSString*)pathComponent {
    //if the specific file not available in AppSuppDir, then use mainBundle
    
    NSString* appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString* updateFilesDir = [appSupportDir stringByAppendingPathComponent:pathComponent];
    NSURL* baseDirectory = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:updateFilesDir]) {
//    if (1==0) { //force mainBundle
        NSLog(@"Using Application Support directory");
        baseDirectory = [NSURL fileURLWithPath:appSupportDir];
    }
    else {
        NSLog(@"Using mainBundle bundle");
        baseDirectory = [[NSBundle mainBundle] bundleURL];
    }
    return [baseDirectory URLByAppendingPathComponent:pathComponent isDirectory:NO];
}

- (NSString*) uniqueTabPathComponent {
    NSString* pathComponent = @"news";
    NSLog(@"Something's wrong -- getting superclass uniqueTabPathComponent");
    return pathComponent;
}

- (void) fetchUpdate {
    NSURL* versionDataLink = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/8902155/data_transparency_version.json"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_queue_create("checkForUpdate", NULL), ^{
        NSError* error = nil;
        NSData* JSONData = [NSData dataWithContentsOfURL:versionDataLink options:NSDataReadingMappedIfSafe error:&error];
        if (!JSONData) {
            NSLog(@"Data download error: %@", error);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSError* error = nil;
            NSDictionary* latestVersion = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
            //NSLog(@"New Dict is %@, error is %@", latestVersion, error);
            
            NSInteger versionNumber = [latestVersion[@"data transparency"][@"current version"] integerValue];
            NSURL* previousVersionFile = [self reformedURLWithCorrectDirectoryUsingPathComponent:@"_site/version.txt"];
            NSInteger previousVersionNumber = [[NSString stringWithContentsOfURL:previousVersionFile encoding:NSUTF8StringEncoding error:&error] integerValue];
            //NSLog(@"new version is %d, previous version is %d, error is %@", versionNumber, previousVersionNumber, intError);
            
            if (versionNumber > previousVersionNumber) {
                NSLog(@"new (%d) is greater than previous version (%d), downloading update", versionNumber, previousVersionNumber);
                [self showCustomSyncBar];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
                void (^completionBlock)(void) = ^() {
                    //increase minimum visibility of sync bar
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.3 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self hideCustomSyncBar];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    });
                };
                NSURL* newVersionLocation = [NSURL URLWithString:latestVersion[@"data transparency"][@"current version download url"]];
                [ZipDownloader downloadZipAtURL:newVersionLocation WithCompletion:completionBlock];
            }
        });
    });

}

#pragma mark - syncBar methods

- (void) showCustomSyncBar {
    if (!self.syncBar) {
        self.syncBar = [[UILabel alloc] initWithFrame:CGRectMake(0, -10.0f, self.view.frame.size.width, 10.0f)];
        [self.syncBar setBackgroundColor:[UIColor colorWithRed:68/255.0f green:110/255.0f blue:143/255.0f alpha:1.0f]];
        
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
    //NSLog(@"Request URL is %@, scheme is %@, last path component is %@, host is %@", request.URL, request.URL.scheme, request.URL.lastPathComponent, request.URL.host);
    if ([request.URL.scheme isEqualToString: @"file"]) {
        if ([request.URL.lastPathComponent isEqualToString:@"index.html"]) { //initial load
            return YES;
        }
        else {
            //NSLog(@"NavigationType is %d (O is 'clicked', 5 is 'other')", navigationType);
            if (navigationType != UIWebViewNavigationTypeLinkClicked) { //from another VC, don't segue again
                return YES;
            }
            self.urlToPassForward = request.URL; //the URL is fully-formed, just send it forward
            [self performSegueWithIdentifier:@"pushNextWebView" sender:self];
            return NO;
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
    
    //http://stackoverflow.com/a/2280767/2284713 and http://stackoverflow.com/q/2275876/2284713
    NSString* documentTitle = [self.DTCWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (documentTitle) {
        self.navigationController.navigationBar.topItem.title  = documentTitle;
    }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
