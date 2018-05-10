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
        self.artistNameLabel.text = track.artistName;
        self.trackNameLabel.text = track.trackName;
        self.imageView.image = [UIImage imageWithData:track.imageData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
