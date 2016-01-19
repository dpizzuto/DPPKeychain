DPPKeychain
===========

DPPKeychain contains a series of classes used for manage easily the iOS keychain and TouchID auth.
The classes are:

- **DPPKeychainManager**, a wrapper for basic operation with iOS keychain (save, retrieve, update, delete).
- **DPPKeychainItem**, a model class that represents keychain item.
- **DPPTouchIdManager**, a wrapper for LocalAuthentication framework. It's a singleton.


DPPTouchIdManager
=================
This class is a Singleton and contains method for check if device is eligible to use touchId authentication or not.
The main method of class is:
```
 - (void)authenticateByTouchId:(NSString*)message withCompletion:(void(^)(BOOL flag, NSError *error))completion
 ```
if device is eligible, this method will show the classic prompt view of touchId with customized message and will return true/false based on correct fingerprint auth or errors.

DPPKeychainManager
==================
This class manages the main operation that you can do on iOS Keychain. The class should be used along with DPPKeychainItem that represents the item of keychain. DPPkeychainItem is designed for authetication purposes so it couldn't have many properties useful for other purposes. 

DPPKeychainItem has the following properties:
- NSData *username
- NSData *passsword
- NSData *service
- NSData *genericDescription
- KCSyncType syncType
- KCAccessibilityType accessibilityType
- KCPasswordType passwordType

Service property is important because will be the main attribute that allows to query the iOS keychain

How to use
==========
###Save operation
Suppose you want to add support for touchID on your application and/or store the login and password of your application with iOS keychain.
You can use DPPTouchIdManager for authenticate user with fingerprint and DPPKeychainManager for saving operation:
```objective-c
    DPPKeychainManager *kcManager = [[DPPKeychainManager alloc] init];
    DPPKeychainItem *kcItem = [[DPPKeychainItem alloc]initWithService:@"MyServiceName" username:@"dpizzuto" password:@"myAw3s0M3pa77W0rD" description:@"My awesome Service" syncType:KCSyncTypeiCloud accessibility:KCAccessibilityAlways passwordType:KCPasswordTypeGeneric];
    
    [[DPPTouchIdManager sharedInstance]authenticateByTouchId:@"Would you use touchID ?" withCompletion:^(BOOL flag, NSError *error) {

        if(!error && flag){

            [kcManager saveDPPKechainItem:kcItem completion:^(NSError *error) {
                if(!error){
                    NSLog(@"All ok");
                }
                else{
                    NSLog(@"Some errors found %@",error);
                }
            }];
        }
    }];
```

###Retrieve operation
If you would to retrieve auth information from keychain, you could use following method:
```objective-c
	[kcManager retrieveDPPKeychainItem:@"MyServiceName" kcSyncType:KCSyncTypeiCloud kcAccessibilityType:KCAccessibilityAlways kcPasswordType:KCPasswordTypeGeneric completion:^(NSString *username, NSString *password) {
		NSLog(@"Username: %@",username);
		NSLog(@"Password: %@",password);
	}];
```
When you retrieve the item from keychain, you should to specify the properties of items used during the save operation otherwise you can't retrieve correcly the data.
You can also encapsulate this method within the method for auth by TouchId so, the credential are retrieved only if touchId passes validation.

###Update operation
You could update the information in the following way:
```objective-c
    DPPKeychainItem *kcItem = [[DPPKeychainItem alloc]initWithService:@"DPPKeychain" username:@"pizzuto.dario" password:@"test" description:@"my service" syncType:KCSyncTypeiCloud accessibility:KCAccessibilityAlways passwordType:KCPasswordTypeGeneric];
    
    DPPKeychainItem *kcItemnew = [[DPPKeychainItem alloc]initWithService:@"DPPKeychain" username:@"dpizzuto" password:@"testnew" description:@"My service" syncType:KCSyncTypeiCloud accessibility:KCAccessibilityAlways passwordType:KCPasswordTypeGeneric];
    
    
    [kcManager updateDPPKeychainItem:kcItem toDPPKeychainItem:kcItemnew completion:^(NSError *error) {
        if(!error){
            NSLog(@"All ok");
        }
        else{
            NSLog(@"Some errors found");
        }
    }];
```
You have to configure the first item for retrieving the information and the second item for updating infomrations.

###Delete operation
If you want to delete the informations saved, you can do:
```objective-c
    [kcManager deleteDPPKeychainItem:@"DPPKeychain" kcSyncType:KCSyncTypeiCloud kcAccessibilityType:KCAccessibilityAlways kcPasswordType:KCPasswordTypeGeneric completion:^(NSError *error) {
        if(!error){
            NSLog(@"All ok");
        }
        else{
            NSLog(@"Some errors found: %@",error);
        }
    }];
```

ToDo
====
- Strong error management
- Single class for manage both DPPKeychainManager and DPPTouchIdManager

License
=======

The MIT License (MIT)

Copyright (c) 2014 Dario Pizzuto

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
