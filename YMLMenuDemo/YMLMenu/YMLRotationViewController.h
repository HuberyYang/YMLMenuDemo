//
//  Copyright © 2016年 HuberyYang. All rights reserved.
/*  😀😀😀 Blog ~> http://huberyyang.com , Email ~> yml_hubery@sina.com 😀😀😀 */

#import <UIKit/UIKit.h>

@protocol YMLRotationViewControllerDelegate <NSObject>

/**
 * 点击按钮获取对应的下标
 * index ~> 下标 */
- (void)menuDidSelectedAtItemIndex:(NSInteger)index;

@end

@interface YMLRotationViewController : UIViewController

/** 按钮图片名称数组 */
@property (strong, nonatomic) NSArray<NSString *> *itemNames;

/** 是否可以旋转,默认为NO */
@property (assign, nonatomic) BOOL rotate;

/** 代理 */
@property (weak, nonatomic) id<YMLRotationViewControllerDelegate>delegate;




@end
