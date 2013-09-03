//
//  YVFavoriteEmptyView.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 9/4/13.
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
}

@end
