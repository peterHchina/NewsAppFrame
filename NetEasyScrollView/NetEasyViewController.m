//
//  ViewController.m
//  NetEasyScrollView
//
//  Created by vivo on 16/5/19.
//  Copyright © 2016年 vivo. All rights reserved.
//

#import "NetEasyViewController.h"
#import "ContentViewController.h"
#import "IFTTTFilmstrip.h"
#import "IFTTTEasingFunction.h"
#import "IFTTTInterpolatable.h"
#define pageNumber  10
#define singleButtonWidth 60
#define fontSize(a)  [UIFont systemFontOfSize:a]
@interface NetEasyViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *buttonsArray;
@end

@implementation NetEasyViewController{
    NSInteger currentPage;
    CGFloat lastXOffset;
    BOOL isSwipeToRight;
   IFTTTFilmstrip* filmstrip;
    BOOL isClickButton;
    
    NSInteger begainDragPage;
    NSInteger dragPageNumber;
    NSInteger endDeceleratingPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureTopView];
    [self configureBottomView];
    filmstrip = [IFTTTFilmstrip new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configureTopView{
    self.buttonsArray = [NSMutableArray new];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    if (pageNumber>7) {
         self.topScrollViewWidthConstraint.constant = (pageNumber-6.2)*singleButtonWidth;
    }
      for (int i = 0 ; i<pageNumber; i++) {
          UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
          [button setTitle:[NSString stringWithFormat:@"%d按钮",i] forState:UIControlStateNormal];
          if (i == 0) {
              [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
              [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
          }else{
              [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
              [button.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
          }
          button.tag = i;
          button.frame = CGRectMake(i*singleButtonWidth, 0, singleButtonWidth , 40);
          [button addTarget:self action:@selector(scrollToTargetView:) forControlEvents:UIControlEventTouchUpInside];
          [self.topContainerView addSubview:button];
          [self.buttonsArray addObject:button];
      }
}

-(void) configureBottomView{
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollViewWidthConstraint.constant = (pageNumber-1)*[UIScreen mainScreen].bounds.size.width;
    for (int i = 0 ; i<pageNumber; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0,self.bottomScrollView.bounds.size.width,self.bottomContainerView.bounds.size.height)];
        [self.bottomContainerView addSubview:view];

        ContentViewController *vc = [[ContentViewController alloc] init];
        vc.view.frame = view.bounds ;
        [view addSubview:vc.view];
        [self addChildViewController:vc];
     }
    lastXOffset = 0;
    begainDragPage = -1000;
}
- (CGFloat)pageWidth
{
    return CGRectGetWidth(self.bottomScrollView.frame);
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    isClickButton = NO;
    CGFloat currentOffset = scrollView.contentOffset.x;
    currentPage = floor(currentOffset / self.pageWidth);
    if(currentOffset> lastXOffset){
        isSwipeToRight = YES;
    }else{
        isSwipeToRight = NO;
    }
    lastXOffset = currentOffset;
    [self scrollTopViewTextColorAnimation:(currentOffset / self.pageWidth - currentPage)];
}

-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (begainDragPage ==-1000) {
        CGFloat currentOffset = scrollView.contentOffset.x;
        begainDragPage =floor(currentOffset / self.pageWidth);
    }
    
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat currentOffset = scrollView.contentOffset.x;
    currentPage = floor(currentOffset / self.pageWidth);
    dragPageNumber =currentPage - begainDragPage;
    [self AnimationToPosition];
}

-(void) scrollTopViewTextColorAnimation:(CGFloat) time{
    UIButton *begainButton;
    UIButton *targetbutton;
    if (isSwipeToRight && currentPage<pageNumber) {
        if (currentPage<pageNumber-1 && currentPage>=0) {
            begainButton = [_buttonsArray objectAtIndex:currentPage];
            targetbutton = [_buttonsArray objectAtIndex:currentPage+1];
            [begainButton setTitleColor:(UIColor *)[filmstrip reverseValueAtTime:time] forState:UIControlStateNormal];
            [targetbutton setTitleColor:(UIColor *)[filmstrip valueAtTime:time] forState:UIControlStateNormal];
            begainButton.titleLabel.font = fontSize(((NSNumber *)[filmstrip reverseSizeAtTime:time]).floatValue);
            targetbutton.titleLabel.font = fontSize(((NSNumber *)[filmstrip sizeAtTime:time]).floatValue);
        }else{
            return;
        }
    }else if(!isSwipeToRight && currentPage>=0 && currentPage!=pageNumber-1){
        time = 1-time;
        if (currentPage>=0) {
            begainButton = [_buttonsArray objectAtIndex:currentPage+1];
            targetbutton = [_buttonsArray objectAtIndex:currentPage];
            [begainButton setTitleColor:(UIColor *)[filmstrip reverseValueAtTime:time] forState:UIControlStateNormal];
            [targetbutton setTitleColor:(UIColor *)[filmstrip valueAtTime:time] forState:UIControlStateNormal];
            begainButton.titleLabel.font = fontSize(((NSNumber *)[filmstrip reverseSizeAtTime:time]).floatValue);
            targetbutton.titleLabel.font = fontSize(((NSNumber *)[filmstrip sizeAtTime:time]).floatValue);
        }else{
            return;
        }

    }
    
}


-(void) AnimationToPosition{
    CGFloat width = singleButtonWidth;
    begainDragPage = -1000;
    if (currentPage < 0 || pageNumber <=6 || currentPage > pageNumber-1) {
        return;
    }
    if ( currentPage>0) {
        if (isSwipeToRight) {
            if (pageNumber - currentPage > 3 && currentPage>2) {
                [self.topScrollView setContentOffset: CGPointMake(self.topScrollView.contentOffset.x+dragPageNumber*width, 0) animated:YES];
            }
        }else{
            if (pageNumber - currentPage > 3 && currentPage >2){
                [self.topScrollView setContentOffset: CGPointMake(self.topScrollView.contentOffset.x+dragPageNumber*width, 0) animated:YES];
            }
        }
    }
    dragPageNumber = 0;
}

-(void) scrollToTargetView:(UIButton *) sender{
    NSInteger tage = sender.tag;
//    isClickButton = YES;
    [self.bottomScrollView setContentOffset: CGPointMake(tage*self.pageWidth, 0) animated: NO];
    [self changeButtonState:tage];
}

-(void) changeButtonState:(NSInteger) tag{
    UIButton * beginButton = [_buttonsArray objectAtIndex:currentPage];
    UIButton *selectedButton = [_buttonsArray objectAtIndex:tag];
    [beginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [beginButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [selectedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selectedButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
}
@end