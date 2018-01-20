//
//  UIViewController+SegueSwizzleInitializer.m
//  ViperArch
//
//  Created by Eduard Pelesh on 3/28/17.
//  Copyright © 2017 ideil. All rights reserved.
//

#import "UIViewController+SegueSwizzleInitializer.h"
#import <ViperArch/ViperArch-Swift.h>

@implementation UIViewController (SegueSwizzleInitializer)

+ (void)initialize {
    [UIViewController segueSwizzle];
}

@end
