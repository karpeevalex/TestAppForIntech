//
//  SearchResultCell.m
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 05/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateWithSong:(NSDictionary *)data
{
    self.artistNameLabel.text = [data valueForKey:@"artistName"];
    self.songNameLabel.text = [data valueForKey:@"songName"];
    self.songImageView.image = [UIImage imageWithData:[data valueForKey:@"imageData"]];
}

@end
