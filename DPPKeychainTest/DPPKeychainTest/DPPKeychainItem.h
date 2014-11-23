//
//  DPPKeychainItem.h
//  DPPLockView
//
//  Created by Dario Pizzuto on 16/11/14.
//  Copyright (c) 2014 Dario Pizzuto. All rights reserved.
//

@import Foundation;
@import ObjectiveC.runtime;

typedef NS_ENUM(NSInteger, KCAccessibilityType){
    KCAccessibilityAlwaysThisDeviceOnly,
    KCAccessibilityAlways,
    KCAccessibilityWhenUnlocked,
    KCAccessibilityAfterFirstUnlock,
    KCAccessibilityWhenUnlockedThisDeviceOnly,
    KCAccessibilityAfterFirstUnlockThisDeviceOnly
};

typedef NS_ENUM(NSInteger, KCSyncType){
    KCSyncTypeiCloud,
    KCSyncTypeLocal
};

typedef NS_ENUM(NSInteger, KCPasswordType){

    KCPasswordTypeGeneric,
    KCPasswordTypeInternet,
    KCPasswordTypeCertificate,
    KCPasswordTypeKey,
    KCPasswordTypeIdentity
};


@interface DPPKeychainItem : NSObject


@property(nonatomic,strong) NSData *username;
@property(nonatomic,strong) NSData *passsword;
@property(nonatomic,strong) NSData *service;
@property(nonatomic,strong) NSData *genericDescription;
@property(nonatomic,assign) KCSyncType syncType;
@property(nonatomic,assign) KCAccessibilityType accessibilityType;
@property(nonatomic,assign) KCPasswordType passwordType;


- (instancetype)initWithService:(NSString*)service username:(NSString*)username password:(NSString*)pwd
                    description:(NSString*)genericDesc syncType:(KCSyncType)sType accessibility:(KCAccessibilityType)accType
                   passwordType:(KCPasswordType)pwdType;

- (NSString*)stringFromPropertyName:(NSString*)prop;

@end
