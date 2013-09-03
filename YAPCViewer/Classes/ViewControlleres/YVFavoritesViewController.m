//
//  YVFavoritesViewController.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 9/1/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVFavoritesViewController.h"

#import "HIDataStoreManager.h"
#import "YVModels.h"

#import "YVTalks.h"
#import "YVTalkCell.h"
#import "YVSectionHeader.h"
#import "YVDogEarView.h"
#import "YVFavoriteEmptyView.h"

#import "YVTalkDetailViewController.h"
#import "YVDateFormatManager.h"

static NSString *const kYVFavoritesTalkCellIdentifier = @"kYVFavoritesTalkCellIdentifier";
static NSString *const kYVFavoritesTalkCacheName = @"kYVFavoritesTalkCacheName";

static NSString *const kYVFavoritesPushToDetailSegueIdentifier = @"PushFromFavoriteToTalkDetailView";

@interface YVFavoritesViewController ()
<UITableViewDataSource,
 UITableViewDelegate,
 NSFetchedResultsControllerDelegate,
 YVDogEarViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frController;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)_updateTableView;

- (void)_showEmptyView:(BOOL)show;

@end

@implementation YVFavoritesViewController

- (void)awakeFromNib
{
    self.view.backgroundColor = [YVTalkCell backgroundColor];
    
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = [YVTalkCell backgroundColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.frController) {
        [NSFetchedResultsController deleteCacheWithName:kYVFavoritesTalkCacheName];

        NSFetchRequest *fr = [YVTalks favoriteTalksRequest];
        NSManagedObjectContext *moc = [HIDataStoreManager sharedManager].mainThreadMOC;
        self.frController = [[NSFetchedResultsController alloc] initWithFetchRequest:fr
                                                                managedObjectContext:moc
                                                                  sectionNameKeyPath:@"start_date"
                                                                           cacheName:kYVFavoritesTalkCacheName];
        self.frController.delegate = self;
    }

    NSError *fetchError = nil;
    if (![self.frController performFetch:&fetchError]) {
        NSLog(@"FETCH ERROR : %@", fetchError.description);
    }
    [self _updateTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if([segue.identifier isEqualToString:kYVFavoritesPushToDetailSegueIdentifier]){
        NSAssert([sender isKindOfClass:[YVTalk class]], @"");

        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Talks"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self.navigationController
                                                                      action:@selector(popNavigationItemAnimated:)];
        self.navigationItem.backBarButtonItem = backButton;

        YVTalkDetailViewController *vc;
        vc = (YVTalkDetailViewController *)segue.destinationViewController;
        vc.talk = (YVTalk *)sender;
    }
}

- (void)_updateTableView
{
    NSInteger objectCount = self.frController.fetchedObjects.count;
    [self _showEmptyView: (0 == objectCount) ? YES : NO];
    [self.tableView reloadData];
}

- (void)_showEmptyView:(BOOL)show
{
    YVFavoriteEmptyView *emptyView = (YVFavoriteEmptyView *)[self.view viewWithTag:YVFavoriteEmptyViewTag];

    if (!show) {
        [emptyView removeFromSuperview];
        self.tableView.hidden = show;
        return;
    }

    
    if (!emptyView) {
        emptyView = [[YVFavoriteEmptyView alloc] initWithFrame:self.view.bounds];
        emptyView.tag = YVFavoriteEmptyViewTag;
    }

    [self.view addSubview:emptyView];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSsource
////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.frController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frController.sections[section];

    return [[sectionInfo objects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YVTalkCell *cell;
    cell = (YVTalkCell *)[tableView dequeueReusableCellWithIdentifier:kYVFavoritesTalkCellIdentifier];
    if (!cell) {
        cell = [[YVTalkCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:kYVFavoritesTalkCellIdentifier];
        cell.dogEarView.delegate = self;
    }

    YVTalk *talk = [self.frController objectAtIndexPath:indexPath];
    NSAssert(talk, @"");

    [cell loadDataFromTalk:talk];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = self.frController.sections[section];

    YVSectionHeader *header = [[YVSectionHeader alloc] initWithFrame:CGRectZero];
    header.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), 23.0f);

    [header setSectionTitle:[sectionInfo name]];
    return header;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    YVTalk *talk = [self.frController objectAtIndexPath:indexPath];
    NSAssert(talk, @"");
    [self performSegueWithIdentifier:kYVFavoritesPushToDetailSegueIdentifier
                              sender:talk];

}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YVTalkCell cellHeight];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSFetchedResultsControllerDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSError *fetchError = nil;
    if (![self.frController performFetch:&fetchError]) {
        NSLog(@"FETCH ERROR : %@", fetchError.localizedDescription);
        return;
    }
    [self _updateTableView];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - YVDogEarViewDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)dogEarView:(YVDogEarView *)dogEarView
    didChangeState:(BOOL)enabled
{
    YVTalkCell *talkCell = (YVTalkCell *)dogEarView.superview;
    NSAssert([talkCell isKindOfClass:[YVTalkCell class]], @"");

    NSIndexPath *indexPath = [self.tableView indexPathForCell:talkCell];
    YVTalk *talk = (YVTalk *)[self.frController objectAtIndexPath:indexPath];

    talk.favorite = @(enabled);

    NSManagedObjectContext *moc = self.frController.managedObjectContext;
    NSError *saveError = nil;

    [[HIDataStoreManager sharedManager] saveContext:moc
                                              error:&saveError];
    if(saveError){
        NSLog(@"SAVE ERROR : %@", [saveError description]);
    }
}

@end
