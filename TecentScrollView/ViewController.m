//
//  ViewController.m
//  TecentScrollView
//
//  Created by vivo on 16/5/25.
//  Copyright © 2016年 vivo. All rights reserved.
//

#import "ViewController.h"
#import "ContentViewController.h"
#import "IFTTTFilmstrip.h"
#import "IFTTTEasingFunction.h"
#import "IFTTTInterpolatable.h"
#import "TitleBGView.h"
#import "TitleModel.h"
#define pageNumber  10
#define singleButtonWidth 60
#define fontSize(a)  [UIFont systemFontOfSize:a]
#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *buttonsArray;
@property (nonatomic,strong) TitleBGView * titleView;
@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,assign) CGFloat totalWidth;
@end

@implementation ViewController
{
    NSInteger currentPage;
    CGFloat lastXOffset;
    BOOL isSwipeToRight;
    IFTTTFilmstrip* filmstrip;
    BOOL isClickButton;
    
    NSMutableDictionary *offestDictory;
    NSInteger lastPageNumber;
    BOOL buttonScrollAnimation;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view, typically from a nib.
    NSArray* titleArray = @[@"要闻",@"娱乐",@"民生",@"本地",@"手机",@"互联网",@"政治",@"纪录片",@"东方今报",@"江南都市报"];
    _titles = [NSMutableArray new];
    filmstrip = [IFTTTFilmstrip new];
    _totalWidth = 0;
    lastPageNumber = 0;
    buttonScrollAnimation = NO;
    for (NSString *title in titleArray) {
        TitleModel * Model = [TitleModel new];
        Model.title = title;
        [_titles addObject:Model];
        _totalWidth+=Model.width;
    }
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configureView{
    
//    self.navigationItem.titleView
    [self configureTopView];
    [self configureBottomView];
    
}

-(void) configureTopView{
    self.buttonsArray = [NSMutableArray new];
    offestDictory = [NSMutableDictionary new];
    self.topScrollview.showsHorizontalScrollIndicator = NO;
    if (_totalWidth>self.topScrollview.bounds.size.width) {
        self.topScrollViewConstraint.constant = (_totalWidth-self.topScrollview.bounds.size.width);
    }
        
    _totalWidth = 0;
    for (int i = 0 ; i<pageNumber; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        TitleModel *model = _titles[i];
        [button setTitle:model.title forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:RGB(18,69,147) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont  boldSystemFontOfSize :18.f]];
        }else{
            [button setTitleColor:RGB(79,79,79) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
        }
        button.tag = i;
        if (i==0) {
            button.frame = CGRectMake(0, 0, model.width , 44);
            _titleView = [[TitleBGView alloc] initWithFrame:CGRectMake(0, 10, model.width, 24)];
            _titleView.backgroundColor = [UIColor clearColor];
            _titleView.alpha = .3;
            [self.topcontainerView addSubview:_titleView];
            model.startPointX = 0;

        }else{
            button.frame = CGRectMake(_totalWidth, 0, model.width , 44);
            model.startPointX = _totalWidth;

        }
        [offestDictory setValue:[NSValue valueWithCGPoint:CGPointMake(_totalWidth, 0)] forKey:[NSString  stringWithFormat:@"%d",i]];
        _totalWidth += model.width;
        [button addTarget:self action:@selector(scrollToTargetView:) forControlEvents:UIControlEventTouchUpInside];
        [self.topcontainerView addSubview:button];
        [self.buttonsArray addObject:button];
        
        
        }
}

-(void) configureBottomView{
//    self.masterScrollView.showsHorizontalScrollIndicator = NO;
    self.masterScrollView.pagingEnabled = YES;
    self.masterScrollViewConstraint.constant = (pageNumber-1)*[UIScreen mainScreen].bounds.size.width;
    for (int i = 0 ; i<pageNumber; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0,self.masterScrollView.bounds.size.width,self.masterScrollView.bounds.size.height)];
        [self.containerView addSubview:view];
        
        ContentViewController *vc = [[ContentViewController alloc] init];
         vc.tag = [NSString stringWithFormat:@"%d",i];
        vc.view.frame = view.bounds ;
        [view addSubview:vc.view];
       
        [self addChildViewController:vc];
    }
    lastXOffset = 0;

}
- (CGFloat)pageWidth
{
    return CGRectGetWidth(self.masterScrollView.frame);
}

-(void) scrollToTargetView:(UIButton *) sender{
    NSInteger tage = sender.tag;
    [self changeButtonState:tage];
    [self.masterScrollView setContentOffset: CGPointMake(tage*self.pageWidth, 0) animated: NO];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffset = scrollView.contentOffset.x;
    currentPage = floor(currentOffset / self.pageWidth);
    if(currentOffset> lastXOffset){
        isSwipeToRight = YES;
    }else{
        isSwipeToRight = NO;
    }
    lastXOffset = currentOffset;
    if(currentPage>=0){
        [self scrollTopViewTitleSizeAnimation:(currentOffset / self.pageWidth - currentPage)];
    }
 }


-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat currentOffset = scrollView.contentOffset.x;
    currentPage = floor(currentOffset / self.pageWidth);
    if (currentPage<0 || currentPage>_titles.count-1) {
        return;
    }
    
    UIButton *bagainButton ;
    UIButton *targetButton;
    if (isSwipeToRight) {
        targetButton =_buttonsArray[currentPage];
        if (currentPage==0) {
            bagainButton = nil;
        }else{
            bagainButton = _buttonsArray[lastPageNumber];
        }
    }else{
        if (currentPage<0) {
            return;
        }
        targetButton =_buttonsArray[currentPage];
        if (currentPage== _titles.count-1) {
            bagainButton = nil;
        }else{
            bagainButton = _buttonsArray[lastPageNumber];
        }

    }
        if (bagainButton) {
            [UIView animateWithDuration:.2 animations:^{
                [bagainButton setTitleColor:RGB(79,79,79) forState:UIControlStateNormal];
            }];
    }
     [UIView animateWithDuration:.2 animations:^{
     [targetButton setTitleColor:RGB(18,69,147) forState:UIControlStateNormal];
     }];
    
    [self AnimationToPosition];
}

-(void) scrollTopViewTitleSizeAnimation:(CGFloat) time{
    if (currentPage<0) {
        return;
    }
    UIButton *bagainButton ;
    UIButton *targetButton ;
    if (isSwipeToRight) {
        if (buttonScrollAnimation) {
            targetButton = _buttonsArray[currentPage];
            [UIView animateWithDuration:.2 animations:^{
               _titleView.frame = CGRectMake(targetButton.frame.origin.x, _titleView.frame.origin.y, targetButton.frame.size.width, _titleView.frame.size.height); 
            } completion:^(BOOL finished) {
                lastPageNumber = currentPage;
                buttonScrollAnimation = NO;
            }];
        }else if (currentPage>=_titles.count-1) {
            return;
        }else{
            bagainButton = _buttonsArray[currentPage];
            targetButton = _buttonsArray[currentPage+1];
            _titleView.frame = [(NSValue *)[filmstrip BoundsFromTime:CGRectMake(bagainButton.frame.origin.x, _titleView.frame.origin.y, bagainButton.frame.size.width, _titleView.frame.size.height) toTime:CGRectMake(targetButton.frame.origin.x, _titleView.frame.origin.y, targetButton.frame.size.width, _titleView.frame.size.height) :time] CGRectValue];
        }
    }else{
        if (buttonScrollAnimation) {
            targetButton = _buttonsArray[currentPage];
            [UIView animateWithDuration:.2 animations:^{
                _titleView.frame = CGRectMake(targetButton.frame.origin.x, _titleView.frame.origin.y, targetButton.frame.size.width, _titleView.frame.size.height);
            } completion:^(BOOL finished) {
                lastPageNumber = currentPage;
                buttonScrollAnimation = NO;
            }];
        }else if (currentPage < 0 || currentPage>=_titles.count-1) {
            return;
        }else{
            bagainButton = _buttonsArray[currentPage+1];
            targetButton = _buttonsArray[currentPage];
            _titleView.frame = [(NSValue *)[filmstrip reverseBoundsFromTime:CGRectMake(bagainButton.frame.origin.x, _titleView.frame.origin.y, bagainButton.frame.size.width, _titleView.frame.size.height) toTime:CGRectMake(targetButton.frame.origin.x, _titleView.frame.origin.y, targetButton.frame.size.width, _titleView.frame.size.height) :time] CGRectValue];
        }
        
    }
    

}

-(void) AnimationToPosition{
    lastPageNumber = currentPage;
    if (currentPage < 0 || _titles.count <=6 || currentPage > _titles.count-1) {
        return;
    }
    
   UIButton* targetButton =_buttonsArray[currentPage];
    if (isSwipeToRight ) {
        if (CGRectContainsRect(CGRectMake(self.topScrollview.contentOffset.x, 0, self.topScrollview.bounds.size.width, self.topScrollview.bounds.size.height),targetButton.frame)) {
               return;
        }else{
            
            CGFloat unVisiableDistance = targetButton.frame.origin.x+targetButton.frame.size.width-self.topScrollview.contentOffset.x-self.topScrollview.frame.size.width;
            CGPoint targetPoint = CGPointMake(self.topScrollview.contentOffset.x+unVisiableDistance, 0);
                [self.topScrollview setContentOffset:targetPoint  animated:YES];
        }
    }else {
        if (CGRectContainsRect(CGRectMake(self.topScrollview.contentOffset.x, 0, self.topScrollview.bounds.size.width, self.topScrollview.bounds.size.height),targetButton.frame)) {
            return;
        }else{
            CGFloat unVisiableDistance = self.topScrollview.contentOffset.x-targetButton.frame.origin.x;
            CGPoint targetPoint = CGPointMake(self.topScrollview.contentOffset.x-unVisiableDistance, 0);
            [self.topScrollview setContentOffset:targetPoint  animated:YES];
        }
    }
    
    
}

-(void) changeButtonState:(NSInteger) tag{
    UIButton * beginButton = [_buttonsArray objectAtIndex:currentPage];
    UIButton *selectedButton = [_buttonsArray objectAtIndex:tag];
    buttonScrollAnimation = YES;
    [beginButton setTitleColor:RGB(79,79,79) forState:UIControlStateNormal];
    [selectedButton setTitleColor:RGB(18,69,147) forState:UIControlStateNormal];
    if (CGRectContainsRect(CGRectMake(self.topScrollview.contentOffset.x, 0, self.topScrollview.bounds.size.width, self.topScrollview.bounds.size.height),selectedButton.frame)) {
        return;
    }else{
        
        if (tag>currentPage) {
            CGFloat unVisiableDistance = selectedButton.frame.origin.x+selectedButton.frame.size.width-self.topScrollview.contentOffset.x-self.topScrollview.frame.size.width;
            CGPoint targetPoint = CGPointMake(self.topScrollview.contentOffset.x+unVisiableDistance, 0);
            [self.topScrollview setContentOffset:targetPoint  animated:YES];
        }else{
            CGFloat unVisiableDistance = self.topScrollview.contentOffset.x-selectedButton.frame.origin.x;
            CGPoint targetPoint = CGPointMake(self.topScrollview.contentOffset.x-unVisiableDistance, 0);
            [self.topScrollview setContentOffset:targetPoint  animated:YES];
        }
    }
}
@end
