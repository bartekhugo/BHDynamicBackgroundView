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
    CGPoint origin = [self.layer convertPoint:CGPointZero toLayer:self.referenceView.layer];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGContextConcatCTM(c,  CGAffineTransformInvert(self.transform));
    [self.patterImage drawAtPoint:CGPointMake(-origin.x, -origin.y)];
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


@end
