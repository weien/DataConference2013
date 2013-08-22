//
//  DataMapViewController.m
//  DataTransparencyConference
//
//  Created by Weien on 8/22/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "DataMapViewController.h"

@interface DataMapViewController ()

@end

@implementation DataMapViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.externalLinkViewer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.federaltransparency.gov/Style%20Library/GISMapping/index.html"]]];
}

@end
