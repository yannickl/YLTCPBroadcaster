//
//  YLTCPUtilsTests.m
//  YLTCPBroadcasterSample
//
//  Created by Yannick LORIOT on 04/11/15.
//  Copyright © 2015 Yannick Loriot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YLTCPUtils.h"

@interface YLTCPUtilsTests : XCTestCase

@end

@implementation YLTCPUtilsTests

- (void)testValidNetworkPrefix {
  NSString *v0 = [YLTCPUtils networkPrefixWithIp:@"192.128.0.11" subnetMask:@"0.0.0.0"];
  XCTAssertEqualObjects(v0, @"0.0.0.0");

  NSString *v1 = [YLTCPUtils networkPrefixWithIp:@"192.128.0.11" subnetMask:@"255.255.255.0"];
  XCTAssertEqualObjects(v1, @"192.128.0.0");

  NSString *v2 = [YLTCPUtils networkPrefixWithIp:@"192.128.0.11" subnetMask:@"255.255.255.128"];
  XCTAssertEqualObjects(v2, @"192.128.0.0");

  NSString *v3 = [YLTCPUtils networkPrefixWithIp:@"192.128.0.211" subnetMask:@"255.255.255.128"];
  XCTAssertEqualObjects(v3, @"192.128.0.128");
}

- (void)testInvalidNetworkPrefix {
  NSString *i0 = [YLTCPUtils networkPrefixWithIp:@"" subnetMask:@""];
  XCTAssertEqualObjects(i0, nil);

  NSString *i1 = [YLTCPUtils networkPrefixWithIp:@"" subnetMask:@"255.255.255.0"];
  XCTAssertEqualObjects(i1, nil);

  NSString *i2 = [YLTCPUtils networkPrefixWithIp:@"192.128.0.11" subnetMask:@"0"];
  XCTAssertEqualObjects(i2, nil);

  NSString *i3 = [YLTCPUtils networkPrefixWithIp:@"192.128.0.11" subnetMask:@"255.255"];
  XCTAssertEqualObjects(i3, nil);
  NSLog(@"networkPrefix %@", i0);
}

@end
