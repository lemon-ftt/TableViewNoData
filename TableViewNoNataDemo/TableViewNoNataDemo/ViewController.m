//
//  ViewController.m
//  TableViewNoNataDemo
//
//  Created by tan on 2017/4/12.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+NoData.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int random;
@property (strong, nonatomic) NSTimer *timer;

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // 外部修改展示的view
    [self.tableView setNoDataBlock:^(NoDataView *view) {
        [view.reloadButton setTitle:@"212121212121" forState:UIControlStateNormal];
    }];
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    //点击刷新
    [self.tableView setReloadBlock:^{
        [weakSelf refresh];
    }];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setData {
    _random = arc4random() % 3;//[0 2]的随机数
    for (int i = 0; i < _random; i ++ ) {
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [self.dataArray addObject:str];
    }
}

- (void)refresh {
    [self setData];
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _random;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)dealloc {
    
    [_timer invalidate];
    _timer = nil;
}

@end
