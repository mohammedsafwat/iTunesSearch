//
//  SearchResultDetailsViewController.h
//  iTunesSearch
//
//  Created by Mohammed Safwat on 1/28/15.
//
//

#import <UIKit/UIKit.h>
#import "SearchResultsCollectionViewCell.h"

@interface SearchResultDetailsViewController : UIViewController
@property (nonatomic, strong) NSMutableDictionary *searchResultDetailsDictionary;
@property (strong, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (strong, nonatomic) IBOutlet UILabel *mediaTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *mediaArtistLabel;
@property (strong, nonatomic) IBOutlet UILabel *mediaAlbumLabel;
@property (strong, nonatomic) IBOutlet UILabel *mediaReleaseDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@end
