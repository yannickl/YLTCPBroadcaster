/*
 * YLTCPBroadcaster
 *
 * Copyright 2014 - present, Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "YLTCPUtils.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation YLTCPUtils

+ (NSString *)localIp {
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

+ (NSString *)localSubnetMask {
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

+ (NSString *)subnetWithIp:(NSString *)ip mask:(NSString *)subnetMask {
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

+ (NSString *)broadcastAddressWithIp:(NSString *)ip mask:(NSString *)subnetMask {
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
