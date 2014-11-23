//
//  DPPKeychainItem.m
//  DPPLockView
//
//  Created by Dario Pizzuto on 16/11/14.
//  Copyright (c) 2014 Dario Pizzuto. All rights reserved.
//

#import "DPPKeychainItem.h"

@implementation DPPKeychainItem

- (instancetype)initWithService:(NSString*)service username:(NSString*)username password:(NSString*)pwd
                    description:(NSString*)genericDesc syncType:(KCSyncType)sType accessibility:(KCAccessibilityType)accType
                   passwordType:(KCPasswordType)pwdType {

    self = [super init];
    if(self){
    
        self.service = [service dataUsingEncoding:NSUTF8StringEncoding];
        self.username = [username dataUsingEncoding:NSUTF8StringEncoding];
        self.passsword = [pwd dataUsingEncoding:NSUTF8StringEncoding];
        self.genericDescription = [genericDesc dataUsingEncoding:NSUTF8StringEncoding];
        self.syncType = sType;
        self.accessibilityType = accType;
        self.passwordType = pwdType;
        
        return self;
    }
    
    return nil;
}


- (NSString*)stringFromPropertyName:(NSString*)prop{

    return [[NSString alloc]initWithData:(NSData*)[self valueForKey:prop] encoding:NSUTF8StringEncoding];
}


- (objc_property_t)propertyNames:(NSString*)propToSearch {
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *tempName = [NSString stringWithUTF8String:name];
        
        if([tempName isEqualToString:propToSearch]){
            return property;
        }
    }
    free(properties);
    return nil;
}


@end
