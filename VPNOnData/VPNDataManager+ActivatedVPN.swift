//
//  VPNDataManager+ActivatedVPN.swift
//  VPNOn
//
//  Created by Lex Tang on 1/20/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import VPNOnKit

extension VPNDataManager
{
    var activatedVPN: VPN? {
        get {
            if VPNManager.sharedManager().isActivatedVPNIDDeprecated {
                let vpns = allVPN()
                for vpn in vpns {
                    var url:NSURL = vpn.objectID.URIRepresentation()
                    var temp:String = url.lastPathComponent
                    let optionalIdx = Optional(temp)
                    if let shortID = optionalIdx {
                        if shortID == VPNManager.sharedManager().activatedVPNID {
                            VPNManager.sharedManager().activatedVPNID = vpn.ID
                        }
                    }
                }
            }
            
            if let activatedVPNID = VPNManager.sharedManager().activatedVPNID {
                return VPNByIDString(activatedVPNID)
            }
            return .None
        }
    }
    
    
}
