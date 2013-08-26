//
//  YVTalkDetailViewController.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTalkDetailViewController.h"

#import "YVDateFormatManager.h"
#import "TTTAttributedLabel.h"

@interface YVTalkDetailViewController ()
<TTTAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *venueLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet TTTAttributedLabel *abstractLabel;

- (void)_loadDataFromTalk:(YVTalk *)talk;

@end

@implementation YVTalkDetailViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

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

    self.venueLabel.text = talk.venue.name;

    NSDateFormatter *df = [YVDateFormatManager sharedManager].defaultFormatter;
    df.dateFormat = YVDateFormatManagerJapaneseDateFormat;

    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ (%@分)",
                           [df stringFromDate:talk.event_date],
                           talk.start_time,
                           talk.end_time,
                           talk.duration];
    
    self.abstractLabel.dataDetectorTypes = NSTextCheckingTypeLink;
    self.abstractLabel.text = talk.abstract.abstract;
    [self.abstractLabel sizeToFit];

    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = CGRectGetMinY(self.abstractLabel.frame)
                            + CGRectGetHeight(self.abstractLabel.frame)
                            + 20.0f;
    self.scrollView.contentSize = contentSize;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - TTTAttributedLabelDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
