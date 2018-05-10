//
//  Track.m
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 07/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import "Track.h"

@implementation Track

- (instancetype)initWithDict:(NSDictionary *)trackDick
{
    self = [super init];
    if (self)
    {
        self.index = [trackDick[@"index"] integerValue];
        self.artistName = trackDick[@"artistName"];
        self.trackName = trackDick[@"trackName"];
        self.imageUrl = trackDick[@"imageUrl"];
        self.keyword = trackDick[@"keyword"];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    if (!self.imageData)
    {
        [self downloadImage];
    }
}

- (void)downloadImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:self.imageUrl];
        self.imageData = [NSData dataWithContentsOfURL:url];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageDownload" object:self];
    });
}

@end
