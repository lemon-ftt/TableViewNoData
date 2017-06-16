//
//  NoDataView.m
//  TableViewNoNataDemo
//
//  Created by tan on 2017/4/12.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createUI];
}

- (void)createUI {
//    self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;// 关掉交互(避免没有数据也不使用占位图而引起的不可点击问题),如果需要使用占位图,必须打开交互
    [self addSubview:self.reloadButton];
}

- (UIButton*)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = CGPointMake(self.center.x, self.center.y-80);
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_reloadButton setTitle:@"" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        [_reloadButton addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 50;
        _reloadButton.frame = rect;
    }
    return _reloadButton;
}

- (void)reloadClick:(UIButton*)button {
    if (self.reloadClickBlock) {
        self.reloadClickBlock();
    }
}

- (void)setBgImageBtn:(UIImage *)bgImageBtn {
    self.reloadButton.bounds = CGRectMake(0, 0, bgImageBtn.size.width, bgImageBtn.size.height);
    [self.reloadButton setBackgroundImage:bgImageBtn forState:UIControlStateNormal];
    [self.reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(bgImageBtn.size.height+50, -50, 0, -50)];
    
}

@end
