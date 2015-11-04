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

#import "YLTCPSocket.h"
#import "YLTCPUtils.h"
#import "YLTCPBroadcasterDelegate.h"

/**
 * @abstract The TCP broadcaster completion block. This block has no return
 * value and takes one argument: the `hosts`.
 *
 * - `hosts`: A list of ip strings corresponding to every host available on
 * the network. If no host is found the array is empty.
 */
typedef void (^YLTCPBroadcasterCompletionBlock) (NSArray * _Nonnull hosts);

/**
 * An `YLTCPBroadcaster` object allows you to find every host on the specified
 * network with a given TCP port open. E.g. find on your local network every
 * hosts with the port `8080` open.
 *
 * `YLTCPBroadcaster` is fully GCD (Grand Central Dispatch) based and
 * Thread-Safe.
 *
 * It works by broadcasting a TCP connection to every host on the network
 * (using the subnet mask) and by waiting the response for each one. In this
 * manner it can determine whether the host is open on the given port.
 */
@interface YLTCPBroadcaster : NSObject

#pragma mark - Creating and Initializing TCP Broadcasters
/** @name Creating and Initializing TCP Broadcasters */

/**
 * @abstract Creates and returns the default broadcaster.
 * @discussion The default broadcaster corresponding to the default device
 * network. It means the broadcaster's `ip`, `subnetMask`, `networkPrefix`
 * and `broadcastAddress` are the same of the current device.
 * @since 1.0.0
 */
+ (_Nonnull instancetype)defaultBroadcaster;

/**
 * @abstract Initializes a broadcaster with an ip and its subnet mask.
 * @param ip The ip of the receiver.
 * @param subnetMask The subnet mask corresponding to the ip.
 * @discussion In order to perform the request the ip and the subnet mask
 * should be the same of the current device.
 * @since 1.0.0
 */
- (_Nonnull id)initWithIp:(NSString * _Nonnull)ip subnetMask:(NSString * _Nonnull)subnetMask;

/**
 * @abstract Creates a broadcaster with an ip and its subnet mask.
 * @param ip The ip of the receiver.
 * @param subnetMask The subnet mask corresponding to the ip.
 * @see initWithIp:subnetMask:
 * @since 1.0.0
 */
+ (_Nonnull instancetype)broadcasterWithIp:(NSString * _Nonnull)ip subnetMask:(NSString * _Nonnull)subnetMask;

#pragma mark - Getting Broadcaster Properties
/** @name Getting Broadcaster Properties */

/**
 * @abstract The receiver’s ip address.
 * @since 1.0.0
 */
@property (nonatomic, strong, readonly) NSString * _Nonnull ip;

/**
 * @abstract The receiver’s subnet mask.
 * @since 1.0.0
 */
@property (nonatomic, strong, readonly) NSString * _Nonnull subnetMask;

/**
 * @abstract The receiver’s network prefix address.
 * @since 1.0.0
 */
@property (nonatomic, strong, readonly) NSString * _Nullable networkPrefix;

/**
 * @abstract The receiver’s broadcast address.
 * @since 1.0.0
 */
@property (nonatomic, strong, readonly) NSString * _Nullable broadcastAddress;

#pragma mark - Managing the Execution of Scan
/** @name Managing the Execution of Scan */

/**
 * @abstract The maximum number of concurrent connection operation that
 * can be executed at the same time. Default to 150.
 * @since 2.0.0
 */
@property (nonatomic, assign) NSInteger maxConcurrentConnectionCount;

#pragma mark - Managing the Delegate
/** @name Managing the Delegate */

/**
 * @abstract The object that acts as the delegate of the receiving TCP
 * broadcaster.
 * @since 2.0.0
 */
@property (nonatomic, weak) id<YLTCPBroadcasterDelegate> _Nullable delegate;


#pragma mark - Scanning the Network
/** @name Scanning the Network */

/**
 * @abstract Performs an asynchronous scan of the current network to find
 * every host which are listening on a given TCP port number.
 * @param port The TCP port number to which the socket should connect.
 * @param completionBlock A broadcaster completion block.
 * @discussion The operation is performed with the
 * `kYLTCPSocketDefaultTimeoutInSeconds` timeout value.
 * @see scanWithPort:timeoutInterval:completionHandler:
 * @since 1.0.0
 */
- (void)scanWithPort:(SInt32)port completionHandler:(YLTCPBroadcasterCompletionBlock _Nullable)completionBlock;

/**
 * @abstract Performs an asynchronous scan of the current network to find
 * every host which are listening on a given TCP port number. The operation
 * is stopped if the time exceeded the timeout.
 * @param port The TCP port number to which the socket should connect.
 * @param timeout The timeout interval for the operation, in seconds.
 * @param completionBlock A broadcaster completion block.
 * @discussion The operation runs entirely within its own GCD dispatch_queue
 * and it calls the completion handler on the main queue when it finishes. If
 * no host is found and/or if an error occured the returned list is empty.
 * @since 1.0.0
 */
- (void)scanWithPort:(SInt32)port timeoutInterval:(NSTimeInterval)timeout completionHandler:(YLTCPBroadcasterCompletionBlock _Nullable)completionBlock;

@end
