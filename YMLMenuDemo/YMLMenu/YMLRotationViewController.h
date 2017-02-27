



//  Copyright © 2016年 Yml. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMLRotationViewControllerDelegate <NSObject>

/**
 点击按钮获取对应的下标

 @param index 下标
 */
- (void)menuDidSelectedAtItemIndex:(NSInteger)index;

@end

@interface YMLRotationViewController : UIViewController

/**
 旋转速度倍率，默认为 1.50f
 */
@property (nonatomic, assign) CGFloat rotationRate;

/**
 按钮图片名称数组
 */
@property (nonatomic, strong) NSArray *itemNames;

/**
 是否可以旋转,默认为NO
 */
@property (nonatomic, assign) BOOL canRotate;


/**
 代理
 */
@property (nonatomic,weak) id<YMLRotationViewControllerDelegate>delegate;




@end
