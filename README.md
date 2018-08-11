# WYViscousBubble
仿qq黏性提醒气泡，支持拖拽、点击

# 效果演示
[点击查看演示效果](https://github.com/shanpengtao/WYViscousBubble/blob/master/%E6%95%88%E6%9E%9C%E6%BC%94%E7%A4%BA.mp4)

![点击查看演示效果](https://github.com/shanpengtao/WYViscousBubble/blob/master/%E6%95%88%E6%9E%9C%E6%BC%94%E7%A4%BA.gif)

# 接入说明：
导入WYViscousBubble.(h,m)及Resource文件夹

# 参数说明：
### // 初始化，默认加载到parentView上，有默认的宽高可根据字体变化而变化
WYViscousBubble *bubble = [WYViscousBubble showBubbleInView:parentView frame:CGRectMake(10, 100, 0, 0)];
### // 设置气泡提示数 0：不显示、负数显示小点、最大显示99+ 
bubble.number = 111;
### // 字体大小
bubble.textFont = [UIFont systemFontOfSize:10];
### // 背景颜色
bubble.bgColor = [UIColor redColor];
### // 文本颜色
bubble.textColor = [UIColor whiteColor];
### // 最大的拖拽距离
bubble.maxDistance = 100;
### // 扩大拖拽边缘范围
bubble.enlargedMargin = 20;
### // 超出过最大距离后恢复时是否显示恢复状态，默认显示
bubble.showRecoveryState = YES;
### // 能否拖拽，默认支持
bubble.canDrag = YES;
### // 能否点击，默认支持
bubble.canClick = YES;
### // 能否晃动动画，默认支持
bubble.canSwing = YES;
### // 加载到window上
[WYViscousBubble setUpParentViewToWindow:bubble];
### // 拖拽结束回调
bubble.bubbleDragFinish = ^{
};
### // 点击回调
bubble.bubbleClick = ^{
};
