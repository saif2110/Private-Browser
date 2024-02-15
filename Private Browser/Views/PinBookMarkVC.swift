//
//  PinBookMarkVC.swift
//  Private Browser
//
//  Created by Saif Mukadam on 05/02/24.
//


import UIKit

protocol PinBookMarkVCDelegates {
    func pinenterdSuccess()
}

class PinBookMarkVC: UIViewController, KAPinFieldDelegate, UITextFieldDelegate {
 
    var delegate:PinBookMarkVCDelegates?
    
    func pinField(_ field: KAPinField, didChangeTo string: String, isValid: Bool) {
      
    }
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        if Manager.PINis == "NA" {
            Manager.PINis = code
            self.dismiss(animated: true)
            return
        }
        
        if Manager.PINis == code {
            delegate?.pinenterdSuccess()
            self.dismiss(animated: true)
            return
        }
        
        if Manager.PINis != code {
            label.text = "Entered pin is wrong. Please try again."
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
            return
        }
        
    }
    
    @IBOutlet var pinField: KAPinField!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Manager.PINis == "NA" {
            label.text = "Enter new 4 digits pin to unlock"
        }else {
            label.text = "Please enter your pin to unlock private bookmarks."
        }
        
        pinField.keyboardType = .numberPad
        pinField.properties.delegate = self
        pinField.becomeFirstResponder()
    
    }
    

  
}
