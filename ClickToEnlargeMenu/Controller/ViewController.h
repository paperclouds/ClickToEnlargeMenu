//
//  ViewController.h
//  ClickToEnlargeMenu
//
//  Created by paperclouds on 2018/4/20.
//  Copyright © 2018年 neisha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/**
 *  记录当前点击的indexPath
 */
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

