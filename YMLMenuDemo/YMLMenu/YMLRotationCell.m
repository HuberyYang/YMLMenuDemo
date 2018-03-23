//
//  Copyright © 2016年 HuberyYang. All rights reserved.
/*  😀😀😀 个人主页 ~> http://huberyyang.top , 邮箱: yml_hubery@sina.com 😀😀😀 */

#import "YMLRotationCell.h"

@interface YMLRotationCell ()

/** 图片 */
@property (strong, nonatomic) UIImageView *imageV;

@end

@implementation YMLRotationCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat w = MIN(frame.size.width, frame.size.height);
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 - w / 2.0,
                                                                      frame.size.height / 2.0 - w / 2.0,
                                                                      w,
                                                                      w)];
        [self addSubview:_imageV];
        _imageV.layer.cornerRadius = w / 2.0;
    }
    return self;
}

- (void)updateCellWith:(NSString *)picName{
    self.imageV.image = [UIImage imageNamed:picName];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

@end
