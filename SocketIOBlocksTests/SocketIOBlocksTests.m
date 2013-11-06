//
//  SocketIOBlocksTests.m
//  SocketIOBlocksTests
//
//  Created by Антон Домашнев on 06.11.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <socket.IO/SocketIOPacket.h>

#import "SocketIO+Blocks.h"

@interface SocketIOBlocksDelegate()<SocketIODelegate>

@property (nonatomic, copy) void (^onStart)(SocketIO *, NSError *);

@property (nonatomic, strong) NSMutableDictionary *onErrorBlocksDictionary;
@property (nonatomic, strong) NSMutableDictionary *onMessageBlocksDictionary;
@property (nonatomic, strong) NSMutableDictionary *onJSONBlocksDictionary;
@property (nonatomic, strong) NSMutableDictionary *onEventBlocksDictionary;

@end

SPEC_BEGIN(SocketIOBlocksSpec)

describe(@"SocketIO+Blocks", ^{
   
    __block SocketIO *socket = nil;
    
    beforeEach(^{
        socket = [[SocketIO alloc] initWithDelegate:nil];
    });
    
    context(@"when first callback assigned", ^{
       
        beforeEach(^{
           [socket addErrorHandler:^(SocketIO *socket, NSError *error) {
               //Do nothing
           } forKey:@""];
        });
        
        it(@"should initialize delegate ad a SocketIODelegate", ^{
            [[((SocketIOBlocksDelegate *)(socket.delegate)) shouldNot] beNil];
        });
        
        it(@"should has delegate SocketIODelegate class", ^{
            [[((SocketIOBlocksDelegate *)(socket.delegate)) should] beMemberOfClass:[SocketIOBlocksDelegate class]];
        });
    });
    
    it(@"when add error handler it should add it to the onErrorBlocksDictionary of delegate", ^{
       
        void(^block)(SocketIO *socketIO, NSError *error) = ^(SocketIO *socketIO, NSError *error){
            NSLog(@"on error block");
        };
        
        [socket addErrorHandler:block forKey:@"blockKey"];
        [[((SocketIOBlocksDelegate *)(socket.delegate)).onErrorBlocksDictionary[@"blockKey"] should] equal: block];
    });
    
    it(@"when remove error handler it should be removed from onErrorBlocksDictionary of delegate", ^{
        
        void(^block)(SocketIO *socketIO, NSError *error) = ^(SocketIO *socketIO, NSError *error){
            NSLog(@"on error block");
        };
        
        [socket addErrorHandler:block forKey:@"blockKey"];
        [socket removeErrorHandlerForKey:@"blockKey"];
        
        [[((SocketIOBlocksDelegate *)(socket.delegate)).onMessageBlocksDictionary[@"blockKey"] should] beNil];
    });
    
    it(@"when add message handler it should add it to the onMessageBlocksDictionary of delegate", ^{
        
        void(^block)(SocketIO *, SocketIOPacket *) = ^(SocketIO *socket, SocketIOPacket *packet){
            NSLog(@"on message block");
        };
        
        [socket addMessageHandler:block forKey:@"blockKey"];
        [[((SocketIOBlocksDelegate *)(socket.delegate)).onMessageBlocksDictionary[@"blockKey"] should] equal: block];
    });
    
    it(@"when remove message handler it should be removed from onMessageBlocksDictionary of delegate", ^{
        
        void(^block)(SocketIO *, SocketIOPacket *) = ^(SocketIO *socket, SocketIOPacket *packet){
            NSLog(@"on message block");
        };
        
        [socket addMessageHandler:block forKey:@"blockKey"];
        [socket removeMessageHandlerForKey:@"blockKey"];
        
        [[((SocketIOBlocksDelegate *)(socket.delegate)).onMessageBlocksDictionary[@"blockKey"] should] beNil];
    });
    
    it(@"when add JSON handler it should add it to the onJSONBlocksDictionary of delegate", ^{
        
        void(^block)(SocketIO *, SocketIOPacket *) = ^(SocketIO *socket, SocketIOPacket *packet){
            NSLog(@"on JSON block");
        };
        
        [socket addJSONHandler:block forKey:@"blockKey"];
        [[((SocketIOBlocksDelegate *)(socket.delegate)).onJSONBlocksDictionary[@"blockKey"] should] equal: block];
    });
    
    it(@"when remove JSON handler it should be removed from onJSONBlocksDictionary of delegate", ^{
        
        void(^block)(SocketIO *, SocketIOPacket *) = ^(SocketIO *socket, SocketIOPacket *packet){
            NSLog(@"on JSON block");
        };
        
        [socket addJSONHandler:block forKey:@"blockKey"];
        [socket removeJSONHandlerForKey:@"blockKey"];
        
        [[((SocketIOBlocksDelegate *)(socket.delegate)).onJSONBlocksDictionary[@"blockKey"] should] beNil];
    });
    
    it(@"when add event handler it should add it to the onEventBlocksDictionary of delegate", ^{
        
        void(^block)(SocketIO *, SocketIOPacket *) = ^(SocketIO *socket, SocketIOPacket *packet){
            NSLog(@"on event block");
        };
        
        [socket addEventHandler:block forKey:@"blockKey"];
        [[((SocketIOBlocksDelegate *)(socket.delegate)).onEventBlocksDictionary[@"blockKey"] should] equal: block];
    });
    
    it(@"when remove event handler it should be removed from onEventBlocksDictionary of delegate", ^{
        
        void(^block)(SocketIO *, SocketIOPacket *) = ^(SocketIO *socket, SocketIOPacket *packet){
            NSLog(@"on event block");
        };
        
        [socket addEventHandler:block forKey:@"blockKey"];
        [socket removeEventHandlerForKey:@"blockKey"];
        
        [[((SocketIOBlocksDelegate *)(socket.delegate)).onEventBlocksDictionary[@"blockKey"] should] beNil];
    });
});

describe(@"SocketIOBlocksDelegate", ^{
   
    __block SocketIOBlocksDelegate *delegate = nil;
    
    beforeEach(^{
        delegate = [SocketIOBlocksDelegate new];
    });
    
    context(@"when initialized", ^{
        
        it(@"shpuld has not nil onErrorBlocksDictionary", ^{
            [[delegate.onErrorBlocksDictionary shouldNot] beNil];
        });
        
        it(@"shpuld has not nil onMessageBlocksDictionary", ^{
            [[delegate.onErrorBlocksDictionary shouldNot] beNil];
        });
        
        it(@"shpuld has not nil onJSONBlocksDictionary", ^{
            [[delegate.onErrorBlocksDictionary shouldNot] beNil];
        });
        
        it(@"shpuld has not nil onEventBlocksDictionary", ^{
            [[delegate.onErrorBlocksDictionary shouldNot] beNil];
        });
    });
    
    context(@"when socket did connect", ^{
       
        __block SocketIO *socketMock = nil;
        __block SocketIO *blockSocket = nil;
        __block NSNumber *didStart = nil;
        __block NSError *blockError = nil;
        __block NSError *connectError = nil;
        
        beforeEach(^{
            
            didStart = @NO;
            socketMock = [KWMock mockForClass:[SocketIO class]];
            connectError = [KWMock mockForClass:[NSError class]];
            
            delegate.onStart = ^(SocketIO *socketIO, NSError *error){
                didStart = @YES;
                blockSocket = socketIO;
                blockError = error;
            };
        });
        
        context(@"without error", ^{
           
            beforeEach(^{
                [delegate socketIODidConnect: socketMock];
            });
            
            it(@"should call block", ^{
                [[didStart should] beTrue];
            });
            
            it(@"should send correct socketIO object into block", ^{
                [[blockSocket should] equal: socketMock];
            });
            
            it(@"should send nil error", ^{
                [[blockError should] beNil];
            });
        });
        
        context(@"with error", ^{
            
            beforeEach(^{
                [delegate socketIODidDisconnect:socketMock disconnectedWithError:connectError];
            });
            
            it(@"should call block", ^{
                [[didStart should] beTrue];
            });
            
            it(@"should send correct socketIO object into block", ^{
                [[blockSocket should] equal: socketMock];
            });
            
            it(@"should send correct error", ^{
                [[blockError should] equal: connectError];
            });
        });
    });
    
    context(@"when receive a message", ^{
       
        __block SocketIOPacket *packetMock = nil;
        __block SocketIOPacket *blockPacket = nil;
        __block SocketIO *socketMock = nil;
        __block SocketIO *blockSocket = nil;
        __block NSNumber *didCall = nil;
        __block NSNumber *didCall2 = nil;
        
        beforeEach(^{
            
            packetMock = [KWMock mockForClass:[SocketIOPacket class]];
            socketMock = [KWMock mockForClass:[SocketIO class]];
            
            didCall = @NO;
            didCall2 = @NO;
            
            delegate.onMessageBlocksDictionary[@"key1"] = ^(SocketIO *socketIO, SocketIOPacket *packet){
                blockSocket = socketIO;
                blockPacket = packet;
                didCall = @YES;
            };
            
            delegate.onMessageBlocksDictionary[@"key2"] = ^(SocketIO *socketIO, SocketIOPacket *packet){
                blockSocket = socketIO;
                didCall2 = @YES;
            };
            
            [delegate socketIO:socketMock didReceiveMessage:packetMock];
        });
        
        it(@"should call all blocks", ^{
            [[didCall should] beTrue];
            [[didCall2 should] beTrue];
        });
        
        it(@"should send correct socketIO object into block", ^{
            [[blockSocket should] equal: socketMock];
        });
        
        it(@"should send correct packet", ^{
            [[blockPacket should] equal: packetMock];
        });
    });

    context(@"when receive a JSON", ^{
        
        __block SocketIOPacket *packetMock = nil;
        __block SocketIOPacket *blockPacket = nil;
        __block SocketIO *socketMock = nil;
        __block SocketIO *blockSocket = nil;
        __block NSNumber *didCall = nil;
        __block NSNumber *didCall2 = nil;
        
        beforeEach(^{
            
            packetMock = [KWMock mockForClass:[SocketIOPacket class]];
            socketMock = [KWMock mockForClass:[SocketIO class]];
            
            didCall = @NO;
            didCall2 = @NO;
            
            delegate.onJSONBlocksDictionary[@"key1"] = ^(SocketIO *socketIO, SocketIOPacket *packet){
                blockSocket = socketIO;
                blockPacket = packet;
                didCall = @YES;
            };
            
            delegate.onJSONBlocksDictionary[@"key2"] = ^(SocketIO *socketIO, SocketIOPacket *packet){
                blockSocket = socketIO;
                didCall2 = @YES;
            };
            
            [delegate socketIO:socketMock didReceiveJSON: packetMock];
        });
        
        it(@"should call all blocks", ^{
            [[didCall should] beTrue];
            [[didCall2 should] beTrue];
        });
        
        it(@"should send correct socketIO object into block", ^{
            [[blockSocket should] equal: socketMock];
        });
        
        it(@"should send correct packet", ^{
            [[blockPacket should] equal: packetMock];
        });
    });

    context(@"when receive an event", ^{
        
        __block SocketIOPacket *packetMock = nil;
        __block SocketIOPacket *blockPacket = nil;
        __block SocketIO *socketMock = nil;
        __block SocketIO *blockSocket = nil;
        __block NSNumber *didCall = nil;
        __block NSNumber *didCall2 = nil;
        
        beforeEach(^{
            
            packetMock = [KWMock mockForClass:[SocketIOPacket class]];
            socketMock = [KWMock mockForClass:[SocketIO class]];
            
            didCall = @NO;
            didCall2 = @NO;
            
            delegate.onEventBlocksDictionary[@"key1"] = ^(SocketIO *socketIO, SocketIOPacket *packet){
                blockSocket = socketIO;
                blockPacket = packet;
                didCall = @YES;
            };
            
            delegate.onEventBlocksDictionary[@"key2"] = ^(SocketIO *socketIO, SocketIOPacket *packet){
                blockSocket = socketIO;
                didCall2 = @YES;
            };
            
            [delegate socketIO:socketMock didReceiveEvent:packetMock];
        });
        
        it(@"should call all blocks", ^{
            [[didCall should] beTrue];
            [[didCall2 should] beTrue];
        });
        
        it(@"should send correct socketIO object into block", ^{
            [[blockSocket should] equal: socketMock];
        });
        
        it(@"should send correct packet", ^{
            [[blockPacket should] equal: packetMock];
        });
    });

    context(@"when receive an error", ^{
        
        __block NSError *socketError = nil;
        __block NSError *blockError = nil;
        __block SocketIO *socketMock = nil;
        __block SocketIO *blockSocket = nil;
        __block NSNumber *didCall = nil;
        __block NSNumber *didCall2 = nil;
        
        beforeEach(^{
            
            socketError = [KWMock mockForClass:[NSError class]];
            socketMock = [KWMock mockForClass:[SocketIO class]];
            
            didCall = @NO;
            didCall2 = @NO;
            
            delegate.onErrorBlocksDictionary[@"key1"] = ^(SocketIO *socketIO, NSError *error){
                blockSocket = socketIO;
                blockError = error;
                didCall = @YES;
            };
            
            delegate.onErrorBlocksDictionary[@"key2"] = ^(SocketIO *socketIO, NSError *error){
                blockSocket = socketIO;
                didCall2 = @YES;
            };
            
            [delegate socketIO:socketMock onError: socketError];
        });
        
        it(@"should call all blocks", ^{
            [[didCall should] beTrue];
            [[didCall2 should] beTrue];
        });
        
        it(@"should send correct socketIO object into block", ^{
            [[blockSocket should] equal: socketMock];
        });
        
        it(@"should send correct error", ^{
            [[blockError should] equal: socketError];
        });
    });
});

SPEC_END