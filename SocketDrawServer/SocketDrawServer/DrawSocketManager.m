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
        _tool.port = 6969;
        _tool.delegate = self;
    }
    return self;
}

- (void)startServer {
    [_tool startServer];
}

- (void)addTarget:(id)target block:(void (^)(NSUInteger, id _Nonnull))block {
    _ManagerTarget * man = [[_ManagerTarget alloc] initWithTarget:target block:block];
    [self.targets addObject:man];
}

#pragma mark -- ELSocketDelegate --

- (void)socketDidReceiveData:(NSData *)data type:(NSUInteger)type {
    id value;
    switch (type) {
        case MessageTypeStartPoint:
        {
            value = ELStringFromData(data);
        }
            break;
        case MessageTypeMovePoint:
        {
            value = ELStringFromData(data);
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


NSString * ELStringFromData(NSData * data){
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
