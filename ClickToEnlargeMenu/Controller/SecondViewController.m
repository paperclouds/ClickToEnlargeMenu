//
//  SecondViewController.m
//  ClickToEnlargeMenu
//
//  Created by paperclouds on 2018/4/23.
//  Copyright © 2018年 neisha. All rights reserved.
//

#import "SecondViewController.h"
#import "ADCardTransition.h"

#define CellID @"CellID"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define HeaderHeight 250

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UIImageView *bgImgView;    //背景图片

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)buildUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self buildTableHeadView];
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(20, 20, 50, 50);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)buildTableHeadView{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, HeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld",_index]]];
    self.topImageView.userInteractionEnabled = YES;
    self.topImageView.frame = CGRectMake(0, 0, screenWidth, HeaderHeight);
    [headerView addSubview:self.topImageView];
    self.bgImgView = self.topImageView;
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    return cell;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [ADCardTransition transitionWithType:operation == UINavigationControllerOperationPush ? ADCardTransitionTypePush : ADCardTransitionTypePop];
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        CGFloat totalOffsetY = HeaderHeight + ABS(offsetY);
        CGFloat f = totalOffsetY / HeaderHeight;
        
        self.bgImgView.frame = CGRectMake(- (screenWidth * f - screenWidth) / 2, offsetY, screenWidth * f, totalOffsetY);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
