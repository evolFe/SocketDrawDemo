//
//  ELSocketTool.h
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

typedef NS_ENUM(NSUInteger, SocketType) {
    SocketTypeClient,
    SocketTypeServer,
};

@protocol ELSocketDelegate <NSObject>

@optional
- (void)socketDidReceiveData:(NSData *)data type:(NSUInteger)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ELSocketTool : NSObject

@property (nonatomic, weak) id<ELSocketDelegate> delegate;

@property (nonatomic, strong) NSString * host;

@property (nonatomic, assign) uint16_t port;

@property (nonatomic, assign) SocketType scoketType; // 默认客户端

- (void)startServer; // 启动服务器 （服务端）  执行此方法的时候 自动变为服务端

- (void)connect2Server; // 连接服务器 （客户端）

- (void)disConnect; //断开连接

- (void)sendMessageData:(NSData *)data type:(NSUInteger)type;

@end

NS_ASSUME_NONNULL_END
