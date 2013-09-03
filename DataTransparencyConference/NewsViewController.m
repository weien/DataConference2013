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
@property BOOL splashScreenHasBeenShown;
@end

@implementation NewsViewController
@synthesize iv = _iv;
@synthesize splashScreenHasBeenShown = _splashScreenHasBeenShown;

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

- (void) viewDidAppear:(BOOL)animated {
    [self displaySplashScreen];
}

- (void) displaySplashScreen {
    
    if (!self.splashScreenHasBeenShown) {
        UIImageView*imageView = nil;
        if ([UIScreen mainScreen].bounds.size.height == 568.0f) {
            NSLog(@"1");
            imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"splash_full-568h.png"]];
        }
        else {
            NSLog(@"2");
            imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"splash_full.png"]];
        }
        
        UIViewController* vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [[vc view] addSubview:imageView];
        [[vc view] bringSubviewToFront:imageView];
        
        // as usual
        //    [self.window makeKeyAndVisible];
        
        [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionTransitionNone animations:^(void){imageView.alpha=0.0f;} completion:^(BOOL finished){[imageView removeFromSuperview];}];
    }
    self.splashScreenHasBeenShown = YES;
}

@end
