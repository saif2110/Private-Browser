//
//  WebviewClass.swift
//  SplitBrowser
//
//  Created by Saif Mukadam on 29/12/23.
//

import UIKit
import WebKit

protocol textfiledDelegate {
    func returnPressed()
}

class WebviewClass: UIView,UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.returnPressed()
        return true
    }
    
    @IBOutlet weak var noBookmarksYet: UILabel!
    @IBOutlet weak var webbar: UIView!
    var delegate:textfiledDelegate?
    @IBOutlet weak var homepage: UIView!
    @IBOutlet weak var bookmarCollection: UICollectionView!
    @IBOutlet weak var menuSlack: UIStackView!
    @IBOutlet weak var textfiled: UITextField!
    @IBOutlet weak var webview: WKWebView!
    var bookmark =  getBookmarks()
    var fevicon:UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    // Initializer required for loading the view from a XIB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // Common initialization code
    private func commonInit() {
        // Load the XIB
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Webview", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        
        let request = URLRequest(url: URL(string: "about:blank")!)
        webview.load(request)
        
        self.bookmarCollection.register(BookmarkCell.nib, forCellWithReuseIdentifier: BookmarkCell.name)
        
        self.textfiled.delegate = self
        self.bookmarCollection.delegate = self
        self.bookmarCollection.dataSource = self
        self.bookmarCollection.reloadData()
        
    }
    
    @IBAction func openMenu(_ sender: Any) {
        self.menuSlack.isHidden.toggle()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @IBAction func restorebar(_ sender: Any) {
        webbar.isHidden = false
    }
    
    @IBAction func tabbarOptions(_ sender: UIButton) {
        menuSlack.isHidden = true
        let tag = sender.tag
        
        switch tag {
        case 0:
            
            webbar.isHidden = true
            break
            
        case 1:
            webview.reload()
            
        case 2:
            
            if let topController = UIApplication.topViewController() {
                let text = webview.url?.absoluteString
                let textShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = topController.view
                topController.present(activityViewController, animated: true, completion: nil)
            }
            
        case 3:
            
            let url = webview.url?.absoluteString ?? ""
            guard !bookmark.contains(url) else {
                return
            }
            appendBookmarks(newString: url)
            
        case 4:
            
            homepage.isHidden = false
            self.bookmark = getBookmarks()
            self.bookmarCollection.reloadData()
            
            
        default:
            break
        }
        
    }
    
    private func hitwebview(url:String){
        webbar.isHidden = true
        homepage.isHidden = true
        menuSlack.isHidden = true
        self.endEditing(true)
        loadContent(from: url, in: webview)
    }
    
    private func loadContent(from text: String, in webView: WKWebView) {
        // Function to create a URL with a default scheme if needed
        func createURL(withString string: String) -> URL? {
            if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
                return url
            } else if string.contains(".") && !string.contains(" ") {
                return URL(string: "https://" + string)
            } else {
                return nil
            }
        }
        
        // Check if the text is a valid URL or can be made into one
        if let url = createURL(withString: text) {
            // Load the URL directly in the WebView
            let request = URLRequest(url: url)
            webView.load(request)
            print("Loading URL: \(url)")
        } else {
            // Treat the text as a Google search query
            let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            if let searchURL = URL(string: "https://www.google.com/search?q=\(query)") {
                let request = URLRequest(url: searchURL)
                webView.load(request)
                print("Performing Google search for: \(text)")
            } else {
                print("Invalid search query")
            }
        }
    }
    
    
    @IBAction func searchEngineButtons(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 0:
            hitwebview(url: "https://www.google.com/")
            break
            
        case 1:
            hitwebview(url: "https://www.bing.com/")
            break
            
        case 2:
            hitwebview(url: "https://duckduckgo.com/")
            break
            
        case 3:
            hitwebview(url: "https://search.yahoo.com/")
            break
            
        default:
            break
        }
        
    }
    
}

extension WebviewClass:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if bookmark.count == 0 {
            self.bookmarCollection.isHidden = true
            self.noBookmarksYet.isHidden = false
        }else{
            self.noBookmarksYet.isHidden = true
            self.bookmarCollection.isHidden = false
        }
        
        return bookmark.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCell.name, for: indexPath) as! BookmarkCell
        
        let link = bookmark[indexPath.row]
        cell.config(url: link)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let link = bookmark[indexPath.row]
        hitwebview(url: link)
    }
    
}
