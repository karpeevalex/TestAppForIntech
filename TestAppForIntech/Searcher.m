//
//  Searcher.m
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 05/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import "Searcher.h"
#import "Track.h"

static Searcher *_instance;

@implementation Searcher

+ (Searcher *)sharedService
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            _instance = [[super allocWithZone:NULL] init];
        }
    }
    return _instance;
}

- (void)searchTrackByString:(NSString *)searchString withCompletion:(void (^)(NSArray *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", searchString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (data != nil)
                                                    {
                                                        id object = [NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:0
                                                                                                      error:nil];
                                                        
                                                        NSMutableArray *results = [NSMutableArray array];
                                                        
                                                        if ([object isKindOfClass:[NSDictionary class]])
                                                        {
                                                            NSArray *mainObject = [object valueForKey:@"results"];
                                                            
                                                            NSInteger i = 0;
                                                            for (NSDictionary *dirtyTrack in mainObject)
                                                            {
                                                                NSMutableDictionary *track = [NSMutableDictionary dictionary];
                                                                track[@"keyword"] = searchString;
                                                                track[@"index"] = [NSString stringWithFormat:@"%ld", i];
                                                                track[@"artistName"] = dirtyTrack[@"artistName"];
                                                                track[@"imageUrl"] = dirtyTrack[@"artworkUrl100"];
                                                                track[@"trackName"] = dirtyTrack[@"trackName"];
                                                                Track *res = [[Track alloc] initWithDict:track];
                                                                [results addObject:res];
                                                                i++;
                                                            }
                                                        }
                                                        
                                                        if (completion)
                                                        {
                                                            completion(results);
                                                        }
                                                    }
                                                }];
        [task resume];
    });
}

@end
