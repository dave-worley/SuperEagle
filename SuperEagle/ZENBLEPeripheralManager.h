//
//  ZENBLEPeripheralManager.h
//  SuperEagle
//
//  Created by David Worley on 6/8/14.
//  Copyright (c) 2014 Zen Lab, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SERVICES.h"

@interface ZENBLEPeripheralManager : NSObject <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *manager;

@property (strong, nonatomic) CBMutableCharacteristic *directionCharacteristic;
@property (strong, nonatomic) CBMutableCharacteristic *speedCharacteristic;

@property (nonatomic, readwrite) CGFloat direction;
@property (nonatomic, readwrite) NSInteger speed;
@property (strong, nonatomic) NSData *directionData;
@property (strong, nonatomic) NSData *speedData;

@property (strong, nonatomic) CBUUID *serviceUUID;
@property (strong, nonatomic) CBUUID *directionUUID;
@property (strong, nonatomic) CBUUID *speedUUID;

- (ZENBLEPeripheralManager *) init;

@end
