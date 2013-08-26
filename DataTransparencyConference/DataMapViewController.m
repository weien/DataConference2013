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
@property (strong, nonatomic) UILabel* infoView;
@property (strong, nonatomic) UIButton* dismissButton;

@end

@implementation DataMapViewController
@synthesize infoView = _infoView;
@synthesize dismissButton = _dismissButton;

- (void) showInfoView {
    CGRect infoViewFrame = self.view.bounds;
    CGRect dismissButtonFrame = CGRectMake(self.view.bounds.size.width / 2 - 20, self.view.bounds.size.height * .50, 40, 30);
    if (!self.infoView) {
//        CGPoint superViewCenter = self.view.center;
//        CGRect infoViewFrame = CGRectMake(superViewCenter.x/2, superViewCenter.y/3, superViewCenter.x, superViewCenter.y/2);
        self.infoView = [[UILabel alloc] initWithFrame:infoViewFrame];
        self.infoView.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
        self.infoView.numberOfLines = 0;
        self.infoView.alpha = .8;
        self.infoView.userInteractionEnabled = YES;
        
        self.infoView.font = [UIFont boldSystemFontOfSize:16];
        NSMutableAttributedString* formattedText = [[NSMutableAttributedString alloc] initWithString:@"This basic map of contracts for Hurricane Sandy relief awards demonstrates what the DATA Act will make possible for all federal funds. \n \n \n \n \n"];
//        [formattedText addAttribute:<#(NSString *)#> value:<#(id)#> range:<#(NSRange)#>
        
        self.infoView.attributedText = formattedText;
        self.infoView.textAlignment = NSTextAlignmentCenter;

        
        
//        self.infoView.layer.cornerRadius = 5.0f;
//        [self.infoView.layer setMasksToBounds:YES];
        
        [self.externalLinkViewer addSubview:self.infoView];
        
        self.dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.dismissButton addTarget:self
                   action:@selector(hideInfoView)
         forControlEvents:UIControlEventTouchUpInside];
        [self.dismissButton setTitle:@"OK" forState:UIControlStateNormal];
        self.dismissButton.frame = dismissButtonFrame;
        self.dismissButton.backgroundColor = [UIColor clearColor];
        self.dismissButton.titleLabel.textColor = [UIColor blackColor];
        [self.infoView addSubview:self.dismissButton];
    }
    self.infoView.frame = infoViewFrame;
    self.infoView.hidden = NO;
    self.dismissButton.frame = dismissButtonFrame;
    
//        [self.syncBar setBackgroundColor:[UIColor colorWithRed:68/255.0f green:110/255.0f blue:143/255.0f alpha:1.0f]];
//        
//        [self.syncBar setText:@"UPDATING..."];
//        [self.syncBar setTextAlignment:NSTextAlignmentCenter];
//        [self.syncBar setTextColor:[UIColor whiteColor]];
//        [self.syncBar setFont:[UIFont systemFontOfSize:8]];
//        //        [self.syncBar setContentMode:UIViewContentModeBottom];
//        
//        [[[UIApplication sharedApplication] keyWindow] addSubview:self.syncBar];
    
}

- (void) hideInfoView {
    self.infoView.hidden = YES;
//    [UIView beginAnimations:@"hideSyncBar" context:nil];
//    [UIView setAnimationDuration:0.3];
//    
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.syncBar cache:YES];
//    [self.syncBar setFrame:CGRectMake(0, adjustmentHeight, viewSize.width, 0)];
//    [UIView commitAnimations];
}

- (void) addInfoButton {
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(hideOrDisplayInfoView) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
}

- (void) hideOrDisplayInfoView {
    if (self.infoView.hidden) {
        [self showInfoView];
    }
    else {
        [self hideInfoView];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.externalLinkViewer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.federaltransparency.gov/Style%20Library/GISMapping/index.html"]]];
    [self showInfoView];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self showInfoView];
    [self addInfoButton];
}

@end
