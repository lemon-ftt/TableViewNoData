//
//  UITableView+NoData.h
//  TableViewNoNataDemo
//
//  Created by tan on 2017/4/12.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoDataView.h"

@interface UITableView (NoData)

@property (nonatomic, assign) BOOL firstReload;
@property (nonatomic, strong) NoDataView *placeholderView;
@property (nonatomic, copy) void(^reloadBlock)(void);
@property (nonatomic,copy) void(^noDataBlock)(NoDataView *placeholderView);

@end
