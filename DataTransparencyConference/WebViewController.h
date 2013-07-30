//
//  WebViewController.h
//  TwitterTimelineSpike
//
//  Created by Weien on 6/19/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *externalLinkViewer;
@property (strong, nonatomic) NSURL* urlToDisplay;
- (IBAction)openPageInBrowser:(id)sender;

@end
