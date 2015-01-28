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
#import "SearchResultDetailsViewController.h"

#define CELL_HEIGHT 50
#define SEARCH_RESULT_DETAILS_SEGUE @"SearchResultDetailsSegue"

@interface SearchMainViewController ()
@property (nonatomic, strong) SearchDataParser* searchDataParser;
@property (nonatomic, assign) NSInteger numberOfReturnedSearchResults;
@property (nonatomic, strong) NSMutableArray* finalReturnedSearchResults;
@property (nonatomic, strong) UILabel* searchResultsNumberLabel;
@end

@implementation SearchMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create an instance from the SearchDataParser class
    self.searchDataParser = [[SearchDataParser alloc]init];
    //Set the delegate of SearchDataParser class
    self.searchDataParser.scheduleDataParserDelegate = self;
    
    //A mutable array that will be filled with the returned final search results
    //after the SearchDataParser finishes its work
    self.finalReturnedSearchResults = [[NSMutableArray alloc]init];

    //Set search text field delegate
    self.searchTextField.delegate = self;
    
    //Set search results collection view deleagate and data source
    self.searchResultsCollectionView.dataSource = self;
    self.searchResultsCollectionView.delegate = self;
    //Set search results collection frame to hold the frame of the current view
    self.searchResultsCollectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.searchResultsCollectionView.allowsSelection = YES;
    //Load the Search Results Collection View Cell
    [self.searchResultsCollectionView registerClass:[SearchResultsCollectionViewCell class] forCellWithReuseIdentifier:@"SearchResultsCollectionViewCell"];
    //A label that will hold the number of returned search results
    self.searchResultsNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, self.view.frame.size.width * 0.8, 20)];
    [self.searchResultsNumberLabel setFont:[UIFont fontWithName:@"GillSans" size:14]];
    
    //Set this to remove the additional automatically generated top space
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    //Move the text field to the top of view with animation
    //and bring the collection view to the below if it
    [self moveTextFieldToTopWithAnimation:textField];
    //Show the progress HUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //Start searching, the search request is done in background
    [self startSearching:textField.text];
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

- (void)startSearching:(NSString*)searchString
{
    [self.searchDataParser getSearchResults:searchString];
}

#pragma mark SearchResultsCollectionView delegates

- (void)propagateFinalReturnedSearchResults:(NSMutableArray *)finalReturnedSearchResults withError:(NSError *)error
{
    //Hide prgress HUD
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //If the returned search results array is not equal to nil and
    //we don't have any errors, we display the search results
    if(finalReturnedSearchResults != nil && error == nil)
    {
        //Set the number of returned search results
        self.numberOfReturnedSearchResults = finalReturnedSearchResults.count;
        //Update the header label holding the returned search results number
        self.searchResultsNumberLabel.text = [NSString stringWithFormat:@"Found %d search results.", finalReturnedSearchResults.count];
        //Set the returned search results array
        self.finalReturnedSearchResults = finalReturnedSearchResults;
        //Reload collection view
        [self.searchResultsCollectionView reloadData];
    }
    else
    {
        //If we get an internet connection error
        if([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
        {
            [self showAlertViewWithTitle:@"iTunes Search Error" andMessage:@"The Internet connection appears to be offline. Please connect to internet and try again."];
        }
        else //For other errors
        {
            [self showAlertViewWithTitle:@"iTunes Search Error" andMessage:@"An error happened while doing search. Please try again."];
        }
    }
}

- (void)showAlertViewWithTitle:(NSString*)title andMessage:(NSString*)message
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
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
    
    searchResultsCollectionViewCell.separatorView.frame = CGRectMake(searchResultsCollectionViewCell.separatorView.frame.origin.x, searchResultsCollectionViewCell.separatorView.frame.origin.y, self.view.frame.size.width, searchResultsCollectionViewCell.separatorView.frame.size.height);
    
    searchResultsCollectionViewCell.mediaArtistLabel.frame = CGRectMake(searchResultsCollectionViewCell.mediaArtistLabel.frame.origin.x, searchResultsCollectionViewCell.mediaArtistLabel.frame.origin.y, searchResultsCollectionViewCell.frame.size.width * 0.75, searchResultsCollectionViewCell.mediaArtistLabel.frame.size.height);
    
    searchResultsCollectionViewCell.mediaTitleLabel.frame = CGRectMake(searchResultsCollectionViewCell.mediaTitleLabel.frame.origin.x, searchResultsCollectionViewCell.mediaTitleLabel.frame.origin.y, searchResultsCollectionViewCell.frame.size.width * 0.75, searchResultsCollectionViewCell.mediaTitleLabel.frame.size.height);
    return searchResultsCollectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Set a color for the selected cell
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    
    [self performSegueWithIdentifier:SEARCH_RESULT_DETAILS_SEGUE sender:[self.searchResultsCollectionView cellForItemAtIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Remove the selection color from the last selected cell
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SearchResultsCollectionViewCell*)sender
{
    if (([segue.identifier isEqualToString:SEARCH_RESULT_DETAILS_SEGUE])) {
        
        SearchResultDetailsViewController *searchResultDetailsViewController = segue.destinationViewController;
        
        searchResultDetailsViewController.searchResultDetailsDictionary = [self.finalReturnedSearchResults objectAtIndex:[self.searchResultsCollectionView indexPathForCell:sender].item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(self.view.frame.size.width, CELL_HEIGHT);
    return cellSize;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [self.searchResultsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchResultsCollectionViewHeader" forIndexPath:indexPath];
        [reusableView addSubview:self.searchResultsNumberLabel];
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 40);
}

@end
