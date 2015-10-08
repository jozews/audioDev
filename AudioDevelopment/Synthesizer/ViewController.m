//
//  ViewController.m
//  Synthesizer
//
//  Created by Jose Rossall on 2/18/15.
//  Copyright (c) 2015 Audio Developments. All rights reserved.
//

#import "ViewController.h"
#import "Modulator.h"
#import "Wave.h"
#import "Tone.h"
#import "Synthesizer.h"
#import "TheAmazingAudioEngine.h"

@interface ViewController ()
@property (nonatomic,strong) Synthesizer * synth;
@property (nonatomic, strong) Wave *wave;
@property (nonatomic,strong) AEAudioController *audioController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:NO];
    [_audioController start:NULL];
    
    self.wave = [[Wave alloc] initWithTone:[Tone sine]];
    self.wave.frequencyModulatorOn = YES;
    self.wave.amplitudeModulatorOn = YES;
    self.wave.frequencyModulator.frequencyModulatorOn = YES;
    self.wave.frequencyModulator.amplitudeModulatorOn = YES;
    self.wave.amplitudeModulator.frequencyModulatorOn = YES;
    self.wave.amplitudeModulator.amplitudeModulatorOn = YES;
    self.synth = [Synthesizer synthesizerWithWave:self.wave];
    self.synth.active = YES;
    [_audioController addChannels:[[NSArray alloc] initWithObjects:self.synth, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(UIButton *)sender {
    if (sender.tag==0) {
        [self.wave start];
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
        sender.tag = 1;
    }
    else {
        [self.wave stop];
        [sender setTitle: @"Start" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

- (IBAction)setFrequency:(UISlider *)sender {
    self.wave.frequency = sender.value;
}

- (IBAction)setAmplitude:(UISlider *)sender {
    self.wave.amplitude = sender.value;
}

- (IBAction)startFM:(UIButton *)sender {
    if (sender.tag==0) {
        [self.wave.frequencyModulator start];
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
        sender.tag = 1;
    }
    else {
        [self.wave.frequencyModulator stop];
        [sender setTitle: @"Start" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

- (IBAction)setFMFreqRatio:(UISlider *)sender {
    self.wave.frequencyModulator.frequencyRatio = sender.value;
}

- (IBAction)setFMAmpRatio:(UISlider *)sender {
    self.wave.frequencyModulator.amplitudeRatio = sender.value;
}

- (IBAction)startFMFM:(UIButton *)sender {
    if (sender.tag==0) {
        [self.wave.frequencyModulator.frequencyModulator start];
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
        sender.tag = 1;
    }
    else {
        [self.wave.frequencyModulator.frequencyModulator stop];
        [sender setTitle: @"Start" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

- (IBAction)setFMFMFreqRatio:(UISlider *)sender {
    self.wave.frequencyModulator.frequencyModulator.frequencyRatio = sender.value;
}

- (IBAction)setFMFMAmpRatio:(UISlider *)sender {
    self.wave.frequencyModulator.frequencyModulator.amplitudeRatio = sender.value;
}

- (IBAction)startFMAM:(UIButton *)sender {
    if (sender.tag==0) {
        [self.wave.frequencyModulator.amplitudeModulator start];
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
        sender.tag = 1;
    }
    else {
        [self.wave.frequencyModulator.frequencyModulator stop];
        [sender setTitle: @"Start" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

- (IBAction)setFMAMFreqRatio:(UISlider *)sender {
    self.wave.frequencyModulator.amplitudeModulator.frequencyRatio = sender.value;
}

- (IBAction)setFMAMAmpRatio:(UISlider *)sender {
    self.wave.frequencyModulator.amplitudeModulator.amplitudeRatio = sender.value;
}

- (IBAction)startAM:(UIButton *)sender {
    if (sender.tag==0) {
        [self.wave.amplitudeModulator start];
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
        sender.tag = 1;
    }
    else {
        [self.wave.amplitudeModulator stop];
        [sender setTitle: @"Start" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

- (IBAction)setAMFreqRatio:(UISlider *)sender {
    self.wave.amplitudeModulator.frequencyRatio = sender.value;
}

- (IBAction)setAMAmpRatio:(UISlider *)sender {
    self.wave.amplitudeModulator.amplitudeRatio = sender.value;
}

- (IBAction)startAMFM:(UIButton *)sender {
    if (sender.tag==0) {
        [self.wave.amplitudeModulator.frequencyModulator start];
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
        sender.tag = 1;
    }
    else {
        [self.wave.amplitudeModulator.frequencyModulator stop];
        [sender setTitle: @"Start" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

- (IBAction)setAMFMFreqRatio:(UISlider *)sender {
    self.wave.amplitudeModulator.frequencyModulator.frequencyRatio = sender.value;
}

- (IBAction)setAMFMAmpRatio:(UISlider *)sender {
    self.wave.amplitudeModulator.frequencyModulator.amplitudeRatio = sender.value;
}

- (IBAction)startAMAM:(UIButton *)sender {
    if (sender.tag==0) {
        [self.wave.amplitudeModulator.amplitudeModulator start];
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
        sender.tag = 1;
    }
    else {
        [self.wave.amplitudeModulator.amplitudeModulator stop];
        [sender setTitle: @"Start" forState: UIControlStateNormal];
        sender.tag = 0;
    }
}

- (IBAction)setAMAMFreqRatio:(UISlider *)sender {
    self.wave.amplitudeModulator.amplitudeModulator.frequencyRatio = sender.value;
}

- (IBAction)setAMAMAmpRatio:(UISlider *)sender {
    self.wave.amplitudeModulator.amplitudeModulator.amplitudeRatio = sender.value;
}

@end












