//
//  WYViscousBubble.m
//  WYViscousBubble
//
//  Created by wayne on 2018/8/4.
//  Copyright © 2018年 58. All rights reserved.
//

#import "WYViscousBubble.h"

/** 默认字体 */
#define DEFAULT_FONT [UIFont systemFontOfSize:10]
/** 默认背景颜色 */
#define DEFAULT_BACKCOLOR [UIColor redColor]
/** 默认文本颜色 */
#define DEFAULT_TEXTCOLOR [UIColor whiteColor]
/** 默认最大距离 */
#define DEFAULT_MAXDISTANCE 100
/** 默认的最大圆宽度 */
#define MAX_COUNT_WIDTH 28
/** 默认的最小圆宽度 */
#define MIN_COUNT_WIDTH 18
/** 默认的小红点大小 */
#define LITTLE_COUNT_HEIGHT 4
/** 文本距离上下边界的距离 */
#define TEXT_TOP_SPACE 3
/** 文本距离左右边界的距离 */
#define TEXT_RIGHT_SPACE 6
/** 底部小圆默认为顶部圆的倍数 */
#define LILLTE_CIRCLE_MULTIPLE 2/3

// 是否设置了宽高
static BOOL isSetUpWH = YES;
// 是否设置了字体
static BOOL isSetUpFont = NO;

@interface WYViscousBubble()
{
    CGPoint smallCircleCenter;
    CGRect smallCircleFrame;
}

/** 轨迹layer */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/** 底部小圆视图 */
@property (nonatomic, strong) UIView *smallCircleView;

/** 顶部圆视图 */
@property (nonatomic, strong) UIView *frontCircleView;

/** 文本 */
@property (nonatomic, strong) UILabel *textLabel;

/** 拖拽手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/** 点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/** gif */
@property (nonatomic, strong) UIImageView *gifImageView;

/** gif图片数组 */
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

@end

@implementation WYViscousBubble

#pragma mark - drop data

- (void)dealloc
{
    [self dropData];
    
    [self removeGifImageView];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

// 清空数据
- (void)dropData
{
    if (_shapeLayer) {
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
    }
    
    if (_smallCircleView) {
        [_smallCircleView removeFromSuperview];
        _smallCircleView = nil;
    }
    
    if (_frontCircleView) {
        [_frontCircleView removeFromSuperview];
        _frontCircleView = nil;
    }
    
    [self removeGestureRecognizer:self.tapGesture];
    
    [self removeGestureRecognizer:self.panGesture];
    
    [self.frontCircleView.layer removeAllAnimations];
}

// 删除gif
- (void)removeGifImageView
{
    [_gifImageView removeFromSuperview];
    _gifImageView = nil;
    
    [self removeFromSuperview];
}

#pragma mark - init

+ (WYViscousBubble *)showBubbleInView:(UIView *)parentView frame:(CGRect)frame
{
    WYViscousBubble *bubble = [[WYViscousBubble alloc] initWithFrame:frame];
    [parentView addSubview:bubble];
    
    return bubble;
}

// 重设父视图为window视图
+ (void)setUpParentViewToWindow:(WYViscousBubble *)bubble
{
    if (!bubble.superview) {
        NSLog(@"没有父视图");
        return;
    }
    if (bubble.superview == [UIApplication sharedApplication].keyWindow) {
        NSLog(@"已重置父视图");
        return;
    }
    
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:bubble.frame fromView:bubble.superview];
    bubble.frame = rect;
    [[UIApplication sharedApplication].keyWindow addSubview:bubble];
    [bubble resetLayoutFrame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDefaultParams];
        
        [self initDefaultView];
    }
    return self;
}

- (void)initDefaultParams
{
    if (self.frame.size.width == 0 || self.frame.size.height == 0) {
        isSetUpWH = NO;
    }
    
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.bgColor = DEFAULT_BACKCOLOR;
    self.textColor = DEFAULT_TEXTCOLOR;
    self.maxDistance = DEFAULT_MAXDISTANCE;
    
    self.canDrag = YES;
    self.canClick = YES;
    self.canSwing = YES;
    self.showRecoveryState = YES;
}

- (void)initDefaultView
{
    [self addSubview:self.smallCircleView];
    [self addSubview:self.frontCircleView];
    [self.frontCircleView addSubview:self.textLabel];
}

#pragma mark - custom method

// 重置布局
- (void)resetLayoutFrame
{
    if (_number > 99) {
        self.textLabel.text = @"99+";
        
        if (!isSetUpWH) {
            
            CGFloat width = MAX_COUNT_WIDTH;
            CGFloat height = MIN_COUNT_WIDTH;
            if (isSetUpFont) {
                CGSize size = [self sizeWithString:self.textLabel.text font:self.textLabel.font];
                width = size.width + TEXT_RIGHT_SPACE * 2;
                height = size.height + TEXT_TOP_SPACE * 2;
            }
            width = MAX(MAX_COUNT_WIDTH, width);
            height = MAX(MIN_COUNT_WIDTH, height);
            
            CGRect rect = self.frame;
            switch (_extendEdge) {
                case JRNumberLabelExtedEdgeLeft:
                    rect.origin.x = self.frame.origin.x - (width - self.frame.size.width);
                    break;
                case JRNumberLabelExtedEdgeCenter:
                    rect.origin.x = self.frame.origin.x - (width - self.frame.size.width) / 2;
                    break;
                case JRNumberLabelExtedEdgeRight:
                default:
                    rect.origin.x = self.frame.origin.x;
                    break;
            }
            rect.size.width = width;
            rect.size.height = height;
            self.frame = rect;
        }
    }
    else if (_number > 0){
        
        self.textLabel.text = [NSString stringWithFormat:@"%ld", (long)_number];
        
        if (!isSetUpWH) {
            
            CGFloat width = MIN_COUNT_WIDTH;
            CGFloat height = MIN_COUNT_WIDTH;
            if (isSetUpFont) {
                CGSize size = [self sizeWithString:self.textLabel.text font:self.textLabel.font];
                width = size.width + TEXT_RIGHT_SPACE * 2;
                height = size.height + TEXT_TOP_SPACE * 2;
            }
            
            width = MAX(width, height);
            width = MAX(MIN_COUNT_WIDTH, width);
            
            CGRect rect = self.frame;
            rect.size.width = width;
            rect.size.height = width;
            self.frame = rect;
        }
    }
    else {
        self.textLabel.text = nil;
        
        if (!isSetUpWH) {
            CGRect rect = self.frame;
            rect.size.width = LITTLE_COUNT_HEIGHT;
            rect.size.height = LITTLE_COUNT_HEIGHT;
            self.frame = rect;
        }
    }
    
    CGFloat circleHeight = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat circleWidth = circleHeight;
    
    if (!isSetUpWH) {
        circleWidth = self.bounds.size.width;
        circleHeight = self.bounds.size.height;
    }
    self.frontCircleView.frame = CGRectMake((self.bounds.size.width - circleWidth)/2, (self.bounds.size.height - circleHeight) / 2, circleWidth, circleHeight);
    self.frontCircleView.layer.cornerRadius = circleHeight / 2;
    self.frontCircleView.layer.masksToBounds = YES;
    
    self.textLabel.frame = self.frontCircleView.bounds;
    
    CGFloat smallWidth = circleHeight * LILLTE_CIRCLE_MULTIPLE;
    self.smallCircleView.bounds = CGRectMake(0, 0, smallWidth, smallWidth);
    self.smallCircleView.center = self.frontCircleView.center;
    self.smallCircleView.layer.cornerRadius = smallWidth / 2;
    self.smallCircleView.layer.masksToBounds = YES;
    
    smallCircleCenter = _smallCircleView.center;
    smallCircleFrame = _smallCircleView.frame;
    
    if (_canSwing) {
        [self swingBubbleAnimation];
    }
}

// 绘制贝塞尔曲线方法
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView smallCirCleView:(UIView *)smallCirCleView
{
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat bigX = bigCenter.x;
    CGFloat bigY = bigCenter.y;
    CGFloat bigRadius = bigCirCleView.bounds.size.height * 0.5;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat smallX = smallCenter.x;
    CGFloat smallY = smallCenter.y;
    CGFloat smallRadius = smallCirCleView.bounds.size.height * 0.5;
    
    CGFloat d = [self distanceWithPointA:smallCenter pointB:bigCenter];
    CGFloat sina = (bigX-smallX)/d;
    CGFloat cosa = (bigY-smallY)/d;
    
    CGPoint pointA = CGPointMake(smallX-smallRadius*cosa, smallY+smallRadius*sina);
    CGPoint pointB = CGPointMake(smallX+smallRadius*cosa, smallY-smallRadius*sina);
    CGPoint pointC = CGPointMake(bigX+bigRadius*cosa, bigY-bigRadius*sina);
    CGPoint pointD = CGPointMake(bigX-bigRadius*cosa, bigY+bigRadius*sina);
    
    CGPoint pointO = CGPointMake(pointA.x+d/2*sina, pointA.y+d/2*cosa);
    CGPoint pointP = CGPointMake(pointB.x+d/2*sina, pointB.y+d/2*cosa);
    
    // 绘制贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    [self.layer insertSublayer:self.shapeLayer below:self.smallCircleView.layer];
    
    return path;
}

#pragma mark - action method

// 拖拽手势
- (void)dragBubble:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    
    CGFloat centerX = pan.view.center.x + point.x;
    CGFloat centerY = pan.view.center.y + point.y;
    
    pan.view.center = CGPointMake(centerX, centerY);
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    
    CGFloat distance = [self distanceWithPointA:self.frontCircleView.center pointB:self.smallCircleView.center];
    
    if(distance < _maxDistance) {
        
        self.smallCircleView.hidden = self.showRecoveryState ? NO : YES;

        CGFloat r1 = smallCircleFrame.size.width > smallCircleFrame.size.height ? smallCircleFrame.size.width * 0.5 - distance / 10 : smallCircleFrame.size.height * 0.5 - distance / 20;
        _smallCircleView.bounds = CGRectMake(0, 0, r1 *2, r1*2);
        _smallCircleView.layer.cornerRadius = r1;
        _smallCircleView.center = smallCircleCenter;
        
        if(_smallCircleView.hidden == NO && distance > 0){
            self.shapeLayer.path = [self pathWithBigCirCleView:self.frontCircleView smallCirCleView:_smallCircleView].CGPath;
        }
    }
    else {
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
        self.smallCircleView.hidden = YES;
    }
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 拖拽开始的时候去掉摇摆动画，并且显示底部小圆
        self.smallCircleView.hidden = NO;
        [self.frontCircleView.layer removeAllAnimations];
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state ==UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        if(distance > _maxDistance){
            NSLog(@"拖动距离%f -> 爆炸回调", distance);
            
            // 拖拽结束回调
            if (_bubbleDragFinish) {
                _bubbleDragFinish();
            }
            
            [self explosionAnimation];
            [self dropData];
        }
        else {
            
            // 拖拽结束且没被销毁时，回弹并开启摇摆动画，且隐藏底部小圆
            self.smallCircleView.hidden = YES;
            [self springbackAnimation];
        }
    }
}

// 点击手势
- (void)clickBubble:(UITapGestureRecognizer *)tap
{
    // 点击气泡回调
    if (_bubbleClick) {
        _bubbleClick();
    }
    
    [self explosionAnimation];
    [self dropData];
}

#pragma mark - animation

//----类似GameCenter的气泡晃动动画------
- (void)swingBubbleAnimation
{
    [self.frontCircleView.layer removeAllAnimations];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.frontCircleView.frame, self.frontCircleView.bounds.size.width / 2, self.frontCircleView.bounds.size.width / 2);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.frontCircleView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    scaleX.removedOnCompletion = NO;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontCircleView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleY.removedOnCompletion = NO;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontCircleView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}


// 爆炸效果
- (void)explosionAnimation
{
    [self.gifImageView startAnimating];
    
    [self performSelector:@selector(removeGifImageView) withObject:nil afterDelay:self.gifImageView.animationDuration + 0.1];
}

// 回弹效果
- (void)springbackAnimation
{
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = nil;
    self.smallCircleView.frame = smallCircleFrame;
    self.smallCircleView.center = smallCircleCenter;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frontCircleView.center = self.smallCircleView.center;
    } completion:^(BOOL finished) {
        self.smallCircleView.hidden = NO;
        
        if (self.canSwing) {
            [self swingBubbleAnimation];
        }
    }];
}

#pragma mark - set

- (void)setNumber:(NSInteger)number
{
    if (_number ^ number) {
        _number = number;
        if (_number == 0) {
            self.hidden = YES;
        }
        else {
            self.hidden = NO;
        }
        [self resetLayoutFrame];
    }
}

- (void)setBgColor:(UIColor *)bgColor
{
    if (bgColor) {
        self.frontCircleView.backgroundColor = self.smallCircleView.backgroundColor = bgColor;
    }
}

- (void)setTextFont:(UIFont *)textFont
{
    if (textFont) {
        
        isSetUpFont = YES;
        
        self.textLabel.font = _textFont = textFont;
        
        [self resetLayoutFrame];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (textColor) {
        self.textLabel.textColor = _textColor = textColor;
    }
}

- (void)setCanDrag:(BOOL)canDrag
{
    if (canDrag) {
        [self.frontCircleView addGestureRecognizer:self.panGesture];
    }
    else {
        [self.frontCircleView removeGestureRecognizer:self.panGesture];
    }
}

- (void)setCanClick:(BOOL)canClick
{
    if (canClick) {
        [self.frontCircleView addGestureRecognizer:self.tapGesture];
    }
    else {
        [self.frontCircleView removeGestureRecognizer:self.tapGesture];
    }
}

- (void)setCanSwing:(BOOL)canSwing
{
    _canSwing = canSwing;
    
    if (_canSwing) {
        [self swingBubbleAnimation];
    }
    else {
        [self.frontCircleView.layer removeAllAnimations];
    }
}

#pragma mark - get

- (UIView *)smallCircleView {
    
    if(!_smallCircleView) {
        _smallCircleView = [[UIView alloc] init];
    }
    return _smallCircleView;
}

- (UIView *)frontCircleView
{
    if (!_frontCircleView) {
        _frontCircleView = [[UIView alloc] init];
    }
    return _frontCircleView;
}

- (CAShapeLayer *)shapeLayer {
    
    if(!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.frontCircleView.backgroundColor.CGColor;
        [self.layer insertSublayer:_shapeLayer below:self.smallCircleView.layer];
    }
    return _shapeLayer;
}
- (NSMutableArray<UIImage *> *)images
{
    if(!_images) {
        _images = [NSMutableArray arrayWithCapacity:0];
        for (int i = 1; i < 6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"WYExplosion_%d", i]];
            if (image) {
                [_images addObject:image];
            }
        }
    }
    return _images;
}

- (UIImageView *)gifImageView
{
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] init];
        _gifImageView.frame = CGRectMake(0, 0, 34, 34);
        _gifImageView.center = self.frontCircleView.center;
        _gifImageView.animationImages = self.images;
        [_gifImageView setAnimationDuration:0.5];
        [_gifImageView setAnimationRepeatCount:1];
        [self addSubview:_gifImageView];
    }
    return _gifImageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = DEFAULT_FONT;
    }
    return _textLabel;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragBubble:)];
    }
    return _panGesture;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBubble:)];
    }
    return _tapGesture;
}

#pragma mark - private method

// 计算2点之间的距离
- (CGFloat)distanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB
{
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    return sqrtf(x * x + y * y);
}

// 通过字体及文字获取size
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    CGSize result;
    
    // 判断系统版本
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        // 向上取整
        result.height = ceil(size.height);
        result.width = ceil(size.width);
        
        return result;
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        return [string sizeWithFont:font constrainedToSize:maxSize];
#pragma clang diagnostic pop
    }
}

@end

