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
    // Do any additional setup after loading the view from its nib.
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

@end
