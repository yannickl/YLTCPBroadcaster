//
//  ViewController.h
//  YLTCPBroadcasterSample
//
//  Created by Yannick Loriot on 27/10/14.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLTCPBroadcasterDelegate.h"

@interface ViewController : UITableViewController <YLTCPBroadcasterDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButtonItem;

- (IBAction)refreshAction:(id)sender;

@end

