//
//  VPNKeychainWrapper.swift
//  VPNOn
//
//  Created by Lex Tang on 12/12/14.
//  Copyright (c) 2014 LexTang.com. All rights reserved.
//

import Foundation

//let kKeychainServiceName = NSBundle.mainBundle().bundleIdentifier!
let kKeychainServiceName = "com.thirdrock.VPNOn"

@objc(VPNKeychainWrapper)
class VPNKeychainWrapper
{
    class func setPassword(password: String, forVPNID VPNID: String) -> Bool {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        KeychainWrapper.removeObjectForKey(key)
        if password.isEmpty {
            return true
        }
        return KeychainWrapper.setString(password, forKey: key)
    }
    
    class func setSecret(secret: String, forVPNID VPNID: String) -> Bool {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        KeychainWrapper.removeObjectForKey("\(key)psk")
        if secret.isEmpty {
            return true
        }
        return KeychainWrapper.setString(secret, forKey: "\(key)psk")
    }
    
    class func setCertificate(certificate: NSData?, forVPNID VPNID: String) -> Bool {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        KeychainWrapper.removeObjectForKey("\(key)cert")
        if let data = certificate {
            KeychainWrapper.setData(data, forKey: "\(key)cert")
        }
        return true
    }
    
    class func passwordForVPNID(VPNID: String) -> NSData? {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        return KeychainWrapper.dataRefForKey(key)
    }
    
    class func secretForVPNID(VPNID: String) -> NSData? {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        return KeychainWrapper.dataRefForKey("\(key)psk")
    }
    
    class func destoryKeyForVPNID(VPNID: String) {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        KeychainWrapper.removeObjectForKey(key)
        KeychainWrapper.removeObjectForKey("\(key)psk")
        KeychainWrapper.removeObjectForKey("\(key)cert")
    }
    
    class func passwordStringForVPNID(VPNID: String) -> String? {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        return KeychainWrapper.stringForKey(key)
    }
    
    class func secretStringForVPNID(VPNID: String) -> String? {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        return KeychainWrapper.stringForKey("\(key)psk")
    }
    
    class func certificateForVPNID(VPNID: String) -> NSData? {
        var url:NSURL = NSURL(string: VPNID)!
        
        let key = url.lastPathComponent
        KeychainWrapper.serviceName = kKeychainServiceName
        return KeychainWrapper.dataForKey("\(key)cert")
    }
}