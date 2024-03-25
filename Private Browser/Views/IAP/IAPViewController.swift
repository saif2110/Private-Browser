////
////  IAPViewController.swift
////  SplitBrowser
////
////  Created by Saif Mukadam on 13/01/24.
////
//
import UIKit
import RevenueCat
import SafariServices
import StoreKit

let mainColor = #colorLiteral(red: 0.2953208983, green: 0.5, blue: 0.8996046782, alpha: 1)

enum IPA:String {
    case Weekly = "PrivateBrowserPRO"
}

var isProTrigger:(() -> ())?

class IAPViewController: UIViewController {
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var weekTitle: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let backGroundColor = #colorLiteral(red: 0.05986089259, green: 0.07497294992, blue: 0.08328766376, alpha: 1)
    let selectedColor = #colorLiteral(red: 0, green: 0.6928513646, blue: 0.6272605658, alpha: 0.2620550497)
    let borderColor =  #colorLiteral(red: 0, green: 0.6928513646, blue: 0.6272605658, alpha: 1)
    
    
    var package:Package?
    var package2:Package?
    
    var selectedPackage:Package?
    
    @IBOutlet weak var yearlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //skipButton.isHidden = Manager.isnumberofTimesAppOpenKey > 8
        revenuCat()
        
        self.skipButton.alpha = 0.0
       // self.skipButton.isHidden = Apps15init.shared.HSB
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1.5) {
                self.skipButton.alpha = 1.0
            }
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    
    private func revenuCat(){
        Purchases.shared.getOfferings { (offerings, error) in
            
            if let offerings = offerings {
                
//                guard let package = offerings[IPA.Weekly.rawValue]?.availablePackages.first else {
//                    return
//                }
                
                guard let package2 = offerings[IPA.Weekly.rawValue]?.availablePackages.first else {
                    return
                }
                
               // self.package = package
                self.package2 = package2
                self.selectedPackage = package2
                
                
                let weekPrice = offerings[IPA.Weekly.rawValue]?.lifetime?.localizedPriceString
                
                
               // let YearPrice = offerings[IPA.Yearly.rawValue]?.annual?.localizedPriceString
                
                
                self.weekTitle.text = "Unlock a premium experience with our exclusive lifetime offer! Upgrade now to enjoy unlimited features and bid farewell to annoying ads forever, all for a single, unbeatable one-time fee of " + (weekPrice ?? "") + "."
              //  self.yearlyTitle.text = (YearPrice ?? "") + " / Year"
                
                
                
            }
        }
    }
    
    @IBAction func weeklyButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedPackage = package
    }
    
    @IBAction func yearlyButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedPackage = package2
    }
    
    @IBAction func subscriptionButton(_ sender: UIButton) {
        //let tag = sender.tag
        //yearlyButton.backgroundColor = backGroundColor
       // weeklyButton.backgroundColor = backGroundColor
        //sender.backgroundColor = selectedColor
    }
    
    
    @IBAction func continueButton(_ sender: Any) {
        self.skipButton.isHidden = true
        //self.continueButton.isUserInteractionEnabled = false
        
        if selectedPackage != nil {
            startIndicator(self: self)
            Purchases.shared.purchase(package: selectedPackage!) { (transaction, purchaserInfo, error, userCancelled) in
                self.skipButton.isHidden = false
                self.continueButton.isUserInteractionEnabled = true
                stopIndicator()
                //print(purchaserInfo,error)
                
                if !(purchaserInfo?.entitlements.active.isEmpty ?? true) {
                    
                    self.PerchesedComplte()
                    
                }else{
                    //self.backButtonoutlet.isHidden = false
                    
                    
                }
                
            }
            
        }
        
    }
    
    func PerchesedComplte(){
        
        stopIndicator()
        
        Manager.isPro = true
        isProTrigger?()
        
        
        let alert = UIAlertController(title: "Congratulations !", message: "You are a pro member now. Enjoy seamless experience with all features unlock.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dismiss(animated: true)
                }
            case .cancel:
                print("")
            case .destructive:
                print("")
            @unknown default:
                fatalError()
            }}))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func privacy(_ sender: Any) {
        let url = URL(string: "https://apps15.com/privacy.html")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func restore(_ sender: Any) {
        startIndicator(self: self)
        Purchases.shared.restorePurchases { (purchaserInfo, error) in
            stopIndicator()
            if !(purchaserInfo?.entitlements.active.isEmpty ?? true) {
                
                self.PerchesedComplte()
                
            }else{
                
                let alert = UIAlertController(title: "Alert!", message: "No previous transactions found!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("")
                    case .cancel:
                        print("")
                    case .destructive:
                        print("")
                    @unknown default:
                        fatalError()
                    }}))
                
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func toc(_ sender: Any) {
        let url = URL(string: "https://apps15.com/termsofuse.html")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func skip(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

var indicator = UIActivityIndicatorView()

func startIndicator(self:UIViewController) {
    indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    indicator.color = mainColor
    self.view.addSubview(indicator)
    indicator.center = CGPoint(x: self.view.frame.size.width / 2.0, y: (self.view.frame.size.height) / 2.0)
    indicator.startAnimating()
}


func stopIndicator() {
    indicator.stopAnimating()
}


struct Manager {
   
    private static let isBlockScriptKey = "isBlockScript"
    private static let isBlockAdKey = "isBlockAd"
    private static let isPIN = "isPIN"
    private static let isProKey = "isPro"
    private static let isWelcomeDoneKey = "isWelcomeDone"
    private static let numberofTimesAppOpenKey = "numberofTimesAppOpen"
    private static let depthSelected = "depthSelected"
    private static let queryHit = "queryHit"
    private static let historyArrayKey = "historyArray"
    
    
    
    static var PINis: String {
        get {
            return UserDefaults.standard.string(forKey: isPIN) ?? "NA"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isPIN)
        }
    }
    
    static var isPro: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isProKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isProKey)
        }
    }
    
    static var isBlockAd: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isBlockAdKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isBlockAdKey)
        }
    }
    
    static var isBlockScript: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isBlockScriptKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isBlockScriptKey)
        }
    }
    
    
    static var isWelcomeDone: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isWelcomeDoneKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isWelcomeDoneKey)
        }
    }
    
    static var isnumberofTimesAppOpenKey: Int {
        get {
            return UserDefaults.standard.integer(forKey: numberofTimesAppOpenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: numberofTimesAppOpenKey)
        }
    }
    
    
}
