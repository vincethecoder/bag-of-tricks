//
//  MasterViewController.m
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "GameListController.h"
#import "GameListDetailViewController.h"
#import "GameSearchResultsController.h"
#import "SWRevealViewController.h"

#import "GameCell.h"
#import "SearchResult.h"

#import "VGSHttpRequest.h"
#import "VGSConstants.h"
#import "VGSUtils.h"

typedef NS_ENUM(NSInteger, GameSubviewsIndex) {
    SearchBarIndex = 0,
    NoMatchLabelIndex
};


@interface GameListController () <VGSDataModificationDelegate,
UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
UISearchControllerDelegate,
UISearchResultsUpdating>

{
    NSUserDefaults *userDefaults;
}
@property NSMutableArray *gameList;
@property NSDictionary *lastSearchTerm;
@property (nonatomic, readwrite, weak) id<VGSDataModificationDelegate> gameSearchResultsDelegate;


@property (nonatomic, strong) UISearchController *searchController;
// our secondary search results table view
@property (nonatomic, strong) GameSearchResultsController *resultsTableController;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@property (nonatomic, readwrite, strong) UIView *nomatchesView;
@property (nonatomic, readwrite, strong) UILabel *matchesLabel;

@property (nonatomic, readwrite, strong) UIRefreshControl *refreshControl;

@end

@implementation GameListController

@synthesize gameList;
@synthesize gameTableView;
@synthesize lastSearchTerm;
@synthesize gameDetailViewController;

@synthesize searchController;
@synthesize resultsTableController;
@synthesize searchControllerWasActive;
@synthesize searchControllerSearchFieldWasFirstResponder;

@synthesize nomatchesView;
@synthesize matchesLabel;
@synthesize refreshControl;

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (!gameList) {
        gameList = [gameList init];
    }
    if (!userDefaults) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    NSString *defaultSearchTerms = [userDefaults valueForKey:UserDefaultSearchParams];
    NSString * searchTerm = GameSearchDefaultParam;
    if (searchTerm.length == 0) {
        searchTerm = defaultSearchTerms;
    }
    
    NSMutableDictionary * requestParams = [[GiantBomb gBasebHttpUrlParams] mutableCopy];
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:
                  NSASCIIStringEncoding];
    [requestParams addEntriesFromDictionary:@{GameHttpQueryParam:searchTerm}]; // Default Search terms
    [self requestVideoGames:requestParams];
}

- (void)setupRefreshControl
{
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self
                       action:@selector(refreshGameList)
             forControlEvents:UIControlEventValueChanged];
    [gameTableView addSubview:refreshControl];
}

- (void)requestVideoGames:(NSDictionary*)searchTerms
{
    lastSearchTerm = searchTerms;
    VGSHttpRequest * videoGameSearchRequest = [VGSHttpRequest initGETRequest: GB_BASE_SERVICE_URL withData: searchTerms];
    
    [videoGameSearchRequest setDelegate:self];
    
    VGSBlockWeakSelf blockSelf = self;
    [videoGameSearchRequest executeWithBlock:^(NSHTTPURLResponse *httpResponse, NSData *data, NSError *error) {
        GameListController *weakSelf =  blockSelf;
        if (!weakSelf) return;
    }];
}

- (void)refreshGameList
{
    [self requestVideoGames:lastSearchTerm];
}

- (void)updateGameList:(GiantBomb *)searchResults
{
    [self invokeRefreshControl];
    
    searchController.active = NO;
    if (searchResults && searchResults.results && searchResults.results.count > 0) {
        gameList = [searchResults.results mutableCopy];
    }
    
    if (gameList.count > 0) {
        nomatchesView.hidden = YES;
    } else {
        nomatchesView.hidden = NO;
    }
    [gameTableView reloadData];
    
}

- (void) disableNetworkIndicatorWithErrorMessage:(NSString*)message
{
    [self invokeRefreshControl];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (message.length > 0) {
        gameList = [@[] mutableCopy];
        [gameTableView reloadData];
        matchesLabel.text = message;
        nomatchesView.hidden = NO;
        matchesLabel.frame = CGRectMake(8.0f, 20.0f, 320.0f, 100.0f);
    } else if (gameList.count == 0){
        nomatchesView.hidden = NO;
    } else {
        nomatchesView.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleNavigationBarWithFontName:@"GillSans-Bold"];
    
    self.gameTableView.dataSource = self;
    self.gameTableView.delegate = self;
    
    self.gameTableView.backgroundColor = [UIColor whiteColor];
    self.gameTableView.separatorColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    
    [self setupRefreshControl];
    [self setupSearchController];
    [self configureNoMatchFoundView];
    
    gameDetailViewController = (GameListDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)invokeRefreshControl
{
    // End the refreshing
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}

- (void)setupSearchController
{
    resultsTableController = [[GameSearchResultsController alloc] init];
    searchController = [[UISearchController alloc] initWithSearchResultsController:resultsTableController];
    searchController.searchResultsUpdater = self;
    [searchController.searchBar sizeToFit];
    searchController.searchBar.placeholder = NSLocalizedString(@"Ex. Nintendo, PS4 or xBox ONE", @"Sample Search Terms");
    gameTableView.tableHeaderView = searchController.searchBar;
    
    resultsTableController.tableView.delegate = self;
    searchController.delegate = self;
    searchController.dimsBackgroundDuringPresentation = YES;
    searchController.searchBar.delegate = self;
    
    searchController.active = NO;
    
    self.definesPresentationContext = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString * searchTerm = searchBar.text;
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSMutableDictionary * requestParams = [[GiantBomb gBasebHttpUrlParams] mutableCopy];
    [requestParams addEntriesFromDictionary:@{GameHttpQueryParam: searchTerm}];
    
    [self requestVideoGames:requestParams];
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

- (void)presentSearchController:(UISearchController *)msearchController {
    VGSLogInfo(@"***presentSearchController");
    [searchController setActive:NO];
    [searchController resignFirstResponder];
    
    
    // restore the searchController's active state
    if (searchControllerWasActive) {
        self.searchController.active = !self.searchControllerWasActive;
        searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}


- (void)willPresentSearchController:(UISearchController *)msearchController {
    VGSLogInfo(@"willPresentSearchController");
    [searchController.searchBar resignFirstResponder];
    
}

- (void)didPresentSearchController:(UISearchController *)msearchController {
    VGSLogInfo(@"****didPresentSearchController");
    [searchController.searchBar resignFirstResponder];
}

- (void)willDismissSearchController:(UISearchController *)msearchController {
    VGSLogInfo(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    VGSLogInfo(@"didDismissSearchController");
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    VGSLogInfo(@"searchBarTextDidBeginEditing");
    [searchController setActive:NO];
}

- (BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    VGSLogInfo(@"searchBarCancelButtonClicked");
}

- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active
{
    VGSLogInfo(@"searchBar - activate");
    [searchBar setShowsCancelButton:active animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    VGSLogInfo(@"updateSearchResultsForSearchController");
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    VGSLogInfo(@"searchBar - textDidChange");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:GameDetailIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *object = self.gameList[indexPath.row];
        GameListDetailViewController *controller  = (GameListDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        [controller setSelectedGame:self.gameList[indexPath.row]];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (gameList.count == 0) {
        gameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    gameTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return gameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GameCell *cell = [tableView dequeueReusableCellWithIdentifier:GameCellIdentifier forIndexPath:indexPath];
    [self configureGameCell:cell forVideoGame:gameList[indexPath.row]];
    return cell;
}

- (void)configureGameCell:(GameCell *)cell forVideoGame:(SearchResult *)videoGame
{
    cell.title.text     = videoGame.name;
    cell.desc.text      = videoGame.desc;
    cell.postDate.text  = videoGame.postDate;
    cell.reviews.text   = videoGame.reviews;
    
    [VGSUtils cellImage:videoGame.imageURL withUIImageView:cell.iconView];
}

- (void)styleNavigationBarWithFontName:(NSString*)navigationTitleFont
{
    UIColor *color = [UIColor colorWithRed:65.0/255 green:75.0/255 blue:89.0/255 alpha:1.0];
    
    [VGSUtils styleNavigationBar:self.navigationController.navigationBar withFontName:navigationTitleFont andColor:color];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ql_logo.png"]];
    logoView.frame = CGRectMake(0, 0, 48, 40);
    UIBarButtonItem *mainLogo = [[UIBarButtonItem alloc] initWithCustomView:logoView];
    self.navigationItem.leftBarButtonItem = mainLogo;
    
    if (IS_IPHONE && !IS_IPHONE_6PLUS) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"menu48.png"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 28.0f, 24.0f)];
        [button addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [menuButton setIsAccessibilityElement:YES];
        [menuButton setAccessibilityLabel:@"menuButton"];
        /// Allows to add multiple buttons in the future
        [self.navigationItem setRightBarButtonItems:@[menuButton] animated:YES];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)configureNoMatchFoundView
{
    nomatchesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 2, self.view.frame.size.height)];
    
    float xAxis = (SCREEN_WIDTH - 100)/2;
    float yAxis = (SCREEN_HEIGHT - 100)/2;
    
    matchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(xAxis,yAxis,320.0f,100.0f)];
    
    UIColor* lightColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    NSString* fontName = @"GillSans";
    matchesLabel.font = [UIFont fontWithName:fontName size:15.0f];
    matchesLabel.shadowColor = [UIColor lightTextColor];
    matchesLabel.textColor = lightColor;
    matchesLabel.shadowOffset = CGSizeMake(0, 1);
    matchesLabel.backgroundColor = [UIColor clearColor];
    
    // Text when there are no results
    matchesLabel.text = NSLocalizedString(@"No Match Found", @"No Match Found Message");
    nomatchesView.backgroundColor = [UIColor colorWithRed: 180.0/255.0 green: 238.0/255.0 blue:180.0/255.0 alpha: 1.0];
    
    nomatchesView.hidden = YES;
    [nomatchesView addSubview:matchesLabel];
    [gameTableView insertSubview:nomatchesView atIndex:NoMatchLabelIndex];
}

@end
