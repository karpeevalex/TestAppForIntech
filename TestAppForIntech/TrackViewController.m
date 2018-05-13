//
//  TrackViewController.m
//  TestAppForIntech
//
//  Created by Aleksandr Karpeev on 07/05/2018.
//  Copyright © 2018 Aleksandr Karpeev. All rights reserved.
//

#import "TrackViewController.h"
#import "Track.h"

@interface TrackViewController ()

@property (nonatomic, strong) Track *track;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TrackViewController

- (instancetype)initWithTrack:(Track *)track
{
    self = [super init];
    if (self)
    {
        self.track = track;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.artistNameLabel.text = self.track.artistName;
    self.trackNameLabel.text = self.track.trackName;
    self.imageView.image = [UIImage imageWithData:self.track.imageData];
}



@end
