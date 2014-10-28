//
//  YLTCPUtils.h
//  YLTCPBroadcasterSample
//
//  Created by Yannick Loriot on 28/10/14.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLTCPUtils : NSObject

+ (NSString *)localIp;
+ (NSString *)localSubnetMask;
+ (NSString *)networkPrefixWithIp:(NSString *)ip subnetMask:(NSString *)subnetMask;
+ (NSString *)broadcastAddressFromIp:(NSString *)ip withSubnetMask:(NSString *)subnetMask;

@end
