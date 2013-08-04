//
//  YVTalkDetailViewController.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTalkDetailViewController.h"

#import "YVDateFormatManager.h"

@interface YVTalkDetailViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet UITextView *abstractTextView;

- (void)_loadDataFromTalk:(YVTalk *)talk;

@end

@implementation YVTalkDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self _loadDataFromTalk:self.talk];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(CGRectGetHeight(self.scrollView.bounds) < self.scrollView.contentSize.height){
        [self.scrollView flashScrollIndicators];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadDataFromTalk:(YVTalk *)talk
{
    if(talk.title.length > 0){
        self.titleLabel.text = talk.title;
    }else{
        self.titleLabel.text = talk.title_en;
    }

    NSDateFormatter *df = [YVDateFormatManager sharedManager].defaultFormatter;
    df.dateFormat = YVDateFormatManagerJapaneseDateFormat;

    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ (%@分)",
                           [df stringFromDate:talk.event_date],
                           talk.start_time,
                           talk.end_time,
                           talk.duration];

    NSString *abstractText = talk.abstract.abstract;
    CGSize textSize = [abstractText sizeWithFont:[UIFont systemFontOfSize:14.0f]
                               constrainedToSize:CGSizeMake(260.0f, INT_MAX)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    self.abstractTextView.contentSize = textSize;

    self.abstractTextView.text = abstractText;

    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = self.abstractTextView.frame.origin.y
                            + CGRectGetHeight(self.abstractTextView.bounds)
                            + 20.0f;
    self.abstractTextView.contentSize = contentSize;
}

@end
