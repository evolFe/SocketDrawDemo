//
//  DrawSocketManager.m
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import "DrawSocketManager.h"
#import "ELSocketTool.h"
#import <UIKit/UIKit.h>

@interface _ManagerTarget : NSObject

@property (nonatomic, weak) id target;

@property (nonatomic, copy) void(^block)(NSUInteger, id);

- (instancetype)initWithTarget:(id)target block:(void(^)(NSUInteger, id))block;

@end

@implementation _ManagerTarget

- (instancetype)initWithTarget:(id)target block:(void (^)(NSUInteger, id))block {
    if (self = [super init]) {
        self.target = target;
        self.block = block;
    }
    return self;
}

@end

@interface DrawSocketManager ()<ELSocketDelegate>

@property (nonatomic, strong) ELSocketTool * tool;

@property (nonatomic, strong) NSMutableArray * targets;

@end

@implementation DrawSocketManager

+ (instancetype)share {
    static DrawSocketManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DrawSocketManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tool = [[ELSocketTool alloc] init];
        _tool.host = @"192.168.1.51";
        _tool.port = 6969;
        _tool.delegate = self;
    }
    return self;
}

- (void)connectServer {
    [_tool connect2Server];
}


- (void)addTarget:(id)target block:(void (^)(NSUInteger, id _Nonnull))block {
    _ManagerTarget * man = [[_ManagerTarget alloc] initWithTarget:target block:block];
    [self.targets addObject:man];
}

- (void)sendStartPoint:(CGPoint)point {
    [_tool sendMessageData:ELDataFromString(NSStringFromCGPoint(point)) type:MessageTypeStartPoint];
}

- (void)sendMovePoint:(CGPoint)point {
    [_tool sendMessageData:ELDataFromString(NSStringFromCGPoint(point)) type:MessageTypeMovePoint];
}

- (void)sendClearDraw {
    [_tool sendMessageData:ELDataFromString(@"clear") type:MessageTypeClear];
}

#pragma mark -- ELSocketDelegate --

- (void)socketDidReceiveData:(NSData *)data type:(NSUInteger)type {
    id value;
    switch (type) {
        case MessageTypeStartPoint:
        {
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
            break;
        case MessageTypeMovePoint:
        {
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
            break;
        default:
            break;
    }
    
    [self.targets enumerateObjectsUsingBlock:^(_ManagerTarget * _Nonnull target, NSUInteger idx, BOOL * _Nonnull stop) {
        if (target.target == nil) {
            [self.targets removeObject:target];
        }else {
            target.block(type, value);
        }
    }];
}


- (NSMutableArray *)targets {
    if (_targets == nil) {
        _targets = [NSMutableArray array];
    }
    return _targets;
}


@end

NSData * ELDataFromString(NSString * string) {
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}


void SendStartPoint(CGPoint point){
    [[DrawSocketManager share] sendStartPoint:point];
}
void SendMovePoint(CGPoint point){
    [[DrawSocketManager share] sendMovePoint:point];
}
void SendClearDraw(void){
    [[DrawSocketManager share] sendClearDraw];
}

