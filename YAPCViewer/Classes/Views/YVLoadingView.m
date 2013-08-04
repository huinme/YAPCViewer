//
//  YVLoadingView.m
//  YAPCViewer
//
//  Created by huin on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVLoadingView.h"

@interface YVLoadingView()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)_setupViews;

@end

@implementation YVLoadingView

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
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.indicatorView.hidesWhenStopped = YES;
    self.indicatorView.center = self.center;
    [self.indicatorView startAnimating];
    [self addSubview:self.indicatorView];
}

- (void)showInSuperView:(UIView *)superview
               animated:(BOOL)animated
{
    self.frame = superview.bounds;
    self.indicatorView.center = self.center;
    
    if(!animated){
        [superview addSubview:self];
        return;
    }
    
    self.alpha = 0.0f;
    [superview addSubview:self];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:NULL];
}

- (void)hideWithAnimated:(BOOL)animated
{
    if(!animated){
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
