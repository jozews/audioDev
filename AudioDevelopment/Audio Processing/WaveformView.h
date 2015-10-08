//
//  AUDAudioView.h
//  Audio Development
//
//  Created by Jose Pablo on 6/15/14.
//  Copyright (c) 2014 Audio Developments. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Waveform;

typedef enum {
    WaveformViewTypeLines,
    WaveformViewTypeDots,
} WaveformViewType;

@interface WaveformView : UIView

@property (nonatomic,weak) Waveform *waveform;

@property (nonatomic,strong) UIColor *color;
@property (nonatomic) WaveformViewType type;
@property (nonatomic) BOOL highlightMinimums;

-(void)drawWaveform;

@end
