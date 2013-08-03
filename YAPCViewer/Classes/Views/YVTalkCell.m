//
//  YVTalkCell.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTalkCell.h"

#import "YVModels.h"

static const CGFloat kYVTalkCellHeight = 65.0f;

@interface YVTalkCell()

@property (nonatomic, strong) UILabel *talkTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)_setupViews;

@end

@implementation YVTalkCell

+ (CGFloat)cellHeight
{
    return kYVTalkCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _setupViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_setupViews
{
    self.textLabel.hidden = YES;

    self.talkTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f,
                                                                   5.0f,
                                                                   CGRectGetWidth(self.bounds) - 30.0f,
                                                                   30.0f)];
    self.talkTitleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.talkTitleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.talkTitleLabel];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f,
                                                               40.0f,
                                                               CGRectGetWidth(self.bounds) - 30.0f,
                                                               13.0f)];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.numberOfLines = 1;
    [self.contentView addSubview:self.timeLabel];
}

- (void)loadDataFromTalk:(YVTalk *)talk
{
    if(talk.title.length > 0){
        self.talkTitleLabel.text = talk.title;
    }else{
        self.talkTitleLabel.text = talk.title_en;
    }

    self.timeLabel.text = talk.start_on;
}

@end
