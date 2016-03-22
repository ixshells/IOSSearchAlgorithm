//
//  SearchKeywordsAlgorithm.m
//  ixshellsLibs
//
//  Created by ixshells on 16/3/17.
//  Copyright © 2016年 ixshells. All rights reserved.
//

#import "SearchKeywordsAlgorithm.h"
#import "pinyin.h"

@interface SearchKeywordsAlgorithm()
{
    
}

@property(nonatomic, strong)NSMutableArray* allData;


@end

@implementation SearchKeywordsAlgorithm


-(NSMutableArray *)fullStringResultArray
{
    if(nil == _fullStringResultArray)
    {
        _fullStringResultArray = [[NSMutableArray alloc] init];
    }
    return _fullStringResultArray;
}

-(NSMutableArray *)searchIndexArray
{
    
    if(nil == _searchIndexArray)
    {
        _searchIndexArray = [[NSMutableArray alloc] init];
    }
    
    return _searchIndexArray;
}


-(void)searchByFuzzy:(NSArray *)searchDataArray keyStr:(NSString *)key
{
    
    _allData = [[NSMutableArray alloc] initWithArray:searchDataArray];
    
    NSArray* kerwords = [self stringTokenizerWithWord:key];
    
    NSString *searchData = @"";
    searchData = [NSString stringWithCString:[key UTF8String] encoding:NSUTF8StringEncoding];
    
    if([searchData length] > 0)
    {
        for(int i=0; i<[_allData count];i++)
        {
            NSString *data = @"";
            
            if(![searchData canBeConvertedToEncoding:NSASCIIStringEncoding])
            {
                data = [_allData objectAtIndex:i];
            }else
            {
                data = [_allData objectAtIndex:i];
                NSMutableString *pinyin = [[NSMutableString alloc] init];
                for(int i=0; i<[data length];i++)
                {
                    NSString *str =[[NSString stringWithFormat:@"%c",pinyinFirstLetter([data characterAtIndex:i])] uppercaseString];
                    [pinyin appendString:str];
                }
                if([pinyin length] > 0)
                    data =  pinyin;
            }
            
            
            if(kerwords.count > 1)
            {
                int currentLocation = 0;
                if(![self searchDataInString:data fullString:[_allData objectAtIndex:i] withSearchText:searchData withLocation:currentLocation index:i])
                    [self searchKeyWords:data fullString:[_allData objectAtIndex:i]  keywords:kerwords];
            }
            else{
                int currentLocation = 0;
                [self searchDataInString:data fullString:[_allData objectAtIndex:i] withSearchText:searchData withLocation:currentLocation index:i];
            }
        }
    }
    
}

-(void)searchKeyWords : (NSString *)data fullString:(NSString *)fullData  keywords:(NSArray *)array
{
    
    float count = 0;
    for (int i=0; i<array.count; i++) {
        
        NSString* keyword = array[i];
        int currentLocation = 0;
        if([self searchDataByKeyword:data fullString:fullData withSearchText:keyword withLocation:currentLocation])
        {
            count += 1.0f;
            count += 1.0f/(i+1.0f)*100.0f;
        }
    }
    
    if(count > 0)
    {
        [self insertObjectBysort:fullData weight:1.0f/count];
    }
}


-(BOOL)searchDataByKeyword:(NSString *)data fullString:(NSString *)fullData withSearchText:(NSString *)searchText withLocation:(int)location{
    
    if(fullData.length < searchText.length)
        return NO;
    
    if(fullData.length - searchText.length >= location)
    {
        NSComparisonResult result = [data compare:searchText options:NSCaseInsensitiveSearch
                                            range:NSMakeRange(location, [searchText length])];
        if (result == NSOrderedSame)
        {
            return YES;
        }else
        {
            location++;
            return [self searchDataByKeyword:data fullString:fullData withSearchText:searchText withLocation:location];
        }
    }
    return NO;
}

-(BOOL)searchDataInString:(NSString *)data fullString:(NSString *)fullData withSearchText:(NSString *)searchText withLocation:(int)location index:(NSInteger)index{
    
    if(fullData.length < searchText.length)
        return NO;
    
    if(fullData.length - searchText.length >= location)
    {
        NSComparisonResult result = [data compare:searchText options:NSCaseInsensitiveSearch
                                            range:NSMakeRange(location, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self insertObjectBysort:fullData weight:location/100000.0f];
            return YES;
        }else
        {
            location++;
            return [self searchDataInString:data fullString:fullData withSearchText:searchText withLocation:location index:index];
        }
    }
    
    return NO;
}

-(void)insertObjectBysort : (NSString *)fullstring weight:(float)weight
{
    NSInteger index =  [self binSearch:weight];
    
    [self.fullStringResultArray insertObject:fullstring atIndex:index];
    [self.searchIndexArray insertObject:[NSNumber numberWithFloat:weight] atIndex:index];
}

-(NSInteger)binSearch : (float)location
{
    if(!self.searchIndexArray.count )
    {
        return 0;
    }
    
    NSInteger low = 0, high = self.searchIndexArray.count - 1, middle;
    while (low <= high) {
        middle = (low + high)/2;
        NSNumber *num = self.searchIndexArray[middle];
        float result = num.floatValue;
        if(result == location)
            return middle;
        else if(result > location)
            high = middle - 1;
        else
            low = middle + 1;
        
    }
    
    return low;
}

-(NSArray *)stringTokenizerWithWord:(NSString *)word{
    NSMutableArray *keyWords=[[NSMutableArray alloc] init];
    
    CFStringTokenizerRef ref=CFStringTokenizerCreate(NULL,  (__bridge CFStringRef)word, CFRangeMake(0, word.length),kCFStringTokenizerUnitWord,NULL);
    CFRange range;
    CFStringTokenizerAdvanceToNextToken(ref);
    range=CFStringTokenizerGetCurrentTokenRange(ref);
    NSString *keyWord;
    
    while (range.length>0)
    {
        keyWord=[word substringWithRange:NSMakeRange(range.location, range.length)];
        [keyWords addObject:keyWord];
        CFStringTokenizerAdvanceToNextToken(ref);
        range=CFStringTokenizerGetCurrentTokenRange(ref);
    }
    
    return keyWords;
}


@end

