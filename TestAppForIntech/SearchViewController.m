//
//  SearchViewController.m
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 05/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultCell.h"
#import "Searcher.h"

@interface SearchViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) NSMutableArray *results;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *searchActivityIndicator;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownload:) name:@"imageDownload" object:nil];
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
    NSString *cellNibName = NSStringFromClass([SearchResultCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName bundle:nil]
         forCellReuseIdentifier:@"cellID"];
    
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
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    NSDictionary *data = self.results[indexPath.row];
    [cell updateWithSong:data];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cellTapped:indexPath.row];
}

- (void)cellTapped:(NSInteger)row
{
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0;
}

#pragma mark - search text field delegate

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self resetSearchResults];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showSearchResult];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self showSearchResult];
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

- (void)showSearchResult
{
    [self resetSearchResults];
    
    [self.searchActivityIndicator startAnimating];
    
    [[Searcher sharedService] searchSongByString:self.searchTextField.text withCompletion:^(NSArray *results){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchActivityIndicator stopAnimating];
            self.results = results.mutableCopy;
            [self.tableView reloadData];
        });
    }];
}

- (void)imageDownload:(NSNotification *)notif
{
    NSDictionary *song = [notif object];
    int index = [song[@"index"] intValue];
    if (self.results[index])
    {
        self.results[index] = song;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

@end
