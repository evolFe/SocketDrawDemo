//
//  UIButton+ELTool.m
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import "UIButton+ELTool.h"

@implementation UIButton (ELTool)

+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                       fontSize:(CGFloat)fontSize
                         target:(id)target action:(SEL)aciton
{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button addTarget:target action:aciton forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}


@end
