//
//  ViewController.m
//  BHDynamicBackground
//
//  Created by Bartek Hugo on 14/11/13.
//  Copyright (c) 2013 Bartek Trzcinski. All rights reserved.
//

#import "ViewController.h"
#import "BHDynamicBackgroundView.h"
#import "UIImage+ImageEffects.h"

@interface ViewController () <UIGestureRecognizerDelegate>
{
    BHDynamicBackgroundView *_patternView;
    
    float prevRotation;
    float prevPinchScale;
    CGPoint prevPanPoint;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BHDynamicBackgroundView *patternView = [[BHDynamicBackgroundView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    patternView.layer.borderColor = [UIColor colorWithRed:237.0/255.0 green:215.0/255.0 blue:209.0/255.0 alpha:1.0].CGColor;
    patternView.layer.borderWidth = 1.0/[[UIScreen mainScreen] scale];
    patternView.referenceView = self.view;
    
    [self.view addSubview:patternView];
    _patternView = patternView;
    
    UIPanGestureRecognizer *panRecognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    panRecognize.delegate = self;
    [_patternView addGestureRecognizer:panRecognize];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    rotationRecognizer.delegate = self;
    [_patternView addGestureRecognizer:rotationRecognizer];
    
    UIPinchGestureRecognizer *zRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    zRecognizer.delegate = self;
    [_patternView addGestureRecognizer:zRecognizer];
    
    //
    
    BHDynamicBackgroundView *patternView2 = [[BHDynamicBackgroundView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    patternView2.layer.borderColor = [UIColor colorWithRed:237.0/255.0 green:215.0/255.0 blue:209.0/255.0 alpha:1.0].CGColor;
    patternView2.layer.borderWidth = 1.0/[[UIScreen mainScreen] scale];
    patternView2.referenceView = self.view;
    
    [self.view addSubview:patternView2];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationCurveLinear
                     animations:^{
        patternView2.center = CGPointMake(150, 400);
        patternView2.transform = CGAffineTransformMakeRotation(45);
    } completion:nil];
    
    

}

- (void)rotate:(UIRotationGestureRecognizer *)rotate {
    if (rotate.state == UIGestureRecognizerStateBegan) {
        prevRotation = 0.0;
    }
    
    float thisRotate = rotate.rotation - prevRotation;
    prevRotation = rotate.rotation;
    _patternView.transform = CGAffineTransformRotate(_patternView.transform, thisRotate);
}

- (void)scale:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan)
        prevPinchScale = 1.0;
    
    float thisScale = 1 + (pinch.scale-prevPinchScale);
    prevPinchScale = pinch.scale;
    _patternView.transform = CGAffineTransformScale(_patternView.transform, thisScale, thisScale);
}

-(void)move:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan){
        prevPanPoint = [pan locationInView:_patternView.superview];
    }
    
    CGPoint curr = [pan locationInView:_patternView.superview];
    
    float diffx = curr.x - prevPanPoint.x;
    float diffy = curr.y - prevPanPoint.y;
    
    CGPoint centre = _patternView.center;
    centre.x += diffx;
    centre.y += diffy;
    _patternView.center = centre;
    
    prevPanPoint = curr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:_patternView];
    return CGRectContainsPoint(_patternView.bounds, location);
}
@end
