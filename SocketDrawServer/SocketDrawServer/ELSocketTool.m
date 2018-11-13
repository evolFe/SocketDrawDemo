//
//  ELSocketTool.m
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import "ELSocketTool.h"
#import "NSData+ELTool.h"
#import "NSMutableData+ELTool.h"

@interface ELSocketTool ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket * socket;

@property (nonatomic, strong) NSMutableArray * clients;


// 共享
@property (nonatomic, strong) NSMutableData * datas; // 读取数据
@property (nonatomic, assign) NSUInteger dataType;
@property (nonatomic, assign) NSUInteger dataLength;

@end

@implementation ELSocketTool

- (void)startServer {
    NSAssert(_port > 0, @"没有设置 port!");
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    NSError *error = nil;
    [_socket acceptOnPort:self.port error:&error];
    if (!error) {
        NSLog(@"服务开启成功");
    }else{
        NSLog(@"服务开启失败");
    }
    _scoketType = SocketTypeServer;
}

- (void)connect2Server {
    NSAssert(_port > 0 && _host.length > 0, @"没有设置 host 或 port!");
    if (_socket == nil) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                             delegateQueue:dispatch_get_main_queue()];
    }
    
    NSError *error = nil;
    [_socket connectToHost:self.host onPort:self.port error:&error];
    if (error) {
        NSLog(@"connect error : %@", error);
    }
}

- (void)disConnect {
    if (_socket) {
        [_socket disconnect];
    }
}

- (void)sendMessageData:(NSData *)data type:(NSUInteger)type {
    [_socket writeData:[data dataWithType:type] withTimeout:-1 tag:0];
}

#pragma mark -- GCDAsyncSocketDelegate

//连接成功回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接成功");
    [sock readDataWithTimeout:-1 tag:0];
}

//断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"断开连接%@",err.localizedDescription);
}


//server端 接受到新连接
-(void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{
    NSLog(@"当前客户端的IP:%@ 端口号%d",clientSocket.connectedHost,clientSocket.connectedPort);
    
    [self.clients addObject:clientSocket]; // 保存一下 不然链接会断
    [clientSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

//接受data
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    if (self.datas.length == 0) { // 新的data
        NSUInteger totalLength = 0; // 长度
        NSData * lengthData = [data subdataWithRange:NSMakeRange(0, 4)];
        [lengthData getBytes:&totalLength length:4];
        self.dataLength = totalLength;
        NSUInteger type = 0; // 类型
        NSData * typeData = [data subdataWithRange:NSMakeRange(4, 4)];
        [typeData getBytes:&type length:4];
        self.dataType = type;
    }
    
    [self.datas appendData:data];
    if (self.datas.length == self.dataLength) { // 当前这条数据读取完毕
        // 清空 datas
        NSData * result = [self.datas subdataWithRange:NSMakeRange(8, self.dataLength - 8)];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(socketDidReceiveData:type:)]) {
                [self.delegate socketDidReceiveData:result type:self.dataType];
            }
        });
        [self.datas clear];
    }
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

#pragma mark -- getters --

- (NSMutableArray *)clients {
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}

- (NSMutableData *)datas {
    if (_datas == nil) {
        _datas = [NSMutableData data];
    }
    return _datas;
}

@end

