//
//  SearchDataParser.h
//  iTunesSearch
//
//  Created by Mohammed Safwat on 1/26/15.
//
//

#import <Foundation/Foundation.h>

@class SearchDataParser;

@protocol SearchDataParserDelegate <NSObject>
- (void)propagateFinalReturnedSearchResults:(NSMutableArray*)finalReturnedSearchResults withError:(NSError*)error;
@end

@interface SearchDataParser : NSObject
@property (nonatomic, weak) id scheduleDataParserDelegate;
- (void)getSearchResults:(NSString*)searchString;
@end
