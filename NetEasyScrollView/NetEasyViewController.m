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
#import "TitleModel.h"
#define pageNumber  10
#define singleButtonWidth 60
#define fontSize(a)  [UIFont systemFontOfSize:a]

@interface NetEasyViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *buttonsArray;
@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,assign) CGFloat totalWidth;
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
     NSInteger lastPageNumber;
    NSMutableDictionary *offestDictory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray* titleArray = @[@"娱乐",@"民生",@"本地",@"手机",@"互联网",@"政治",@"纪录片",@"东方今报",@"江南都市报"];
    _totalWidth = 0;
    lastPageNumber = 0;
    _titles = [NSMutableArray new];
     filmstrip = [IFTTTFilmstrip new];
    for (NSString *title in titleArray) {
        TitleModel * Model = [TitleModel new];
        Model.title = title;
        [_titles addObject:Model];
        _totalWidth+=Model.width;
    }

    [self configureTopView];
    [self configureBottomView];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configureTopView{
    self.buttonsArray = [NSMutableArray new];
    offestDictory = [NSMutableDictionary new];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    if (_totalWidth>self.topScrollView.bounds.size.width) {
        self.topScrollViewWidthConstraint.constant = (_totalWidth-self.topScrollView.bounds.size.width);
    }
    _totalWidth = 0;
      for (int i = 0 ; i<_titles.count; i++) {
          UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
          TitleModel *model = _titles[i];
          [button setTitle:model.title forState:UIControlStateNormal];
          if (i == 0) {
              [button setTitleColor:RGB(211,0,0) forState:UIControlStateNormal];
              [button.titleLabel setFont:[UIFont systemFontOfSize:15.f weight:UIFontWeightThin]];
              CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.2, 1.2);
              button.transform =scaleTransform;
          }else{
              [button setTitleColor:RGB(69,69,69)forState:UIControlStateNormal];
              [button.titleLabel setFont:[UIFont systemFontOfSize:15.f weight:UIFontWeightThin]];
          }
          button.tag = i;
          if (i==0) {
              button.frame = CGRectMake(0, 0, model.width , 44);
              model.startPointX = 0;
              
          }else{
              button.frame = CGRectMake(_totalWidth, 0, model.width , 44);
              model.startPointX = _totalWidth;
          }

          [button addTarget:self action:@selector(scrollToTargetView:) forControlEvents:UIControlEventTouchUpInside];
          [self.topContainerView addSubview:button];
          [self.buttonsArray addObject:button];
          
          if (i==2) {
               [offestDictory setValue:[NSValue valueWithCGPoint:CGPointMake(0, 0)] forKey:[NSString  stringWithFormat:@"%d",i]];
          }else if(i>2 && _titles.count-i>3){
              [offestDictory setValue:[NSValue valueWithCGPoint:CGPointMake( _totalWidth, 0)] forKey:[NSString  stringWithFormat:@"%d",i]];
          }
          _totalWidth += model.width;
      }
}

-(void) configureBottomView{
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollViewWidthConstraint.constant = (_titles.count-1)*[UIScreen mainScreen].bounds.size.width;
    for (int i = 0 ; i<_titles.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0,self.bottomScrollView.bounds.size.width,self.bottomContainerView.bounds.size.height)];
        [self.bottomContainerView addSubview:view];

        ContentViewController *vc = [[ContentViewController alloc] init];
        vc.tag = [NSString stringWithFormat:@"%d",i];
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
    if (isSwipeToRight && currentPage<_titles.count) {
        if (currentPage<_titles.count-1 && currentPage>=0) {
            begainButton = [_buttonsArray objectAtIndex:currentPage];
            targetbutton = [_buttonsArray objectAtIndex:currentPage+1];
            [begainButton setTitleColor:(UIColor *)[filmstrip reverseValueAtTime:time] forState:UIControlStateNormal];
            [targetbutton setTitleColor:(UIColor *)[filmstrip valueAtTime:time] forState:UIControlStateNormal];
//            begainButton.titleLabel.font = fontSize(((NSNumber *)[filmstrip reverseSizeAtTime:time]).floatValue);
//            targetbutton.titleLabel.font = fontSize(((NSNumber *)[filmstrip sizeAtTime:time]).floatValue);
            CGFloat scale = (CGFloat)[(NSNumber *)[filmstrip sizeAtTime:time] floatValue];
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
            targetbutton.transform =scaleTransform;
            
            CGFloat scale1 = (CGFloat)[(NSNumber *)[filmstrip reverseSizeAtTime:time] floatValue];
            CGAffineTransform scaleTransform1 = CGAffineTransformMakeScale(scale1, scale1);
            begainButton.transform =scaleTransform1;
        }else{
            return;
        }
    }else if(!isSwipeToRight && currentPage>=0 && currentPage!=_titles.count-1){
        time = 1-time;
        if (currentPage>=0) {
            begainButton = [_buttonsArray objectAtIndex:currentPage+1];
            targetbutton = [_buttonsArray objectAtIndex:currentPage];
            [begainButton setTitleColor:(UIColor *)[filmstrip reverseValueAtTime:time] forState:UIControlStateNormal];
            [targetbutton setTitleColor:(UIColor *)[filmstrip valueAtTime:time] forState:UIControlStateNormal];
//            begainButton.titleLabel.font = fontSize(((NSNumber *)[filmstrip reverseSizeAtTime:time]).floatValue);
//            targetbutton.titleLabel.font = fontSize(((NSNumber *)[filmstrip sizeAtTime:time]).floatValue);
            CGFloat scale = (CGFloat)[(NSNumber *)[filmstrip sizeAtTime:time] floatValue];
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
            targetbutton.transform =scaleTransform;
            
            CGFloat scale1 = (CGFloat)[(NSNumber *)[filmstrip reverseSizeAtTime:time] floatValue];
            CGAffineTransform scaleTransform1 = CGAffineTransformMakeScale(scale1, scale1);
            begainButton.transform =scaleTransform1;

        }else{
            return;
        }

    }
    
}


-(void) AnimationToPosition{
//    CGFloat width = singleButtonWidth;
    begainDragPage = -1000;
    if (currentPage < 0 || _titles.count <=6 || currentPage > _titles.count-1) {
        return;
    }
//    if ( currentPage>0) {
//        if (isSwipeToRight) {
//            if (pageNumber - currentPage > 3 && currentPage>2) {
//                [self.topScrollView setContentOffset: CGPointMake(self.topScrollView.contentOffset.x+dragPageNumber*width, 0) animated:YES];
//            }
//        }else{
//            if (pageNumber - currentPage > 3 && currentPage >2){
//                [self.topScrollView setContentOffset: CGPointMake(self.topScrollView.contentOffset.x+dragPageNumber*width, 0) animated:YES];
//            }
//        }
//    }
    
    NSValue *point = (NSValue *)[offestDictory valueForKey:[NSString stringWithFormat:@"%ld",currentPage]];
    if (point) {
         [self.topScrollView setContentOffset:point.CGPointValue  animated:YES];
    }
   

    dragPageNumber = 0;
}

-(void) scrollToTargetView:(UIButton *) sender{
    NSInteger tage = sender.tag;
    [self changeButtonState:tage];
    [self.bottomScrollView setContentOffset: CGPointMake(tage*self.pageWidth, 0) animated: NO];
    NSValue *point = (NSValue *)[offestDictory valueForKey:[NSString stringWithFormat:@"%ld",tage]];
    if (point) {
        [self.topScrollView setContentOffset:point.CGPointValue animated:YES];

    }
    
}

-(void) changeButtonState:(NSInteger) tag{
    UIButton * beginButton = [_buttonsArray objectAtIndex:currentPage];
    UIButton *selectedButton = [_buttonsArray objectAtIndex:tag];
    [beginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [beginButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [selectedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [selectedButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    
   
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.2, 1.2);
    CGAffineTransform scaleTransform1 = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:.1 animations:^{
        selectedButton.transform =scaleTransform;
         beginButton.transform =scaleTransform1;
    }];
    
}
@end
