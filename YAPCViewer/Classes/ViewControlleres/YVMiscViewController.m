//
//  YVMiscViewController.m
//  YAPCViewer
//
//  Created by huin on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVMiscViewController.h"

#import "TTTAttributedLabel.h"

@interface YVMiscViewController ()
<TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *acknowledgementLabel;

@end

@implementation YVMiscViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.delegate = self;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.frame = CGRectInset(self.view.bounds, 15.0f, 20.0f);
    label.dataDetectorTypes = NSTextCheckingTypeLink;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Acknowledgement" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    label.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [label sizeToFit];
    label.backgroundColor = self.view.backgroundColor;

    self.acknowledgementLabel = label;
    [self.view addSubview:self.acknowledgementLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
