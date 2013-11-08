README
======

Category on [socket.IO-objc](https://github.com/pkyeck/socket.IO-objc?source=c)  to use block callbacks instead of delegate callbacks.

Adding SocketIO+Blocks to your project
====================================

From CocoaPods
------------

Add `pod 'SocketIOBlocks'` to your Podfile.

Source files
------------

Another way to add the SocketIO+Blocks to your project is to directly add the source files and resources to your project.

1. Download the [latest code version](https://github.com/Antondomashnev/socket.IO-Blocks/downloads) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, than drag and drop SocketIO+Blocks.h and SocketIO+Blocks.m files onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include SocketIO+Blocks wherever you need it with `#import "SocketIO+Blocks.h"`.

Usage
=====

To connect to your host simply write
```objective-c
SocketIO *socketIO = [[SocketIO alloc] initWithDelegate:nil];
[socketIO connectToHost:@"localhost" onPort:3000 withCallback:^(SocketIO *socketIO, NSError *error){
    NSLog(@"Socket %@ did connect with error %@", socket, error);
}];
```
If you need additional parameters you could use another methods
```objective-c
- (void)connectToHost:(NSString *)host onPort:(NSInteger)port withParams:(NSDictionary *)params withCallback:(void (^)(SocketIO *, NSError *))callback;
- (void)connectToHost:(NSString *)host onPort:(NSInteger)port withParams:(NSDictionary *)params withNamespace:(NSString *)endpoint withCallback:(void (^)(SocketIO *, NSError *))callback;
```
A delegate methods which response on error has been replaced by two methods. Key uses for support multiple error handlers
```objective-c
- (void)addErrorHandler:(void (^)(SocketIO *, NSError *))handler forKey:(NSString *)key;
- (void)removeErrorHandlerForKey:(NSString *)key
```
To handle received messages you can add handler for specific key too
```objective-c
- (void)addMessageHandler:(void (^)(SocketIO *, SocketIOPacket *))handler forKey:(NSString *)key;
```
If you no longer need message handler you can simply remove it from socket
```objective-c
- (void)removeMessageHandlerForKey:(NSString *)key;
```
The same logic applies for handle events and JSON objects.

## License

(The MIT License)

Copyright (c) 2013 Anton Domashnev. All rights reserved.

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
