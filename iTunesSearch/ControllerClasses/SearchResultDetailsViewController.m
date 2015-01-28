//
//  SearchResultDetailsViewController.m
//  iTunesSearch
//
//  Created by Mohammed Safwat on 1/28/15.
//
//

#import "SearchResultDetailsViewController.h"
#import "JMImageCache.h"

@interface SearchResultDetailsViewController ()

@end

@implementation SearchResultDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mediaTitleLabel.text = [self.searchResultDetailsDictionary objectForKey:@"trackName"];
    self.mediaArtistLabel.text = [self.searchResultDetailsDictionary objectForKey:@"artistName"];
    self.mediaAlbumLabel.text = [NSString stringWithFormat:@"Album : %@", [self.searchResultDetailsDictionary objectForKey:@"collectionName"]];
    double trackPrice = [[self.searchResultDetailsDictionary objectForKey:@"trackPrice"] doubleValue];
    self.priceLabel.text = [NSString stringWithFormat:@"$%.02f", trackPrice];
    self.mediaReleaseDateLabel.text = [NSString stringWithFormat:@"Release date : %@", [self.searchResultDetailsDictionary objectForKey:@"releaseDate"]];
    
    NSString* mediaImageURLString = [self.searchResultDetailsDictionary objectForKey:@"artworkUrl100"];
    mediaImageURLString = [mediaImageURLString stringByReplacingOccurrencesOfString:@"100" withString:@"400"];
    NSURL* mediaImageURL = [[NSURL alloc]initWithString:mediaImageURLString];
    [self.mediaImageView setImageWithURL:mediaImageURL key:nil placeholder:nil completionBlock:nil failureBlock:nil];
    self.mediaImageView.layer.cornerRadius = 150;
    self.mediaImageView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
