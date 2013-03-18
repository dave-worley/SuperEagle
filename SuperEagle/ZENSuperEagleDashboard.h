//
//  ZENSuperEagleDashboard.h
//  SuperEagle
//
//  Created by David Worley on 3/3/13.
//  Copyright (c) 2013 Zen Lab, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"
#import <AVFoundation/AVFoundation.h>

@interface ZENSuperEagleDashboard : UIViewController <BLEDelegate>

@property (strong, nonatomic) BLE *bleShield;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonConnect;

@property (weak, nonatomic) IBOutlet UIView *controlPad;
@property (weak, nonatomic) IBOutlet UILabel *touchDisplay;
@property (strong, nonatomic) UIGestureRecognizer *panGestureRecognizer;

- (void) controlPadWasTouched:(id)sender;

@property (strong, nonatomic) AVAudioPlayer *player;

- (void) connectionTimer:(NSTimer *)timer;
- (IBAction)scanForPeripherals:(id)sender;
- (void) bleWrite:(NSString *)payload;

- (CGFloat) calculateVolume:(CGFloat)sliderValue;

@end
