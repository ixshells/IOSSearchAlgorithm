//
//  SearchKeywordsAlgorithm.h
//  ixshellsLibs
//
//  Created by ixshells on 16/3/17.
//  Copyright © 2016年 ixshells. All rights reserved.
//

#ifndef SearchKeywordsAlgorithm_h
#define SearchKeywordsAlgorithm_h

#import <Foundation/Foundation.h>

@interface SearchKeywordsAlgorithm : NSObject

@property(nonatomic, strong)NSMutableArray* fullStringResultArray;
@property(nonatomic, strong)NSMutableArray* searchIndexArray;

-(void)searchByFuzzy:(NSArray *)searchDataArray keyStr:(NSString *)key;

-(NSArray *)stringTokenizerWithWord:(NSString *)word;

@end




#endif /* SearchKeywordsAlgorithm_h */
