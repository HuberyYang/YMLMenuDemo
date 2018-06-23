//
//  Copyright © 2016年 HuberyYang. All rights reserved.
/*  😀😀😀 Blog ~> http://huberyyang.com , Email ~> yml_hubery@sina.com 😀😀😀 */

#import "YMLRotationLayout.h"

@implementation YMLRotationLayout{
    
    NSMutableArray *_attributes; // 子视图frame数组
}

- (void)prepareLayout{
    [super prepareLayout];
    
    // 按钮个数
    int itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    _attributes = [[NSMutableArray alloc] init];
    // 先设定大圆的半径 取长和宽最短的（圆环外径）
    CGFloat radius = MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height) / 2.2;
    // 圆心位置
    CGPoint center = self.collectionView.center;
    
    // 设置每个item的大小
    for (int idx = 0; idx < itemCount; idx ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        // 设置item大小
        attris.size = CGSizeMake(_itemRadius, _itemRadius);
        
        if (itemCount == 1) {
            attris.center = self.collectionView.center;
        } else {
            
            // 计算每个item的圆心位置
            /*
             .
             . .
             .  . r
             .   .
             .    .
             .......
             */
            // 计算每个item中心的坐标
            // 算出的x，y值还要减去item自身的半径大小
            float x = center.x + cosf(2 * M_PI / itemCount * idx + _rotationAngle) * (radius - _itemRadius / 2.0);
            float y = center.y + sinf(2 * M_PI / itemCount * idx + _rotationAngle) * (radius - _itemRadius / 2.0);
            
            attris.center = CGPointMake(x, y);
        }
        [_attributes addObject:attris];
    }
}

// contentSize
- (CGSize)collectionViewContentSize{
    return self.collectionView.frame.size;
}

// cell / header / footer 的frame数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributes;
}


@end
