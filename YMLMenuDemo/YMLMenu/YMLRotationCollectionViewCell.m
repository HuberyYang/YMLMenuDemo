//
//  Copyright © 2016年 Tommy. All rights reserved.
//

#import "YMLRotationCollectionViewCell.h"

@interface YMLRotationCollectionViewCell ()

@property (strong, nonatomic) UIImageView *carImageView;

@end

@implementation YMLRotationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        _carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _carImageView.userInteractionEnabled = YES;
        [self addSubview:_carImageView];
    }
    return self;
}

- (void)updateCellWith:(NSString *)picName{
    self.carImageView.image = [UIImage imageNamed:picName];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

@end
