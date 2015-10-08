//
//  AUDAudioView.m
//  Audio Development
//
//  Created by Jose Pablo on 6/15/14.
//  Copyright (c) 2014 Audio Developments. All rights reserved.
//

#import "WaveformView.h"
#import "Waveform.h"

#define k16bitRange 32767.0
#define audioViewRange (k16bitRange*1)
#define dotSize 1.0
#define minimumDotSize 4.0


@implementation WaveformView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _color = [UIColor redColor];
    _type = WaveformViewTypeDots;
    _highlightMinimums = NO;
    return self;
}

-(void)setHighlightMinimums:(BOOL)highlightMinimums
{
    _highlightMinimums =  highlightMinimums;
    [self setNeedsDisplay];
}

-(void)setWaveform:(Waveform *)waveform
{
    _waveform = waveform;
    [self setNeedsDisplay];
}

-(void)drawWaveform
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (!_waveform) return;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if (_type==WaveformViewTypeLines)
    {
        CGContextSetLineWidth(contextRef, 1.0);
        CGContextSetStrokeColorWithColor(contextRef, _color.CGColor);
        for (int i=0; i<self.waveform.buffer.length-1; i++)
        {
            CGContextBeginPath(contextRef);
            CGContextMoveToPoint(contextRef, i , (self.frame.size.height/2)-((self.frame.size.height/2)*_waveform.buffer.samples[i]/audioViewRange));
            CGContextAddLineToPoint(contextRef, i+1 , (self.frame.size.height/2)-((self.frame.size.height/2)*_waveform.buffer.samples[i+1]/audioViewRange));
            CGContextStrokePath(contextRef);
        }
    }
    
    else if (_type==WaveformViewTypeDots)
    {
        CGContextSetFillColorWithColor(contextRef, _color.CGColor);
        for (int i=0; i<self.waveform.buffer.length; i++)
        {
            CGContextFillEllipseInRect(contextRef, CGRectMake(i-(dotSize/2), (self.frame.size.height/2)-((self.frame.size.height/2)*_waveform.buffer.samples[i]/audioViewRange)-(dotSize/2), dotSize, dotSize));
        }
    }
    
    if (_highlightMinimums)
    {
        CGContextSetFillColorWithColor(contextRef, _color.CGColor);
        for (int i=0; i < _waveform.minimums.length; i++)
        {
            CGContextFillEllipseInRect(contextRef, CGRectMake(_waveform.minimums.samples[i]-(minimumDotSize/2), (self.frame.size.height/2)-((self.frame.size.height/2)*_waveform.buffer.samples[_waveform.minimums.samples[i]]/audioViewRange)-(minimumDotSize/2), minimumDotSize, minimumDotSize));
        }
    }
}

@end
