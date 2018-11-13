//
//  NSMutableData+ELTool.m
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import "NSMutableData+ELTool.h"

@implementation NSMutableData (ELTool)

- (void)clear {
    [self resetBytesInRange:NSMakeRange(0, self.length)];
    [self setLength:0];
}

@end
