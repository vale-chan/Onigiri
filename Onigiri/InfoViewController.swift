//
//  InfoViewController.swift
//  Onigiri
//
//  Created by Vale-chan on 16.06.19.
//  Copyright © 2019 Vale-chan. All rights reserved.
//

import UIKit
extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}

class InfoViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* nicht mehr Verlinkt für den Moment
         
        let linkedText = NSMutableAttributedString(attributedString: infoTextView.attributedText)
        let hyperlinked = linkedText.setAsLink(textToFind: "hier", linkURL: "https://onlinelibrary.wiley.com/doi/full/10.1111/medu.12583")
        
        if hyperlinked {
            infoTextView.attributedText = NSAttributedString(attributedString: linkedText)
        }
 */

    
        shadowView.layer.shadowColor =  UIColor(red:0, green:0, blue:0, alpha: 1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        shadowView.layer.shadowRadius = 1.5
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.cornerRadius = 2
    }
    

}
