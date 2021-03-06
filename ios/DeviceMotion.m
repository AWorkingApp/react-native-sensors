
//  DeviceMotion.m


#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#include <math.h>
#import "DeviceMotion.h"

@implementation DeviceMotion

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"DeviceMotion");
    
    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_REMAP_METHOD(isAvailable,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    return [self isAvailableWithResolver:resolve
                                rejecter:reject];
}

- (void) isAvailableWithResolver:(RCTPromiseResolveBlock) resolve
                        rejecter:(RCTPromiseRejectBlock) reject {
    if([self->_motionManager isDeviceMotionAvailable])
    {
        /* Start the accelerometer if it is not active already */
        if([self->_motionManager isDeviceMotionActive] == NO)
        {
            resolve(@YES);
        } else {
            reject(@"-1", @"DeviceMotion is not active", nil);
        }
    }
    else
    {
        reject(@"-1", @"DeviceMotion is not available", nil);
    }
}

RCT_EXPORT_METHOD(setUpdateInterval:(double) interval) {
    NSLog(@"setUpdateInterval: %f", interval);
    double intervalInSeconds = interval / 1000;
    
    [self->_motionManager setDeviceMotionUpdateInterval:intervalInSeconds];
}

RCT_EXPORT_METHOD(getUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.deviceMotionUpdateInterval;
    NSLog(@"getUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getData:(RCTResponseSenderBlock) cb) {
    double x = self->_motionManager.deviceMotion.gravity.x;
    double y = self->_motionManager.deviceMotion.gravity.y;
    double z = self->_motionManager.deviceMotion.gravity.z;
    double timestamp = self->_motionManager.deviceMotion.timestamp;
    
    double pitchRadians = atan2(z, y);
    double pitch = (pitchRadians / (M_PI / 180));
    if(pitch < 0) {
        pitch = 360.0 + pitch;
    }
    pitch = 270 - pitch;
    double yawRadians = atan2(y, x);
    double yaw = (yawRadians / (M_PI / 180));
    if (yaw < 0) {
        yaw = -1 * yaw;
    } else {
        yaw = 180 - yaw + 180;
    }
    
    NSLog(@"getData: %f, %f, %f, %f, %f, %f", x, y, z, timestamp, pitch, yaw);
    
    cb(@[[NSNull null], @{
             @"x" : [NSNumber numberWithDouble:x],
             @"y" : [NSNumber numberWithDouble:y],
             @"z" : [NSNumber numberWithDouble:z],
             @"pitch" : [NSNumber numberWithDouble: pitch],
             @"yaw" : [NSNumber numberWithDouble: yaw],
             @"timestamp" : [NSNumber numberWithDouble:timestamp]
             }]
       );
}

RCT_EXPORT_METHOD(startUpdates) {
    NSLog(@"startUpdates");
    [self->_motionManager startDeviceMotionUpdates];
    
    /* Receive the devicemotion data on this block */
    
    [self->_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                              withHandler:^(CMDeviceMotion *deviceMotion, NSError *error)
     {
         double x = deviceMotion.gravity.x;
         double y = deviceMotion.gravity.y;
         double z = deviceMotion.gravity.z;
         
         double timestamp = deviceMotion.timestamp;
         
         double pitchRadians = atan2(z, y);
         double pitch = (pitchRadians / (M_PI / 180));
         if(pitch < 0) {
             pitch = 360.0 + pitch;
         }
         pitch = 270 - pitch;
         
         double yawRadians = atan2(y, x);
         double yaw = (yawRadians / (M_PI / 180));
         if (yaw < 0) {
             yaw = -1 * yaw;
         } else {
             yaw = 180 - yaw + 180;
         }
         
         NSLog(@"startDeviceMotionUpdates: %f, %f, %f, %f, %f, %f", x, y, z, timestamp, pitch, yaw);
         
         [self.bridge.eventDispatcher sendDeviceEventWithName:@"DeviceMotion" body:@{
                                                                                     @"x" : [NSNumber numberWithDouble:x],
                                                                                     @"y" : [NSNumber numberWithDouble:y],
                                                                                     @"z" : [NSNumber numberWithDouble:z],
                                                                                     @"pitch" : [NSNumber numberWithDouble: pitch],
                                                                                     @"yaw" : [NSNumber numberWithDouble: yaw],
                                                                                     @"timestamp" : [NSNumber numberWithDouble:timestamp]
                                                                                     }];
     }];
    
}

RCT_EXPORT_METHOD(stopUpdates) {
    NSLog(@"stopUpdates");
    [self->_motionManager stopDeviceMotionUpdates];
}

@end
