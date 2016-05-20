//
//  ViewController.h
//  NetEasyScrollView
//
//  Created by vivo on 16/5/19.
//  Copyright © 2016年 vivo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetEasyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topScrollViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomScrollViewWidthConstraint;
@end

