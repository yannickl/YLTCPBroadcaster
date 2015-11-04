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

/// The preferred timeout in seconds
extern const NSUInteger kYLTCPSocketDefaultTimeoutInSeconds;

/**
 * @abstract Defines the different socket status.
 * @since 2.0.0
 */
typedef NS_ENUM(NSInteger, YLTCPSocketStatus) {
  /** Generic error status error. */
  YLTCPSocketStatusError,
  /** Cannot open a socket error. */
  YLTCPSocketStatusOpenSocketError,
  /** No available host error. */
  YLTCPSocketStatusNoHostError,
  /** Connection time out connection. */
  YLTCPSocketStatusTimeOutError,
  /** Host:port endpoint available. */
  YLTCPSocketStatusOpened
};

/**
 * @abstract The TCP socket completion block. This block has no return value 
 * and takes two arguments: the `success` and the `message`.
 *
 * - `success`: Boolean value to check whether the socket achieved a connection
 * with the remote host. If the value is equal to `NO` it means that an error 
 * occured and you should look at the `errorMessage` argument.
 * - `errorMessage`: A NSString to describe the reason of the connection failure.
 */
typedef void (^YLTCPSocketCompletionBlock) (BOOL success, NSString * _Nullable errorMessage);

/**
 * The main purpose of the `YLTCPSocket` is to try to open a TCP socket with a
 * remote host to check if a connection is possible.
 */
@interface YLTCPSocket : NSObject

#pragma mark - Creating and Initializing TCP Sockets
/** @name Creating and Initializing TCP Sockets */

/**
 * @abstract Initializes a TCP socket with an endpoint's name and port number.
 * @param hostname The hostname of the remote endpoint.
 * @param port The TCP port number to which the socket should connect.
 * @since 1.0.0
 */
- (_Nonnull id)initWithHostname:(NSString * _Nonnull)hostname port:(SInt32)port;

/**
 * @abstract Creates a TCP socket with an endpoint's name and port number.
 * @param hostname The hostname of the remote endpoint.
 * @param port The TCP port number to which the socket should connect.
 * @see initWithHostname:port:
 * @since 1.0.0
 */
+ (_Nonnull instancetype)socketWithHostname:(NSString * _Nonnull)hostname port:(SInt32)port;

#pragma mark - Getting Socket Properties
/** @name Getting Socket Properties */

/**
 * @abstract The receiver’s host name.
 * @since 1.0.0
 */
@property (nonatomic, strong, readonly) NSString * _Nonnull hostname;

/**
 * @abstract The receiver’s TCP port number.
 * @since 1.0.0
 */
@property (nonatomic, readonly) SInt32 port;

#pragma mark - Connecting with Host
/** @name Connecting with Host */

/**
 * @abstract Performs an synchronous connection to the remote endpoint.
 * @param timeout The timeout interval for the operation, in seconds.
 * @returns A tcp status.
 * @discussion The operation is performed with the
 * `kYLTCPSocketDefaultTimeoutInSeconds` timeout value.
 * @since 2.0.0
 */
- (YLTCPSocketStatus)connectWithTimeoutInterval:(NSTimeInterval)timeout;

/**
 * @abstract Performs an asynchronous connection to the remote endpoint and
 * call the completion handler when the operation did finished or if the
 * time exceeded the timeout.
 * @param completionBlock A socket completion block.
 * @discussion The operation is performed with the
 * `kYLTCPSocketDefaultTimeoutInSeconds` timeout value.
 * @see connectWithTimeoutInterval:completionHandler:
 * @since 1.0.0
 */
- (void)connectWithCompletionHandler:(YLTCPSocketCompletionBlock _Nullable)completionBlock;

/**
 * @abstract Performs an asynchronous connection to the remote endpoint and
 * call the completion handler when the operation did finished or if the
 * time exceeded the timeout.
 * @param timeout The timeout interval for the operation, in seconds.
 * @param completionBlock A socket completion block.
 * @discussion The operation runs entirely within its own GCD dispatch_queue
 * and it calls the completion handler on the main queue when it finishes.
 * @since 1.0.0
 */
- (void)connectWithTimeoutInterval:(NSTimeInterval)timeout completionHandler:(YLTCPSocketCompletionBlock _Nullable)completionBlock;

@end
