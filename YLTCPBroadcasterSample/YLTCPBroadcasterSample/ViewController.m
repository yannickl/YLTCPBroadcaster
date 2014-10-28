//
//  ViewController.m
//  YLTCPBroadcasterSample
//
//  Created by Yannick Loriot on 27/10/14.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import "ViewController.h"
#import "YLTCPBroadcaster.h"

@interface ViewController ()
@property (nonatomic, strong) YLTCPBroadcaster *broadcaster;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _broadcaster = [YLTCPBroadcaster defaultBroadcaster];
    [_broadcaster scanPort:8080 completionHandler:^(NSArray *hosts) {
        NSLog(@"%@", hosts);
    }];
}

@end
