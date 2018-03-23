//
//  Copyright © 2016年 HuberyYang. All rights reserved.
/*  😀😀😀 个人主页 ~> http://huberyyang.top , 邮箱: yml_hubery@sina.com 😀😀😀 */

#import <UIKit/UIKit.h>

@protocol YMLRotationViewControllerDelegate <NSObject>

/**
 * 点击按钮获取对应的下标
 * index ~> 下标 */
- (void)menuDidSelectedAtItemIndex:(NSInteger)index;

@end

@interface YMLRotationViewController : UIViewController

/** 旋转速度倍率，默认为1倍 */
@property (nonatomic, assign) CGFloat rotationRate;

/** 按钮图片名称数组 */
@property (nonatomic, strong) NSArray *itemNames;

/** 是否可以旋转,默认为NO */
@property (nonatomic, assign) BOOL canRotate;

/** 代理 */
@property (nonatomic,weak) id<YMLRotationViewControllerDelegate>delegate;




@end
