# WYViscousBubble
仿qq黏性提醒气泡，支持拖拽、点击

#使用说明：

# // 初始化，默认加载到parentView上
# WYViscousBubble *bubble = [WYViscousBubble showBubbleInView:parentView frame:CGRectMake(10, 100, 0, 0)];
# // 设置气泡提示数 0：不显示、负数显示小点、最大显示99+
# bubble.number = 111;
# // 字体大小
# bubble.textFont = [UIFont systemFontOfSize:10];
# // 背景颜色
# bubble.bgColor = [UIColor redColor];
# // 文本颜色
# bubble.textColor = [UIColor whiteColor];
# // 最大的拖拽距离
# bubble.maxDistance = 100;
# // 超出过最大距离后恢复时是否显示恢复状态，默认显示
# bubble.showRecoveryState = NO;
# // 能否拖拽，默认支持
# bubble.canDrag = NO;
# // 能否点击，默认支持
# bubble.canClick = NO;
# // 能否晃动动画，默认支持
# bubble.canSwing = NO;
# // 加载到window上
# [WYViscousBubble setUpParentViewToWindow:bubble];
# // 拖拽结束回调
# bubble.bubbleDragFinish = ^{
# };
# // 点击回调
# bubble.bubbleClick = ^{
# };
