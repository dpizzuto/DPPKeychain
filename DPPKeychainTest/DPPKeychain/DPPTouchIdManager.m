//
//  DPPTouchId.m
//  DPPLockView
//
//  Created by Dario Pizzuto on 10/11/14.
//  Copyright (c) 2014 Dario Pizzuto. All rights reserved.
//

#import "DPPTouchIdManager.h"
#import "DPPKeychainManager.h"

@implementation DPPTouchIdManager

+ (instancetype)sharedInstance {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (BOOL)deviceEligibleForTouchID {

    LAContext *myContext = [LAContext new];
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        return YES;
    }
    return NO;
}

- (void)authenticateByTouchId:(NSString*)message withCompletion:(void(^)(BOOL flag, NSError *error))completion{
    
    LAContext *myContext = [LAContext new];
    NSString *myLocalizedReasonString = message;
    
    if([self deviceEligibleForTouchID]){
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    completion(YES,error);
                                } else {
                                    completion(NO,error);
                                }
                            }];
    }
    else {
        completion(NO,[NSError errorWithDomain:@"DPPTouchIdManager" code:99 userInfo:nil]);
    }
}


//- (void)saveLoginInfoByTouchId:(NSString*)message service:(NSString*)service username:(NSString*)username password:(NSString*)password withCompletion:(void(^)(BOOL flag, NSError *error))completion{
//    
//    
//    
//    LAContext *myContext = [[LAContext alloc] init];
//    NSError *authError = nil;
//    NSString *myLocalizedReasonString = message;
//    DPPKeychainManager *kcManager = [DPPKeychainManager new];
//    
//    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
//        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
//                  localizedReason:myLocalizedReasonString
//                            reply:^(BOOL success, NSError *error) {
//                                if (success) {
//                                    
//                                    [kcManager saveLoginInfoToKeychain:service username:username password:service saveItemiCloud:YES completion:^(NSError *error) {
//                                        
//                                        if(!error){
//                                            completion(YES,nil);
//                                        }
//                                        else{
//                                            completion(NO,error);
//                                        }
//                                    }];
//                                } else {
//                                    completion(NO,error);
//                                }
//                            }];
//    } else {
//        completion(NO,authError);
//    }
//}
//
//- (void)authenticateByTouchIdMessage:(NSString*)message serviceName:(NSString*)service withCompletion:(void(^)(BOOL flag, NSError *error))completion{
//
//
//}


@end
