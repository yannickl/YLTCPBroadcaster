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

- (void)viewDidLoad {
  [super viewDidLoad];

  _remoteHosts = @[];

  _broadcaster          = [YLTCPBroadcaster defaultBroadcaster];
  _broadcaster.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self scanNetwork];
}

#pragma mark - Actions

- (IBAction)refreshAction:(id)sender {
  [self scanNetwork];
}

#pragma mark - Private Methods

- (void)scanNetwork {
  UIApplication *app = [UIApplication sharedApplication];
  [app setNetworkActivityIndicatorVisible:YES];

  _remoteHosts = @[];

  [self.tableView reloadData];

  _refreshButtonItem.enabled = NO;
  self.title                 = [NSString stringWithFormat:@"Scanning %@:%d...", _broadcaster.networkPrefix, 8080];

  __weak typeof(self) weakSelf = self;
  [_broadcaster scanWithPort:8080 timeoutInterval:1.5 completionHandler:^(NSArray *hosts) {
    [app setNetworkActivityIndicatorVisible:NO];

    weakSelf.refreshButtonItem.enabled = YES;
    weakSelf.title                     = @"Available Hosts";
  }];
}

#pragma mark - YLTCPBroadcaster Delegate Methods

-(void)tcpBroadcaster:(YLTCPBroadcaster *)broadcaster didFoundHost:(NSString *)host {
  [self.tableView beginUpdates];

  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_remoteHosts.count inSection:0];
  _remoteHosts           = [_remoteHosts arrayByAddingObject:host];

  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];

  [self.tableView endUpdates];
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
