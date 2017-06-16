//
//  UITableView+NoData.m
//  TableViewNoNataDemo
//
//  Created by tan on 2017/4/12.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "UITableView+NoData.h"
#import "NSObject+Swizzling.h"
#import "NoDataView.h"

@implementation UITableView (NoData)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 方法交换，将reloadData实现交换为custom_reloadData
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData)
                               bySwizzledSelector:@selector(custom_reloadData)];
    });
}

- (void)custom_reloadData {
    if (!self.firstReload) {
        [self checkEmpty];
    }
    self.firstReload = NO;
    [self custom_reloadData];
}

- (void)checkEmpty {
    BOOL isEmpty = YES;//flag标示
    
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1;//获取当前TableView组数
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i];//获取当前TableView各组行数
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
        }
    }
    if (isEmpty) {//若为空，加载占位图
        //默认占位图
        if (!self.placeholderView) {
            [self makeDefaultPlaceholderView];
        }else {
            if (self.noDataBlock) {
                self.noDataBlock(self.placeholderView);
            }
            __weak typeof(self) weakSelf = self;
            [self.placeholderView setReloadClickBlock:^{
                if (weakSelf.reloadBlock) {
                    weakSelf.reloadBlock();
                }
            }];
        }
        self.placeholderView.hidden = NO;
        [self addSubview:self.placeholderView];
    } else {//不为空，移除占位图
        self.placeholderView.hidden = YES;
    }
}

- (void)makeDefaultPlaceholderView {
    self.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    NoDataView *noDataView = [[NoDataView alloc]init];
    if (self.tableHeaderView) {
        noDataView.frame = CGRectMake(0,CGRectGetHeight(self.tableHeaderView.frame), self.frame.size.width,  self.frame.size.height - CGRectGetHeight(self.tableHeaderView.frame));
    }else {
        noDataView.frame = self.bounds;
    }
    
    if (self.noDataBlock) {
        self.noDataBlock(noDataView);
    }
    __weak typeof(self) weakSelf = self;
    [noDataView setReloadClickBlock:^{
        if (weakSelf.reloadBlock) {
            weakSelf.reloadBlock();
        }
    }];
    self.placeholderView = noDataView;
}

- (void (^)(NoDataView *))noDataBlock {
    return objc_getAssociatedObject(self, @selector(noDataBlock));
}

- (void)setNoDataBlock:(void (^)(NoDataView *))noDataBlock {
    objc_setAssociatedObject(self, @selector(noDataBlock), noDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NoDataView *)placeholderView {
    return objc_getAssociatedObject(self, @selector(placeholderView));
}

- (void)setPlaceholderView:(NoDataView *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)firstReload {
    return [objc_getAssociatedObject(self, @selector(firstReload)) boolValue];
}

- (void)setFirstReload:(BOOL)firstReload {
    objc_setAssociatedObject(self, @selector(firstReload), @(firstReload), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(void))reloadBlock {
    return objc_getAssociatedObject(self, @selector(reloadBlock));
}

- (void)setReloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, @selector(reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
