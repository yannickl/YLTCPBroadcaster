//
//  ViewController.m
//  YLTCPBroadcasterSample
//
//  Created by Yannick Loriot on 27/10/14.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import "ViewController.h"
#import "YLTCPBroadcaster.h"

static NSString * kTableViewCellIdentifier = @"YLDeviceCell";

@interface ViewController ()
@property (nonatomic, strong) YLTCPBroadcaster *broadcaster;
@property (nonatomic, strong) NSArray          *remoteHosts;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _broadcaster = [YLTCPBroadcaster defaultBroadcaster];

    [self scanNetwork];
}

#pragma mark - Actions

- (IBAction)refreshAction:(id)sender {
    [self scanNetwork];
}

#pragma mark - Private Methods

- (void)scanNetwork
{
    UIApplication *app = [UIApplication sharedApplication];
    [app setNetworkActivityIndicatorVisible:YES];
    
    _refreshButtonItem.enabled = NO;
    self.title                 = [NSString stringWithFormat:@"Scanning %@:%d...", _broadcaster.networkPrefix, 8080];
    
    __weak typeof(self) weakSelf = self;
    [_broadcaster scanPort:8080 completionHandler:^(NSArray *hosts) {
        [app setNetworkActivityIndicatorVisible:NO];
        
        weakSelf.remoteHosts               = hosts;
        weakSelf.refreshButtonItem.enabled = YES;
        weakSelf.title                     = @"Available Hosts";
        
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_remoteHosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    
    cell.textLabel.text = [_remoteHosts objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
