//
//  ViewController.m
//  YMLMenuDemo
//
//  Created by Hubery_Yang on 17/1/1.
//  Copyright © 2017年 YmlHubery. All rights reserved.
//

#import "ViewController.h"
#import "YMLRotationViewController.h"


@interface ViewController ()<YMLRotationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"显示菜单" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showMenu:(UIButton *)sender{
    
    NSArray *carPicArr = @[@"空调",@"灯具",@"汽车用品",@"汽保工具",@"小车配件",@"大车配件",@"加装改装",@"其他"];
    
    YMLRotationViewController *rotationVC = [[YMLRotationViewController alloc] init];
    rotationVC.itemNames = carPicArr;
    rotationVC.delegate  = self;
    rotationVC.canRotate = YES;
    [self presentViewController:rotationVC animated:YES completion:nil];
}

#pragma mark -- YMLRotationViewControllerDelegate

- (void)menuDidSelectedAtItemIndex:(NSInteger)index{
    
    NSLog(@"选中第 %ld 项",index);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
