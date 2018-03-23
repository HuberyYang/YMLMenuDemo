//
//  Copyright © 2016年 Yml. All rights reserved.
//

#import "YMLRotationLayout.h"

@implementation YMLRotationLayout{
    
    NSMutableArray * _attributeAttay;
    CGFloat _rLength;
    NSInteger _itemCount;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    // 按钮个数
    _itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    _attributeAttay = [[NSMutableArray alloc] init];
    // 先设定大圆的半径 取长和宽最短的
    CGFloat radius = MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height) / 2.2;
    // 圆心位置
    CGPoint center = CGPointMake(self.collectionView.frame.size.width / 2.0, self.collectionView.frame.size.height / 2.0);
    
    _rLength = _itemRadius;
    
    // 设置每个item的大小
    for (int i = 0; i < _itemCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        // 设置item大小
        attris.size = CGSizeMake(_rLength, _rLength);
        // 计算每个item的圆心位置
        /*
         .
         . .
         .   . r
         .     .
         .........
         */
        // 计算每个item中心的坐标
        // 算出的x，y值还要减去item自身的半径大小
        float x = center.x + cosf(2 * M_PI / _itemCount * i + _rotationAngle) * (radius - _rLength / 2.0);
        float y = center.y + sinf(2 * M_PI / _itemCount * i + _rotationAngle) * (radius - _rLength / 2.0);
        
        attris.center = CGPointMake(x, y);
        [_attributeAttay addObject:attris];
    }
}

// 设置内容区域的大小
- (CGSize)collectionViewContentSize{
    return self.collectionView.frame.size;
}

// 返回设置数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeAttay;
}


@end
