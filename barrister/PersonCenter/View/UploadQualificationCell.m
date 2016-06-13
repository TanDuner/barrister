//
//  UploadQualificationCell.m
//  barrister
//
//  Created by 徐书传 on 16/6/13.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "UploadQualificationCell.h"

@interface UploadQualificationCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *uploadImageView;

@end

@implementation UploadQualificationCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.uploadImageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.model) {
        return;
    }
    if (self.model.uploadImage) {
        [self.uploadImageView setImage:self.model.uploadImage];
    }
    else
    {
        [self.uploadImageView setImage:[UIImage imageNamed:@"uploadImage.png"]];
    }

    

    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"* %@",self.model.title]];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
    self.titleLabel.attributedText = attrituteString;
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [kSeparatorColor setStroke];
    
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    [linePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [linePath stroke];
    
}

#pragma -mark ---Getter---------
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] initWithFrame:RECT(LeftPadding, 23.5, 200, 13)];
        _titleLabel.font = SystemFont(14.0f);
    }
    return _titleLabel;
}
-(UIImageView *)uploadImageView
{
    if (!_uploadImageView) {
        _uploadImageView = [[UIImageView alloc] initWithFrame:RECT(SCREENWIDTH - 10 - 40, (60 - 40)/2.0, 40, 40)];
        _uploadImageView.backgroundColor = RGBCOLOR(204, 204, 204);
    }
    return _uploadImageView;
}

@end
