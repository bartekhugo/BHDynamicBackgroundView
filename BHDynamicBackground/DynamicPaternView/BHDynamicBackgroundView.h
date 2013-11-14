//
//  BHDynamicBackgroundView.h
//  PatterImage
//
//  Created by Bartek Hugo on 07/11/13.
//  Copyright (c) 2013 Bartek Trzcinski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHDynamicBackgroundView : UIView

@property (nonatomic, strong) UIImage *patterImage;
@property (nonatomic, strong) UIView *referenceView; // superview by default

@end
