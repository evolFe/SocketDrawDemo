//
//  ViewController.m
//  SocketDrawServer
//
//  Created by evol on 2018/11/13.
//  Copyright © 2018 evol. All rights reserved.
//

#import "ViewController.h"
#import "DrawSocketManager.h"
#import "draws/DrawView.h"

@interface ViewController ()

@property (nonatomic, strong) DrawView * drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[DrawSocketManager share] startServer];
    
    
    _drawView = [[DrawView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_drawView];
    
}


@end
