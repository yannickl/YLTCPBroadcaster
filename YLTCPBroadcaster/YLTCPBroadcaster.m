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

#import "YLTCPBroadcaster.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@interface YLTCPBroadcaster ()
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *subnetMask;
@property (nonatomic, strong) NSString *networkPrefix;
@property (nonatomic, strong) NSString *broadcastAddress;

@end

@implementation YLTCPBroadcaster

#pragma mark Creating and Initializing TCP Broadcasters

- (id)initWithIp:(NSString *)ip subnetMask:(NSString *)subnetMask {
  if ((self = [super init])) {
    NSParameterAssert(ip);
    NSParameterAssert(subnetMask);

    _ip                           = ip;
    _subnetMask                   = subnetMask;
    _networkPrefix                = [YLTCPUtils subnetWithIp:_ip mask:_subnetMask];
    _broadcastAddress             = [YLTCPUtils broadcastAddressWithIp:_ip mask:_subnetMask];
    _maxConcurrentConnectionCount = 150;
  }
  return self;
}

+ (instancetype)broadcasterWithIp:(NSString *)ip subnetMask:(NSString *)subnetMask {
  return [[self alloc] initWithIp:ip subnetMask:subnetMask];
}

+ (instancetype)defaultBroadcaster {
  static YLTCPBroadcaster *defaultBroadcaster;
  static dispatch_once_t once;

  dispatch_once(&once, ^{
    NSString *ip         = [YLTCPUtils localIp];
    NSString *subnetMask = [YLTCPUtils localSubnetMask];
    defaultBroadcaster   = [[self alloc] initWithIp:ip subnetMask:subnetMask];
  });

  return defaultBroadcaster;
}

#pragma mark - Scanning the Network

- (void)scanWithPort:(SInt32)port completionHandler:(YLTCPBroadcasterCompletionBlock)completion {
  [self scanWithPort:port timeoutInterval:kYLTCPSocketDefaultTimeoutInSeconds completionHandler:completion];
}

- (void)scanWithPort:(SInt32)port timeoutInterval:(NSTimeInterval)timeout completionHandler:(YLTCPBroadcasterCompletionBlock)completion {
  @autoreleasepool {
    NSMutableArray *availableHosts = [NSMutableArray array];

    NSArray *networkPrefixParts    = [_networkPrefix componentsSeparatedByString:@"."];
    NSArray *broadcastAddressParts = [_broadcastAddress componentsSeparatedByString:@"."];

    NSOperationQueue *queue           = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = _maxConcurrentConnectionCount;

    // IP v4
    if (networkPrefixParts.count == 4 && networkPrefixParts.count == broadcastAddressParts.count) {
      NSInteger p1Floor = [networkPrefixParts[0] integerValue];
      NSInteger p1Ceil  = [broadcastAddressParts[0] integerValue] + 1;
      NSInteger p2Floor = [networkPrefixParts[1] integerValue];
      NSInteger p2Ceil  = [broadcastAddressParts[1] integerValue] + 1;
      NSInteger p3Floor = [networkPrefixParts[2] integerValue];
      NSInteger p3Ceil  = [broadcastAddressParts[2] integerValue] + 1;
      NSInteger p4Floor = [networkPrefixParts[3] integerValue] + 1;
      NSInteger p4Ceil  = [broadcastAddressParts[3] integerValue];

      for (NSInteger p1 = p1Floor; p1 < p1Ceil; p1++) {
        for (NSInteger p2 = p2Floor; p2 < p2Ceil; p2++) {
          for (NSInteger p3 = p3Floor; p3 < p3Ceil; p3++) {
            for (NSInteger p4 = p4Floor; p4 < p4Ceil; p4++) {
              NSString *remoteIp = [NSString stringWithFormat:@"%ld.%ld.%ld.%ld", (long)p1, (long)p2, (long)p3, (long)p4];

              YLTCPSocket *socket = [YLTCPSocket socketWithHostname:remoteIp port:port];

              [queue addOperationWithBlock:^{
                YLTCPSocketStatus status = [socket connectWithTimeoutInterval:timeout];

                if (status == YLTCPSocketStatusOpened) {
                  if (_delegate && [_delegate respondsToSelector:@selector(tcpBroadcaster:didFoundHost:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [_delegate tcpBroadcaster:self didFoundHost:remoteIp];
                    });
                  }

                  [availableHosts addObject:remoteIp];
                }
              }];
            }
          }
        }
      }
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      [queue waitUntilAllOperationsAreFinished];

      dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
          completion(availableHosts);
        }
      });
    });
  }
}

@end
