//
//  DrawSocketManager.h
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeTypeNone,
    MessageTypeMovePoint,  // on Touch moved
    MessageTypeStartPoint, // onTouchBegan
    MessageTypeClear,
};

NS_ASSUME_NONNULL_BEGIN

@interface DrawSocketManager : NSObject

+ (instancetype)share;

- (void)startServer;

- (void)addTarget:(id)target block:(void(^)(NSUInteger, id value))block;

@end

NS_ASSUME_NONNULL_END

NSString * ELStringFromData(NSData * data);
