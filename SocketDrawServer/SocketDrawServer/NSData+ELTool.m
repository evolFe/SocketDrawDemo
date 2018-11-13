//
//  NSData+ELTool.m
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import "NSData+ELTool.h"
#import "GCDAsyncSocket.h"

@implementation NSData (ELTool)

- (NSMutableData *)dataWithType:(NSUInteger)type {
    NSMutableData * newData = [NSMutableData data];
    [newData appendData:self.lengthData];
    [newData appendData:[self dataWithCotentType:type]];
    [newData appendData:self];
    [newData appendData:[GCDAsyncSocket CRLFData]];
    return newData;
}

- (NSData *)lengthData {
    NSUInteger totalLength = 2 + 4 + 4 + self.length;
    NSData * data = [NSData dataWithBytes:&totalLength length:4];
    return data;
}

- (NSData *)dataWithCotentType:(NSUInteger)type {
    NSData * data = [NSData dataWithBytes:&type length:4];
    return data;
}

@end
