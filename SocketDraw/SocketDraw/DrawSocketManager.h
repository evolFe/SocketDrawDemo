//
//  DrawSocketManager.h
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeTypeNone,
    MessageTypeMovePoint,  // on Touch moved
    MessageTypeStartPoint, // onTouchBegan
    MessageTypeClear,
};

NS_ASSUME_NONNULL_BEGIN

@interface DrawSocketManager : NSObject

+ (instancetype)share;

- (void)connectServer;

- (void)addTarget:(id)target block:(void(^)(NSUInteger type, id value))block;

- (void)sendStartPoint:(CGPoint)point;

- (void)sendMovePoint:(CGPoint)point;

- (void)sendClearDraw; // 清空画布

@end

NS_ASSUME_NONNULL_END

NSData * ELDataFromString(NSString * string);
void SendStartPoint(CGPoint point);
void SendMovePoint(CGPoint point);
void SendClearDraw(void);

