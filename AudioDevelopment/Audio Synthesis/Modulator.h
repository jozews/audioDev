//
//  SYModulator.h
//  Synthesis
//
//  Created by Jose Pablo on 4/20/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wave.h"

@class Tone;
@class Envelope;
@class Wave;

/*! Opaque wave */

@interface Modulator : Wave

@property (nonatomic,weak) Wave *carrier; ///< The carrier wave of the modulator

@property (nonatomic) float frequencyRatio; ///< Frequency as an unsigned float of the frequency
@property (nonatomic) float amplitudeRatio; ///< Amplitude as an unsigned decimal of the amplitude
@property (nonatomic) BOOL ring; ///< Whether the amplitude modulation is of ring type, doesn't adjust changes

bool modulatorIsActive(Modulator *modulator); ///<Whether the modulator is active

-(instancetype)initWithTone:(Tone*)tone; ///< Instantiates a wave with the given tone

void modulatorCarrierFrequencyChanged (Modulator *modulator); ///< updates the modulator frequency relative to its carrier and ratio
void modulatorCarrierAmplitudeChanged (Modulator *modulator); ///< Updates the modulator amplitude relative to its carrier and ratio

double amplitudeModulatorSample(Modulator *modulator); ///< Returns the next sample of the amplitude modulator

@end