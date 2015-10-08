//
//  SYWave.m
//  Synthesis
//
//  Created by Jose Pablo on 4/15/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import "Wave.h"
#import "Tone.h"
#import "Modulator.h"
#import "Envelope.h"

#define samplesPerSecond 44100.0
#define secondsPerSample (1.0/samplesPerSecond)
#define sinePeriod (2.0*M_PI)
#define incrementPerHertz (sinePeriod/samplesPerSecond)
#define increment(frequency) (incrementPerHertz*frequency)

#define smoothAmplitudeAdjust 0.0002
#define smoothFrequencyAdjust 0.1
#define smoothAmplitudeControl 0.001

#define targAmpStop 0.0
#define targAmpStart 1.0

#define zero 0.0

@interface Wave ()
@property (nonatomic) BOOL isActive; ///<Whether the wave is active
@property (nonatomic) BOOL isRestarting; ///<Whether the wave is restarting with envelope

@property (nonatomic) float phase; ///< Phase of the wave

@property (nonatomic) BOOL effectEnvelopeOn; ///< Effective envelope on to avoid changes while active
@property (nonatomic) float effectFreq; ///< Effective frequency to smoothly adjusted changes
@property (nonatomic) float effectAmp; ///< Effective amplitude to smoothly adjusted changes
@property (nonatomic) float ampControl; ///< Amplitude control to start and stop wave
@property (nonatomic) float targAmpControl; ///< Target amplitude control to adjust amplitude control
@end

@implementation Wave

-(instancetype)init{
    self = [super init];
    if (!self) return  nil;
    self.tone = [Tone sine];
    self.frequency=0.0;
    self.amplitude=0.0;
    self.envelopeOn=NO;
    //private
    self.isActive=NO;
    self.isRestarting=NO;
    self.effectEnvelopeOn=NO;
    self.phase=0.0;
    self.effectFreq=0.0;
    self.effectAmp=0.0;
    self.ampControl=0.0;
    self.targAmpControl=0.0;
    return self;
}

-(instancetype)initWithTone:(Tone *)tone{
    self = [self init];
    if (!self) return  nil;
    self.tone=tone;
    return self;
}

void setWaveFrequency(Wave *wave, float frequency){
    wave->_frequency=frequency;
}

void setWaveAmplitude(Wave *wave, float amplitude){
    wave->_amplitude=amplitude;
}

-(void)setEnvelope:(Envelope *)envelope{
    _envelope=envelope;
    if (_envelope) _envelope.observerWave=self;
}

-(void)setEnvelopeOn:(BOOL)envelopeOn{
    _envelopeOn=envelopeOn;
    if (_envelopeOn && !_envelope) {
        _envelope=[Envelope envelope];
        _envelope.observerWave=self;
    }
}

-(void)setFrequencyModulator:(Modulator *)frequencyModulator{
    _frequencyModulator=frequencyModulator;
    if (_frequencyModulator) _frequencyModulator.carrier=self;
}

-(void)setFrequencyModulatorOn:(BOOL)frequencyModulatorOn{
    _frequencyModulatorOn=frequencyModulatorOn;
    if (_frequencyModulatorOn) {
        if (!_frequencyModulator) _frequencyModulator=[[Modulator alloc] init];
        _frequencyModulator.carrier=self;
    }
}

-(void)setAmplitudeModulator:(Modulator *)amplitudeModulator{
    _amplitudeModulator=amplitudeModulator;
    if (_amplitudeModulator) _amplitudeModulator.carrier=self;
}

-(void)setAmplitudeModulatorOn:(BOOL)amplitudeModulatorOn{
    _amplitudeModulatorOn=amplitudeModulatorOn;
    if (-amplitudeModulatorOn) {
        if (!_amplitudeModulator) _amplitudeModulator=[[Modulator alloc] init];
        _amplitudeModulator.carrier=self;
    }
}

double waveFrequency (Wave *wave){
    return wave->_frequency;
}

double waveAmplitude (Wave *wave){
    return wave->_amplitude;
}

bool waveIsActive (Wave *wave){
    if (!wave) return NO;
    return wave->_isActive;
}

double waveEffectiveFrequency (Wave *wave){
    return wave->_effectFreq;
}

double waveEffectiveAmplitude (Wave *wave){
    return wave->_effectAmp;
}

double waveAmplitudeControl(Wave *wave){
    return wave->_ampControl;
}

-(void)start{
    if (_isActive) {
        _isRestarting=YES;
        [self stop];
        return;
    }
    _effectEnvelopeOn=_envelopeOn;
    if (_effectEnvelopeOn) startEnvelope(_envelope);
    else _targAmpControl=targAmpStart;
    _isActive=YES;
}

-(void)stop{
    if (_effectEnvelopeOn) stopEnvelope(_envelope);
    else _targAmpControl=targAmpStop;
}

-(void)end{
    _isActive=NO;
}

void startWave (Wave *wave){
    if (wave->_isActive) {
        wave->_isRestarting=YES;
        stopWave(wave);
        return;
    }
    wave->_effectEnvelopeOn=wave->_envelopeOn;
    if (wave->_effectEnvelopeOn) startEnvelope(wave->_envelope);
    else wave->_targAmpControl=targAmpStart;
    wave->_isActive=YES;
}

void stopWave (Wave *wave){
    if (wave->_effectEnvelopeOn) stopEnvelope(wave->_envelope);
    else wave->_targAmpControl=targAmpStop;
}

void endWave (Wave *wave) {
    wave->_isActive=NO;
}

void restartWave (Wave *wave) {
    wave->_isRestarting=NO;
    endWave(wave);
    startWave(wave);
}

void observedEnvelopeEnded (Wave *wave, Envelope *envelope){
    endWave(wave);
}

void observedEnvelopeStopped (Wave *wave, Envelope *envelope){
    if (!wave->_isRestarting) endWave(wave);
    else restartWave(wave);
}

double waveSample (Wave *wave){
    if (wave->_amplitude-wave->_effectAmp>smoothAmplitudeAdjust) {
        wave->_effectAmp+=smoothAmplitudeAdjust;
        if (wave->_frequencyModulator) modulatorCarrierAmplitudeChanged(wave->_frequencyModulator);
        if (wave->_amplitudeModulator) modulatorCarrierAmplitudeChanged(wave->_amplitudeModulator);
    }
    else if (wave->_effectAmp-wave->_amplitude>smoothAmplitudeAdjust) {
        wave->_effectAmp-=smoothAmplitudeAdjust;
        if (wave->_frequencyModulator) modulatorCarrierAmplitudeChanged(wave->_frequencyModulator);
        if (wave->_amplitudeModulator) modulatorCarrierAmplitudeChanged(wave->_amplitudeModulator);
    }
    if (wave->_frequency-wave->_effectFreq>smoothFrequencyAdjust) {
        wave->_effectFreq+=smoothFrequencyAdjust;
        if (wave->_frequencyModulator) modulatorCarrierFrequencyChanged(wave->_frequencyModulator);
        if (wave->_amplitudeModulator) modulatorCarrierFrequencyChanged(wave->_amplitudeModulator);
    }
    else if (wave->_effectFreq-wave->_frequency>smoothFrequencyAdjust) {
        wave->_effectFreq-=smoothFrequencyAdjust;
        if (wave->_frequencyModulator) modulatorCarrierFrequencyChanged(wave->_frequencyModulator);
        if (wave->_amplitudeModulator) modulatorCarrierFrequencyChanged(wave->_amplitudeModulator);
    }
    if (!wave->_isActive) return zero;
    if (wave->_targAmpControl-wave->_ampControl>smoothAmplitudeControl) wave->_ampControl+=smoothAmplitudeControl;
    else if (wave->_ampControl-wave->_targAmpControl>smoothAmplitudeControl) wave->_ampControl-=smoothAmplitudeControl;
    else if (wave->_targAmpControl==targAmpStop) {
        if (wave->_isRestarting) restartWave(wave);
        else endWave(wave);
    }
    wave->_phase+=(wave->_phase>sinePeriod)? increment(wave->_effectFreq)-sinePeriod : increment(wave->_effectFreq);
    double sample=(wave->_frequencyModulatorOn)? toneSampleModulated(wave->_tone ,wave->_phase, waveSample(wave->_frequencyModulator)) : toneSample(wave->_tone ,wave->_phase);
    sample*=(wave->_amplitudeModulatorOn)?  amplitudeModulatorSample(wave->_amplitudeModulator) : wave->_effectAmp;
    sample*=(wave->_effectEnvelopeOn)? envelopeValue(wave->_envelope) : wave->_ampControl;
    return sample;
}




@end

