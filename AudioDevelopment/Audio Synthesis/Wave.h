//
//  SYWave.h
//  Synthesis
//
//  Created by Jose Pablo on 4/15/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tone;
@class Modulator;
@class Envelope;

/*! Wave sampler */

@interface Wave : NSObject

@property (nonatomic) Tone *tone; ///< Tone of the wave

@property (nonatomic) float frequency; ///< Frequency of the wave as Hertz
@property (nonatomic) float amplitude; ///< Amplitude of the wave as an unsigned decimal

@property (nonatomic,strong) Envelope *envelope; ///< The amplitude envelope
@property (nonatomic) BOOL envelopeOn; ///< Whether the wave starts with its envelope

@property (nonatomic,strong) Modulator *frequencyModulator; ///< The frequency modulator
@property (nonatomic) BOOL frequencyModulatorOn; ///< Whether the wave is frequency modulated, doesn't adjust changes

@property (nonatomic,strong) Modulator *amplitudeModulator; ///The amplitude modulator
@property (nonatomic) BOOL amplitudeModulatorOn; ///< Whether the wave is amplitude modulated, doesn't adjust changes

@property (nonatomic,readonly) BOOL isActive; ///<Whether the wave is active
bool waveIsActive (Wave *wave); ///<Whether the wave is active

void setWaveFrequency(Wave *wave, float frequency); ///< Sets wave frequency
void setWaveAmplitude(Wave *wave, float amplitude); ///< Sets wave amplitude
double waveEffectiveFrequency(Wave *wave); ///< Gets the wave effective frequency
double waveEffectiveAmplitude(Wave *wave); ///< Gets the wave effective amplitude
double waveAmplitudeControl(Wave *wave); ///< Gets the wave amplitude control

-(instancetype)initWithTone:(Tone*)tone; ///< Instantiates a wave with the given tone
-(void)start; ///< Start the wave with adjust
-(void)stop; ///< Stops the wave with adjust
-(void)end; ///< Ends the wave without adjust

void startWave(Wave *wave); ///< Start the wave with adjust
void stopWave(Wave *wave); ///< Stops the wave with adjust
void endWave(Wave *wave); ///< Ends the wave without adjust

void observedEnvelopeEnded(Wave *wave, Envelope *envelope); ///< Notifier function of the envelope
void observedEnvelopeStopped(Wave *wave, Envelope *envelope); ///< Notifier function of the envelope

double waveSample(Wave *wave); ///< Returns the next sample of the wave

@end
