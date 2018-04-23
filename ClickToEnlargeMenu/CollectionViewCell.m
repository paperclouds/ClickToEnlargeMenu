//
//  CollectionViewCell.m
//  ClickToEnlargeMenu
//
//  Created by paperclouds on 2018/4/20.
//  Copyright © 2018年 neisha. All rights reserved.
//

#import "CollectionViewCell.h"

//#define labelWidth

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:0.8];
        self.layer.cornerRadius = 5;
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

@end
