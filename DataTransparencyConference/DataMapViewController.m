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

@end

@implementation DataMapViewController
@synthesize infoView = _infoView;

- (void) showInfoView {
    if (!self.infoView) {
//        CGPoint superViewCenter = self.view.center;
//        CGRect infoViewFrame = CGRectMake(superViewCenter.x/2, superViewCenter.y/3, superViewCenter.x, superViewCenter.y/2);
        CGRect infoViewFrame = self.view.bounds;
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
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(hideInfoView)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"OK" forState:UIControlStateNormal];
        button.frame = CGRectMake(self.view.frame.size.width / 2 - 20, self.view.frame.size.width * .75, 40, 30);
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.textColor = [UIColor blackColor];
        [self.infoView addSubview:button];
    }
    
    self.infoView.hidden = NO;
    
        
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

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.externalLinkViewer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.federaltransparency.gov/Style%20Library/GISMapping/index.html"]]];
    [self showInfoView];
}

@end
