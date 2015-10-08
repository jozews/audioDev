//
//  SYTone.m
//  Synthesis
//
//  Created by Jose Pablo on 4/30/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import "Tone.h"

#define toneCapacity 9
#define samplePeakLimit 1.0

@interface Tone ()

@property (nonatomic) NSUInteger capacity; ///< The partials capacity
@property (nonatomic) float fraction; ///< Fraction of the sample that is returned to avoid distortion

@property (nonatomic) float *sinRatios; ///< Array of the sin ratios
@property (nonatomic) float *cosRatios; ///< Array of the cos ratios
@property (nonatomic) float *sinAmps; ///< Array of the sin amplitudes
@property (nonatomic) float *cosAmps; ///< Array of the cos amplitude

@end

@implementation Tone

+(instancetype)sine{
    Tone *tone=[[Tone alloc]init];
    tone.capacity=1;
    tone.fraction=1.0;
    tone.sinRatios=malloc(sizeof(float)*tone.capacity);
    *tone.sinRatios=1.0;
    tone.sinAmps=malloc(sizeof(float)*tone.capacity);
    *tone.sinAmps=1.0;
    return tone;
}

+(instancetype)sawtooth{
    Tone *tone=[[Tone alloc]init];
    tone.capacity=toneCapacity;
    tone.fraction=1.0;
    tone.sinRatios=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinRatios[i]=i+1.0;
    }
    tone.sinAmps=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinAmps[i]=pow(-1.0, i)/(i+1.0);
    }
    return tone;
}

+(instancetype)square{
    Tone *tone=[[Tone alloc]init];
    tone.capacity=toneCapacity;
    tone.fraction=1.0;
    tone.sinRatios=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinRatios[i]=2.0*i+1.0;
    }
    tone.sinAmps=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinAmps[i]=1.0/(i+1.0);
    }
    return tone;
}

+(instancetype)triangle{
    Tone *tone=[[Tone alloc]init];
    tone.capacity=toneCapacity;
    tone.fraction=1.0;
    tone.sinRatios=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinRatios[i]=2.0*i+1.0;
    }
    tone.sinAmps=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinAmps[i]=pow(-1.0, i)/(pow(2.0*i+1.0, 2.0));
    }
    return tone;
}

+(instancetype)unitTriangle{
    Tone *tone=[[Tone alloc]init];
    tone.capacity=toneCapacity;
    tone.fraction=1.0;
    tone.sinRatios=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinRatios[i]=2.0*i+1.0;
    }
    tone.sinAmps=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinAmps[i]=pow(-1.0, i);
    }
    return tone;
}

+(instancetype)inverseSawtooth{
    Tone *tone=[[Tone alloc]init];
    tone.capacity=toneCapacity;
    tone.fraction=1.0;
    tone.sinRatios=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinRatios[i]=i+1.0;
    }
    tone.sinAmps=malloc(sizeof(float)*tone.capacity);
    for (int i=0; i<tone.capacity; i++) {
        tone.sinAmps[i]=1.0/(i+1.0);
    }
    return tone;
}

double toneSample (Tone *tone ,double phase){
    double sample=0.0;
    for (int i=0; i<tone->_capacity; i++) {
        sample+=tone->_sinAmps[i]*sin(tone->_sinRatios[i]*phase);
    }
    if (sample>1.0) tone->_fraction=samplePeakLimit/sample;
    else if (sample<-1.0) tone->_fraction=-samplePeakLimit/sample;
    return sample*tone->_fraction;
}

double toneSampleModulated (Tone *tone ,double phase, double modulation){
    double sample=0.0;
    for (int i=0; i<tone->_capacity; i++) {
        sample+=tone->_sinAmps[i]*sin((tone->_sinRatios[i]*phase)+modulation);
    }
    if (sample>1.0) tone->_fraction=samplePeakLimit/sample;
    else if (sample<-1.0) tone->_fraction=-samplePeakLimit/sample;
    return sample*tone->_fraction;
}

@end
