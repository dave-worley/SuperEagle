//
//  ZENSuperEagleDashboard.h
//  SuperEagle
//
//  Created by David Worley on 3/3/13.
//  Copyright (c) 2013 Zen Lab, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZENSuperEagleDashboard : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *leftMotorSlider;
@property (weak, nonatomic) IBOutlet UISlider *motorSlider;
@property (weak, nonatomic) IBOutlet UISlider *rightMotorSlider;

- (NSArray *) realignMotorSliders:(NSArray *)motorSliders;
- (NSArray *) positionMotorSliders:(NSArray *)motorSliders;

@end
