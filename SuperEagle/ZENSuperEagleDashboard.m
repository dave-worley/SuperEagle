//
//  ZENSuperEagleDashboard.m
//  SuperEagle
//
//  Created by David Worley on 3/3/13.
//  Copyright (c) 2013 Zen Lab, LLC. All rights reserved.
//

#import "ZENSuperEagleDashboard.h"

@interface ZENSuperEagleDashboard ()

@end

@implementation ZENSuperEagleDashboard

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPeripheralManager:[[ZENBLEPeripheralManager alloc] init]];
    [self setPanGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(controlPadWasTouched:)]];
    [self.controlPad addGestureRecognizer:self.panGestureRecognizer];
    NSURL *themeURL = [[NSBundle mainBundle] URLForResource:@"sunmantheme" withExtension:@"caf"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:themeURL error:nil];
    [self.player prepareToPlay];
    [self.player setVolume:0.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handling
- (void) controlPadWasTouched:(id)sender
{
    UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)sender;
    NSInteger columnSize = (self.controlPad.frame.size.width / 3) / 2;
    CGPoint controlPadCenter = CGPointMake(self.controlPad.frame.size.width/2,
                                           self.controlPad.frame.size.height/2);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }

        case UIGestureRecognizerStateChanged: {
            CGPoint touchInControlPad = [gesture locationInView:self.controlPad];
            NSInteger xDistanceFromCenter = (touchInControlPad.x - controlPadCenter.x); //fabsf(touchInControlPad.x - controlPadCenter.x);
            NSInteger yDistanceFromCenter = (touchInControlPad.y - controlPadCenter.y) * -1; //fabsf(touchInControlPad.y - controlPadCenter.y);
            CGFloat direction = 0.5f;
            if (fabsf(xDistanceFromCenter) > columnSize && touchInControlPad.x > controlPadCenter.x) {
                direction = 1.0f;
            } else if (fabsf(xDistanceFromCenter) > columnSize && touchInControlPad.x < controlPadCenter.x) {
                direction = 0.0f;
            }
            NSInteger speed = yDistanceFromCenter * 2;
            if (abs(speed) > MAX_SPEED) {
                NSInteger modifier = 1;
                if (speed < 0) {
                    modifier = -1;
                }
                speed = MAX_SPEED * modifier;
            }
            [self bleWrite:direction atSpeed:speed];

            [self.player setVolume:[self calculateVolume:fabsf(yDistanceFromCenter)]];
            break;
        }

        case UIGestureRecognizerStateEnded: {
            [self bleWrite:0.5f atSpeed:0]; // sends a stop
            break;
        }

        default: {
            [self bleWrite:0.5f atSpeed:0]; // sends a stop
            break;
        }
    }
}
- (CGFloat) calculateVolume:(CGFloat)sliderValue
{
    CGFloat const inMin = 0.0;
    CGFloat const inMax = 255.0;

    CGFloat const outMin = 0.1;
    CGFloat const outMax = 1.0;

    CGFloat in = sliderValue;
    CGFloat out = outMin + (outMax - outMin) * (in - inMin) / (inMax - inMin);
    return out;
}
- (void) bleWrite:(CGFloat)direction atSpeed:(NSInteger)speed
{
    [_peripheralManager setDirection:direction];
    [_peripheralManager setSpeed:speed];
    return;
}

#pragma mark - BLE stuff
// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer {
}

- (IBAction)scanForPeripherals:(id)sender {
}

@end
