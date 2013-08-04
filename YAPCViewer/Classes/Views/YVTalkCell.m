//
//  YVTalkCell.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTalkCell.h"

#import "YVModels.h"

static const CGFloat kYVTalkCellHeight = 60.0f;

static NSString *const kYVTalkCellNormalBackgroundColor         = @"#fefefe";
static NSString *const kYVTalkCellTalkTitleNormalTextColor      = @"#0f0f0f";
static NSString *const kYVTalkCellTalkTitleSelectedTextColor    = @"#ffffff";
static NSString *const kYVTalkCellTimeNormalTextColor           = @"#5f5f5f";
static NSString *const kYVTalkCellTimeSelectedTextColor         = @"#ffffff";

@interface YVTalkCell()

- (void)_setupViews;

@end

@implementation YVTalkCell

+ (CGFloat)cellHeight
{
    return kYVTalkCellHeight;
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorForHex:kYVTalkCellNormalBackgroundColor];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
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
}

- (void)_setupViews
{
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [[self class] backgroundColor];
}

- (void)loadDataFromTalk:(YVTalk *)talk
{
    if(talk.title.length > 0){
        self.textLabel.text = talk.title;
    }else{
        self.textLabel.text = talk.title_en;
    }

    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", talk.start_time, talk.end_time];
}

@end
