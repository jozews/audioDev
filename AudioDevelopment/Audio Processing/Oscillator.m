//
//  AUDOscillator.m
//  Synthesis
//
//  Created by Jose Pablo on 5/24/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import "Oscillator.h"

#define k16bitRange 32767.0
#define samplesPerSecond 44100.0
#define secondsPerSample (1.0/samplesPerSecond)
#define zero 0
#define amplitudeThreshold 25
#define yShift 1
#define xShift +(M_PI/2)

@interface Oscillator ()
@property (nonatomic) AUDUIntBuffer minimums;
@property (nonatomic,strong) Oscillator *oscillator;
@end

@implementation Oscillator

+(Oscillator*)oscillator
{
    Oscillator *oscillator=[[Oscillator alloc] init];
    return oscillator;
}

void oscillatorAddMinimums (Oscillator *oscillator, AUDUIntBuffer minumums)
{
    
}

@end















/*
 @property (nonatomic) SInt16 *samples;
 @property (nonatomic) NSUInteger length;
 @property (nonatomic) SInt16 amplitude;
 @property (nonatomic) SInt16 delta;
 @property (nonatomic) NSUInteger count;
 @property (nonatomic) BOOL increasing;
 
 void oscillatorAddSample (AUDOscillator *oscillator, AudioSampleType sample)
 {
 if (sample>oscillator->_samples[oscillator->_count-1] && !oscillator->_increasing) {
 if (oscillator->_samples[0]-sample>amplitudeThreshold) {
 oscillator->_length=oscillator->_count;
 oscillator->_amplitude=oscillator->_samples[0]-sample;
 AudioSampleType distortion;
 for (int i=0; i<oscillator->_count; i++) {
 CGFloat phase = M_PI*i/(oscillator->_count-1);
 AudioSampleType y = oscillator->_samples[i]-oscillator->_samples[oscillator->_count-1];
 AudioSampleType idealY = (oscillator->_amplitude/2)*(cos(phase)+oscillator->_amplitude);
 distortion += (y-idealY<0) ? -(y-idealY) : y-idealY;
 }
 oscillator->_distortion = distortion/oscillator->_count;
 }
 else {
 oscillator->_length=0;
 oscillator->_amplitude=0;
 oscillator->_distortion=0;
 }
 oscillator->_increasing=YES;
 oscillator->_count=zero;
 }
 else if (sample<oscillator->_samples[oscillator->_count-1] && oscillator->_increasing){
 if (sample-oscillator->_samples[0]>amplitudeThreshold) {
 oscillator->_length=oscillator->_count;
 oscillator->_amplitude=sample-oscillator->_samples[0];
 AudioSampleType distortion;
 for (int i=0; i<oscillator->_count; i++) {
 CGFloat phase = M_PI*i/(oscillator->_count-1);
 AudioSampleType y = oscillator->_samples[i]-oscillator->_samples[0];
 AudioSampleType idealY = (oscillator->_amplitude/2)*(cos(phase)+oscillator->_amplitude);
 distortion += (y-idealY<0) ? -(y-idealY) : y-idealY;
 }
 oscillator->_distortion = distortion/oscillator->_count;
 }
 else {
 oscillator->_length=0;
 oscillator->_amplitude=0;
 oscillator->_distortion=0;
 }
 oscillator->_increasing=NO;
 oscillator->_count=zero;
 }
 oscillator->_samples[oscillator->_count++]=sample;
 }
 */
