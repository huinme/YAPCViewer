//
//  YVLoadingView.h
//  YAPCViewer
//
//  Created by huin on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YVLoadingView : UIView

- (void)showInSuperView:(UIView *)superview
               animated:(BOOL)animated;

- (void)hideWithAnimated:(BOOL)animated;

@end
