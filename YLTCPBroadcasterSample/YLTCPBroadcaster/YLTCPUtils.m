//
//  YLTCPUtils.m
//  YLTCPBroadcasterSample
//
//  Created by Yannick Loriot on 28/10/14.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import "YLTCPUtils.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation YLTCPUtils

+ (NSString *)localIp
{
    NSString *broadcastAddress = nil;
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr  = NULL;
    int success                = 0;
    
    // Retrieve the current interfaces
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        temp_addr = interfaces;
        
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    broadcastAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return broadcastAddress;
}

+ (NSString *)localSubnetMask
{
    NSString *broadcastAddress = nil;
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr  = NULL;
    int success                = 0;
    
    // Retrieve the current interfaces
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        temp_addr = interfaces;
        
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    broadcastAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return broadcastAddress;
}

+ (NSString *)networkPrefixWithIp:(NSString *)ip subnetMask:(NSString *)subnetMask
{
    NSParameterAssert(ip);
    NSParameterAssert(subnetMask);
    
    NSString *networkPrefixAddress = nil;
    
    struct in_addr host, mask, networkPrefix;
    char networkPrefix_address[INET_ADDRSTRLEN];
    
    if (inet_pton(AF_INET, [ip cStringUsingEncoding:NSUTF8StringEncoding], &host) == 1
        && inet_pton(AF_INET, [subnetMask cStringUsingEncoding:NSUTF8StringEncoding], &mask) == 1) {
        networkPrefix.s_addr = host.s_addr & mask.s_addr;
        
        if (inet_ntop(AF_INET, &networkPrefix, networkPrefix_address, INET_ADDRSTRLEN) != NULL) {
            networkPrefixAddress = [NSString stringWithCString:networkPrefix_address encoding:NSUTF8StringEncoding];
        }
    }
    
    return networkPrefixAddress;
}

+ (NSString *)broadcastAddressFromIp:(NSString *)ip withSubnetMask:(NSString *)subnetMask
{
    NSParameterAssert(ip);
    NSParameterAssert(subnetMask);
    
    NSString *networkPrefixAddress = nil;
    
    struct in_addr host, mask, networkPrefix;
    char networkPrefix_address[INET_ADDRSTRLEN];
    
    if (inet_pton(AF_INET, [ip cStringUsingEncoding:NSUTF8StringEncoding], &host) == 1
        && inet_pton(AF_INET, [subnetMask cStringUsingEncoding:NSUTF8StringEncoding], &mask) == 1) {
        networkPrefix.s_addr = host.s_addr | ~mask.s_addr;
        
        if (inet_ntop(AF_INET, &networkPrefix, networkPrefix_address, INET_ADDRSTRLEN) != NULL) {
            networkPrefixAddress = [NSString stringWithCString:networkPrefix_address encoding:NSUTF8StringEncoding];
        }
    }
    
    return networkPrefixAddress;
}

@end
