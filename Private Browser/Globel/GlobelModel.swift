//
//  GlobelModel.swift
//  SplitBrowser
//
//  Created by Saif Mukadam on 31/12/23.
//

import Foundation
import UIKit


func appendBookmarks(newString: String) {
    let key = "bookmarks" // The common key for UserDefaults
    var bookmarks = UserDefaults.standard.stringArray(forKey: key) ?? []
    
    // Append the new string
    bookmarks.append(newString)
    
    // Save the updated array back to UserDefaults
    UserDefaults.standard.set(bookmarks, forKey: key)
}


func getBookmarks() -> [String] {
    let key = "bookmarks"
    return UserDefaults.standard.stringArray(forKey: key) ?? []
}

func getFirstLetterOfDomain(from urlString: String) -> String? {
    guard let url = URL(string: urlString),
          let host = url.host else {
        return nil
    }
    
    // Find the first letter of the domain (e.g., 'f' in facebook.com)
    let components = host.split(separator: ".")
    if components.count > 1, let firstLetter = components[1].first {
        return String(firstLetter)
    } else if let firstLetter = components.first?.first {
        return String(firstLetter)
    }
    return nil
}



class TextFieldWithDoneButton: UITextField {
    
    // Initializer for programmatically created text fields
    override init(frame: CGRect) {
        super.init(frame: frame)
        addDoneButtonOnKeyboard()
    }
    
    // Initializer for text fields loaded from a storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}



extension UIImageView {
    func loadImage(from urlString: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error downloading image: \(error)")
                    completion(false, error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error: invalid HTTP response code")
                    completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response code"]))
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    print("Error: no image data or can't create image")
                    completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No image data or can't create image"]))
                    return
                }

                self.image = image
                completion(true, nil)
            }
        }.resume()
    }
}




class BlurredTransparentView: UIView {
    
    // Initializer for programmatically created views
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurEffect()
    }
    
    // Initializer for views loaded from a storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBlurEffect()
    }
    
    private func setupBlurEffect() {
        // Choose the style of the blur effect you want
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark) // or .extraLight, .dark
        
        // Create a UIVisualEffectView which will render the blur effect
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        
        // Make sure the effect view resizes to always fit the entire view
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredEffectView.frame = self.bounds
        
        // Add the effect view to the view hierarchy
        addSubview(blurredEffectView)
        blurredEffectView.layer.zPosition = -1  // Put the blur view behind other content
    }
}

extension UIView {

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }


    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
               shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
               shadowOpacity: Float = 0.4,
               shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}
