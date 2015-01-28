//
//  SearchDataParser.m
//  iTunesSearch
//
//  Created by Mohammed Safwat on 1/26/15.
//
//

#import "SearchDataParser.h"
#import "Common.h"
#import "AFNetworking.h"

@interface SearchDataParser()
//Array that will hold some dictionaries containing the mappings of search results
@end

@implementation SearchDataParser

- (void)getSearchResults:(NSString*)searchString
{
    NSString* searchParametersFullString = @"";
    
    NSArray* searchStringComponents = [searchString componentsSeparatedByString:@" "];
    NSMutableArray* filteredSearchStringComponents = [[NSMutableArray alloc]init];
    
    //Handle if the input search text components contain spaces
    for(NSString* searchStringComponent in searchStringComponents)
    {
        if(![searchStringComponent isEqual:@""])
        {
            [filteredSearchStringComponents addObject:searchStringComponent];
        }
    }
    //Append search text components with "+" between them
    for(NSString* stringComponent in filteredSearchStringComponents)
    {
        if([filteredSearchStringComponents indexOfObject:stringComponent] > 0)
        {
            searchParametersFullString = [searchParametersFullString stringByAppendingFormat:@"+%@", stringComponent];
        }
        else
        {
            searchParametersFullString = [searchParametersFullString stringByAppendingFormat:@"%@", stringComponent];
        }
    }
    
    //Create the final search URL
    NSURL* searchURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@", iTunesSearchBaseURL, searchParametersFullString]];
    
    NSURLRequest* searchParametersRequest = [[NSURLRequest alloc]initWithURL:searchURL];
    
    //Begin Async operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:searchParametersRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat progress;
        if (totalBytesExpectedToRead > 0 && totalBytesRead <= totalBytesExpectedToRead)
            progress = (CGFloat) totalBytesRead / totalBytesExpectedToRead;
        else
            progress = (totalBytesRead % 1000000l) / 1000000.0f;
    }];
    
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSMutableData* downloadedData = [[NSMutableData alloc]init];
        downloadedData = (NSMutableData*)responseObject;
        //Array of dictionaries holding the returned search data
        NSArray *searchResultJsonDataArray = [downloadedData valueForKey:@"results"];
        NSMutableArray* finalParsedSearchResults = [self parseSearchData:searchResultJsonDataArray];
        [self.scheduleDataParserDelegate propagateFinalReturnedSearchResults:finalParsedSearchResults withError:nil];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error happened while sending search request with description : %@", error.localizedDescription);
        [self.scheduleDataParserDelegate propagateFinalReturnedSearchResults:nil withError:error];
    }];

}

- (NSMutableArray*)parseSearchData:(NSArray*)searchResultJsonDataArray
{
    NSMutableArray* finalParsedSearchResults = [[NSMutableArray alloc]init];
    for(int i = 0; i < searchResultJsonDataArray.count; i++)
    {
        NSMutableDictionary* searchResultDictionary = [[NSMutableDictionary alloc]init];
        searchResultDictionary = [searchResultJsonDataArray objectAtIndex:i];
        [finalParsedSearchResults addObject:searchResultDictionary];
    }
    return finalParsedSearchResults;
}
@end



