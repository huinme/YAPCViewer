//
//  YVEventDayView.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVEventDayView.h"

#import <QuartzCore/QuartzCore.h>

#import "YVDateFormatManager.h"

static NSString *const kYVEventDayViewBackgroundColor = @"#d5d5d5";
static NSString *const kYVEventDayViewShadowLineColor = @"#aeaeae";

@interface YVEventDayView()

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UIButton *prevButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic, assign) NSInteger currentEventDaysIndex;

- (void)_setupViews;

- (void)_prevButtonDidTapped:(id)sender;
- (void)_nextButtonDidTapped:(id)sender;

- (void)_displayDateForCurrentIndex;
- (void)_updateButtonStateForIndex:(NSInteger)index;

- (UIImage *)_prevButtonImage:(BOOL)highlighted;
- (UIImage *)_nextButtonImage:(BOOL)highlighted;

@end

@implementation YVEventDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _setupViews];
}

- (void)setEventDays:(NSArray *)eventDays
{
    NSParameterAssert(eventDays);
    [eventDays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj isKindOfClass:[NSString class]], @"Object contained in eventDays must be kind of NSString class.");
    }];

    _eventDays = eventDays;

    self.currentEventDaysIndex = 0;

    [self _displayDateForCurrentIndex];

    [self _updateButtonStateForIndex:self.currentEventDaysIndex];
}

- (void)_setupViews
{
    self.backgroundColor = [UIColor colorForHex:kYVEventDayViewBackgroundColor];

    self.prevButton.backgroundColor = self.backgroundColor;
    [self.prevButton setImage:[self _prevButtonImage:NO] forState:UIControlStateNormal];
    [self.prevButton setImage:[self _prevButtonImage:YES] forState:UIControlStateHighlighted];
    [self.prevButton addTarget:self
                        action:@selector(_prevButtonDidTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.prevButton];
    

    self.nextButton.backgroundColor = self.backgroundColor;
    [self.nextButton setImage:[self _nextButtonImage:NO] forState:UIControlStateNormal];
    [self.nextButton setImage:[self _nextButtonImage:YES] forState:UIControlStateHighlighted];    
    [self.nextButton addTarget:self
                        action:@selector(_nextButtonDidTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextButton];

    
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectZero];
    shadow.frame = CGRectMake(0.0f, CGRectGetHeight(self.bounds)-1.0f,
                              CGRectGetWidth(self.bounds), 1.0f);
    shadow.backgroundColor = [UIColor colorForHex:kYVEventDayViewShadowLineColor];
    [self addSubview:shadow];
}

- (void)_prevButtonDidTapped:(id)sender
{
    NSInteger index = self.currentEventDaysIndex;
    if(index - 1 >= 0){
        self.currentEventDaysIndex -= 1;
    }

    [self _displayDateForCurrentIndex];
}

- (void)_nextButtonDidTapped:(id)sender
{
    NSInteger index = self.currentEventDaysIndex;
    if(index + 1 <= self.eventDays.count){
        self.currentEventDaysIndex += 1;
    }

    [self _displayDateForCurrentIndex];
}

- (void)_displayDateForCurrentIndex
{
    NSString *dayString = self.eventDays[self.currentEventDaysIndex];
    NSDateFormatter *df = [YVDateFormatManager sharedManager].defaultFormatter;
    df.dateFormat = YVDateFormatManagerShortDateFormat;
    NSDate *date = [df dateFromString:dayString];

    df = [YVDateFormatManager sharedManager].japaneseDateFormatter;
    self.dateLabel.text = [df stringFromDate:date];

    if(self.delegate
       && [self.delegate respondsToSelector:@selector(eventDayView:dayDidChanged:)]){
        [self.delegate eventDayView:self dayDidChanged:dayString];
    }

    [self _updateButtonStateForIndex:self.currentEventDaysIndex];
}

- (void)_updateButtonStateForIndex:(NSInteger)index
{
    if(0 == index){
        self.prevButton.enabled = NO;
    }else{
        self.prevButton.enabled = YES;
    }

    if(self.eventDays.count-1 == index){
        self.nextButton.enabled = NO;
    }else{
        self.nextButton.enabled = YES;
    }
}

- (UIImage *)_prevButtonImage:(BOOL)highlighted
{
    // 14x18
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(14.0f, 18.0f), NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGMutablePathRef fillPath = CGPathCreateMutable();
        CGPathMoveToPoint(fillPath, NULL, 14.0f, 0.0f);
        CGPathAddLineToPoint(fillPath, NULL, 0.0f, 9.0f);
        CGPathAddLineToPoint(fillPath, NULL, 14.0f, 18.0f);
        CGPathMoveToPoint(fillPath, NULL, 14.0f, 0.0f);
        CGPathCloseSubpath(fillPath);
    CGContextAddPath(ctx, fillPath);

    CGContextSetShadowWithColor(ctx, CGSizeMake(0.0f, 1.0f), 0.0f, [UIColor whiteColor].CGColor);
    if(highlighted){
        CGContextSetFillColorWithColor(ctx, [UIColor colorForHex:@"#484848"].CGColor);
    }else{
        CGContextSetFillColorWithColor(ctx, [UIColor colorForHex:@"#727272"].CGColor);
    }
    CGContextDrawPath(ctx, kCGPathFill);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    CGPathRelease(fillPath);
    
    return image;
}

- (UIImage *)_nextButtonImage:(BOOL)highlighted
{
    // 14x18
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(14.0f, 18.0f), NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGMutablePathRef fillPath = CGPathCreateMutable();
        CGPathMoveToPoint(fillPath, NULL, 0.0f, 0.0f);
        CGPathAddLineToPoint(fillPath, NULL, 14.0f, 9.0f);
        CGPathAddLineToPoint(fillPath, NULL, 0.0f, 18.0f);
        CGPathMoveToPoint(fillPath, NULL, 0.0f, 0.0f);
        CGPathCloseSubpath(fillPath);
    CGContextAddPath(ctx, fillPath);

    CGContextSetShadowWithColor(ctx, CGSizeMake(0.0f, 1.0f), 0.0f, [UIColor whiteColor].CGColor);
    if(highlighted){
        CGContextSetFillColorWithColor(ctx, [UIColor colorForHex:@"#484848"].CGColor);
    }else{
        CGContextSetFillColorWithColor(ctx, [UIColor colorForHex:@"#727272"].CGColor);
    }
    CGContextFillPath(ctx);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    CGPathRelease(fillPath);

    return image;
}

@end
