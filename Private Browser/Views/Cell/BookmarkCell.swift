//
//  BookmarkCell.swift
//  SplitBrowser
//
//  Created by Saif Mukadam on 30/12/23.
//

import UIKit

class BookmarkCell: UICollectionViewCell {
    
    
    static var name: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: name, bundle: Bundle.main)
    }
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var iconofBookmark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func config(url:String) {
        
        let urlString = url
        let main = URL(string: urlString)
        let domain = main?.host
        let wholeURL = (main?.scheme ?? "") + "://" + (domain ?? "") + "/favicon.ico"
    
        iconImage.loadImage(from: wholeURL) { success, error in
            if !success{
                self.iconImage.isHidden = true
                self.iconofBookmark.isHidden = false
                self.iconofBookmark.text = String(domain?.first ?? "H").capitalized
            }
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImage.isHidden = false
        iconofBookmark.isHidden = true
        iconImage.image = nil // Reset the image
    }
    
}
