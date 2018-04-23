//
//  ViewController.m
//  ClickToEnlargeMenu
//
//  Created by paperclouds on 2018/4/20.
//  Copyright © 2018年 neisha. All rights reserved.
//

#import "ViewController.h"
#import "LineLayout.h"
#import "CollectionViewCell.h"
#import "UIColor+Extend.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define largeCellWidth 150
#define height 200
#define lineSpace 5

#define CellIdentifier  @"CellIdentifier"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSIndexPath *selectIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _selectIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.view addSubview:self.collectionView];
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"DataPlist" ofType:@"plist"];
        _dataArray = [NSArray arrayWithContentsOfFile:plistPath];
    }
    return _dataArray;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        LineLayout *layout = [[LineLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, screenWidth, height) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier     forIndexPath:indexPath];
    NSString *color = self.dataArray[indexPath.item][@"color"];
    cell.backgroundColor = [UIColor colorWithHexString:color];
    cell.titleLbl.text = self.dataArray[indexPath.item][@"text"];
    if ([indexPath isEqual:_selectIndex]) {
        cell.titleLbl.transform = CGAffineTransformMakeRotation(0);
    }else{
        cell.titleLbl.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
        cell.titleLbl.textAlignment = NSTextAlignmentCenter;
        cell.titleLbl.frame = cell.bounds;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath isEqual:_selectIndex]) {
        return CGSizeMake(largeCellWidth, height);
    }else{
        return CGSizeMake((screenWidth-largeCellWidth-lineSpace*(self.dataArray.count-1))/(self.dataArray.count-1), height);
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return lineSpace;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (![_selectIndex isEqual:indexPath]) {
        _selectIndex = indexPath;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                cell.titleLbl.transform = CGAffineTransformMakeRotation(0);
                } completion:^(BOOL finished) {
                }];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
