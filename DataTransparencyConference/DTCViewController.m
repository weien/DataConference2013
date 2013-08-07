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
@synthesize baseDirectoryToUse = _baseDirectoryToUse;

#pragma mark - data handling

- (void) setUpPage {
    //to prevent the dreaded "white flash" http://stackoverflow.com/a/2722801/2284713
    self.DTCWebView.backgroundColor = [UIColor clearColor];
    self.DTCWebView.opaque = NO;
    
//    NSString* appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    
    if (self.urlToDisplayHere) { //was forwarded from another DTCViewController
        //        NSError* error = nil;
        //        NSString* indexHTML = [NSString stringWithContentsOfURL:self.urlToDisplayHere encoding:NSUTF8StringEncoding error:&error];
        //        NSLog(@"Actual HTML is %@, error is %@", indexHTML, error);
        
        NSString* urlComponent = self.urlToDisplayHere.absoluteString;
        [self loadRequestInCorrectDirectoryUsingPathComponent:urlComponent];
        
        
//        NSString* updateCheckDir = [appSupportDir stringByAppendingPathComponent:urlComponent];
//                NSLog(@"urlToDisplayHere is %@", updateCheckDir);
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:updateCheckDir]) {
//            NSLog(@"Using Application Support directory");
//            self.baseDirectoryToUse = [NSURL fileURLWithPath:appSupportDir];
//        }
//        else {
//            NSLog(@"Using mainBundle bundle");
//            self.baseDirectoryToUse = [[NSBundle mainBundle] bundleURL];
//        }
//        
//        NSURL* siteURL = [self.baseDirectoryToUse URLByAppendingPathComponent:urlComponent isDirectory:NO];
//        [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:siteURL]];
    }
    else {
        //if the specific file not available in AppSuppDir, then use mainBundle
        NSString* tabPathComponent = [NSString stringWithFormat:@"_site/%@/index.html", [self uniqueTabPathComponent]];
        
        [self loadRequestInCorrectDirectoryUsingPathComponent:tabPathComponent];
        
//        NSString* updateFilesDir = [appSupportDir stringByAppendingPathComponent:tabPathComponent];
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:updateFilesDir]) {
//            NSLog(@"Using Application Support directory");
//            self.baseDirectoryToUse = [NSURL fileURLWithPath:appSupportDir];
//        }
//        else {
//            NSLog(@"Using mainBundle bundle");
//            self.baseDirectoryToUse = [[NSBundle mainBundle] bundleURL];
//        }
//        
//        NSURL* siteURL = [self.baseDirectoryToUse URLByAppendingPathComponent:tabPathComponent isDirectory:NO];
//        [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:siteURL]];
    }
}

- (void) loadRequestInCorrectDirectoryUsingPathComponent:(NSString*)pathComponent {
    NSString* appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString* updateFilesDir = [appSupportDir stringByAppendingPathComponent:pathComponent];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:updateFilesDir]) {
        NSLog(@"Using Application Support directory");
        self.baseDirectoryToUse = [NSURL fileURLWithPath:appSupportDir];
    }
    else {
        NSLog(@"Using mainBundle bundle");
        self.baseDirectoryToUse = [[NSBundle mainBundle] bundleURL];
    }
    
    NSURL* siteURL = [self.baseDirectoryToUse URLByAppendingPathComponent:pathComponent isDirectory:NO];
    [self.DTCWebView loadRequest:[NSURLRequest requestWithURL:siteURL]];
}

- (NSString*) uniqueTabPathComponent {
    NSString* pathComponent = @"news";
    NSLog(@"Something's wrong -- getting superclass uniqueTabPathComponent");
    return pathComponent;
}

- (void) fetchUpdate {
    NSURL* versionDataLink = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/8902155/data_transparency_version.json"];
    
    dispatch_async(dispatch_queue_create("checkForUpdate", NULL), ^{
        NSError* error = nil;
        NSData* JSONData = [NSData dataWithContentsOfURL:versionDataLink options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"Data download error: %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError* error = nil;
            NSDictionary* latestVersion = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
            //NSLog(@"New Dict is %@, error is %@", latestVersion, error);
            
            NSInteger versionNumber = [latestVersion[@"data transparency"][@"current version"] integerValue];
            NSURL* previousVersionFile = [self.baseDirectoryToUse URLByAppendingPathComponent:@"_site/version.txt" isDirectory:NO];
            NSInteger previousVersionNumber = [[NSString stringWithContentsOfURL:previousVersionFile encoding:NSUTF8StringEncoding error:&error] integerValue];
            //NSLog(@"new version is %d, previous version is %d, error is %@", versionNumber, previousVersionNumber, intError);
            
            if (versionNumber > previousVersionNumber) {
                NSLog(@"new (%d) is greater than previous version (%d), downloading update", versionNumber, previousVersionNumber);
                [self showCustomSyncBar];
                
                void (^completionBlock)(void) = ^() {
//                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
//                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                        [self hideCustomSyncBar];
//                    });
                    [self hideCustomSyncBar];
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
    //NSLog(@"Request URL is %@, scheme is %@, last path component is %@, host is %@, path is %@", request.URL, request.URL.scheme, request.URL.lastPathComponent, request.URL.host, request.URL.path);
    if ([request.URL.scheme isEqualToString: @"file"]) {
        if ([request.URL.lastPathComponent isEqualToString:@"index.html"]) { //initial load
            return YES;
        }
        else {
            NSLog(@"NavigationType is %d", navigationType);
            if (navigationType != UIWebViewNavigationTypeLinkClicked) { //from another VC
                return YES;
            }
            
            NSString* urlPathComponent = [@"_site" stringByAppendingString:request.URL.path];
//            NSURL* internalURL = [self.baseDirectoryToUse URLByAppendingPathComponent:urlPathComponent isDirectory:NO];
            
            self.urlToPassForward = [NSURL URLWithString:urlPathComponent]; //temp
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
