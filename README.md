# YLTCPBroadcaster [![Supported Plateforms](https://cocoapod-badges.herokuapp.com/p/YLTCPBroadcaster/badge.svg)](http://cocoadocs.org/docsets/YLTCPBroadcaster/) [![Version](https://cocoapod-badges.herokuapp.com/v/YLMoment/badge.svg)]

YLTCPBroadcaster is a small library to help to scan/broadcast over the TCP protocol and written in Objective-C.

## Requirements

- iOS 5.0+
- Xcode 6.0

## Installation

The recommended approach to use _YLTCPBroadcaster_ in your project is using the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.

### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add YLTCPBroadcaster:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '5.0'
pod 'YLTCPBroadcaster', '~> 1.0.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

### Manually

[Download](https://github.com/YannickL/YLTCPBroadcaster/archive/master.zip) the project and copy the `YLTCPBroadcaster` folder into your project and then simply `#import "YLTCPBroadcaster.h"` in the file(s) you would like to use it in.

## Usage

Under development

## Contact

Yannick Loriot
 - [https://twitter.com/yannickloriot](https://twitter.com/yannickloriot)
 - [contact@yannickloriot.com](mailto:contact@yannickloriot.com)


## License (MIT)

Copyright (c) 2014-present - Yannick Loriot

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
