//
//  ViewController.m
//  LLResuseScrollView
//
//  Created by leileigege on 2017/2/8.
//  Copyright © 2017年 leileigege. All rights reserved.
//

/*
 UIScrollView需要设置内容的大小才能滚动,当内容的宽<=sc的宽,水平方向不能滚动,当内容的高<=sc的高,垂直方向不能滚动
 */
/*
 UIScrollView需要设置内容的大小才能滚动,当内容的宽<=sc的宽,水平方向不能滚动,当内容的高<=sc的高,垂直方向不能滚动
 */
#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, retain) UIImageView *centerView,*reuseView;
@property (nonatomic, retain) NSTimer *tim;

@end



@implementation ViewController
int currentIndex,nextIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(60, 0, 200, 200)];
    sc.tag = 1;
    sc.backgroundColor = [UIColor redColor];
    sc.delegate = self;
    sc.contentSize = CGSizeMake(600, 200);
    sc.contentOffset = CGPointMake(200, 0);
    _centerView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 200, 200)];
    _reuseView = [[UIImageView alloc]initWithFrame:CGRectMake(400, 0, 200, 200)];
    _centerView.image = [UIImage imageNamed:@"0.jpg"];
    sc.pagingEnabled = YES;
    [sc addSubview:_centerView];
    [sc addSubview:_reuseView];
    [self.view addSubview:sc];
    
    
    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(60, 200, 200, 20)];
    page.backgroundColor = [UIColor grayColor];
    page.tag = 2;
    //设置页数
    page.numberOfPages = 4;
    //设置当前页
    //page.currentPage = 1;
    //设置不选中的颜色
    page.pageIndicatorTintColor = [UIColor greenColor];
    //设置当前页的颜色
    page.currentPageIndicatorTintColor = [UIColor yellowColor];
    [page addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:page];
    _tim = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(move) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_tim forMode:UITrackingRunLoopMode];
}



- (void)move
{
    UIScrollView *sc = (UIScrollView *)[self.view viewWithTag:1];
    CGPoint point = sc.contentOffset;
    point.x += 200;
    [sc setContentOffset:point animated:YES];
}

- (void)changePage:(UIPageControl *)page
{
    UIScrollView *sc = (UIScrollView *)[self.view viewWithTag:1];
    long dx = page.currentPage - currentIndex;
    if (dx > 0) {
        [sc setContentOffset:CGPointMake(400, 0) animated:YES];
    }else if (dx==0){
        [sc setContentOffset:CGPointMake(200, 0) animated:YES];
    }else{
        [sc setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

// 当scrollView滚动的时候调用,任何偏移都会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:2];
    float x = scrollView.contentOffset.x;
    if (x > 200) {
        _reuseView.frame = CGRectMake(400, 0, 200, 200);
        nextIndex = (currentIndex+1)%4;
        _reuseView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",nextIndex]];
        if (x >= 400) {
            scrollView.contentOffset = CGPointMake(200+(x-400), 0);
            _centerView.image = _reuseView.image;
            currentIndex = nextIndex;
        }
    }
    if (x < 200) {
        _reuseView.frame = CGRectMake(0, 0, 200, 200);
        nextIndex = (currentIndex+3)%4;
        _reuseView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",nextIndex]];
        if (x <= 0) {
            scrollView.contentOffset = CGPointMake(200+x, 0);
            _centerView.image = _reuseView.image;
            currentIndex = nextIndex;
        }
        
    }
    
    page.currentPage = currentIndex;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"停");
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_tim setFireDate:[NSDate distantFuture]];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tim setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}

/*
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 UIScrollView *sc = (UIScrollView *)[self.view viewWithTag:1];
 CGPoint point = sc.contentOffset;
 point.x += 200;
 //sc.contentOffset = point;
 //让sc偏移有动画
 [sc setContentOffset:point animated:YES];
 }
 */


@end
