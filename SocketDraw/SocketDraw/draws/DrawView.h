//
//  DrawView.h
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawView : UIView

@property (nonatomic, strong) UIColor * lineColor;

@property (nonatomic, assign) CGFloat lineWidth;


- (void)clear;

@end

NS_ASSUME_NONNULL_END
