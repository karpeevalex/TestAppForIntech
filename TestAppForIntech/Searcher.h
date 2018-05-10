//
//  Searcher.h
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 05/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Searcher : NSObject

+ (Searcher *)sharedService;
- (void)searchTrackByString:(NSString *)searchString withCompletion:(void (^)(NSArray *results))completion;

@end
