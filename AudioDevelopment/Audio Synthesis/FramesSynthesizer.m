//
//  AUSynthesizer.m
//  Synthesis
//
//  Created by Jose Pablo on 5/26/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import "AUDFramesSynthesizer.h"

@interface AUDFramesSynthesizer () <AEAudioPlayable>
@property (nonatomic) AEAudioControllerRenderCallback renderCallback;
@property (nonatomic) AudioSampleType *samples;
@property (nonatomic) int frameIndex;
@property (nonatomic) int frames;
@end

@implementation AUDFramesSynthesizer

+(AUDFramesSynthesizer*)synthesizer
{
    AUDFramesSynthesizer *synth=[[AUDFramesSynthesizer alloc]init];
    synth.renderCallback=synthCallback;
    synth.frames=0;
    synth.frameIndex=0;
    synth.volume=1.0;
    return synth;
}

-(void)synthesizeSamples:(AudioSampleType*)samples frames:(int)frames
{
    _samples=samples;
    _frames=frames;
    _frameIndex=0;
}

OSStatus synthCallback (id channel,
                        AEAudioController *audioController,
                        const AudioTimeStamp *time,
                        UInt32 frames,
                        AudioBufferList *audio)
{
    AUDFramesSynthesizer *synth=channel;
    if (!synth->_samples) return noErr;
	AudioSampleType *leftBuffer = (AudioSampleType *)audio->mBuffers[0].mData;
    AudioSampleType *rigthBuffer = (AudioSampleType *)audio->mBuffers[1].mData;
	for (UInt32 i=0; i<frames; ++i) {
        if (synth->_frameIndex>=synth->_frames) synth->_frameIndex=0;
        AudioSampleType sample=synth->_samples[synth->_frameIndex];
        leftBuffer[i]=sample;
        rigthBuffer[i]=sample;
        synth->_frameIndex++;
    }
    return noErr;
}

@end
