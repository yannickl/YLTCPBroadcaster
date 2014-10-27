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
@property (nonatomic, strong) YLTCPSocket *socket1;
@property (nonatomic, strong) YLTCPSocket *socket2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"debut");
    
    _socket1 = [YLTCPSocket socketWithHostName:@"192.168.0.11" port:8080];
    [_socket1 connectWithCompletionHandler:^(BOOL success, NSString *message) {
        NSLog(@"%d: %@", success, message);
    }];
    
    _socket2 = [YLTCPSocket socketWithHostName:@"192.168.0.14" port:8080];
    [_socket2 connectWithCompletionHandler:^(BOOL success, NSString *message) {
        NSLog(@"%d: %@", success, message);
    }];
    
    NSLog(@"fin");
}

@end
