//
//  YVDogEarView.m
//  YAPCViewer
//
//  Created by kshuin on 8/26/13.
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

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    self.enabled = !self.isEnabled;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dogEarView:didChangeState:)]) {
        [self.delegate dogEarView:self didChangeState:self.isEnabled];
    }
}

- (void)_setupViews
{
    self.backgroundColor = [UIColor clearColor];

    UIImage *bgImage = [self _backgroundImage];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = self.bounds;
    [self addSubview:bgImageView];

    static const CGFloat iconHeight = 14.0f;
    CGSize iconSize = CGSizeMake(iconHeight, iconHeight);
    NSDictionary *shadowAttr = @{FAKShadowAttributeBlur : @(0.0f),
                                 FAKShadowAttributeColor : [UIColor darkGrayColor],
                                 FAKShadowAttributeOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.5f)]};
    NSDictionary *attrs = @{FAKImageAttributeForegroundColor : [UIColor whiteColor],
                            FAKImageAttributeBackgroundColor : [UIColor clearColor],
                            FAKImageAttributeShadow : shadowAttr};
    UIImage *starIcon = [FontAwesomeKit imageForIcon:FAKIconStar
                                           imageSize:iconSize
                                            fontSize:iconHeight
                                          attributes:attrs];
    self.starIconView = [[UIImageView alloc] initWithImage:starIcon];
    self.starIconView.frame = CGRectMake(25.5f, 5.0f, iconHeight, iconHeight);
    [self addSubview:self.starIconView];
}

- (UIImage *)_backgroundImage
{
    // 32x32
    CGRect bounds = self.bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGMutablePathRef fillPath = CGPathCreateMutable();
    CGPathMoveToPoint(fillPath, NULL, 8.0f, 0.0f);
    CGPathAddLineToPoint(fillPath, NULL, CGRectGetWidth(bounds), 0.0f);
    CGPathAddLineToPoint(fillPath, NULL, CGRectGetWidth(bounds), 36.0f);
    CGPathAddLineToPoint(fillPath, NULL, 8.0f, 0.0f);
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
