//
//  WYViscousBubble.h
//  WYViscousBubble
//
//  Created by wayne on 2018/8/4.
//  Copyright © 2018年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WYNumberLabelExtendEdge){
    JRNumberLabelExtedEdgeRight = 0,    // 向右延伸
    JRNumberLabelExtedEdgeCenter = 1,   // 向两边延伸
    JRNumberLabelExtedEdgeLeft = 2      // 向左延伸
};

@interface WYViscousBubble : UIView

/**
 *  展示黏性气泡
 */
+ (WYViscousBubble *)showBubbleInView:(UIView *)parentView frame:(CGRect)frame;

/**
 *  重设父视图为window视图，防止被其他视图遮挡
 */
+ (void)setUpParentViewToWindow:(WYViscousBubble *)bubble;

/** 0:不显示 (<0:显示小红点, >0:显示数字, 最大为99+) */
@property (nonatomic, assign) NSInteger number;

/** 气泡背景颜色，默认红色 */
@property (nonatomic, strong) UIColor *bgColor;

/** 文字颜色，默认白色 */
@property (nonatomic, strong) UIColor *textColor;

/** 数字字体，默认10 */
@property (nonatomic, strong) UIFont *textFont;

/** 当没有设置宽高时才会判断此项，当宽度不够时，延伸方向，默认向右 */
@property (nonatomic, assign) WYNumberLabelExtendEdge extendEdge;

/** 气泡是否支持拖拽，默认支持 */
@property (nonatomic, assign) BOOL canDrag;

/** 气泡是否支持点击，默认支持 */
@property (nonatomic, assign) BOOL canClick;

/** 气泡是否支持摇摆动画，默认支持 */
@property (nonatomic, assign) BOOL canSwing;

/** 恢复时是否显示恢复过程，默认显示 */
@property (nonatomic, assign) BOOL showRecoveryState;

/** 最大拖拽范围，默认为100 */
@property (nonatomic, assign) NSInteger maxDistance;

#pragma mark - callBack

/** 气泡点击 */
@property (nonatomic, copy) void(^bubbleClick)(void);

/** 气泡拖拽结束 */
@property (nonatomic, copy) void(^bubbleDragFinish)(void);


@end

