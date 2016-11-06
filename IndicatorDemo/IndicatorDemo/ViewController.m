//
//  ViewController.m
//  IndicatorDemo
//
//  Created by 周潇 on 2016/11/6.
//  Copyright © 2016年 zx. All rights reserved.
//

#import "ViewController.h"
#import "IndicatorView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置table
    UITableView * table = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:table];
    
    table.dataSource = self;
    table.delegate = self;
    
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    // 设置指示器
    IndicatorView * idc = [[IndicatorView alloc] init];
    
    NSInteger N = 20;
    NSMutableArray * mArr = [NSMutableArray array];
    for (int i = 0; i < N; ++i) {
        [mArr addObject:[NSString stringWithFormat:@"%d",i + 1]];
    }
    
    [self.view addSubview:idc];
    
    idc.titles = [mArr copy]; // 设置指示器的文字
    idc.frame = CGRectMake(self.view.bounds.size.width - 50, 100, 0, 0);
    idc.tableView = table;
    
   
    
    
}



// 组头设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    lbl.text = [NSString stringWithFormat:@"section%ld",(long)(section+1)];
    lbl.backgroundColor = [UIColor lightGrayColor];
    return lbl;
}



// 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
