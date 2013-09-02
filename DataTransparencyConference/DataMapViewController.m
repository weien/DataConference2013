//
//  DataMapViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 8/22/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "DataMapViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DataMapViewController ()
@property (strong, nonatomic) UIButton* infoView;
@property (strong, nonatomic) UIButton* dismissButton;
@property (strong, nonatomic) UILabel* infoLabel;

@end

@implementation DataMapViewController
@synthesize infoView = _infoView;
@synthesize dismissButton = _dismissButton;
@synthesize infoLabel = _infoLabel;

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //alternative: if this happens, show special "sorry" view... to be hidden at various points?
    
    //https://gist.github.com/ardalahmet/1153867
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSURL* cookieURL = [NSURL URLWithString:@"http://www.federaltransparency.gov/Style%20Library/GISMapping/index.html"];
        NSArray* myCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieURL];
        NSLog(@"Cookies are %@", myCookies);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int status = [httpResponse statusCode];
        if (status == 403) {
            NSLog(@"Boop. http status code: %d", status);
            for (NSHTTPCookie* cookie in myCookies) {
                NSLog(@"Delete cookie! Chomp! %@", cookie);
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            }
            [self.externalLinkViewer reload];
            NSLog(@"Removing all caches");
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [self.externalLinkViewer reload];
            //[self.externalLinkViewer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.federaltransparency.gov/funded/Sandy/Pages/Sandy-Award.aspx"]]]; //might work better
        }
    }
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"Request URL is %@, scheme is %@, last path component is %@, host is %@", request.URL, request.URL.scheme, request.URL.lastPathComponent, request.URL.host);
    //NSLog(@"Self.URLToDisplay is %@", self.urlToDisplay);
    return YES;
}

- (void) showInfoView {
    CGRect infoViewFrame = self.view.bounds;
    CGRect infoLabelFrame = CGRectMake(self.view.bounds.size.width / 2 - 140, self.view.bounds.size.height * .1, 280, 140);
//    CGRect dismissButtonFrame = CGRectMake(self.view.bounds.size.width / 2 - 20, self.view.bounds.size.height * .5, 40, 30);
    CGRect dismissButtonFrame = CGRectMake(120, 100, 40, 30);
    
    if (!self.infoView) {
        self.infoView = [[UIButton alloc] initWithFrame:infoViewFrame];
        self.infoView.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
//        self.infoView.numberOfLines = 0;
        self.infoView.alpha = .8;
        self.infoView.userInteractionEnabled = YES;
        
        [self.infoView addTarget:self
                               action:@selector(hideInfoView)
                     forControlEvents:UIControlEventTouchUpInside];
        
//        self.infoView.font = [UIFont boldSystemFontOfSize:16];
//        NSMutableAttributedString* formattedText = [[NSMutableAttributedString alloc] initWithString:@"This basic map of Hurricane Sandy relief awards demonstrates what the DATA Act will make possible for all federal funds. \n \n \n \n \n"];
//        [formattedText addAttribute:<#(NSString *)#> value:<#(id)#> range:<#(NSRange)#>
//        self.infoView.attributedText = formattedText;
//        self.infoView.textAlignment = NSTextAlignmentCenter;
//        self.infoView.layer.cornerRadius = 5.0f;
//        [self.infoView.layer setMasksToBounds:YES];
        [self.externalLinkViewer addSubview:self.infoView];
        
        
        self.infoLabel = [[UILabel alloc] initWithFrame:infoLabelFrame];
        self.infoLabel.backgroundColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1.0f];
        self.infoLabel.textColor = [UIColor blackColor];        
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.alpha = .9;
        self.infoLabel.font = [UIFont systemFontOfSize:16];
        NSMutableAttributedString* formattedText = [[NSMutableAttributedString alloc] initWithString:@"This map of Hurricane Sandy relief awards demonstrates what the DATA Act will make possible for all federal funds. \n \n"];
        self.infoLabel.attributedText = formattedText;
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.layer.cornerRadius = 3;
        [self.infoLabel.layer setMasksToBounds:YES];
        self.infoLabel.userInteractionEnabled = YES;
        [self.infoView addSubview:self.infoLabel];
//        self.infoLabel.layer.borderWidth = 1;
//        self.infoLabel.contentMode = UIViewContentModeTop;
        
        
        self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dismissButton addTarget:self
                   action:@selector(hideInfoView)
         forControlEvents:UIControlEventTouchUpInside];
        [self.dismissButton setTitle:@"OK" forState:UIControlStateNormal];
        self.dismissButton.frame = dismissButtonFrame;
        self.dismissButton.backgroundColor = [UIColor orangeColor];
        self.dismissButton.titleLabel.textColor = [UIColor whiteColor];
        self.dismissButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.dismissButton.layer.cornerRadius = 3;
        self.dismissButton.showsTouchWhenHighlighted = YES;
        [self.infoLabel addSubview:self.dismissButton];
    }

    [UIView beginAnimations:@"hideInfoLabel" context:nil];
    [UIView setAnimationDuration:0.3];
    //    self.infoView.hidden = NO;
    self.infoView.frame = infoViewFrame;
    self.dismissButton.frame = dismissButtonFrame;
    self.infoLabel.frame = infoLabelFrame;
    self.infoView.alpha = .8;
    [UIView commitAnimations];
    
}

- (void) hideInfoView {
//    self.infoView.hidden = YES;
    [UIView beginAnimations:@"hideInfoLabel" context:nil];
    [UIView setAnimationDuration:0.3];
    
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.syncBar cache:YES];
//    CGRect infoLabelFrame = CGRectMake(self.view.bounds.size.width / 2 - 140, self.view.bounds.size.height * .1, 280, 140);
    [self.infoLabel setFrame:CGRectMake(-280, self.view.bounds.size.height * .1, 280, 140)];
    self.infoView.alpha = 0;
    [UIView commitAnimations];
}

- (void) addInfoButton {
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(hideOrDisplayInfoView) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setLeftBarButtonItem:modalButton animated:YES];
}

- (void) hideOrDisplayInfoView {
    if (CGRectIntersectsRect(self.externalLinkViewer.frame, self.infoLabel.frame)) {
        [self hideInfoView];
    }
    else {
        [self showInfoView];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.externalLinkViewer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.federaltransparency.gov/Style%20Library/GISMapping/index.html"]]];
    [self showInfoView];
    [self addInfoButton];    
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (CGRectIntersectsRect(self.externalLinkViewer.frame, self.infoLabel.frame)) {
        [self showInfoView];    
    }
}

@end
