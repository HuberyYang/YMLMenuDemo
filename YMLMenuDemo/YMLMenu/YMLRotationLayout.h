//
//  Copyright © 2016年 Yml. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLRotationLayout : UICollectionViewLayout


/**
 按钮半径
 */
@property (nonatomic,assign) CGFloat itemRadius;

/**
 item相对圆心旋转角度
 */
@property (nonatomic,assign) CGFloat rotationAngle;

@end
