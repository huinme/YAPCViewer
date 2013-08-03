//
//  YVTalkListViewController.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTalkListViewController.h"

#import "HIDataStoreManager.h"
#import "YVModels.h"
#import "YVTalks.h"

#import "YVTalkCell.h"

static NSString *const kYVTalkListTalkCellIdentifier = @"kYVTalkListTalkCellIdentifier";
static NSString *const kYVTalkListTalksCacheName = @"kYVTalkListTalksCacheName";

@interface YVTalkListViewController ()
<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation YVTalkListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(!self.frController){
        NSFetchRequest *fr = [YVTalks allTalksFetchRequest];
        NSManagedObjectContext *moc = [HIDataStoreManager sharedManager].mainThreadMOC;
        self.frController = [[NSFetchedResultsController alloc] initWithFetchRequest:fr
                                                                managedObjectContext:moc
                                                                  sectionNameKeyPath:nil
                                                                           cacheName:kYVTalkListTalksCacheName];
        self.frController.delegate = self;
    }

    NSError *fetchError = nil;
    if(![self.frController performFetch:&fetchError]){
        NSLog(@"FETCH ERROR : %@", fetchError);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[YVTalks new] fetchAllTalksWithHandler:^(NSDictionary *dataDict, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.frController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = self.frController.sections[section];
    return [[sectionInfo objects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YVTalkCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:kYVTalkListTalkCellIdentifier];
    if(nil == cell){
        cell = [[YVTalkCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:kYVTalkListTalkCellIdentifier];
    }

    YVTalk *talk = [self.frController objectAtIndexPath:indexPath];
    [cell loadDataFromTalk:talk];

    return cell;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YVTalkCell cellHeight];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSFethedResultsControllerDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if(type == NSFetchedResultsChangeInsert){
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }else if(type == NSFetchedResultsChangeUpdate){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }else if(type == NSFetchedResultsChangeDelete){
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
