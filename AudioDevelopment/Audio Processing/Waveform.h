//
//  AUDWaveform.h
//  Audio Development
//
//  Created by Jose Pablo on 6/7/14.
//  Copyright (c) 2014 Audio Developments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Oscillator.h"

typedef struct {
    SInt16 *samples;
    NSUInteger length;
} AUDInt16Buffer;

@interface Waveform : NSObject

@property (nonatomic,readonly) AUDInt16Buffer buffer;

@property (nonatomic,readonly) AUDUIntBuffer minimums;
@property (nonatomic,readonly,strong) Oscillator *oscillator;

+(Waveform *)waveform;

void waveformCopyBuffer (Waveform *waveform, AUDInt16Buffer buffer);

@end