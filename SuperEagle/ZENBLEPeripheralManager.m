//
//  ZENBLEPeripheralManager.m
//  SuperEagle
//
//  Created by David Worley on 6/8/14.
//  Copyright (c) 2014 Zen Lab, LLC. All rights reserved.
//

#import "ZENBLEPeripheralManager.h"

@implementation ZENBLEPeripheralManager

- (ZENBLEPeripheralManager *) init {

    self = [super init];

    if (self) {
        _serviceUUID = [CBUUID UUIDWithString:CONTROL_SERVICE_UUID];
        _directionUUID = [CBUUID UUIDWithString:DIRECTION_CHARACTERISTIC_UUID];
        _speedUUID = [CBUUID UUIDWithString:SPEED_CHARACTERISTIC_UUID];
        _manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        _direction = 0.5f;
        _speed = 0;
    }
    return self;
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {

}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{

}

- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }

    NSDictionary *controlServiceSettings = @{CBAdvertisementDataLocalNameKey : @"RobotRemote",
                                             CBAdvertisementDataServiceUUIDsKey: @[_serviceUUID]};
    [_manager startAdvertising:controlServiceSettings];
    NSLog(@"Advertising control service.");

    _directionCharacteristic = [[CBMutableCharacteristic alloc] initWithType:_directionUUID
                                                                  properties:CBCharacteristicPropertyRead
                                                                       value:nil
                                                                 permissions:CBAttributePermissionsReadable];
    _speedCharacteristic = [[CBMutableCharacteristic alloc] initWithType:_speedUUID
                                                              properties:CBCharacteristicPropertyRead
                                                                   value:nil
                                                             permissions:CBAttributePermissionsReadable];

    // make the service with the characteristics
    CBMutableService *controlService = [[CBMutableService alloc] initWithType:_serviceUUID primary:YES];
    controlService.characteristics = @[_directionCharacteristic, _speedCharacteristic];
    [_manager addService:controlService];
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral
                   central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    [self prepareAndSendData];
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    NSLog(@"%fd, %d", _direction, _speed);
    [self prepareAndSendData];
}

- (void) prepareAndSendData {
    NSLog(@"preparing data");
    // make the values be data
    _directionData = [NSData dataWithBytes: &_direction length: sizeof(_direction)];
    _speedData = [NSData dataWithBytes: &_speed length: sizeof(_speed)];

    // SEND THAT SHIT
    NSNumber *directionDataIndexNumber = [NSNumber numberWithInt:0];
    NSNumber *speedDataIndexNumber = [NSNumber numberWithInt:0];
    NSDictionary *datadict = @{@"direction": @[_directionData, directionDataIndexNumber, _directionCharacteristic],
                               @"speed": @[_speedData, speedDataIndexNumber, _speedCharacteristic]};
    for (NSArray *sendData in datadict) {
        [self send:(NSData *)[sendData objectAtIndex:0]
           atIndex:(NSNumber *)[sendData objectAtIndex:1]
 forCharacteristic:[sendData objectAtIndex:2]];
    }
}

- (void) send:(NSData *)data atIndex:(NSNumber *)startIndex forCharacteristic:(CBMutableCharacteristic *)characteristic {
    static BOOL isSendingEOM = NO;
    NSInteger index = [startIndex intValue];
    NSData *eom = [@"EOM" dataUsingEncoding:NSUTF8StringEncoding];

    if (index >= data.length){
        return;
    }

    BOOL didSend = YES;

    while (didSend) {

        NSInteger amountToSend = data.length - index;
        if (amountToSend > NOTIFY_MTU) {
            amountToSend = NOTIFY_MTU;
        }
        NSData *chunk = [NSData dataWithBytes:data.bytes + index length:amountToSend];
        didSend = [_manager updateValue:chunk
                      forCharacteristic:characteristic
                   onSubscribedCentrals:nil];
        if (!didSend) {
            return;
        }

        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);

        index += amountToSend;
        if (index >= data.length) {
            isSendingEOM = YES;
            BOOL eomSent = [_manager updateValue:eom
                               forCharacteristic:characteristic
                            onSubscribedCentrals:nil];
            if (eomSent) {
                isSendingEOM = NO;
                NSLog(@"Sent: EOM");
            }

            return;
        }
    }
}

@end
