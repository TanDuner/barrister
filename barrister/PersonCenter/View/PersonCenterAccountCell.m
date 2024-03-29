//
//  PersonCenterAccountCell.m
//  barrister
//
//  Created by 徐书传 on 16/3/29.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "PersonCenterAccountCell.h"
#import "YYWebImage.h"

#define IconWidht 65


@interface PersonCenterAccountCell ()

@property (nonatomic,strong) UIImageView *iconImageIVew;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *rightRow;

@property (nonatomic,strong) UILabel *subtitleLabel;



@end

@implementation PersonCenterAccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.iconImageIVew];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightRow];
        [self addSubview:self.subtitleLabel];
        [self addSubview:self.starView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.model.isAccountLogin) {
        [self.iconImageIVew setFrame:RECT(LeftPadding + 5, ([PersonCenterAccountCell getCellHeight] - IconWidht)/2.0, IconWidht, IconWidht)];
        [self.titleLabel setFrame:RECT(self.iconImageIVew.x + self.iconImageIVew.width + 15, self.iconImageIVew.y + 5, SCREENWIDTH - self.iconImageIVew.width - LeftPadding - 5 - 15 - 30, 15)];
        [self.subtitleLabel setFrame:RECT(self.titleLabel.x, self.iconImageIVew.y + self.iconImageIVew.height - 35 , self.titleLabel.width, 10)];
        _titleLabel.textColor = KColorGray333;
        self.rightRow.hidden = NO;
        self.starView.hidden = NO;
        [self.starView setFrame:RECT(self.titleLabel.x, CGRectGetMaxY(self.subtitleLabel.frame) + 10, 80, 15)];
    }
    else
    {
        [self.iconImageIVew setFrame:RECT(LeftPadding + 5, ([PersonCenterAccountCell getCellHeight] - IconWidht)/2.0, IconWidht, IconWidht)];
        [self.titleLabel setFrame:RECT(self.iconImageIVew.x + self.iconImageIVew.width + 15, ([PersonCenterAccountCell getCellHeight] - 15)/2.0, SCREENWIDTH - 100, 15)];
        _titleLabel.textColor = KColorGray666;
        self.rightRow.hidden = YES;
        self.starView.hidden = YES;

    }
    
    [self.rightRow setFrame:CGRectMake(SCREENWIDTH - 15 - 15, ([PersonCenterAccountCell getCellHeight] - 15)/2.0, 15, 15)];
}


-(void)configData
{
    if (self.model) {
   
        if (self.model.isAccountLogin) {
            self.subtitleLabel.hidden = NO;
            _titleLabel.text = [BaseDataSingleton shareInstance].userModel.name?[BaseDataSingleton shareInstance].userModel.name:[BaseDataSingleton shareInstance].userModel.phone;
            _subtitleLabel.text = [NSString stringWithFormat:@"律所：%@",[BaseDataSingleton shareInstance].userModel.company?[BaseDataSingleton shareInstance].userModel.company:@"无"];
            [_iconImageIVew yy_setImageWithURL:[NSURL URLWithString:[BaseDataSingleton shareInstance].userModel.userIcon] placeholder:[UIImage imageNamed:self.model.iconNameStr]];
            
            [self.starView setScorePercent:([BaseDataSingleton shareInstance].userModel.stars)];
        }
        else{
            self.subtitleLabel.hidden = YES;
            self.starView.hidden = YES;
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.model.iconNameStr ofType:nil]];
            self.iconImageIVew.image = image;
            self.titleLabel.text = self.model.titleStr;
            
            if (self.model.isShowArrow) {
                self.rightRow.hidden = NO;
            }
            else {
                self.rightRow.hidden = YES;
            }
            
        }
    }
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    [kSeparatorColor setStroke];
    
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    [linePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [linePath stroke];
    
}

+(CGFloat)getCellHeight
{
    return LeftPadding*2 + IconWidht;
}

-(UIImageView *)iconImageIVew
{
    if (!_iconImageIVew) {
        _iconImageIVew = [[UIImageView alloc] init];
        _iconImageIVew.layer.cornerRadius = IconWidht/2.0;
        _iconImageIVew.layer.masksToBounds = YES;
    }
    return _iconImageIVew;
}


-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = KColorGray666;
        _titleLabel.font = SystemFont(15.0f);
    }
    return _titleLabel;
}


-(UIImageView*)rightRow
{
    if (!_rightRow) {
        _rightRow = [[UIImageView alloc] init];
        _rightRow.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rightRow.png" ofType:nil]];
        _rightRow.hidden = YES;

    }
    return _rightRow;
}


-(UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = SystemFont(13.0f);
        _subtitleLabel.textColor = KColorGray666;
        _subtitleLabel.hidden = YES;
    }
    return _subtitleLabel;
}

-(CWStarRateView *)starView
{
    if (!_starView) {
        _starView = [[CWStarRateView alloc] initWithFrame:RECT(self.titleLabel.x, CGRectGetMaxY(self.subtitleLabel.frame) + 10, 80, 15) numberOfStars:5];
        _starView.isAllowTap = NO;
    }
    return _starView;
}

@end
