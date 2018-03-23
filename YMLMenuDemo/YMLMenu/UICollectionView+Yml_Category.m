//
//  Copyright © 2016年 Yml. All rights reserved.
//

#import "UICollectionView+Yml_Category.h"
#import <objc/runtime.h>

static NSString * const largeRadiusKey = @"largeRadiusKey";
static NSString * const smallRadiusKey = @"smallRadiusKey";

@implementation UICollectionView (Yml_Category)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint centerPoint = self.center;
    
    UITouch *touch = touches.anyObject;
    CGPoint point  = [touch locationInView:self];
    
    CGFloat rLength = sqrt((point.x - centerPoint.x) * (point.x - centerPoint.x) + (point.y - centerPoint.y) * (point.y - centerPoint.y));
    
    // 手势范围
    if (!(rLength <= [self.largeRadius floatValue] && rLength >= [self.smallRadius floatValue])) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchBegin" object:nil userInfo:@{@"x":[NSString stringWithFormat:@"%f",point.x],@"y":[NSString stringWithFormat:@"%f",point.y]}];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint centerPoint = self.center;
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    CGFloat rLength = sqrt((point.x - centerPoint.x) * (point.x - centerPoint.x) + (point.y - centerPoint.y) * (point.y - centerPoint.y));
    
    // 手势范围
    if (!(rLength <= [self.largeRadius floatValue] && rLength >= [self.smallRadius floatValue])) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchMoving" object:nil userInfo:@{@"x":[NSString stringWithFormat:@"%f",point.x],@"y":[NSString stringWithFormat:@"%f",point.y]}];
}

// 结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    CGPoint centerPoint = self.center;
//    
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:self];
//    
//    CGFloat rLength = sqrt((point.x - centerPoint.x) * (point.x - centerPoint.x) + (point.y - centerPoint.y) * (point.y - centerPoint.y));
      // 手势范围
//    if (!(rLength <= [self.largeRadius floatValue] && rLength >= [self.smallRadius floatValue])) {
//        return;
//    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchEnd" object:nil userInfo:@{@"x":[NSString stringWithFormat:@"%f",point.x],@"y":[NSString stringWithFormat:@"%f",point.y]}];
    
}


- (void)setLargeRadius:(NSString *)largeRadius{
    objc_setAssociatedObject(self, &largeRadiusKey, largeRadius, OBJC_ASSOCIATION_COPY);
}

- (NSString *)largeRadius{
    return objc_getAssociatedObject(self, &largeRadiusKey);
}

- (void)setSmallRadius:(NSString *)smallRadius{
    objc_setAssociatedObject(self, &smallRadiusKey, smallRadius, OBJC_ASSOCIATION_COPY);
}

- (NSString *)smallRadius{
    return objc_getAssociatedObject(self, &smallRadiusKey);
}


@end
