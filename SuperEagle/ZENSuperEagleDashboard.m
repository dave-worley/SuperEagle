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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bleShield = [[BLE alloc] init];
    [self.bleShield controlSetup:1];
    self.bleShield.delegate = self;
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
        case UIGestureRecognizerStateBegan:
        {
            break;
        }

        case UIGestureRecognizerStateChanged:
        {
            CGPoint touchInControlPad = [gesture locationInView:self.controlPad];
            NSInteger xDistanceFromCenter = (touchInControlPad.x - controlPadCenter.x); //fabsf(touchInControlPad.x - controlPadCenter.x);
            NSInteger yDistanceFromCenter = (touchInControlPad.y - controlPadCenter.y) * -1; //fabsf(touchInControlPad.y - controlPadCenter.y);
            NSString *motorCode = @"m";
            if (fabsf(xDistanceFromCenter) > columnSize && touchInControlPad.x > controlPadCenter.x) {
                motorCode = @"r";
            } else if (fabsf(xDistanceFromCenter) > columnSize && touchInControlPad.x < controlPadCenter.x) {
                motorCode = @"l";
            } else {
                motorCode = @"m";
            }
            NSString *payload = [NSString stringWithFormat:@"%@:%d", motorCode, yDistanceFromCenter * 2];
            [self bleWrite:payload];

            [self.player setVolume:[self calculateVolume:fabsf(yDistanceFromCenter)]];
            break;
        }

        case UIGestureRecognizerStateEnded:
        {
            [self bleWrite:@"m:0"]; // sends a stop
            break;
        }

        default:
        {
            [self bleWrite:@"m:0"]; // sends a stop
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
- (void) bleWrite:(NSString *)payload
{
    NSData *data = [payload dataUsingEncoding:NSUTF8StringEncoding];
    [self.bleShield write:data];
}

#pragma mark - BLE stuff
// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer
{
    if (self.bleShield.peripherals.count > 0) {
        [self.bleShield connectPeripheral:[self.bleShield.peripherals objectAtIndex:0]];
    }
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
}

- (void) bleDidDisconnect
{
    [self.buttonConnect setTitle:@"Connect"];
    [self.buttonConnect setTintColor:[UIColor redColor]];
    [self.player stop];
    [self.player setCurrentTime:0.0];
}

-(void) bleDidConnect
{
    [self.spinner stopAnimating];
    [self.buttonConnect setTitle:@"Disconnect"];
    [self.buttonConnect setTintColor:[UIColor blackColor]];
    [self.player play];
}

-(void) bleDidUpdateRSSI:(NSNumber *)rssi
{
    NSLog(@"%@", rssi.stringValue);
}

- (IBAction)scanForPeripherals:(id)sender
{
    if (self.bleShield.activePeripheral) {
        if(self.bleShield.activePeripheral.isConnected)
        {
            [[self.bleShield CM] cancelPeripheralConnection:[self.bleShield activePeripheral]];
            return;
        }
    }

    if (self.bleShield.peripherals) {
        self.bleShield.peripherals = nil;
    }

    [self.bleShield findBLEPeripherals:3];

    [NSTimer scheduledTimerWithTimeInterval:(float)7.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

@end
