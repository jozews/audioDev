//
//  SYModulator.m
//  Synthesis
//
//  Created by Jose Pablo on 4/20/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import "Modulator.h"
#import "Wave.h"
#import "Tone.h"
#import "Envelope.h"

#define smoothRingControl 0.001
#define targRing 1.0
#define targNonRing 0.5

@interface Modulator ()
@property (nonatomic) float ringControl;
@property (nonatomic) float targRingControl;
@end

@implementation Modulator

-(instancetype)init{
    self = [super init];
    if (!self) return nil;
    self.frequencyRatio=0.0;
    self.amplitudeRatio=0.0;
    self.ring=NO;
    //private
    self.ringControl=targRing;
    return self;
}

-(instancetype)initWithTone:(Tone*)tone{
    self = [self init];
    if (!self) return nil;
    self.tone = tone;
    return self;
}

bool modulatorIsActive(Modulator *modulator){
    return waveIsActive(modulator);
}

-(void)setFrequencyRatio:(float)frequencyRatio{
    _frequencyRatio=frequencyRatio;
    self.frequency=_frequencyRatio*_carrier.frequency;
}

-(void)setAmplitudeRatio:(float)amplitudeRatio{
    _amplitudeRatio=amplitudeRatio;
    self.amplitude=_amplitudeRatio*_carrier.amplitude;
}

-(void)setRing:(BOOL)ring{
    _ring=ring;
    if (_ring) _targRingControl=targRing;
    else _targRingControl=targNonRing;
}

void modulatorCarrierAmplitudeChanged (Modulator *modulator) {
    setWaveAmplitude(modulator, waveEffectiveAmplitude(modulator->_carrier)*modulator->_amplitudeRatio);
}

void modulatorCarrierFrequencyChanged (Modulator *modulator) {
    setWaveFrequency(modulator, waveEffectiveFrequency(modulator->_carrier)*modulator->_frequencyRatio);
}

double amplitudeModulatorSample(Modulator *modulator){
    if (modulator->_targRingControl-modulator->_ringControl>smoothRingControl) modulator->_ringControl+=smoothRingControl;
    else if (modulator->_ringControl-modulator->_targRingControl>smoothRingControl) modulator->_ringControl-=smoothRingControl;
    if (modulator->_ring) return waveEffectiveAmplitude(modulator->_carrier)*(1-waveAmplitudeControl(modulator))+(modulator->_ringControl*waveSample(modulator));
    else return modulator->_ringControl*(waveEffectiveAmplitude(modulator->_carrier)+waveSample(modulator));
}

@end









