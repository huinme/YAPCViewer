//
//  YVTalkCell.m
//  YAPCViewer
//
//  Created by kshuin on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTalkCell.h"

#import <QuartzCore/QuartzCore.h>

#import "YVModels.h"
#import "YVDogEarView.h"

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
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    
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

    [self bringSubviewToFront:self.dogEarView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.size.width = 270.0f;
    self.textLabel.frame = textFrame;
}

- (void)_setupViews
{
    self.textLabel.backgroundColor = [UIColor redColor];
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [[self class] backgroundColor];

    CGRect earFrame = CGRectMake(CGRectGetWidth(self.bounds)-44.0f, 0.0f,
                                 44.0f, 44.0f);
    self.dogEarView = [[YVDogEarView alloc] initWithFrame:earFrame];
    [self insertSubview:self.dogEarView aboveSubview:self.contentView];
}

- (void)loadDataFromTalk:(YVTalk *)talk
{
    if(talk.title.length > 0){
        self.textLabel.text = talk.title;
    }else{
        self.textLabel.text = talk.title_en;
    }

    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ - %@",
                                                           talk.venue.name,
                                                           talk.start_time,
                                                           talk.end_time];

    NSParameterAssert(talk);
    self.dogEarView.enabled = talk.isFavorited;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (self.dogEarView == touch.view) {
        return;
    }

    [super touchesBegan:touches withEvent:event];
}

@end
