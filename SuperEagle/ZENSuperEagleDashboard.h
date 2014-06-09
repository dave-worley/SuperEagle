//
//  ZENSuperEagleDashboard.h
//  SuperEagle
//
//  Created by David Worley on 3/3/13.
//  Copyright (c) 2013 Zen Lab, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "ZENBLEPeripheralManager.h"

@interface ZENSuperEagleDashboard : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonConnect;

@property (weak, nonatomic) IBOutlet UIView *controlPad;
@property (weak, nonatomic) IBOutlet UILabel *touchDisplay;
@property (strong, nonatomic) UIGestureRecognizer *panGestureRecognizer;

@property (strong, nonatomic) ZENBLEPeripheralManager *peripheralManager;

- (void) controlPadWasTouched:(id)sender;

@property (strong, nonatomic) AVAudioPlayer *player;

- (void) connectionTimer:(NSTimer *)timer;
- (IBAction)scanForPeripherals:(id)sender;
- (void) bleWrite:(CGFloat)direction atSpeed:(NSInteger)speed;

- (CGFloat) calculateVolume:(CGFloat)sliderValue;

@end
