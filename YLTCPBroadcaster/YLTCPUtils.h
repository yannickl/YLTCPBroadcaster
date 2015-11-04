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

#import <Foundation/Foundation.h>

/**
 * Collection of useful method to work with sockets.
 */
@interface YLTCPUtils : NSObject

#pragma mark - Getting Socket Properties
/** @name Getting Socket Properties */

/**
 * @abstract Returns the current device's ip address on the network.
 * @discussion E.g. `192.168.0.1`. It returns nil if something
 * went wrong.
 * @since 1.0.0
 */
+ (NSString * _Nullable)localIp;

/**
 * @abstract Returns the subnet mask of the current device network.
 * @discussion E.g. `255.255.255.0`. It returns nil if something
 * went wrong.
 * @since 1.0.0
 */
+ (NSString * _Nullable)localSubnetMask;

/**
 * @abstract Compute and returns the network prefix using a given ip and
 * its subnet mask.
 * @param ip An ip address.
 * @param subnetMask A subnet mask.
 * @discussion E.g. with the `192.168.5.130` ip address and its associated
 * network mask `255.255.255.192`, the network prefix is `192.168.5.128`.
 * It returns nil if something went wrong.
 * @since 1.0.0
 */
+ (NSString * _Nullable)subnetWithIp:(NSString * _Nonnull)ip mask:(NSString * _Nonnull)subnetMask;

/**
 * @abstract Compute and returns the broadcast address using a given ip and
 * its subnet mask.
 * @param ip An ip address.
 * @param subnetMask A subnet mask.
 * @discussion E.g. with the `192.168.5.130` ip address and its associated
 * network mask `255.255.255.192`, the broadcast address is `192.168.5.191`.
 * It returns nil if something went wrong.
 * @since 1.0.0
 */
+ (NSString * _Nullable)broadcastAddressWithIp:(NSString * _Nonnull)ip mask:(NSString * _Nonnull)subnetMask;

@end
