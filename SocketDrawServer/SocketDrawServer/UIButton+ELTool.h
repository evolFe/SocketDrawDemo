//
//  UIButton+ELTool.h
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ELTool)

+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                       fontSize:(CGFloat)fontSize
                         target:(id)target action:(SEL)aciton;

@end

NS_ASSUME_NONNULL_END
