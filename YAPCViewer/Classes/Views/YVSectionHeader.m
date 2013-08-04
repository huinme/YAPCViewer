//
//  YVSectionHeader.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVSectionHeader.h"

#import <QuartzCore/QuartzCore.h>

@interface YVSectionHeader()

@property (nonatomic, strong) UILabel *sectionTitleLabel;

- (void)_setupViews;

@end

@implementation YVSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CAGradientLayer *gradientLayer = [self.layer valueForKey:@"glayer"];
    if(!gradientLayer){
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.name = @"glayer";
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = @[(id)[UIColor colorWithGray:0.7f].CGColor,
                                 (id)[UIColor colorWithGray:0.8f].CGColor];
        [gradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
        [gradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
        gradientLayer.opacity = 0.7f;
        [self.layer insertSublayer:gradientLayer atIndex:0];
        [self.layer setValue:gradientLayer forKey:gradientLayer.name];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIView *topline = [self viewWithTag:'tpln'];
    topline.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), 1.0f);

    UIView *bottomline = [self viewWithTag:'btln'];
    bottomline.frame = CGRectMake(0.0f, CGRectGetHeight(self.bounds)-1.0f, CGRectGetWidth(self.bounds), 1.0f);
}

- (void)_setupViews
{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    self.sectionTitleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.sectionTitleLabel.textColor = [UIColor colorForHex:@"#262626"];
    self.sectionTitleLabel.numberOfLines = 1;
    self.sectionTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.sectionTitleLabel.shadowColor = [UIColor whiteColor];
    self.sectionTitleLabel.shadowOffset = CGSizeMake(0.0f, 1.0);
    self.sectionTitleLabel.backgroundColor = [UIColor clearColor];

    [self addSubview:self.sectionTitleLabel];

    UIView *topline = [[UIView alloc] initWithFrame:CGRectZero];
    topline.tag = 'tpln';
    topline.backgroundColor = [UIColor colorForHex:@"#c9c9c9"];
    [self addSubview:topline];

    UIView *bottomline = [[UIView alloc] initWithFrame:CGRectZero];
    bottomline.tag = 'btln';
    bottomline.backgroundColor = [UIColor colorForHex:@"#b1b1b1"];
    [self addSubview:bottomline];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    self.sectionTitleLabel.frame = CGRectInset(self.bounds, 10.0f, 0.0f);
}

- (void)setSectionTitle:(NSString *)sectionTitle
{
    self.sectionTitleLabel.text = sectionTitle;
}

- (NSString *)sectionTitle
{
    return self.sectionTitleLabel.text;
}

@end
