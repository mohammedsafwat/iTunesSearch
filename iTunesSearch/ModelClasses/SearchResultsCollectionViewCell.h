//
//  SearchResultsCollectionViewCell.h
//  iTunesSearch
//
//  Created by Mohammed Safwat on 1/26/15.
//
//

#import <UIKit/UIKit.h>

@interface SearchResultsCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (strong, nonatomic) IBOutlet UILabel *mediaTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *mediaArtistLabel;
@end
