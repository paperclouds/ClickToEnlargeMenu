//
//  ADCardTransition.m
//  CardTransitionDemo
//
//  Created by hztuen on 2017/6/9.
//  Copyright © 2017年 cesar. All rights reserved.
//

#import "ADCardTransition.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "CollectionViewCell.h"

@interface ADCardTransition ()

/**
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) ADCardTransitionType type;

@end

@implementation ADCardTransition

+ (instancetype)transitionWithType:(ADCardTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(ADCardTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case ADCardTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
            
        case ADCardTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
    }
}

// 执行push过渡动画
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //起始页面
    ViewController *fromVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //目标页面
    SecondViewController *toVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //不知道为什么， cellForItemAtIndexPath，取不到cell，cell为null
    //    CardAnimationCell *cell = (CardAnimationCell *)[fromVC.cardScrollViewer.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathWithIndex:fromVC.currentIndex]];
    
    //拿到当前点击的cell的imageView
    CollectionViewCell *cell;
    NSArray *cellArray = [fromVC.collectionView visibleCells];
    for (int i = 0; i < cellArray.count; i++) {
        if (fromVC.currentIndex == [cellArray[i] tag] - 1000) {
            cell = (CollectionViewCell *)cellArray[i];
        }
    }
    
    UIView *containerView = [transitionContext containerView];
    //图片
    UIView *imageView = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    imageView.frame = [cell.imageView convertRect:cell.imageView.bounds toView: containerView];
    
    //titleView
//    UIView *titleView = [cell.titleView snapshotViewAfterScreenUpdates:NO];
//    titleView.frame = [cell.titleView convertRect:cell.titleView.bounds toView:containerView];
    
    //设置动画前的各个控件的状态
    cell.imageView.hidden = YES;
//    cell.titleView.hidden = YES;
    toVC.view.alpha = 0;
    toVC.topImageView.hidden = YES;
//    toVC.titleView.hidden = YES;
    toVC.tableView.hidden = YES;
    
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:toVC.view];
//    [containerView addSubview:titleView];
    [containerView addSubview:imageView];
    
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //图片frame
        imageView.frame = [toVC.topImageView convertRect:toVC.topImageView.bounds toView:containerView];
        
        //titleView frame
//        CGRect titleFrame = titleView.frame;
//        titleFrame.origin = [toVC.titleView convertPoint:toVC.titleView.bounds.origin toView:containerView];
//        titleView.frame = titleFrame;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        imageView.hidden = YES;
        toVC.topImageView.hidden = NO;
//        titleView.hidden = YES;
//        toVC.titleView.hidden = NO;
        toVC.tableView.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
    
}

//执行pop过渡动画
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    SecondViewController *fromVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //不知道为什么， cellForItemAtIndexPath，取不到cell，cell为null
    //    CardAnimationCell *cell = (CardAnimationCell *)[toVC.cardScrollViewer.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathWithIndex:toVC.currentIndex]];
    
    //取到cell
    CollectionViewCell *cell;
    NSArray *cellArray = [toVC.collectionView visibleCells];
    for (int i = 0; i < cellArray.count; i++) {
        if (toVC.currentIndex == [cellArray[i] tag] - 1000) {
            cell = (CollectionViewCell *)cellArray[i];
        }
    }
    
    UIView *containerView = [transitionContext containerView];
//    //这里的lastView就是push时候初始化的那个tempView
    UIView *imageView = containerView.subviews.lastObject;
//    //titleView
//    UIView *titleView = containerView.subviews[1];
    
    //设置初始状态
    cell.imageView.hidden = YES;
//    cell.titleView.hidden = YES;
    fromVC.topImageView.hidden = YES;
//    fromVC.titleView.hidden = YES;
    imageView.hidden = NO;
//    titleView.hidden = NO;
    [containerView insertSubview:toVC.view atIndex:0];
//
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageView.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
//        titleView.frame = [cell.titleView convertRect:cell.titleView.bounds toView:containerView];
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        cell.imageView.hidden = NO;
//        cell.titleView.hidden = NO;
        [imageView removeFromSuperview];
//        [titleView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
}

@end
