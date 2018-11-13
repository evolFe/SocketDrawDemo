//
//  DrawView.m
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import "DrawView.h"
#import "../UIButton+ELTool.h"
#import "../DrawSocketManager.h"

@interface DrawView () {
    CGMutablePathRef _currentPath;
}

@property (nonatomic, strong) CAShapeLayer * drawLayer;

@end

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}


- (void)_setup {
    _lineColor = [UIColor blackColor];
    _lineWidth = 2.0f;
    [self.layer addSublayer:self.drawLayer];
    
    __weak typeof(self) ws = self;
    [[DrawSocketManager share] addTarget:self block:^(NSUInteger type, id  _Nonnull value) {
        switch (type) {
            case MessageTypeStartPoint:
                [ws drawBegin:CGPointFromString(value)];
                break;
            case MessageTypeMovePoint:
                [ws drawMove:CGPointFromString(value)];
            default:
                break;
        }
    }];
}


- (void)clear {
    _currentPath = NULL;
    self.drawLayer.path = _currentPath;
}

- (void)drawBegin:(CGPoint)point {
    if (_currentPath == NULL) {
        _currentPath = CGPathCreateMutable();
    }
    CGPathMoveToPoint(_currentPath, NULL, point.x, point.y);
}

- (void)drawMove:(CGPoint)point {
    CGPathAddLineToPoint(_currentPath, NULL, point.x, point.y);
    self.drawLayer.path = _currentPath;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_currentPath == NULL) {
        _currentPath = CGPathCreateMutable();
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathMoveToPoint(_currentPath, NULL, point.x, point.y);
    SendStartPoint(point);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathAddLineToPoint(_currentPath, NULL, point.x, point.y);
    self.drawLayer.path = _currentPath;
    SendMovePoint(point);
}



#pragma mark -- getters --

- (CAShapeLayer *)drawLayer {
    if (_drawLayer == nil) {
        _drawLayer = [[CAShapeLayer alloc] init];
        _drawLayer.frame = self.bounds;
        _drawLayer.fillColor = [UIColor clearColor].CGColor;
        _drawLayer.strokeColor = _lineColor.CGColor;
        _drawLayer.lineWidth = _lineWidth;
    }
    return _drawLayer;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
