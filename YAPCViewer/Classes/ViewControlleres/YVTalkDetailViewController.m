//
//  YVTalkDetailViewController.m
//  YAPCViewer
//
//  Created by kshuin on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTalkDetailViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "UIImageView+WebCache.h"
#import "YVDateFormatManager.h"
#import "TTTAttributedLabel.h"
#import "YVDogEarView.h"
#import "HIDataStoreManager.h"

@interface YVTalkDetailViewController ()
<TTTAttributedLabelDelegate,
 YVDogEarViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet YVDogEarView *dogYearView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet TTTAttributedLabel *venueLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet UIImageView *speakerImageView;
@property (nonatomic, weak) IBOutlet UILabel *speakerNameLabel;

@property (nonatomic, weak) IBOutlet TTTAttributedLabel *abstractLabel;

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *separatorLines;

- (void)_loadDataFromTalk:(YVTalk *)talk;

@end

@implementation YVTalkDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.speakerImageView.layer.cornerRadius = 3.0f;

    [self.separatorLines enumerateObjectsUsingBlock:^(UIView *line, NSUInteger idx, BOOL *stop) {
        line.layer.masksToBounds = NO;
        line.layer.shadowPath = [UIBezierPath bezierPathWithRect:line.bounds].CGPath;
        line.layer.shadowRadius = 0.0f;
        line.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
        line.layer.shadowOpacity = 0.5f;
        line.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    }];

    CGRect dogYearFrame = self.dogYearView.frame;
    self.dogYearView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)
                                         - CGRectGetWidth(dogYearFrame),
                                        0.0f,
                                        CGRectGetWidth(dogYearFrame),
                                        CGRectGetHeight(dogYearFrame));
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

    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@分)",
                           talk.start_time,
                           talk.end_time,
                           talk.duration];

    self.speakerNameLabel.text = [NSString stringWithFormat:@"%@(%@)",
                                                            talk.speaker.name,
                                                            talk.speaker.nickname];
    if(talk.speaker.profile_image_url){
        NSURL *url = [NSURL URLWithString:talk.speaker.profile_image_url];
        [self.speakerImageView setImageWithURL:url placeholderImage:nil];
    }
    
    self.abstractLabel.dataDetectorTypes = NSTextCheckingTypeLink;
    self.abstractLabel.text = talk.abstract.abstract;
    [self.abstractLabel sizeToFit];

    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = CGRectGetMinY(self.abstractLabel.frame)
                            + CGRectGetHeight(self.abstractLabel.frame)
                            + 20.0f;
    self.scrollView.contentSize = contentSize;

    NSParameterAssert(talk);
    self.dogYearView.delegate = self;
    self.dogYearView.enabled = talk.isFavorited;
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

////////////////////////////////////////////////////////////////////////////////
#pragma mark - YVDogEarViewDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)dogEarView:(YVDogEarView *)dogEarView
    didChangeState:(BOOL)enabled
{
    NSManagedObjectContext *moc = [HIDataStoreManager sharedManager].mainThreadMOC;
    YVTalk *talk = (YVTalk *)[moc objectWithID:self.talk.objectID];

    talk.favorite = @(enabled);
    [[HIDataStoreManager sharedManager] saveContext:moc error:nil];

    self.talk = talk;
    [self _loadDataFromTalk:talk];
}

@end
