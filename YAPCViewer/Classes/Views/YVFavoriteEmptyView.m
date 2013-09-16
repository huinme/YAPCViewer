//
//  YVFavoriteEmptyView.m
//  YAPCViewer
//
//  Created by kshuin on 9/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVFavoriteEmptyView.h"

const NSInteger YVFavoriteEmptyViewTag = 'emty';

@interface YVFavoriteEmptyView()

- (void)_setupViews;

@end

@implementation YVFavoriteEmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];
    }
    return self;
}

- (void)_setupViews
{
    UIImage *bgImage = [UIImage imageNamed:@"default_background"];
    self.backgroundColor = [UIColor colorWithPatternImage:bgImage];

    UIImage *image = [UIImage imageNamed:@"nofav"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((CGRectGetWidth(self.bounds)-image.size.width)/2.0f,
                                 (CGRectGetHeight(self.bounds)-image.size.height)/2.0f,
                                 image.size.width,
                                 image.size.height);

    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;

    NSLog(@"frame : %@", NSStringFromCGRect(imageView.frame));
    [self addSubview:imageView];
}

@end
