//
//  SearchResultsCollectionViewCell.m
//  iTunesSearch
//
//  Created by Mohammed Safwat on 1/26/15.
//
//

#import "SearchResultsCollectionViewCell.h"

@implementation SearchResultsCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SearchResultsCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        //Add border to media image
        self.mediaImageView.layer.borderWidth = 0.5;
        self.mediaImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        //Add separator view
        float separatorViewHeight = 0.5;
        self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - separatorViewHeight, self.frame.size.width, separatorViewHeight)];
        self.separatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.separatorView];

    }
    
    return self;
}
@end
