//
//  SearchResultCell.h
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 05/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *songImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

- (void)updateWithSong:(NSDictionary *)data;

@end
