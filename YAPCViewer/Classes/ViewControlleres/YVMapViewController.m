//
//  YVMapsViewController.m
//  YAPCViewer
//
//  Created by huin on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVMapViewController.h"

static const CGFloat kYVMapViewMapMinimumZoomScale = 1.0f;
static const CGFloat kYVMapViewMapMaximumZoomScale = 2.0f;

@interface YVMapViewController ()
<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *mapView;
@property (nonatomic, strong) IBOutlet UIImageView *mapImageView;

- (void)_handleDoubleTapGesture:(UITapGestureRecognizer *)tapGR;

@end

@implementation YVMapViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIImage *bgImage = [UIImage imageNamed:@"default_background"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.minimumZoomScale = kYVMapViewMapMinimumZoomScale;
    self.mapView.maximumZoomScale = kYVMapViewMapMaximumZoomScale;

    UITapGestureRecognizer *tapGR = nil;
    tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(_handleDoubleTapGesture:)];
    tapGR.numberOfTapsRequired = 2;
    tapGR.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:tapGR];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.mapView.frame = self.view.bounds;
    self.mapView.contentSize = self.mapImageView.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.mapImageView = nil;
    self.mapView = nil;
}

- (void)_handleDoubleTapGesture:(UITapGestureRecognizer *)tapGR
{
    CGPoint touchPoint = [tapGR locationInView:self.mapView];
    CGFloat currentScale = self.mapView.zoomScale;
    CGRect zoomRect = CGRectZero;
    if (currentScale < kYVMapViewMapMaximumZoomScale) {
        // zoom
        zoomRect = [self _zoomRectForScrollView:self.mapView
                                      withScale:kYVMapViewMapMaximumZoomScale
                                     withCenter:touchPoint];
    }else{
        // wide
        zoomRect = [self _zoomRectForScrollView:self.mapView
                                      withScale:kYVMapViewMapMinimumZoomScale
                                     withCenter:touchPoint];
    }

    [self.mapView zoomToRect:zoomRect animated:YES];
}

- (CGRect)_zoomRectForScrollView:(UIScrollView *)scrollView
                       withScale:(float)scale
                      withCenter:(CGPoint)center
{
    CGRect zoomRect;

    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;

    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);

    return zoomRect;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate
////////////////////////////////////////////////////////////////////////////////

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapImageView;
}

@end
