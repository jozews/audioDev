//
//  AUDWaveform.m
//  Audio Development
//
//  Created by Jose Pablo on 6/7/14.
//  Copyright (c) 2014 Audio Developments. All rights reserved.
//

#import "Waveform.h"

#define defaultMinimumsCapacity 10
#define minAddedAmpThreshold 300
#define minAmpThreshold 50
#define minAmpPerSampleThreshold 80
#define minLengthThreshold 8

@interface Waveform ()
@property (nonatomic) AUDInt16Buffer buffer;
@property (nonatomic) AUDUIntBuffer minimums;
@property (nonatomic) NSUInteger minimumsCapacity;
@property (nonatomic,strong) Oscillator *oscillator;
@end

@implementation Waveform

+(Waveform *)waveform
{
    Waveform *waveform = [[Waveform alloc] init];
    waveform.minimumsCapacity = defaultMinimumsCapacity;
    AUDUIntBuffer minimums = { malloc(sizeof(NSUInteger)*waveform.minimumsCapacity), 0};
    waveform.minimums = minimums;
    return waveform;
}

void waveformCopyBuffer (Waveform *waveform, AUDInt16Buffer buffer)
{
    waveform->_buffer = buffer;
    waveform->_minimums.length = 0;
    
    NSUInteger lastMinIdx = 0, lastMaxIdx = 0;
    BOOL lastDeltaPositive = (waveform->_buffer.samples[1] - waveform->_buffer.samples[0] > 0) ? YES : NO ;
    BOOL deltaPositive = NO;
    
    for (int i = 2; i < waveform->_buffer.length; i++)
    {
        deltaPositive = (waveform->_buffer.samples[i] - waveform->_buffer.samples[i-1] > 0) ? YES : NO;
        if (lastDeltaPositive && !deltaPositive)
        {
            BOOL threshold = YES;
            if (threshold)
            {
                lastMaxIdx = i-1;
            }
        }
        else if (!lastDeltaPositive && deltaPositive)
        {
            SInt16 amplitude1 = waveform->_buffer.samples[lastMaxIdx]-waveform->_buffer.samples[lastMinIdx];
            SInt16 amplitude2 = waveform->_buffer.samples[lastMaxIdx]-waveform->_buffer.samples[i-1];
            BOOL threshold1 = (amplitude1+amplitude2 > minAddedAmpThreshold) ? YES : NO;
            BOOL threshold2 = (amplitude1 > minAmpThreshold && amplitude2 > minAmpThreshold) ? YES : NO;
            if (threshold1 && threshold2)
            {
                waveform->_minimums.samples[waveform->_minimums.length] = i-1;
                waveform->_minimums.length++;
                if (waveform->_minimums.length == waveform->_minimumsCapacity)
                {
                    waveform->_minimumsCapacity += defaultMinimumsCapacity;
                    waveform->_minimums.samples = realloc(waveform->_minimums.samples, sizeof(NSUInteger)*waveform->_minimumsCapacity);
                }
                lastMinIdx = i-1;
            }
        }
        lastDeltaPositive = deltaPositive;
    }
}

@end




