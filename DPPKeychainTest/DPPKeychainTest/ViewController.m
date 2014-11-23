//
//  ViewController.m
//  DPPKeychainTest
//
//  Created by Dario Pizzuto on 23/11/14.
//  Copyright (c) 2014 Dario Pizzuto. All rights reserved.
//

#import "ViewController.h"
#import "DPPKeychainManager.h"
#import "DPPTouchIdManager.h"
#import "DPPKeychainItem.h"

@interface ViewController ()

@end

@implementation ViewController{
    
    DPPKeychainManager *kcManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kcManager = [[DPPKeychainManager alloc]init];
    
    
}


- (IBAction)save:(id)sender{
    
    DPPKeychainItem *kcItem = [[DPPKeychainItem alloc]initWithService:@"DPPKeychain" username:@"pizzuto.dario" password:@"test" description:@"my service" syncType:KCSyncTypeiCloud accessibility:KCAccessibilityAlways passwordType:KCPasswordTypeGeneric];
    
    [[DPPTouchIdManager sharedInstance]authenticateByTouchId:@"Would you use touchID for save password ?" withCompletion:^(BOOL flag, NSError *error) {
        
        NSLog(@"Flag ? %i",flag);
        NSLog(@"Error: %@",error);
        
        if(!error && flag){
            
            [kcManager saveDPPKechainItem:kcItem completion:^(NSError *error) {
                if(!error){
                    NSLog(@"All ok");
                }
                else{
                    NSLog(@"Some errors found");
                }
            }];
        }
    }];
}


- (IBAction)retrieve:(id)sender{
    
    [[DPPTouchIdManager sharedInstance]authenticateByTouchId:@"TouchID ?" withCompletion:^(BOOL flag, NSError *error) {
        
        NSLog(@"Flag ? %i",flag);
        NSLog(@"Error: %@",error);
        
        if(flag){
            [kcManager retrieveDPPKeychainItem:@"DPPKeychain" kcSyncType:KCSyncTypeiCloud kcAccessibilityType:KCAccessibilityAlways kcPasswordType:KCPasswordTypeGeneric completion:^(NSString *username, NSString *password) {
                
                NSLog(@"PWD: %@",password);
                NSLog(@"Username: %@",username);
            }];
        }
        
    }];
}

- (IBAction)delete:(id)sender{
    
    [kcManager deleteDPPKeychainItem:@"DPPKeychain" kcSyncType:KCSyncTypeiCloud kcAccessibilityType:KCAccessibilityAlways kcPasswordType:KCPasswordTypeGeneric completion:^(NSError *error) {
        if(!error){
            NSLog(@"All ok");
        }
        else{
            NSLog(@"Some errors found");
        }
    }];
    
    
}

- (IBAction)update:(id)sender{
    
    DPPKeychainItem *kcItem = [[DPPKeychainItem alloc]initWithService:@"DPPKeychain" username:@"pizzuto.dario" password:@"test" description:@"my service" syncType:KCSyncTypeiCloud accessibility:KCAccessibilityAlways passwordType:KCPasswordTypeGeneric];
    
    DPPKeychainItem *kcItemnew = [[DPPKeychainItem alloc]initWithService:@"DPPKeychain" username:@"pizzuto.darietto" password:@"testnew" description:@"My service" syncType:KCSyncTypeiCloud accessibility:KCAccessibilityAlways passwordType:KCPasswordTypeGeneric];
    
    
    [kcManager updateDPPKeychainItem:kcItem toDPPKeychainItem:kcItemnew completion:^(NSError *error) {
        if(!error){
            NSLog(@"All ok");
        }
        else{
            NSLog(@"Some errors found");
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
