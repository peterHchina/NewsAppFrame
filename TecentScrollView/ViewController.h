//
//  ViewController.h
//  TecentScrollView
//
//  Created by vivo on 16/5/25.
//  Copyright © 2016年 vivo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *masterScrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topScrollViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *topcontainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *masterScrollViewConstraint;


@end

