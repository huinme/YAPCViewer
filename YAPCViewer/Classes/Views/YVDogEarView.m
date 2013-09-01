//
//  YVDogEarView.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/26/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVDogEarView.h"

#import "YVModels.h"

#import <QuartzCore/QuartzCore.h>
#import <FontAwesomeKit/FontAwesomeKit.h>

@interface YVDogEarView()

@property (nonatomic, strong) UIImageView *starIconView;

- (void)_setupViews;
- (UIImage *)_backgroundImage;

@end

@implementation YVDogEarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];

        self.enabled = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [self _setupViews];
    self.enabled = YES;
}

- (BOOL)isEnabled
{
    return !self.starIconView.hidden;
}

- (void)setEnabled:(BOOL)enabled
{
    self.starIconView.hidden = !enabled;
}

- (void)loadDataFromTalk:(YVTalk *)talk
{
    self.talkId = talk.id;

    if(self.delegate
       && [self.delegate respondsToSelector:@selector(tappedFavorite:)]){
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc]initWithTarget:self.delegate action:@selector(tappedFavorite:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
}

- (void)_setupViews
{
    self.backgroundColor = [UIColor clearColor];

    UIImage *bgImage = [self _backgroundImage];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = self.bounds;
    [self addSubview:bgImageView];

    CGSize iconSize = CGSizeMake(14.0f, 14.0f);
    CGFloat iconFontSize = 14.0f;
    NSDictionary *shadowAttr = @{FAKShadowAttributeBlur : @(0.0f),
                                 FAKShadowAttributeColor : [UIColor darkGrayColor],
                                 FAKShadowAttributeOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.5f)]};
    NSDictionary *attrs = @{FAKImageAttributeForegroundColor : [UIColor whiteColor],
                            FAKImageAttributeBackgroundColor : [UIColor clearColor],
                            FAKImageAttributeShadow : shadowAttr};
    UIImage *starIcon = [FontAwesomeKit imageForIcon:FAKIconStar
                                           imageSize:iconSize
                                            fontSize:iconFontSize
                                          attributes:attrs];
    self.starIconView = [[UIImageView alloc] initWithImage:starIcon];
    self.starIconView.frame = CGRectMake(16.0f, 3.0f, 14.0f, 14.0f);
    [self addSubview:self.starIconView];
}

- (UIImage *)_backgroundImage
{
    // 14x18
    CGRect bounds = self.bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGMutablePathRef fillPath = CGPathCreateMutable();
    CGPathMoveToPoint(fillPath, NULL, 0.0f, 0.0f);
    CGPathAddLineToPoint(fillPath, NULL, CGRectGetWidth(bounds), 0.0f);
    CGPathAddLineToPoint(fillPath, NULL, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    CGPathAddLineToPoint(fillPath, NULL, 0.0f, 0.0f);
    CGPathCloseSubpath(fillPath);

    CGContextAddPath(ctx, fillPath);

    CGContextSetFillColorWithColor(ctx, [UIColor colorForHex:@"#808080"].CGColor);
    CGContextFillPath(ctx);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    CGPathRelease(fillPath);

    return image;
}

@end
