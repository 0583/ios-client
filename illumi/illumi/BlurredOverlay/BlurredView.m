//
//  BlurredView.m
//  illumi
//
//  Created by 0583 on 2019/6/28.
//  Copyright © 2019 0583. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

void createBlurredOverlay () {
    // only apply the blur if the user hasn't disabled transparency effects
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        // always fill the view
//        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
//        [self.view addSubview:blurEffectView];
        // if you have more UIViews, use an insertSubview API to place it where needed
    } else {
//        self.view.backgroundColor = [UIColor blackColor];
    }

}
