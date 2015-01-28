//
//  ViewController.m
//  iTunesSearch
//
//  Created by Mohammed Safwat on 1/24/15.
//
//

#import "SearchMainViewController.h"
#import "SearchDataParser.h"
#import "SearchResultsCollectionViewCell.h"
#import "JMImageCache.h"

#define CELL_HEIGHT 50

@interface SearchMainViewController ()
@property (nonatomic, strong) SearchDataParser* searchDataParser;
@property (nonatomic, assign) NSInteger numberOfReturnedSearchResults;
@property (nonatomic, strong) NSMutableArray* finalReturnedSearchResults;
@end

@implementation SearchMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextField.delegate = self;
    
    self.searchResultsCollectionView.dataSource = self;
    self.searchResultsCollectionView.delegate = self;
    self.searchResultsCollectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Load the Search Results Collection View Cell
    [self.searchResultsCollectionView registerClass:[SearchResultsCollectionViewCell class] forCellWithReuseIdentifier:@"SearchResultsCollectionViewCell"];
    
    self.searchDataParser = [[SearchDataParser alloc]init];
    self.searchDataParser.scheduleDataParserDelegate = self;
    
    self.finalReturnedSearchResults = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark textFieldDelegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveTextFieldToTopWithAnimation:textField];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startSearching:textField.text];
}

- (void)startSearching:(NSString*)searchString
{
    [self.searchDataParser getSearchResults:searchString];
}

- (void)propagateFinalReturnedSearchResults:(NSMutableArray *)finalReturnedSearchResults
{
    self.numberOfReturnedSearchResults = finalReturnedSearchResults.count;
    self.finalReturnedSearchResults = finalReturnedSearchResults;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.searchResultsCollectionView reloadData];
}

- (void)moveTextFieldToTopWithAnimation:(UITextField*)textField
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         textField.transform = CGAffineTransformMakeTranslation(0, -self.view.frame.size.height * 0.32);
                         self.searchResultsCollectionView.transform = CGAffineTransformMakeTranslation(0, textField.frame.origin.y + textField.frame.size.height );
                     }
                     completion:^(BOOL finished){
                         self.searchResultsCollectionView.contentInset = UIEdgeInsetsMake(0, 0, textField.frame.size.height + textField.frame.origin.y, 0);
                     }];
}

#pragma mark UICollectionViewDelagtes

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfReturnedSearchResults;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultsCollectionViewCell *searchResultsCollectionViewCell = [self.searchResultsCollectionView dequeueReusableCellWithReuseIdentifier:@"SearchResultsCollectionViewCell"forIndexPath:indexPath];
    
    if(searchResultsCollectionViewCell == nil)
        searchResultsCollectionViewCell = [[SearchResultsCollectionViewCell alloc]init];
    
    searchResultsCollectionViewCell.layer.shouldRasterize = YES;
    searchResultsCollectionViewCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    searchResultsCollectionViewCell.mediaTitleLabel.text = [[self.finalReturnedSearchResults objectAtIndex:indexPath.item] objectForKey:@"trackName"];
    searchResultsCollectionViewCell.mediaArtistLabel.text = [[self.finalReturnedSearchResults objectAtIndex:indexPath.item] objectForKey:@"artistName"];
    NSURL* mediaImageURL = [NSURL URLWithString:[[self.finalReturnedSearchResults objectAtIndex:indexPath.item] objectForKey:@"artworkUrl100"]];
    [searchResultsCollectionViewCell.mediaImageView setImageWithURL:mediaImageURL key:nil placeholder:[UIImage imageNamed:@"mediaImagePlaceholder"] completionBlock:nil failureBlock:nil];
    searchResultsCollectionViewCell.frame = CGRectMake(0, searchResultsCollectionViewCell.frame.origin.y, searchResultsCollectionViewCell.frame.size.width, searchResultsCollectionViewCell.frame.size.height);
    return searchResultsCollectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(self.view.frame.size.width, CELL_HEIGHT);
    
    return cellSize;
}

@end
