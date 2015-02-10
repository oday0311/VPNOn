//
//  LTVPNTableViewCell.swift
//  VPNOn
//
//  Created by Lex on 1/16/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit

let kLTTableViewCellAccessoryWidth: CGFloat = 16
let kLTTableViewCellRightMargin: CGFloat = 36

class LTVPNTableViewCell: UITableViewCell
{
    var IKEv2: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        if IKEv2 {
            let tagWidth: CGFloat = 34
            let tagHeight: CGFloat = 14
            let tagX = CGRectGetWidth(bounds) - tagWidth - kLTTableViewCellAccessoryWidth - kLTTableViewCellRightMargin
            let tagY = (CGRectGetHeight(bounds) - tagHeight) / 2
            let tagRect = CGRectMake(tagX, tagY, tagWidth, tagHeight)
            drawIKEv2Tag(radius: 2, rect: tagRect, tagText: "IKEv2", color: tintColor)
        }
    }
    
    func drawIKEv2Tag(#radius: CGFloat, rect: CGRect, tagText: String, color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Variable Declarations
        let height: CGFloat = rect.size.height / 1.20
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        color.setStroke()
        rectanglePath.lineWidth = 1
        rectanglePath.stroke()
        
        
        //// Text Drawing
        let textRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(height - 1), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = NSString(string: tagText).boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect);
        NSString(string: tagText).drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview != nil {
            if accessoryType == .DisclosureIndicator {
                if accessoryView == nil {
                    accessoryView = LTTableViewCellDeclosureIndicator()
                    accessoryView!.frame = CGRectMake(0, 0, kLTTableViewCellAccessoryWidth, kLTTableViewCellAccessoryWidth)
                }
            }
        }
    }
}
