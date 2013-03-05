//
//  ZENSuperEagleDashboard.h
//  SuperEagle
//
//  Created by David Worley on 3/3/13.
//  Copyright (c) 2013 Zen Lab, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ZENSuperEagleDashboard : UIViewController <BLEDelegate>

@property (strong, nonatomic) BLE *bleShield;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UISlider *leftMotorSlider;
@property (weak, nonatomic) IBOutlet UISlider *motorSlider;
@property (weak, nonatomic) IBOutlet UISlider *rightMotorSlider;

- (IBAction) leftMotorSliderChanged:(id)sender;
- (IBAction) motorSliderChanged:(id)sender;
- (IBAction) rightMotorSliderChanged:(id)sender;
- (IBAction) motorSliderWasReleased:(id)sender;
- (NSArray *) realignMotorSliders:(NSArray *)motorSliders;
- (NSArray *) positionMotorSliders:(NSArray *)motorSliders;
- (NSString *) stringForSlider:(UISlider *)slider;
- (void) connectionTimer:(NSTimer *)timer;
- (IBAction)scanForPeripherals:(id)sender;

@end
