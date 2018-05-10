//
//  SearchViewController.m
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 05/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import "SearchViewController.h"
#import "Searcher.h"
#import "Track.h"
#import "TrackViewController.h"

@interface SearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) NSMutableArray *results;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *searchActivityIndicator;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownload:) name:@"imageDownload" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchTextField.placeholder = @"Enter keyword";
    self.searchTextField.delegate = self;
    [self.searchTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [self setupTableView];
    [self setupSearchActivityIndicator];
}

- (void)setupTableView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.bounds), 215)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, -(215/2), 0.0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupSearchActivityIndicator
{
    self.searchActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.searchActivityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.tableFooterView addSubview:self.searchActivityIndicator];
    [self.searchActivityIndicator.centerXAnchor constraintEqualToAnchor:self.tableView.centerXAnchor].active = YES;
    [self.searchActivityIndicator.centerYAnchor constraintEqualToAnchor:self.tableView.centerYAnchor].active = YES;
}

#pragma mark - table view data source and delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Track *track = self.results[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = track.artistName;
    cell.detailTextLabel.text = track.trackName;
    cell.imageView.image = [UIImage imageWithData:track.imageData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cellTapped:indexPath.row];
}

- (void)cellTapped:(NSInteger)row
{
    [self.navigationController pushViewController:[[TrackViewController alloc] initWithTrack:self.results[row]]
                                         animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - search text field delegate

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self resetSearchResults];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showSearchResultIfNeeded];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length >= 5)
    {
        [self showSearchResultIfNeeded];
    }
}

#pragma mark - helpers

- (void)resetSearchResults
{
    if (self.results.count > 0)
    {
        self.results = nil;
        [self.tableView reloadData];
    }
}

- (void)showSearchResultIfNeeded
{
    [self resetSearchResults];
    [self.searchActivityIndicator startAnimating];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showSearchResult) userInfo:nil repeats:NO];
}

- (void)showSearchResult
{
    [[Searcher sharedService] searchTrackByString:self.searchTextField.text withCompletion:^(NSArray *results){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchActivityIndicator stopAnimating];
            self.results = results.mutableCopy;
            [self.tableView reloadData];
        });
    }];
}

- (void)imageDownload:(NSNotification *)notif
{
    Track *track = [notif object];
    NSInteger index = track.index;
    __weak SearchViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.searchTextField.text isEqualToString:track.keyword])
        {
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:index inSection:0]];
            [weakSelf.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    });
}

@end
