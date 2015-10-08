//
//  Filter.m
//  Audio Development
//
//  Created by Jože Ws on 9/12/15.
//  Copyright (c) 2015 Audio Developments. All rights reserved.
//

#import "Filter.h"
#import "Wave.h"
#import "Modulator.h"

#define k16bitRange 32767.0

@interface Filter () <AEAudioFilter>
@property (nonatomic) AEAudioControllerFilterCallback filterCallback;
@end

@implementation Filter

+(instancetype)filter {
    Filter *filter=[[Filter alloc] init];
    if (!filter) return nil;
    filter.active=YES;
    filter.filterCallback=&filterCallback;
    return filter;
}

-(void)setAmplitudeModulator:(Wave *)amplitudeModulator{
    _amplitudeModulator=amplitudeModulator;
}

-(void)setAmplitudeModulatorOn:(BOOL)amplitudeModulatorOn{
    _amplitudeModulatorOn=amplitudeModulatorOn;
    if (-amplitudeModulatorOn) {
        if (!_amplitudeModulator) _amplitudeModulator=[[Wave alloc] init];
    }
}
static OSStatus filterCallback(__unsafe_unretained Filter *filter,
                               __unsafe_unretained AEAudioController *audioController,
                               AEAudioControllerFilterProducer producer,
                               void *producerToken,
                               const AudioTimeStamp *time,
                               UInt32 frames,
                               AudioBufferList *audio) {
    
    if (!filter->_active) return noErr;
    SInt16 *leftBuffer = (SInt16 *)audio->mBuffers[0].mData;
    SInt16 *rigthBuffer = (SInt16 *)audio->mBuffers[1].mData;
    for (UInt32 i = 0; i < frames; ++i) {
        if (filter->_amplitudeModulator) {
            leftBuffer[i] *= (float)k16bitRange*waveSample(filter->_amplitudeModulator);
            rigthBuffer[i] *= (float)k16bitRange*waveSample(filter->_amplitudeModulator);
        }
    }
    
    return noErr;
}

-(AEAudioControllerFilterCallback)filterCallback {
    return filterCallback;
}

@end
