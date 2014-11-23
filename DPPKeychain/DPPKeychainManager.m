//
//  DPPKeychainManager.m
//  DPPLockView
//
//  Created by Dario Pizzuto on 09/11/14.
//  Copyright (c) 2014 Dario Pizzuto. All rights reserved.
//

#import "DPPKeychainManager.h"

@implementation DPPKeychainManager

- (instancetype)init {
    
    self = [super init];
    
    if(self){
        return self;
    }
    return nil;
}

#pragma mark - Keychain Login item

- (void)saveDPPKechainItem:(DPPKeychainItem*)keychainItem completion:(void(^)(NSError* error))completion {
    
    NSMutableDictionary *kcDictionary = [self buildKeychainDictionarySaveAction:keychainItem];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)kcDictionary, NULL);
    if(errSecSuccess != status) {
        NSLog(@"Unable add item with key =%@ error:%d",[keychainItem service],(int)status);
        completion([NSError errorWithDomain:@"DPPKeychain" code:1 userInfo:nil]);
    }
    else{
        completion(nil);
    }
}


- (void)retrieveDPPKeychainItem:(NSString*)service kcSyncType:(KCSyncType)syncType kcAccessibilityType:(KCAccessibilityType)accType kcPasswordType:(KCPasswordType)pwdType completion:(void(^)(NSString *username, NSString *password))completion{

    NSMutableDictionary *dict = [self buildKeychainDictionaryRetrieveAction:service kcSyncType:syncType kcAccessibilityType:accType passwordType:pwdType];
    
    CFDictionaryRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict,(CFTypeRef *)&result);
    
    if( status != errSecSuccess) {
        NSLog(@"Unable to fetch item for key %@ with error:%d",service,(int)status);
        //        NSLog(@"Error: %@",NSStringFromOSStatus(status));
        completion(nil,nil);
    }
    else{
        completion([[NSString alloc]initWithData:(__bridge NSData *)CFDictionaryGetValue(result, kSecAttrAccount) encoding:NSUTF8StringEncoding],
                   [[NSString alloc]initWithData:(__bridge NSData *)CFDictionaryGetValue(result, kSecValueData) encoding:NSUTF8StringEncoding]);
        
    }
}


- (void)updateDPPKeychainItem:(DPPKeychainItem*)item toDPPKeychainItem:(DPPKeychainItem*)newItem
                   completion:(void(^)(NSError* error))completion {
    
    NSMutableDictionary *dict = [self buildKeychainDictionarySaveAction:item];
    
    NSMutableDictionary *keychainDictionaryToUpdate = [self buildKeychainDictionaryUpdateAction:[item stringFromPropertyName:@"service"] username:[newItem stringFromPropertyName:@"username"] password:[newItem stringFromPropertyName:@"passsword"]];

    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)dict, (__bridge CFDictionaryRef)keychainDictionaryToUpdate);

    if(errSecSuccess != status) {
        NSLog(@"Unable add item with key =%@ error:%d",[newItem stringFromPropertyName:@"username"],(int)status);
//        NSLog(@"Error: %@",NSStringFromOSStatus(status));
        completion([NSError errorWithDomain:@"DPPKeychain" code:1 userInfo:nil]);
    }
    else{
        completion(nil);
    }
}


- (void)deleteDPPKeychainItem:(NSString*)service kcSyncType:(KCSyncType)syncType kcAccessibilityType:(KCAccessibilityType)accType kcPasswordType:(KCPasswordType)pwdType completion:(void(^)(NSError* error))completion {

    NSMutableDictionary *dict = [self buildKeychainDictionaryDeleteAction:service kcSyncType:syncType kcAccessibilityType:accType passwordType:pwdType];;
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dict);
    if( status != errSecSuccess) {
//        NSLog(@"Error: %@",NSStringFromOSStatus(status));
        completion([NSError errorWithDomain:@"DPPKeychain" code:1 userInfo:nil]);
        NSLog(@"Unable to remove item for key %@ with error:%d",service,(int)status);
    }
    else{
        completion(nil);
    }
    
}



#pragma mark -  NSMutableDictionary build based on action

- (NSMutableDictionary*)buildKeychainDictionarySaveAction:(DPPKeychainItem*)kItem{

    NSMutableDictionary *keychainDictionary = [[NSMutableDictionary alloc] init];
    [keychainDictionary setObject:[self convertKCPasswordType:[kItem passwordType]] forKey:(__bridge id)kSecClass];
    [keychainDictionary setObject:[self convertKCAccessibilityType:[kItem accessibilityType]] forKey:(__bridge id)kSecAttrAccessible];
    [keychainDictionary setObject:[self convertKCSyncType:[kItem syncType]] forKey:(__bridge id)kSecAttrSynchronizable];
    [keychainDictionary setObject:[kItem passsword] forKey:(__bridge id)kSecValueData];
    [keychainDictionary setObject:[kItem username] forKey:(__bridge id)kSecAttrAccount];
    [keychainDictionary setObject:[kItem service] forKey:(__bridge id)kSecAttrService];
    [keychainDictionary setObject:[kItem genericDescription] forKey:(__bridge id)kSecAttrGeneric];
    
    return keychainDictionary;
}

- (NSMutableDictionary*)buildKeychainDictionaryRetrieveAction:(NSString*)service kcSyncType:(KCSyncType)syncType kcAccessibilityType:(KCAccessibilityType)accType passwordType:(KCPasswordType)pwdType{
    
    NSMutableDictionary *keychainDictionary = [[NSMutableDictionary alloc] init];
    [keychainDictionary setObject:[self convertKCPasswordType:pwdType] forKey:(__bridge id)kSecClass];
    [keychainDictionary setObject:[self convertKCAccessibilityType:accType] forKey:(__bridge id)kSecAttrAccessible];
    [keychainDictionary setObject:[self convertKCSyncType:syncType] forKey:(__bridge id)kSecAttrSynchronizable];
    [keychainDictionary setObject:service forKey:(__bridge id)kSecAttrService];
    [keychainDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [keychainDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    [keychainDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

    return keychainDictionary;
}

- (NSMutableDictionary*)buildKeychainDictionaryUpdateAction:(NSString*)service username:(NSString*)username password:(NSString*)pwd {
    
    NSMutableDictionary *keychainDictionary = [[NSMutableDictionary alloc] init];
    [keychainDictionary setObject:[service dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecAttrService];
    [keychainDictionary setObject:[username dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecAttrAccount];
    [keychainDictionary setObject:[pwd dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    return keychainDictionary;
}

- (NSMutableDictionary*)buildKeychainDictionaryDeleteAction:(NSString*)service kcSyncType:(KCSyncType)syncType kcAccessibilityType:(KCAccessibilityType)accType passwordType:(KCPasswordType)pwdType{
    
    NSMutableDictionary *keychainDictionary = [[NSMutableDictionary alloc] init];
    [keychainDictionary setObject:[self convertKCPasswordType:pwdType] forKey:(__bridge id)kSecClass];
    [keychainDictionary setObject:[self convertKCAccessibilityType:accType] forKey:(__bridge id)kSecAttrAccessible];
    [keychainDictionary setObject:[self convertKCSyncType:syncType] forKey:(__bridge id)kSecAttrSynchronizable];
    [keychainDictionary setObject:service forKey:(__bridge id)kSecAttrService];
    
    return keychainDictionary;
}


#pragma mark -  Convert DPP***Type enum

- (id)convertKCAccessibilityType:(KCAccessibilityType)accType{

    switch (accType) {
        case KCAccessibilityAlwaysThisDeviceOnly:
            return (__bridge id)(kSecAttrAccessibleAlwaysThisDeviceOnly);
        case KCAccessibilityAlways:
            return (__bridge id)(kSecAttrAccessibleAlways);
        case KCAccessibilityWhenUnlocked:
            return (__bridge id)(kSecAttrAccessibleWhenUnlocked);
        case KCAccessibilityAfterFirstUnlock:
            return (__bridge id)(kSecAttrAccessibleAfterFirstUnlock);
        case KCAccessibilityWhenUnlockedThisDeviceOnly:
            return (__bridge id)(kSecAttrAccessibleWhenUnlockedThisDeviceOnly);
        case KCAccessibilityAfterFirstUnlockThisDeviceOnly:
            return (__bridge id)(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly);
        default:
            return (__bridge id)(kSecAttrAccessibleAlwaysThisDeviceOnly);
    }
}


- (id)convertKCSyncType:(KCSyncType)syncType{
    
    switch (syncType) {
        case KCSyncTypeiCloud:
            return (id)(kCFBooleanTrue);
        case KCSyncTypeLocal:
            return (id)(kCFBooleanFalse);
        default:
            return (id)(kCFBooleanFalse);
    }
}

- (id)convertKCPasswordType:(KCPasswordType)pwdType{
    
    switch (pwdType) {
        case KCPasswordTypeCertificate:
            return (__bridge id)(kSecClassCertificate);
        case KCPasswordTypeGeneric:
            return (__bridge id)(kSecClassGenericPassword);
        case KCPasswordTypeIdentity:
            return (__bridge id)(kSecClassIdentity);
        case KCPasswordTypeInternet:
            return (__bridge id)(kSecClassInternetPassword);
        case KCPasswordTypeKey:
            return (__bridge id)(kSecClassKey);
        default:
            return (__bridge id)(kSecClassGenericPassword);
    }
}


@end
