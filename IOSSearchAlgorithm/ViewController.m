//
//  ViewController.m
//  IOSSearchAlgorithm
//
//  Created by ixshells on 16/3/20.
//  Copyright © 2016年 ixshells. All rights reserved.
//

#import "ViewController.h"
#import "SearchKeywordsAlgorithm.h"

#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height)
#define fSelfViewWidth (self.view.bounds.size.width)
#define fSelfViewHeight (self.view.bounds.size.height)

#define RGB_A(r, g, b, a) ([UIColor colorWithRed:(r)/255.0f \
green:(g)/255.0f \
blue:(b)/255.0f \
alpha:(a)/255.0f])

#define RGB(r, g, b) RGB_A(r, g, b, 255)

@interface ViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
{
    UISearchBar * _searchBar;
    UISearchDisplayController * _searchDisplayController;
    UITableView * _tableView;
    NSArray *_tagArray;
    NSMutableArray* _searchResultArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    [[[[ _searchBar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    
    _tagArray = [self readLocalData];
    _searchResultArray = [NSMutableArray new];
    
    _searchBar.backgroundColor = RGB(248, 94, 32);
    [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_searchBar sizeToFit];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fSelfViewWidth, 460)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _searchBar;
    _tableView.tableHeaderView.backgroundColor = RGB(248, 94, 32);
    [self.view addSubview:_tableView];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate = self;
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setSearchResultsDelegate:self];
    
    
}

-(NSArray *)readLocalData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"keyword"ofType:@"csv"];
    
    NSString *contents = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSInteger idx;
    for (idx = 0; idx < contentsArray.count; idx++){
        NSString* currentContent = [contentsArray objectAtIndex:idx];
        NSLog(@"%@",currentContent);
    }
    
    return contentsArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)searchFilter : (NSString *)searchText
{
    SearchKeywordsAlgorithm* search = [SearchKeywordsAlgorithm new];
    [search searchByFuzzy:_tagArray keyStr:searchText];
    
    _searchResultArray = search.fullStringResultArray;
}

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _searchDisplayController.searchResultsTableView)
    {
        return [_searchResultArray count];
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    {
        cell.textLabel.text = [_searchResultArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchFilter:searchText];
}
#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    /*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
    [_searchDisplayController.searchResultsTableView setDelegate:self];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
{
    
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;                   // called when bookmark button pressed
{
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;                     // called when cancel button pressed
{
    
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2); // called when search results button pressed
{
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
    [_searchBar resignFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
