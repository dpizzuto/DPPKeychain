//
//  DPPKeychainManager.h
//  DPPLockView
//
//  Created by Dario Pizzuto on 09/11/14.
//  Copyright (c) 2014 Dario Pizzuto. All rights reserved.
//

@import Foundation;
#import "DPPKeychainItem.h"

@interface DPPKeychainManager : NSObject

- (instancetype)init;

- (void)saveDPPKechainItem:(DPPKeychainItem*)keychainItem completion:(void(^)(NSError* error))completion;

- (void)retrieveDPPKeychainItem:(NSString*)service kcSyncType:(KCSyncType)syncType kcAccessibilityType:(KCAccessibilityType)accType kcPasswordType:(KCPasswordType)pwdType completion:(void(^)(NSString *username, NSString *password))completion;

- (void)updateDPPKeychainItem:(DPPKeychainItem*)item toDPPKeychainItem:(DPPKeychainItem*)newItem
                   completion:(void(^)(NSError* error))completion;

- (void)deleteDPPKeychainItem:(NSString*)service kcSyncType:(KCSyncType)syncType kcAccessibilityType:(KCAccessibilityType)accType kcPasswordType:(KCPasswordType)pwdType completion:(void(^)(NSError* error))completion;

@end
