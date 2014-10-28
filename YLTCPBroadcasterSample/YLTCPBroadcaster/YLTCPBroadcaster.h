//
//  YLTCPBroadcaster.h
//  YLTCPBroadcasterSample
//
//  Created by Yannick Loriot on 27/10/14.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import "YLTCPSocket.h"
#import "YLTCPUtils.h"

typedef void (^YLTCPBroadcasterCompletionBlock) (NSArray *hosts);

@interface YLTCPBroadcaster : NSObject
@property (nonatomic, strong, readonly) NSString *ip;
@property (nonatomic, strong, readonly) NSString *subnetMask;

- (id)initWithIp:(NSString *)ip subnetMask:(NSString *)subnetMask;
+ (instancetype)broadcasterWithIp:(NSString *)ip subnetMask:(NSString *)subnetMask;
+ (instancetype)defaultBroadcaster;

- (void)scanPort:(NSInteger)port completionHandler:(YLTCPBroadcasterCompletionBlock)completion;
- (void)scanPort:(NSInteger)port timeout:(NSTimeInterval)timeout completionHandler:(YLTCPBroadcasterCompletionBlock)completion;

@end