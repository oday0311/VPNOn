//
//  LTVPNCertificateViewController.swift
//  VPNOn
//
//  Created by Lex on 1/23/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import VPNOnKit

@objc protocol LTVPNCertificateViewControllerDelegate {
    optional func didTapSaveCertificateWithData(data: NSData?, URLString andURLString: String)
}

class LTVPNCertificateViewController: UITableViewController, UITextFieldDelegate
{
    weak var delegate: LTVPNCertificateViewControllerDelegate?
    var temporaryCertificateURL: String?
    var temporaryCertificateData: NSData?
    
    private let kDownloadingText = NSLocalizedString("Downloading...", comment: "Certifiate - Download Cell - Downloading")
    private let kDownloadText = NSLocalizedString("Download", comment: "Certifiate - Download Cell")
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var certificateURLField: UITextField!
    @IBOutlet weak var certificateSummaryCell: LTVPNTableViewCell!
    @IBOutlet weak var deleteCell: UITableViewCell!
    @IBOutlet weak var downloadCell: LTTableViewActionCell!
    
    lazy var vpn: VPN? = {
        if let ID = VPNDataManager.sharedManager.selectedVPNID {
            if let result = VPNDataManager.sharedManager.VPNByID(ID) {
                let vpn = result
                return vpn
            }
        }
        return Optional.None
        }()

    var downloading: Bool = false {
        didSet {
            Optional(self.downloadCell.textLabel)!.text = self.downloading ? kDownloadingText : kDownloadText
            self.downloadCell.disabled = self.downloading
        }
    }
    
    var certificateData: NSData? {
        didSet {
            self.updateCertificateSummary()
            self.updateSaveButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let vpnObject = vpn {
            certificateURLField.text = vpnObject.certificateURL
            if let certificate = VPNKeychainWrapper.certificateForVPNID(vpnObject.ID) {
                certificateData = certificate
            }
        } else {
            if let url = temporaryCertificateURL {
                certificateURLField.text = url
            }
            if let data = temporaryCertificateData {
                certificateData = data
            }
        }
    }
    
    deinit {
        vpn = nil
        certificateData = nil
        delegate = nil
    }
    
    // MARK: - Save
    
    @IBAction func save(sender: AnyObject) {
        if let data = certificateData {
            if let vpnObject = vpn {
                VPNKeychainWrapper.setCertificate(data, forVPNID: vpnObject.ID)
                vpnObject.certificateURL = certificateURLField.text
                VPNDataManager.sharedManager.saveContext()
            } else if let d = delegate {
                d.didTapSaveCertificateWithData?(data, URLString: certificateURLField.text)
            }
        }
        
        popDetailViewController()
    }
    
    func updateSaveButton() {
        if certificateData == nil {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
    
    // MARK: - Download && Scan && Delete
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell == deleteCell {
                let deleteTitle = NSLocalizedString("Delete Certificate?", comment: "Certificate - Delete alert - Title")
                let deleteButtonTitle = NSLocalizedString("Delete", comment: "Certificate - Delete alert - Delete button")
                let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Certificate - Delete alert - Cancel button")
                
                let alert = UIAlertController(title: deleteTitle, message: "", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: deleteButtonTitle, style: .Destructive, handler: { _ -> Void in
                    self.deleteCertificate()
                }))
                alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else if cell == downloadCell {
                downloadURL()
            }
        }
    }
    
    func downloadURL() {
        downloading = true
        if let URL = NSURL(string: certificateURLField.text) {
            LTVPNDownloader().download(URL) {
                response, data, error in
                dispatch_async(dispatch_get_main_queue(), {
                    if let err = error {
                        Optional(self.certificateSummaryCell.textLabel)!.text = error.localizedDescription
                    } else {
                        self.certificateData = data
                    }
                    self.downloading = false
                })
            }
        }
    }
    
    func updateCertificateSummary() {
        if let data = certificateData {
            let bytesFormatter = NSByteCountFormatter()
            bytesFormatter.countStyle = NSByteCountFormatterCountStyle.File
            let bytesCount = bytesFormatter.stringFromByteCount(Int64(data.length))
            let certificateFormat = NSLocalizedString("Certificate downloaded (%s)", comment: "Certificate - Status")
            let certificateText = String(format: certificateFormat, bytesCount)
            Optional(certificateSummaryCell.textLabel)!.text = certificateText
        } else {
            let defaultCertificateStatus = NSLocalizedString("Certificate will be downloaded and stored in Keychain", comment: "Certificate - Default status")
            Optional(certificateSummaryCell.textLabel)!.text = defaultCertificateStatus
        }
    }
    
    func deleteCertificate() {
        certificateData = nil
        
        if let vpnObject = vpn {
            VPNKeychainWrapper.setCertificate(nil, forVPNID: vpnObject.ID)
            vpnObject.certificateURL = ""
            VPNDataManager.sharedManager.saveContext()
        } else if let d = delegate {
            d.didTapSaveCertificateWithData?(nil, URLString: "")
        }
        
        popDetailViewController()
    }
    
    // MARK: - TextField delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        updateCertificateSummary()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        updateCertificateSummary()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        downloadURL()
        return true
    }
    
    // MARK: - Navigation
    
    func popDetailViewController() {
        let topNavigationController = splitViewController!.viewControllers.last! as UINavigationController
        topNavigationController.popViewControllerAnimated(true)
    }
    
}
