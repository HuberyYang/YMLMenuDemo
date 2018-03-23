//
//  Copyright © 2016年 Yml. All rights reserved.
//

#import "YMLRotationViewController.h"
#import "YMLRotationLayout.h"
#import "YMLRotationCollectionViewCell.h"
#import "UICollectionView+Yml_Category.h"

#define R_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define R_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define R_TAG  3000
#define RadiansToDegrees(x) (180.0 * x / M_PI)

@interface YMLRotationViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>


/** collectionView */
@property (nonatomic, strong) UICollectionView *collectView;

/** layout */
@property (nonatomic, strong) YMLRotationLayout *layout;

/** 上一次滑动到的点 */
@property (nonatomic, assign) CGPoint lastPoint;

/** collectionView中心点 ，也是菜单的中心点 */
@property (nonatomic, assign) CGPoint centerPoint;

/** 相对于初始状态滑动过的角度总和 */
@property (nonatomic, assign) CGFloat totalRads;

/** 按钮半径 */
@property (nonatomic, assign) CGFloat itemRadius;


@end

@implementation YMLRotationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取item半径
    [self makeItemRadius];
    // 添加collectionView
    [self createCollectionView];
    // 返回按钮
    [self addBackButton];
    // 是否支持旋转
    _canRotate ? [self getNotifacation] : nil;
}

- (void)createCollectionView{
    
    _layout = [[YMLRotationLayout alloc] init];
    _layout.itemRadius = _itemRadius;
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, R_SCREEN_WIDTH, R_SCREEN_HEIGHT) collectionViewLayout:_layout];
    
    _collectView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    _collectView.dataSource = self;
    _collectView.delegate = self;
    
    CGFloat larRadius = MIN(self.collectView.frame.size.width, self.collectView.frame.size.height)/2.2;
    
    _collectView.largeRadius = [NSString stringWithFormat:@"%f",larRadius];
    _collectView.smallRadius = [NSString stringWithFormat:@"%f",_itemRadius];
    
    [_collectView registerClass:[YMLRotationCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YMLRotationCollectionViewCell class])];
    
    [self.view addSubview:_collectView];
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getNotifacation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchBegin:)  name:@"touchBegin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchMoving:) name:@"touchMoving" object:nil];
}

- (void)makeItemRadius{
    
    if (_rotationRate == 0.0f) {
        _rotationRate = 2.00f;
    }
    
    if (_itemNames == nil || _itemNames.count == 0) {
        
        _itemRadius = 60.0f;
    } else if (_itemNames.count == 1 || _itemNames.count == 2){
        
        _itemRadius = R_SCREEN_WIDTH / 2.2;
        
    } else {
        
        CGFloat larRadius = R_SCREEN_WIDTH / 2.2;
        double perRadius = 2 * M_PI / _itemNames.count;
        _itemRadius = (larRadius * fabs(sin(perRadius)) - 10) / (fabs(sin(perRadius)) + 1) ;
    }
}

- (NSArray *)itemNames{
    
    if (_itemNames == nil) {
        _itemNames = [[NSArray alloc] init];
    }
    return _itemNames;
}

- (CGFloat)rotationRate{
    
    if (_rotationRate == 0.0f) {
        _rotationRate = 1.50f;
    }
    return _rotationRate;
}


#pragma mark  UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YMLRotationCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YMLRotationCollectionViewCell class]) forIndexPath:indexPath];
    cell.layer.cornerRadius = _itemRadius / 2.0;
    cell.layer.masksToBounds = YES;
    
    // 由于重载了collectionview点击事件，所以需要添加点击手势处理点击事件
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewCellClicked:)]];
    cell.tag = R_TAG + indexPath.row;
    
    [cell updateCellWith:[_itemNames objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionViewCellClicked:(UITapGestureRecognizer *)tap{
    
    NSInteger index = tap.view.tag - R_TAG;
    if (self.delegate) {
        [self.delegate menuDidSelectedAtItemIndex:index];
    }
}

#pragma mark -- 按钮滑动，重新布局

// 滑动开始
- (void)touchBegin:(NSNotification *)sender{
    
    _centerPoint = self.collectView.center;
    NSDictionary *dic = sender.userInfo;
    CGPoint point = CGPointMake([dic[@"x"] floatValue], [dic[@"y"] floatValue]);
    _lastPoint = point;
}

// 正在滑动中
- (void)touchMoving:(NSNotification *)sender{
    
    NSDictionary *dic = sender.userInfo;
    CGPoint point = CGPointMake([dic[@"x"] floatValue], [dic[@"y"] floatValue]);
    
    // 手指当前所在的点与collectionView中心点x坐标差值
    CGFloat x = point.x - _centerPoint.x;
    
    // 滑动中前后两点Y坐标差值
    CGFloat difY = point.y - _lastPoint.y;
    
    // 以collectionView center为中心计算滑动角度
    CGFloat rads = [self angleBetweenFirstLineStart:_centerPoint firstLineEnd:_lastPoint andSecondLineStart:_centerPoint secondLineEnd:point];
    
    if (x >= 0) {
        
        if (difY > 0) {
            _totalRads += rads;
        }else{
            _totalRads -= rads;
        }
        
    } else {
        
        if (difY > 0) {
            _totalRads -= rads;
        }else{
            _totalRads += rads;
        }
    }
    
    // 将纯度数转化为π
    _layout.rotationAngle = _totalRads / 180.0 * _rotationRate;
    
    // 重新布局
    [_layout invalidateLayout];
    
    // 更新记录点
    _lastPoint = point;
}

// 两条直线之间的夹角
- (CGFloat)angleBetweenFirstLineStart:(CGPoint)firstLineStart firstLineEnd:(CGPoint)firstLineEnd andSecondLineStart:(CGPoint)secondLineStart secondLineEnd:(CGPoint)secondLineEnd{
    
    CGFloat a = firstLineEnd.x - firstLineStart.x;
    CGFloat b = firstLineEnd.y - firstLineStart.y;
    CGFloat c = secondLineEnd.x - secondLineStart.x;
    CGFloat d = secondLineEnd.y - secondLineStart.y;
    
    CGFloat rads = acos((a * c + b * d) / (sqrt(a * a + b * b) * sqrt(c * c + d * d)));
    return RadiansToDegrees(rads);
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
