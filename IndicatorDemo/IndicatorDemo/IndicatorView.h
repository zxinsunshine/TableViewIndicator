//
//  IndicatorView.h
//  IndicatorDemo
//
//  Created by 周潇 on 2016/11/6.
//  Copyright © 2016年 zx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorView : UIView

@property(nonatomic,strong)NSArray<NSString *> * titles;
@property(nonatomic,weak)UITableView * tableView;

@end
