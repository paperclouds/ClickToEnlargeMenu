//
//  CollectionViewCell.m
//  ClickToEnlargeMenu
//
//  Created by paperclouds on 2018/4/20.
//  Copyright © 2018年 neisha. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLbl];
    }
    return self;
}

-(UILabel *)titleLbl{
    if (_titleLbl == nil) {
        self.titleLbl = [[UILabel alloc]init];
        self.titleLbl.numberOfLines = 0;
        self.titleLbl.lineBreakMode = NSLineBreakByCharWrapping;
        self.titleLbl.textColor = [UIColor whiteColor];
        self.titleLbl.transform =CGAffineTransformMakeRotation(M_PI_2);
        self.titleLbl.frame = self.bounds;
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.frame = self.bounds;
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.hidden = YES;
    }
    return _imageView;
}

@end
