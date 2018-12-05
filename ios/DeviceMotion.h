//
//  Devicemotion.h
//  RNSensors
//
//  Created by chen liu on 2018-12-05.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <CoreMotion/CoreMotion.h>

@interface DeviceMotion : NSObject <RCTBridgeModule> {
    CMMotionManager *_motionManager;
}

- (void) isAvailableWithResolver:(RCTPromiseResolveBlock) resolve
                        rejecter:(RCTPromiseRejectBlock) reject;
- (void) setUpdateInterval:(double) interval;
- (void) getUpdateInterval:(RCTResponseSenderBlock) cb;
- (void) getData:(RCTResponseSenderBlock) cb;
- (void) startUpdates;
- (void) stopUpdates;

@end
