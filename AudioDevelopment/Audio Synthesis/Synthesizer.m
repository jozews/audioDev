//
//  SYSynthesizer.m
//  Synthesis
//
//  Created by Jose Pablo on 4/16/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import "Synthesizer.h"
#import "Wave.h"

#define k16bitRange 32767.0
#define smoothOutputAdjust 0.00025

@interface Synthesizer () <AEAudioPlayable>
@property (nonatomic) AEAudioControllerRenderCallback renderCallback;
@end

@implementation Synthesizer

+(instancetype)synthesizer{
    Synthesizer *synthesizer=[[Synthesizer alloc] init];
    if (!synthesizer) return nil;
    synthesizer.active=NO;
    synthesizer.volume=1.0;
    synthesizer.pan=0.0;
    synthesizer.renderCallback=&synthCallback;
    return synthesizer;
}

+(instancetype)synthesizerWithWave:(Wave*)wave{
    Synthesizer *synthesizer=[Synthesizer synthesizer];
    if (!synthesizer) return nil;
    synthesizer.wave=wave;
    return synthesizer;
}

OSStatus synthCallback (id channel,
                       AEAudioController *audioController,
                       const AudioTimeStamp *time,
                       UInt32 frames,
                       AudioBufferList *audio) {
    Synthesizer *synth=channel;
    if (!synth->_active) return noErr;
	SInt16 *leftBuffer = (SInt16 *)audio->mBuffers[0].mData;
    SInt16 *rigthBuffer = (SInt16 *)audio->mBuffers[1].mData;
	for (UInt32 i = 0; i < frames; ++i) {
        if (synth->_wave) {
            float sample=waveSample(synth->_wave);
            leftBuffer[i]=(float)k16bitRange*sample;
            rigthBuffer[i]=(float)k16bitRange*sample;
        }
    }
    return noErr;
}

@end