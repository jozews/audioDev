//
//  AUSynthesizer.h
//  Synthesis
//
//  Created by Jose Pablo on 5/26/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheAmazingAudioEngine.h"

@interface AUDFramesSynthesizer : NSObject

@property (nonatomic) float volume; ///< Volume of audio playable protocol
@property (nonatomic) float pan; ///< Pan of audio playable protocol
@property (nonatomic,readonly) AEAudioControllerRenderCallback renderCallback; ///< Render callback of audio playable protocol

+(AUDFramesSynthesizer*)synthesizer;
-(void)synthesizeSamples:(AudioSampleType*)samples frames:(int)frames;

@end
