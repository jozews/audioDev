//
//  SYWavetable.m
//  Synthesis
//
//  Created by Jose Pablo on 5/17/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import "AUDWavetable.h"

#define samplesSize 4096
#define samplesPerSecond 44100.0
#define sinePeriod (2.0*M_PI)
#define incrementPerHertz (sinePeriod/samplesPerSecond)

@interface AUDWavetable ()
@property (nonatomic) CGFloat *samples;
@property (nonatomic) CGFloat stridePerSample;
@property (nonatomic) CGFloat sampleIndex;
@end

@implementation AUDWavetable

+(AUDWavetable*)wavetable{
    AUDWavetable *wavetable=[[AUDWavetable alloc]init];
    wavetable.frequency=10.76*50;
    wavetable.amplitude=0.0;
    wavetable.samples=malloc(sizeof(CGFloat)*samplesSize+1);
    for (int i=0; i<=samplesSize; i++) wavetable.samples[i]=sin(sinePeriod*i/samplesSize);
    wavetable.sampleIndex=0.0;
    return wavetable;
}

-(void)setFrequency:(CGFloat)frequency{
    _frequency=frequency;
    _stridePerSample=_frequency/(float)samplesSize;
}

double wavetableSample (AUDWavetable *wavetable){
    wavetable->_sampleIndex+=(wavetable->_sampleIndex>samplesSize) ? (wavetable->_frequency*samplesSize/samplesPerSecond)-samplesSize : wavetable->_frequency*samplesSize/samplesPerSecond;
    CGFloat sample=wavetable.samples[(int)wavetable->_sampleIndex];
    CGFloat interpolation=wavetable->_sampleIndex-(int)wavetable->_sampleIndex;
    if (interpolation>0.0) sample+=((1-interpolation)*wavetable->_samples[(int)wavetable->_sampleIndex])+(interpolation*wavetable->_samples[(int)wavetable->_sampleIndex+1]);
    return sample*wavetable->_amplitude;
}

@end

