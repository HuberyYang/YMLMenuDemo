//
//  Copyright © 2016年 HuberyYang. All rights reserved.
/*  😀😀😀 Blog ~> http://huberyyang.com , Email ~> yml_hubery@sina.com 😀😀😀 */

#import "YMLRotationViewController.h"
#import "YMLRotationLayout.h"
#import "YMLRotationCell.h"

#define R_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define R_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface YMLRotationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>


/** collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;

/** layout */
@property (strong, nonatomic) YMLRotationLayout *layout;

/** 上一次滑动到的点 */
@property (assign, nonatomic) CGPoint lastPoint;

/** collectionView中心点 ，也是菜单的中心点 */
@property (assign, nonatomic) CGPoint centerPoint;

/** 相对于初始状态滑动过的角度总和 */
@property (assign, nonatomic) CGFloat totalRads;

/** 圆环上按钮直径 */
@property (assign, nonatomic) CGFloat itemRadius;

/** 圆环外径 */
@property (assign, nonatomic) CGFloat larRadius;


@end

@implementation YMLRotationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 返回按钮
    [self addBackButton];
    // 计算菜单、按钮的半径
    [self calculateItemRadius];
    // 添加collectionView
    [self createCollectionView];
}

- (void)addBackButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 40, 60, 25);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backToFormerPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)backToFormerPage{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 按钮半径设置，可根据需求修改
- (void)calculateItemRadius{
    
    if (_itemNames.count == 1) {
        _itemRadius = R_SCREEN_WIDTH / 2.2;
    } else if (_itemNames.count == 2){
        _itemRadius = R_SCREEN_WIDTH / 4.0;
    } else {
        CGFloat larRadius = R_SCREEN_WIDTH / 2.2;
        double perRadius = 2 * M_PI / _itemNames.count;
        _itemRadius = (larRadius * fabs(sin(perRadius)) - 10) / (fabs(sin(perRadius)) + 1) ;
    }
}

- (void)createCollectionView{
    
    _layout = [[YMLRotationLayout alloc] init];
    _layout.itemRadius = _itemRadius;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, R_SCREEN_WIDTH, R_SCREEN_HEIGHT) collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[YMLRotationCell class] forCellWithReuseIdentifier:NSStringFromClass([YMLRotationCell class])];
    [self.view addSubview:_collectionView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuBeingPaned:)];
    pan.delegate = self;
    [_collectionView addGestureRecognizer:pan];
    
    // 设置滑动中心点
    _centerPoint = _collectionView.center;
    // 圆环外径
    CGFloat larRadius = MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height) / 2.2;
    _larRadius = larRadius;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemNames ?  _itemNames.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YMLRotationCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YMLRotationCell class]) forIndexPath:indexPath];
    [cell updateCellWithPicture:[_itemNames objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuDidSelectedAtItemIndex:)]) {
        [self.delegate menuDidSelectedAtItemIndex:indexPath.row];
    }
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 初始滑动时记录点为当前点
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
        _lastPoint = point;
    }
    return YES;
}

#pragma mark -- 菜单滑动，重新布局
- (void)menuBeingPaned:(UIPanGestureRecognizer *)panGR {
    if (!_rotate) return;
    
    CGPoint point = [panGR locationInView:panGR.view];
    CGFloat rLength = sqrt(pow((point.x - _centerPoint.x), 2.0)  +  pow((point.y - _centerPoint.y), 2.0));
    
    // 手势范围
    if (rLength <= _larRadius && rLength >= _larRadius - _itemRadius) {
        [self touchMoving:point];
    }
    // 由范围外进入范围内时将当前点赋值于记录点
    else if (_lastPoint.x == -100 && _lastPoint.y == -100) {
        _lastPoint = point;
    }
    // 由范围内进入范围外时清除记录点
    else {
        _lastPoint = CGPointMake(-100, -100);
    }
}

// 正在滑动中
- (void)touchMoving:(CGPoint )point{
    
    // 以collectionView center为中心计算滑动角度
    CGFloat rads = [self angleBetweenFirstLineStart:_centerPoint
                                       firstLineEnd:_lastPoint
                                 andSecondLineStart:_centerPoint
                                      secondLineEnd:point];
    
    if (_lastPoint.x != _centerPoint.x && point.x != _centerPoint.x) {

        CGFloat k1 = (_lastPoint.y - _centerPoint.y) / (_lastPoint.x - _centerPoint.x);
        CGFloat k2 = (point.y - _centerPoint.y) / (point.x - _centerPoint.x);
        if (k2 > k1) {
            _totalRads += rads;
        } else {
            _totalRads -= rads;
        }
    }
    
    _layout.rotationAngle = _totalRads;
    // 重新布局
    [_layout invalidateLayout];
    
    // 更新记录点
    _lastPoint = point;
}

// 两条直线之间的夹角
- (CGFloat)angleBetweenFirstLineStart:(CGPoint)firstLineStart
                         firstLineEnd:(CGPoint)firstLineEnd
                   andSecondLineStart:(CGPoint)secondLineStart
                        secondLineEnd:(CGPoint)secondLineEnd
{
    CGFloat a1 = firstLineEnd.x - firstLineStart.x;
    CGFloat b1 = firstLineEnd.y - firstLineStart.y;
    CGFloat a2 = secondLineEnd.x - secondLineStart.x;
    CGFloat b2 = secondLineEnd.y - secondLineStart.y;
    
    // 夹角余弦
    double cos = (a1 * a2 + b1 * b2) / (sqrt(pow(a1, 2.0) + pow(b1, 2.0)) * sqrt(pow(a2, 2.0) + pow(b2, 2.0)));
    // 浮点计算结果可能超过1，需要控制
    cos = cos > 1 ? 1 : cos;
    return acos(cos);
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
