//
//  NoDataView.h
//  TableViewNoNataDemo
//
//  Created by tan on 2017/4/12.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataView : UIView

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, copy) void(^reloadClickBlock)(void);
@property (nonatomic, strong) UIImage *bgImageBtn;

@end
