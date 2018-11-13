//
//  DrawViewController.m
//  SocketDraw
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import "DrawViewController.h"
#import "draws/DrawView.h"
#import "UIButton+ELTool.h"

@interface DrawViewController ()

@property (nonatomic, strong) DrawView * drawView;

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _drawView = [[DrawView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_drawView];
    
    [self _setupButtons];
}

- (void)_setupButtons {
    UIButton * backButton = [UIButton buttonWithTitle:@"Back" titleColor:[UIColor blueColor] fontSize:18 target:self action:@selector(onBack)];
    [self.view addSubview:backButton];
    CGRect frame = backButton.frame;
    frame.origin.x = 14.;
    frame.origin.y = 40;
    backButton.frame = frame;
    
    UIButton * clearButton = [UIButton buttonWithTitle:@"Clear" titleColor:[UIColor blueColor] fontSize:18 target:self action:@selector(onClear)];
    [self.view addSubview:clearButton];
    frame = clearButton.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame) - 14 - CGRectGetWidth(frame);
    frame.origin.y = 40;
    clearButton.frame = frame;
    
}

- (void)onBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClear {
    [self.drawView clear];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
