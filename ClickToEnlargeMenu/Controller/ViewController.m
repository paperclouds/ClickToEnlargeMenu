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
#import "SecondViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define WIDTH screenWidth/375
#define largeCellWidth 150*WIDTH
#define Height 200*WIDTH
#define lineSpace 5

#define CellIdentifier  @"CellIdentifier"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (strong , nonatomic) NSIndexPath * m_lastAccessed;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"ClickToEnlargeMenu";
    self.automaticallyAdjustsScrollViewInsets = NO;
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
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Height, screenWidth, Height) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self.collectionView addGestureRecognizer:panGesture];
    }
    return _collectionView;
}

-(void)panGesture:(UIPanGestureRecognizer*)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            float pointerX = [gestureRecognizer locationInView:self.collectionView].x;
            float pointerY = [gestureRecognizer locationInView:self.collectionView].y;
            for(CollectionViewCell* cell1 in self.collectionView.visibleCells) {
                float cellLeftTop = cell1.frame.origin.x;
                float cellRightTop = cellLeftTop + cell1.frame.size.width;
                float cellLeftBottom = cell1.frame.origin.y;
                float cellRightBottom = cellLeftBottom + cell1.frame.size.height;
                
                if (pointerX >= cellLeftTop && pointerX <= cellRightTop && pointerY >= cellLeftBottom && pointerY <= cellRightBottom) {
                    NSIndexPath* touchOver = [self.collectionView indexPathForCell:cell1];
                    if (self.m_lastAccessed != touchOver) {
                        if (cell1.selected) {
                            [self collectionView:self.collectionView didDeselectItemAtIndexPath:touchOver];
                        }
                        else
                        {
                            [self collectionView:self.collectionView didSelectItemAtIndexPath:touchOver];
                            
                        }
                    }
                    
                    self.m_lastAccessed = touchOver;
                    
                }
            }
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                self.m_lastAccessed = nil;
                self.collectionView.scrollEnabled = YES;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier     forIndexPath:indexPath];
    cell.tag = indexPath.row + 1000;
    NSString *color = self.dataArray[indexPath.item][@"color"];
    cell.backgroundColor = [UIColor colorWithHexString:color];
    cell.titleLbl.text = self.dataArray[indexPath.item][@"text"];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)indexPath.item]];
    if ([indexPath isEqual:_selectIndex]) {
        cell.titleLbl.transform = CGAffineTransformMakeRotation(0);
        cell.imageView.hidden = NO;
    }else{
        cell.titleLbl.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.imageView.hidden = YES;
    }
        cell.titleLbl.textAlignment = NSTextAlignmentCenter;
        cell.titleLbl.frame = cell.bounds;
        cell.imageView.frame = cell.bounds;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath isEqual:_selectIndex]) {
        return CGSizeMake(largeCellWidth, Height);
    }else{
        return CGSizeMake((screenWidth-largeCellWidth-lineSpace*(self.dataArray.count-1))/(self.dataArray.count-1), Height);
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return lineSpace;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if ([_selectIndex isEqual:indexPath]) {
        [self didSelectAtIndex:indexPath.item];
        self.m_lastAccessed = indexPath;
    }else{
        _selectIndex = indexPath;
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
             dispatch_async(dispatch_get_main_queue(), ^{
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
             });
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                cell.titleLbl.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
            }];
        }];
    }
}

- (void)didSelectAtIndex:(NSInteger)index{
    self.currentIndex = index;
    SecondViewController *second = [[SecondViewController alloc]init];
    second.index = index;
    self.navigationController.delegate = second;
    [self.navigationController pushViewController:second animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
