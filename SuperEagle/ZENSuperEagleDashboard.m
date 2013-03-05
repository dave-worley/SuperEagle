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

    NSArray *sliders = [NSArray arrayWithObjects:self.leftMotorSlider,
                                                 self.motorSlider,
                                                 self.rightMotorSlider, nil];
    [self positionMotorSliders:[self realignMotorSliders:sliders]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) realignMotorSliders:(NSArray *)motorSliders
{
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    for (UISlider *slider in motorSliders) {
        [slider setTransform:trans];
    }
    return motorSliders;
}
- (NSArray *) positionMotorSliders:(NSArray *)motorSliders
{
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    NSInteger width = windowFrame.size.width;
    NSInteger columnWidth = width / 3;
    NSInteger columnStart = (columnWidth / 2) - 5;
    for (UISlider *slider in motorSliders) {
        CGRect sliderFrame = slider.frame;
        CGRect newFrame = CGRectMake(columnStart, 20, sliderFrame.size.width, sliderFrame.size.height);
        [slider setFrame:newFrame];
        columnStart += columnWidth;
    }
    return motorSliders;
}
- (NSArray *)positionMotorSpeedLabels:(NSArray *)motorSpeedLabels
{
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    NSInteger width = windowFrame.size.width;
    NSInteger columnWidth = width / 3;
    NSInteger columnStart = (columnWidth / 2) - 5;
    for (UILabel *label in motorSpeedLabels) {
        CGRect currentFrame = [label frame];
        CGRect newFrame = CGRectMake(columnStart, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
        [label setFrame:newFrame];
        columnStart += columnWidth;
    }
    return motorSpeedLabels;
}

#pragma mark - Event Handling
- (IBAction) leftMotorSliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger index = roundl(slider.value);
    NSData *payload = [NSData dataWithBytes:&index length:sizeof(index)];
    [self.bleShield write:payload];
}
- (IBAction) motorSliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger index = roundl(slider.value);
    NSData *payload = [NSData dataWithBytes:&index length:sizeof(index)];
    [self.bleShield write:payload];
}
- (IBAction) rightMotorSliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger index = roundl(slider.value);
    NSData *payload = [NSData dataWithBytes:&index length:sizeof(index)];
    [self.bleShield write:payload];
}
- (IBAction) motorSliderWasReleased:(id)sender
{
    [UIView animateWithDuration:0.25f animations:^{
        [(UISlider *)sender setValue:0];
    }];
    NSUInteger index = 0;
    NSData *payload = [NSData dataWithBytes:&index length:sizeof(index)];
    [self.bleShield write:payload];
}
- (NSString *) stringForSlider:(UISlider *)slider
{
    return [NSString stringWithFormat:@"%f", slider.value];
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
    //[self.buttonConnect setTitle:@"Connect" forState:UIControlStateNormal];
}

-(void) bleDidConnect
{
    [self.spinner stopAnimating];
    //[self.buttonConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
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

//- (IBAction)BLEShieldSend:(id)sender
//{
//    NSString *s;
//    NSData *d;
//
//    if (self.textField.text.length > 16)
//        s = [self.textField.text substringToIndex:16];
//    else
//        s = self.textField.text;
//
//    s = [NSString stringWithFormat:@"%@\r\n", s];
//    d = [s dataUsingEncoding:NSUTF8StringEncoding];
//
//    [bleShield write:d];
//}
//
//- (IBAction)BLEShieldScan:(id)sender
//{
//    if (bleShield.activePeripheral)
//        if(bleShield.activePeripheral.isConnected)
//        {
//            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
//            return;
//        }
//
//    if (bleShield.peripherals)
//        bleShield.peripherals = nil;
//
//    [bleShield findBLEPeripherals:3];
//
//    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
//
//    [self.spinner startAnimating];
//}

@end
