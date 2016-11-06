//
//  IndicatorView.m
//  IndicatorDemo
//
//  Created by 周潇 on 2016/11/6.
//  Copyright © 2016年 zx. All rights reserved.
//

#import "IndicatorView.h"

// 文字大小
static const CGFloat fontSize = 12;

// 字体颜色
#define fontColor [UIColor lightGrayColor];

// 字体突出的颜色
#define highlightFontColor [UIColor blackColor];

// 每个元素的宽度
static const CGFloat itemWid = 16;

// 动画扩展的范围
static const CGFloat animateRadius = 40;

// 动画平移波峰
static const CGFloat animatePeak = 70;

// 动画放大速度参数
static const CGFloat animateScale = 1.5;

// 动画透明度最小值
static const CGFloat animateMinAlpha = 0.5;

@interface IndicatorView ()

// tableView的组数
@property(nonatomic,assign)NSInteger sectionN;


@end

@implementation IndicatorView


# pragma mark - 初始化
// 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}


# pragma mark - 手势动画
// 手势
- (void)pan:(UIPanGestureRecognizer *)ges{
    CGPoint pos = [ges locationInView:self];
    
    switch (ges.state) {
        case UIGestureRecognizerStateChanged:
            [self animateWithPosition:pos];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            [self quitAnimation];
            
            break;
            
        default:
            break;
    }
 
}



// 根据位置产生动画
- (void)animateWithPosition:(CGPoint)position{
    for (int i = 0 ; i < self.subviews.count; ++i) {
        UILabel * v = self.subviews[i];
        // v的位置信息
        CGRect frame = v.frame;
        // 当前view的偏移量
        CGFloat offsetY = frame.origin.y + frame.size.height / 2;
        
        CGFloat relativeY = ABS(position.y - offsetY);
        
        
        // 相对因子
        CGFloat relativeFactor = 0;
        
        if (relativeY < 2 * animateRadius) {
            relativeFactor = cos(relativeY/animateRadius * M_PI_4) * animateScale;
            // 改变横向偏移
            v.transform = CGAffineTransformMakeTranslation(- relativeFactor * animatePeak, 0);
            
            // 改变大小
            v.transform = CGAffineTransformScale(v.transform, 1 + relativeFactor * animateScale, 1 + relativeFactor * animateScale);
            
            
            // 判断手指是否处于当前title
            if(i * itemWid < position.y && (i + 1) * itemWid > position.y){
                
                // 1. 改变透明度 和 突出的颜色
                v.alpha = 1;
                v.textColor = highlightFontColor;
                
                
                // 2. 移动相应的tableView
                // 若i不超过tableView的组数
                if (i < _sectionN ) {
                    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:i];
                    [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                }
                
            }
            else{
                // 其他地方渐变
                v.alpha = (1 - relativeFactor) + animateMinAlpha;
                v.textColor = fontColor;
            }
            
            
        }
        else{
            v.transform = CGAffineTransformIdentity;
            v.alpha = 1;
        }

    }
}

// 取消动画
- (void)quitAnimation{
    for (int i = 0 ; i < self.subviews.count; ++i) {
        UILabel * v = self.subviews[i];
        v.transform = CGAffineTransformIdentity;
        v.alpha = 1;
        v.textColor = fontColor;
    }
}


#pragma mark - 设置内容
// 设置指示的内容
- (void)setTitles:(NSArray<NSString *> *)titles{
    
    _titles = titles;
    
    // 清空子视图
    if (self.subviews.count > 0) {
        
        [self.subviews performSelector:@selector(removeFromSuperview)];
    }
    
    // 更新frame
    CGRect frame = self.frame;
    frame.size = CGSizeMake(itemWid, titles.count * itemWid);
    self.frame = frame;
    
    // 添加新的子视图
    for (int i = 0; i < titles.count; ++i) {
        UILabel * lbl = [[UILabel alloc] init];
        lbl.text = titles[i];
        lbl.font = [UIFont systemFontOfSize:fontSize];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.frame = CGRectMake(0, i * itemWid, itemWid, itemWid);
        lbl.textColor = fontColor;
        [self addSubview:lbl];
    }
    
    
}

// 设置table时同时保存组数
- (void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    _sectionN = [tableView numberOfSections];
}




#pragma mark - 重写位置调整
// 设置frame时只改变大小，不改变坐标
- (void)setFrame:(CGRect)frame{
    
    frame.size = CGSizeMake(itemWid, self.subviews.count * itemWid);
    [super setFrame:frame];
    
}








@end
