//
//  LTTableViewActionCell.swift
//  VPNOn
//
//  Created by Lex Tang on 1/21/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit

class LTTableViewActionCell: UITableViewCell
{
    var _disabled = false
    var disabled: Bool {
        get {
            return _disabled
        }
        set {
            if newValue {
                Optional(self.textLabel)?.textColor = LTThemeManager.sharedManager.currentTheme!.textColor
            } else {
                Optional(self.textLabel)?.textColor = LTThemeManager.sharedManager.currentTheme!.tintColor
            }
        }
    }
}
