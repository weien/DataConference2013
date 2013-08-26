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
@property (strong, nonatomic) UIView* infoView;
@property (strong, nonatomic) UIButton* dismissButton;
@property (strong, nonatomic) UILabel* infoLabel;

@end

@implementation DataMapViewController
@synthesize infoView = _infoView;
@synthesize dismissButton = _dismissButton;
@synthesize infoLabel = _infoLabel;

- (void) showInfoView {
    CGRect infoViewFrame = self.view.bounds;
    CGRect infoLabelFrame = CGRectMake(self.view.bounds.size.width / 2 - 140, self.view.bounds.size.height * .1, 280, 140);
//    CGRect dismissButtonFrame = CGRectMake(self.view.bounds.size.width / 2 - 20, self.view.bounds.size.height * .5, 40, 30);
    CGRect dismissButtonFrame = CGRectMake(120, 100, 40, 30);

    
    
    if (!self.infoView) {
        self.infoView = [[UIView alloc] initWithFrame:infoViewFrame];
        self.infoView.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
//        self.infoView.numberOfLines = 0;
        self.infoView.alpha = .8;
        self.infoView.userInteractionEnabled = YES;
        
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
//        self.infoLabel.alpha = 1;
        self.infoLabel.font = [UIFont boldSystemFontOfSize:16];
        NSMutableAttributedString* formattedText = [[NSMutableAttributedString alloc] initWithString:@"This basic map of Hurricane Sandy relief awards demonstrates what the DATA Act will make possible for all federal funds. \n \n"];
        self.infoLabel.attributedText = formattedText;
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.layer.cornerRadius = 5.0f;
        [self.infoLabel.layer setMasksToBounds:YES];
        self.infoLabel.userInteractionEnabled = YES;
        [self.infoView addSubview:self.infoLabel];
//        self.infoLabel.layer.borderWidth = 1;
//        self.infoLabel.contentMode = UIViewContentModeTop;
        
        
        self.dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.dismissButton addTarget:self
                   action:@selector(hideInfoView)
         forControlEvents:UIControlEventTouchUpInside];
        [self.dismissButton setTitle:@"OK" forState:UIControlStateNormal];
        self.dismissButton.frame = dismissButtonFrame;
        self.dismissButton.backgroundColor = [UIColor clearColor];
        self.dismissButton.titleLabel.textColor = [UIColor blackColor];
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
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
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
