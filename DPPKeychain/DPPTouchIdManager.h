//
//  DPPTouchId.h
//  DPPLockView
//
//  Created by Dario Pizzuto on 10/11/14.
//  Copyright (c) 2014 Dario Pizzuto. All rights reserved.
//

@import Foundation;
@import LocalAuthentication;

@class DPPKeychainManager;

@interface DPPTouchIdManager : NSObject


+ (instancetype)sharedInstance;

- (void)authenticateByTouchId:(NSString*)message withCompletion:(void(^)(BOOL flag, NSError *error))completion;

- (BOOL)deviceEligibleForTouchID;

@end
