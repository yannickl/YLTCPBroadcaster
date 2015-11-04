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

@class YLTCPBroadcaster;

/**
 * @abstract The TCP broadcaster delegate aims to make the host discovering more interactive by warning the receiver each time a new endpoint is found.
 * @since 2.0.0
 */
@protocol YLTCPBroadcasterDelegate <NSObject>

@optional

#pragma mark - Responding to Discovery Events
/** @name Responding to Discovery Events */

/**
 * @abstract Tells the delegate that a host did found.
 * @param broadcaster The tcp broadcasted that found the host.
 * @param host The host found as a string.
 * @since 2.0.0
 */
- (void)tcpBroadcaster:(YLTCPBroadcaster * _Nonnull)broadcaster didFoundHost:(NSString * _Nonnull)host;

@end