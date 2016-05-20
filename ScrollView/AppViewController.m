//
//  ViewController.m
//  ScrollView
//
//  Created by vivo on 16/3/17.
//  Copyright © 2016年 vivo. All rights reserved.
//

#import "AppViewController.h"

@interface AppViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
//    self.scrollView.contentOffset = CGPointMake(500, -500);
    
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    // Do any additional setup after loading the view, typically from a nib.
    self.scrollView.contentSize = CGSizeMake( 375, 10000);
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    NSLog(@"viewDidload");
}

-(void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
     NSLog(@"viewWillLayoutSubviews");
}

-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
//    self.scrollView.contentSize = CGSizeMake( 375, 10000);
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    self.scrollView.contentOffset = CGPointMake(0, 500);
    NSLog(@"viewDidLayoutSubviews");
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     NSLog(@"viewWillAppear");
}

-(void) awakeFromNib{
     NSLog(@"awakeFromNib");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll - Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}// any offset changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2){
    NSLog(@"scrollViewDidZoom- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}// any zoom scale changes

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    NSLog(@"scrollViewWillEndDragging- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}// called on finger up as we are moving

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}// called when scroll view grinds to a halt

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndScrollingAnimation- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    NSLog(@"viewForZoomingInScrollView");
    return [UIView new];
}// return a view that will be scaled. if delegate returns nil, nothing happens
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
    NSLog(@"scrollViewWillBeginZooming- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}// called before the scroll view begins zooming its content
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"scrollViewDidEndZooming- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}// scale between minimum and maximum. called after any 'bounce' animations

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"scrollViewShouldScrollToTop- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
    return YES;
}// return a yes if you want to scroll to the top. if not defined, assumes YES
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScrollToTop- Drag:%@, Decelerate:%@",self.scrollView.dragging ?@"Yes":@"NO",self.scrollView.decelerating?@"Yes":@"NO");
}// called when scrolling animation finished. may be called immediately if already at top

@end
