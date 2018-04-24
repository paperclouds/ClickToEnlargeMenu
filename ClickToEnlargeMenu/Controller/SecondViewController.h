//
//  SecondViewController.h
//  ClickToEnlargeMenu
//
//  Created by paperclouds on 2018/4/23.
//  Copyright © 2018年 neisha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger index;//点击第几张
@property (nonatomic, strong) UIImageView *topImageView;//顶部图片
@property (nonatomic, strong) UITableView *tableView;

@end
