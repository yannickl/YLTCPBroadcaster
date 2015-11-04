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

- (void)testValidNetworkSubnet {
  NSString *v0 = [YLTCPUtils subnetWithIp:@"192.128.0.11" mask:@"0.0.0.0"];
  XCTAssertEqualObjects(v0, @"0.0.0.0");

  NSString *v1 = [YLTCPUtils subnetWithIp:@"192.128.0.11" mask:@"255.255.255.0"];
  XCTAssertEqualObjects(v1, @"192.128.0.0");

  NSString *v2 = [YLTCPUtils subnetWithIp:@"192.128.0.11" mask:@"255.255.255.128"];
  XCTAssertEqualObjects(v2, @"192.128.0.0");

  NSString *v3 = [YLTCPUtils subnetWithIp:@"192.128.0.211" mask:@"255.255.255.128"];
  XCTAssertEqualObjects(v3, @"192.128.0.128");
}

- (void)testInvalidNetworkSubnet {
  NSString *i0 = [YLTCPUtils subnetWithIp:@"" mask:@""];
  XCTAssertEqualObjects(i0, nil);

  NSString *i1 = [YLTCPUtils subnetWithIp:@"" mask:@"255.255.255.0"];
  XCTAssertEqualObjects(i1, nil);

  NSString *i2 = [YLTCPUtils subnetWithIp:@"192.128.0.11" mask:@"0"];
  XCTAssertEqualObjects(i2, nil);

  NSString *i3 = [YLTCPUtils subnetWithIp:@"192.128.0.11" mask:@"255.255"];
  XCTAssertEqualObjects(i3, nil);
}

- (void)testValidNetworkBroadcast {
  NSString *v0 = [YLTCPUtils broadcastAddressWithIp:@"192.128.0.11" mask:@"0.0.0.0"];
  XCTAssertEqualObjects(v0, @"255.255.255.255");

  NSString *v1 = [YLTCPUtils broadcastAddressWithIp:@"192.128.0.11" mask:@"255.255.255.0"];
  XCTAssertEqualObjects(v1, @"192.128.0.255");

  NSString *v2 = [YLTCPUtils broadcastAddressWithIp:@"192.128.0.11" mask:@"255.255.255.128"];
  XCTAssertEqualObjects(v2, @"192.128.0.127");

  NSString *v3 = [YLTCPUtils broadcastAddressWithIp:@"192.128.0.211" mask:@"255.255.255.128"];
  XCTAssertEqualObjects(v3, @"192.128.0.255");
}

- (void)testInvalidNetworkBroadcast {
  NSString *i0 = [YLTCPUtils broadcastAddressWithIp:@"" mask:@""];
  XCTAssertEqualObjects(i0, nil);

  NSString *i1 = [YLTCPUtils broadcastAddressWithIp:@"" mask:@"255.255.255.0"];
  XCTAssertEqualObjects(i1, nil);

  NSString *i2 = [YLTCPUtils broadcastAddressWithIp:@"192.128.0.11" mask:@"0"];
  XCTAssertEqualObjects(i2, nil);

  NSString *i3 = [YLTCPUtils broadcastAddressWithIp:@"192.128.0.11" mask:@"255.255"];
  XCTAssertEqualObjects(i3, nil);
}

@end
