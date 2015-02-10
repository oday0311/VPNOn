//
//  VPNManager.h
//  VPNOnFramework
//
//  Created by Lex on 12/12/14.
//  Copyright (c) 2014 Lex Tang. All rights reserved.
//

#ifndef VPNOnFramework_VPNManager_h
#define VPNOnFramework_VPNManager_h

@import Foundation;
@import NetworkExtension;

@class VPNManager;

@interface VPNManager : NSObject

@property (strong, nonatomic) NSString *activatedVPNID;
@property (readonly, nonatomic) NEVPNStatus status;
@property (readonly, nonatomic) BOOL isActivatedVPNIDDeprecated;
@property (strong, nonatomic) NSString *onDemandDomains;
@property (strong, nonatomic) NSArray *onDemandDomainsArray;
@property (assign, nonatomic) BOOL onDemand;

+ (VPNManager *) sharedManager;

- (void) connectIPSec:(NSString *)title
               server:(NSString *)server
              account:(NSString *)account
                group:(NSString *)group
             alwaysOn:(BOOL)alwaysOn
          passwordRef:(NSData *)passwordRef
            secretRef:(NSData *)secretRef
          certificate:(NSData *)certificate;

- (void) connectIKEv2:(NSString *)title
               server:(NSString *)server
              account:(NSString *)account
                group:(NSString *)group
             alwaysOn:(BOOL)alwaysOn
          passwordRef:(NSData *)passwordRef
            secretRef:(NSData *)secretRef
          certificate:(NSData *)certificate;

- (void) disconnect;

- (void) removeProfile;

- (NSArray *) domainsInString:(NSString *)string;

@end

#endif
