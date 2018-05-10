//
//  Track.h
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 07/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSString *keyword;

- (instancetype)initWithDict:(NSDictionary *)trackDick;

@end
