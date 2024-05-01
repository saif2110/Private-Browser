//
//  ViewController.swift
//  Private Browser
//
//  Created by Saif Mukadam on 29/01/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var primaryView: UIView!
    var wkwebview = WebviewClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.wkwebview.frame = self.primaryView.bounds
            self.primaryView.addSubview(self.wkwebview)
            self.wkwebview.delegate = self
            self.wkwebview.webview.navigationDelegate = self
            self.primaryView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        
        
        if !Manager.isWelcomeDone {
            DispatchQueue.main.async {
                let main = UIStoryboard(name: "Welcome", bundle: Bundle.main)
                let vc = main.instantiateViewController(identifier: "WelcomeVC")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
        
        
        if !Manager.isPro {
            showIAP()
        }
        
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(callback), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callback), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func showIAP(){
        DispatchQueue.main.async {
            let vc = IAPViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    
    @objc func callback() {
        sleep(1)
        WebCacheCleaner.clear()
    }
    
    func checkIfInputIsFocused(in webView: WKWebView, completion: @escaping (Bool) -> Void) {
        let js = "document.activeElement.tagName.toLowerCase() === 'input' || document.activeElement.tagName.toLowerCase() === 'textarea'"
        webView.evaluateJavaScript(js) { (result, error) in
            if let isInputFocused = result as? Bool {
                completion(isInputFocused)
            } else {
                completion(false)
            }
        }
    }
    
    
    
    
    
    @objc func keyboardWillHide(notification: Notification) {
        //        self.mySplitView.assignRatios(newRatio: 0.5, for: 1)
        //        self.mySplitView.update()
    }
    
    
    @objc func keyboardDidShow(notification: Notification) {
        
        if wkwebview.textfiled.isFirstResponder {
            //self.activeWebView = "Upper"
            self.keyboardDetected()
            return
        }
        
        
        
        // Evaluate JavaScript in both web views
        checkIfInputIsFocused(in: wkwebview.webview) { [weak self] isFocused in
            if isFocused {
                
                // self?.activeWebView = "Upper"
                self?.keyboardDetected()
                return
            }
        }
        
    }
    
    
    private func keyboardDetected() {
        
        
        
    }
    
    
}


extension ViewController: textfiledDelegate,WKNavigationDelegate,PinBookMarkVCDelegates {
    
    func openIAP() {
        showIAP()
    }
    
    
    func pinenterdSuccess() {
        wkwebview.unlockedView.isHidden = true
    }
    
    
    func bookmarkUnlock() {
        DispatchQueue.main.async {
            let main = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = main.instantiateViewController(withIdentifier: "PinBookMarkVC") as! PinBookMarkVC
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    
    func returnPressed() {
        
    }
    
    
}
