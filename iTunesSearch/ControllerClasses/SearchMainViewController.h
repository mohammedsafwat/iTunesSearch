//
//  ViewController.h
//  iTunesSearch
//
//  Created by Mohammed Safwat on 1/24/15.
//
//

#import <UIKit/UIKit.h>
#import "SearchDataParser.h"
#import "MBProgressHUD.h"

@interface SearchMainViewController : UIViewController <UITextFieldDelegate, SearchDataParserDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UICollectionView *searchResultsCollectionView;

@end

