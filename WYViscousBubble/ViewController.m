//
//  ViewController.m
//  WYViscousBubble
//
//  Created by wayne on 2018/8/4.
//  Copyright © 2018年 58. All rights reserved.
//

#import "ViewController.h"
#import "WYViscousBubble.h"

//  随机颜色
#define   RandomColor   [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define isIPhoneX \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 普通iPhone的navigationBar的高度
#define NormalNavigationBarHeight 64
// iPhoneX的navigationBar高度
#define XNavigationBarHeight 88

#define NavigationBarHeight  (isIPhoneX ? XNavigationBarHeight:NormalNavigationBarHeight)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, NavigationBarHeight, self.view.bounds.size.width - 20, 50);
    button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [button setTitle:@"showBubble" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showBubble) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    WYViscousBubble *bubble = [WYViscousBubble showBubbleInView:self.view frame:CGRectMake(self.view.center.x - 10, NavigationBarHeight + 100, 0, 0)];
    bubble.number = 111;
    bubble.bubbleDragFinish = ^{
        NSLog(@"执行了拖拽结束回调");
    };
    bubble.bubbleClick = ^{
        NSLog(@"执行了点击回调");
    };
}

- (void)showBubble
{
    int width = 10 + (arc4random() % 101);
    int height = 10 + (arc4random() % 101);
    int x = 10 + (arc4random() % ((int)self.view.frame.size.width - 20 - width));
    int y = NavigationBarHeight + 70 + (arc4random() % ((int)self.view.frame.size.height - NavigationBarHeight - 70 - height));
    NSLog(@"随机frame：(%d,%d),(%d,%d)", x, y, width, height);
    
    WYViscousBubble *bubble = [WYViscousBubble showBubbleInView:self.view frame:CGRectMake(x, y, width, height)];
    // 字体大小
    bubble.textFont = [UIFont systemFontOfSize:(10 + (arc4random() % 11))];
    // 提示数
    bubble.number = (arc4random() % 150);
    NSLog(@"随机数：%ld", (long)bubble.number);
    // 背景颜色
    bubble.bgColor = RandomColor;
    // 文本颜色
    UIColor *color = RandomColor;
    bubble.textColor = color == bubble.bgColor ? [UIColor whiteColor] : color;
    // 最大的拖拽距离
    bubble.maxDistance = 50 + (arc4random() % 100);
    // 扩大拖拽边缘范围
    bubble.enlargedMargin = 20;
    // 超出过最大距离后恢复时是否显示恢复状态
    bubble.showRecoveryState = YES;
    // 能否拖拽
    bubble.canDrag = YES;
    // 能否点击
    bubble.canClick = YES;
    // 能否晃动
    bubble.canSwing = YES;
    // 加载到window上
    [WYViscousBubble setUpParentViewToWindow:bubble];
    // 拖拽结束回调
    bubble.bubbleDragFinish = ^{
        NSLog(@"执行了拖拽结束回调");
    };
    // 点击回调
    bubble.bubbleClick = ^{
        NSLog(@"执行了点击回调");
    };
}


- (void)push
{
    [self.navigationController pushViewController:[UIViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
