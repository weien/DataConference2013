//
//  NewsViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 7/29/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()
@property (strong, nonatomic) UIImageView* iv;
@end

@implementation NewsViewController
@synthesize iv = _iv;

- (NSString*) uniqueTabPathComponent {
    NSString* pathComponent = @"news";
    return pathComponent;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    self.iv.hidden = YES;
}

- (void) preventBlackFlash {
    //minimize black flash
    //loadHTMLString doesn't seem to make a difference
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"];
    //    [self.DTCWebView loadHTMLString:[NSString stringWithFormat:@"<html><body><img src=\"file://%@\"></body></html>",path] baseURL:nil];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];

    //thanks http://stackoverflow.com/a/12532527/2284713 -- have to manually check for 4" display
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        self.iv.image = [UIImage imageNamed:@"Default-568h.png"];
    } else {
        self.iv.image = [UIImage imageNamed:@"Default.png"];
    }
    self.iv.hidden = NO;
    [self.navigationController.view addSubview:self.iv];
}

- (void) viewDidLoad {
    [self preventBlackFlash];
    [super viewDidLoad];
}

@end
