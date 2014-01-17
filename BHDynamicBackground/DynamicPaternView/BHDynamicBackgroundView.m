//
//  BGDynamicBackgroundView.m
//  PatterImage
//
//  Created by Bartek Hugo on 07/11/13.
//  Copyright (c) 2013 Bartek Trzcinski. All rights reserved.
//

#import "BHDynamicBackgroundView.h"
#import "UIImage+ImageEffects.h"

@interface BHDynamicBackgroundView ()
{
    CADisplayLink *displayLink;
    
    UIView *_referenceView;
}

@end

@implementation BHDynamicBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.allowsEdgeAntialiasing = YES;
        [self addDisplaylink];
    }
    return self;
}


- (void)setPatterImage:(UIImage *)patterImage
{
    _patterImage = patterImage;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CALayer *layer = self.layer;
    if ([[self.layer animationKeys] count])
        layer = self.layer.presentationLayer;
    
    CGPoint position = [self.referenceView.layer convertPoint:CGPointZero fromLayer:layer];
    CGAffineTransform transform = [layer affineTransform];
    

    CGContextConcatCTM(c,  CGAffineTransformInvert(transform));
    [self.patterImage drawAtPoint:CGPointMake(-position.x, -position.y)];
    CGContextRestoreGState(c);
}

- (void)setReferenceView:(UIView *)referenceView
{
    _referenceView = referenceView;
    UIGraphicsBeginImageContextWithOptions(referenceView.frame.size, YES, [[UIScreen mainScreen] scale]);
    [_referenceView drawViewHierarchyInRect:referenceView.bounds afterScreenUpdates:YES];
    UIImage *newBGImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    newBGImage = [newBGImage applyBlurWithRadius:2
                                       tintColor:[UIColor clearColor] saturationDeltaFactor:2.0 maskImage:nil];
    self.patterImage = newBGImage;
}

- (UIView *)referenceView
{
    if (!_referenceView)
        return self.superview;
    
    return _referenceView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    [self setNeedsDisplay];
}


- (void)addDisplaylink
{
    if (displayLink) {
        [displayLink invalidate];
    }
    
    displayLink = [CADisplayLink displayLinkWithTarget:self
                                              selector:@selector(tick:)];
    
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)tick:(CADisplayLink *)sender
{
    if ([[self.layer animationKeys] count])
    {
        [self setNeedsDisplay];
        
    }
}


@end
