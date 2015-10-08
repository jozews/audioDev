//
//  ViewController.m
//  AudioFilter
//
//  Created by Jože Ws on 9/13/15.
//  Copyright (c) 2015 Audio Developments. All rights reserved.
//

#import "ViewController.h"
#import "Modulator.h"
#import "Wave.h"
#import "Tone.h"
#import "Filter.h"
#import "Synthesizer.h"
#import "AEPlaythroughChannel.h"
#import "TheAmazingAudioEngine.h"

@interface ViewController ()
@property (nonatomic,strong) AEAudioController *audioController;
@property (nonatomic,strong) Filter *filter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:NO];
    [_audioController start:NULL];
    
    self.filter = [Filter filter];
    self.filter.amplitudeModulatorOn = YES;
    
    self.playthroughChannel = [[AEPlaythroughChannel alloc] initWithAudioController:self.audioController];
    
    [_audioController addChannels:[[NSArray alloc] initWithObjects:self.playthroughChannel, nil]];
    [_audioController addInputReceiver:self.playthroughChannel];
    [_audioController addFilter:self.filter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
